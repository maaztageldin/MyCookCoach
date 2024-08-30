import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/chat_utile.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/chat_blocs/chat_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/chat_blocs/chat_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/chat_blocs/chat_state.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/chat/chat_tile.dart';

class MessageListPage extends StatefulWidget {
  final String recipeId;
  final String chefId;

  const MessageListPage({super.key, required this.recipeId, required this.chefId});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
        GetChatListByRecipeIDandChefID(widget.recipeId, widget.chefId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatListLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chats"),
            ),
            body: ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                String otherUserId = chat.participants!.firstWhere((p) => p != widget.chefId);

                return ChatTile(
                  userId: otherUserId,
                  onTap: () {
                    ChatUtils().startChat(context, widget.chefId, otherUserId, widget.recipeId);

                    // Handle tap event here
                  },
                );
              },
            ),
          );
        } else if (state is ChatErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chats"),
            ),
            body: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chats"),
            ),
            body: const Center(
              child: Text('No Chats Found'),
            ),
          );
        }
      },
    );
  }
}
