import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_event.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_state.dart';
import 'package:mycookcoach/features/location_espace/presentation/components/location_item-card.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String userId = FirebaseUserRepo().currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(FetchAllLocalsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LocalsLoaded && state.locals.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                  child: Text(
                    "Equiper ta Cuisine",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddin,
                    ),
                    child: GridView.builder(
                      itemCount: state.locals.length, //products.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: kDefaultPaddin,
                        crossAxisSpacing: kDefaultPaddin,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) => LocationItemCard(
                        local: state.locals[index], // products[index],
                        press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KitchenScreen(
                              localId: state.locals[index].id,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Aucun local disponible pour le moment."),
            );
          }
        },
      ),
    );
  }
}

class KitchenScreen extends StatelessWidget {
  final String localId;

  const KitchenScreen({Key? key, required this.localId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuisines pour le local $localId"),
      ),
      body: const Center(
        child: Text("Liste des cuisines pour ce local"),
      ),
    );
  }
}
