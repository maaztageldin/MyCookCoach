import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/components/cours_info.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_event.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_state.dart';

class HomeRecipeScreen extends StatefulWidget {
  const HomeRecipeScreen({super.key});

  @override
  State<HomeRecipeScreen> createState() => _HomeRecipeScreenState();
}

class _HomeRecipeScreenState extends State<HomeRecipeScreen> {
  late UserEntity user;

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
          if (state is UserErrorState) {
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
            user = state.user;
            return RecipeInfo(
              user: user,
            );
          } else {
            return const Center(
              child: Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
