import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_event.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_state.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/help_center_page.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/invite_friends_page.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/privacy_policy_page.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/profile/edit_personal_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<UserBloc>()
        .add(GetUserById(FirebaseUserRepo().currentUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil mis à jour avec succès'),
                backgroundColor: Color(0xFF8B4513),
              ),
            );
            context
                .read<UserBloc>()
                .add(GetUserById(FirebaseUserRepo().currentUser!.uid));
            GoRouter.of(context).pop();
          } else if (state is UserErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator(color: kMainColor));
          } else if (state is UserLoaded) {
            return UserDetails(user: state.user);
          } else if (state is UserErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  final UserEntity user;

  const UserDetails({super.key, required this.user});

  @override
  UserDetailsState createState() => UserDetailsState();
}

class UserDetailsState extends State<UserDetails> {
  bool isEditing = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.user.firstName!;
    lastNameController.text = widget.user.lastName!;
    roleController.text = widget.user.role!;
    emailController.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),//Color(0xFF8B4513).withOpacity(0.8),

      //backgroundColor: Color(0xFFf8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Profile picture and name
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          _getImageProvider(widget.user.pictureUrl),
                    ),
                  ],
                ),
                SizedBox(height: 26),
                Text(
                  widget.user.firstName! + " " + widget.user.lastName!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.user.role!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Info cards
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  /*ProfileInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: emailController.text,
                    isEditing: isEditing,
                    controller: emailController,
                  ),*/
                  ProfileListItem(
                    icon: Icons.person,
                    text: 'Information personnelle',
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditPersonalInfo(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfileListItem(
                    icon: Icons.credit_card,
                    text: 'méthodes de paiement',
                    onTap: () {},
                  ),
                  ProfileListItem(
                    icon: Icons.shopping_bag,
                    text: 'mes commandes',
                    onTap: () {},
                  ),
                  ProfileListItem(
                    icon: Icons.settings,
                    text: 'paramètres',
                    onTap: () {},
                  ),
                  ProfileListItem(
                    icon: Icons.help_outline,
                    text: 'centre d\'aide',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HelpCenterPage(),
                        ),
                      );
                    },
                  ),
                  ProfileListItem(
                    icon: Icons.privacy_tip_outlined,
                    text: 'politique de confidentialité',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  ProfileListItem(
                    icon: Icons.person_add_alt_1,
                    text: 'inviter vos amis',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InviteFriendsPage(),
                        ),
                      );
                    },
                  ),
                  ProfileListItem(
                    icon: Icons.logout,
                    text: 'se déconnecter',
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String? imageUrl) {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      if (Uri.tryParse(imageUrl)!.isAbsolute) {
        return NetworkImage(imageUrl);
      } else {
        return FileImage(File(imageUrl));
      }
    } else {
      return const AssetImage('assets/img/img.png');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  "Déconnexion",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                // Content
                Text(
                  "Êtes-vous sûr de vouloir vous déconnecter?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "annuler",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF8B4513).withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        //Navigator.of(context).pop();
                        _signOut(context);
                      },
                      child: const Text(
                        "Oui",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isEditing;
  final TextEditingController controller;

  const ProfileInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isEditing,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Supprime l'ombre pour un look plat
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            16), // Augmente le rayon pour des coins plus arrondis
      ),
      color: Colors.grey.shade100, // Couleur de fond douce et neutre
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        // Espace généreux autour du contenu
        leading: Icon(
          icon,
          color: Colors.grey.shade800,
          // Couleur de l'icône plus douce et neutre
          size:
              28, // Taille de l'icône légèrement augmentée pour un effet premium
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // Style gras pour une meilleure lisibilité
            fontSize: 18,
            // Taille de la police plus grande pour le titre
            color: Colors.grey.shade800, // Couleur de texte assortie à l'icône
          ),
        ),
        subtitle: isEditing
            ? TextField(
                controller: controller,
                style: TextStyle(
                  fontSize:
                      16, // Taille de la police adaptée pour le sous-titre
                  color: Colors.grey.shade600, // Couleur du texte plus légère
                ),
                decoration: InputDecoration(
                  border: InputBorder.none, // Enlève la bordure du TextField
                ),
              )
            : Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16, // Taille de la police du sous-titre
                  color: Colors.grey.shade600, // Couleur du texte du sous-titre
                ),
              ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Center(
        child: Text(
          'Favorites Page',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

