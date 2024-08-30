import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/services/database_service.dart';
import 'package:mycookcoach/core/services/media_service.dart';
import 'package:mycookcoach/core/services/storage_service.dart';
import 'package:mycookcoach/core/utils/utils.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/message.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_event.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_state.dart';

class ChatPage extends StatefulWidget {
  final String chatUserId;
  final UserEntity currentUserEntity, otherUserEntity;
  final String recipeId;

  const ChatPage({
    super.key,
    required this.chatUserId,
    required this.currentUserEntity,
    required this.otherUserEntity,
    required this.recipeId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser? currentUser, otherUser;
  late UserEntity chatUser;
  late DataBaseService _dataBaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _dataBaseService = DataBaseService();
    _mediaService = MediaService();
    _storageService = StorageService();

    context.read<UserBloc>().add(
          GetUserById(
            widget.chatUserId,
          ),
        );
    currentUser = ChatUser(
      id: widget.currentUserEntity.userId,
      firstName: widget.currentUserEntity.lastName,
    );
    otherUser = ChatUser(
      id: widget.otherUserEntity.userId,
      firstName: widget.otherUserEntity.lastName,
      profileImage: widget.otherUserEntity.pictureUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is UserLoaded) {
          chatUser = state.user;
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.user.firstName!),
            ),
            body: _buildUI(),
          );
        } else {
          return const Center(
            child: Text(
              "error creation chats",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
        stream: _dataBaseService.getChatData(
          currentUser!.id,
          otherUser!.id,
          widget.recipeId,
        ),
        builder: (context, snapshot) {
          Chat? chat = snapshot.data?.data();
          List<ChatMessage> messages = [];
          if (chat != null && chat.messages != null) {
            messages = _generateChatMessagesList(
              chat.messages!,
            );
          }
          return DashChat(
            messageOptions: const MessageOptions(
              showOtherUsersAvatar: true,
              showTime: true,
            ),
            inputOptions: InputOptions(
              alwaysShowSend: true,
              trailing: [
               _mediaMessageButton(),
              ],
            ),
            currentUser: currentUser!,
            onSend: _sendMessage,
            messages: messages,
          );
        });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: chatMessage.user.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(
            chatMessage.createdAt,
          ),
        );
        await _dataBaseService.sendChatMessage(
          currentUser!.id,
          otherUser!.id,
          message,
          widget.recipeId,
        );
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(
          chatMessage.createdAt,
        ),
      );
      await _dataBaseService.sendChatMessage(
        currentUser!.id,
        otherUser!.id,
        message,
        widget.recipeId,
      );
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          createdAt: m.sentAt!.toDate(),
          medias: [ChatMedia(
            url: m.content!,
            fileName: "",
            type: MediaType.image,
          ),
        ]);
      } else {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getImageFromGallery(context);
        if (file != null) {
          String chatId = generateChatID(
            uid1: currentUser!.id,
            uid2: otherUser!.id, recipeId: widget.recipeId,
          );

          String? downloadURL = await _storageService.uploadImageToChat(
            file: file,
            chatID: chatId,
          );
          if (downloadURL != null) {
            ChatMessage chatMessage = ChatMessage(
                user: currentUser!,
                createdAt: DateTime.now(),
                medias: [
                  ChatMedia(
                    url: downloadURL,
                    fileName: "",
                    type: MediaType.image,
                  )
                ]);
            _sendMessage(chatMessage);
          }
        }
      },
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
