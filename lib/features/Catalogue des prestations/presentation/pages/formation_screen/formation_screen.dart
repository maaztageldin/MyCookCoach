import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/formation_blocs/formation_bloc.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/formation_blocs/formation_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/formation_blocs/formation_state.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/formation_screen/formation_item.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_event.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_state.dart';

class FormationScreen extends StatefulWidget {
  const FormationScreen({super.key});

  @override
  State<FormationScreen> createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  bool isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    context
        .read<UserBloc>()
        .add(GetUserById(FirebaseUserRepo().currentUser!.uid));
    context.read<FormationBloc>().add(FetchFormationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    late UserEntity user;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          user = state.user;
          isUserLoaded = true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        ),
        body: BlocBuilder<FormationBloc, FormationState>(
          builder: (context, state) {
            if (state is FormationLoadingState) {
              return const Center(child: CircularProgressIndicator(color: kMainColor));
            } else if (state is FormationLoadedState) {
              if (!isUserLoaded) {
                return const Center(child: CircularProgressIndicator(color: kMainColor));
              }
              final formations = state.formations;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Formations Professionnelles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: formations.length,
                      itemBuilder: (context, index) {
                        final formation = formations[index];
                        return FormationItem(
                          formation: formation,
                          user: user,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Aucune formation disponible'),
              );
            }
          },
        ),
      ),
    );
  }
}
