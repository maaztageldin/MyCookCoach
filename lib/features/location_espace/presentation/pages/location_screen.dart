import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_event.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_state.dart';
import 'package:mycookcoach/features/location_espace/presentation/components/location_item-card.dart';
import 'package:mycookcoach/features/location_espace/presentation/pages/kitchen_screen.dart';
import 'package:mycookcoach/features/location_espace/presentation/pages/my_reservations_screen.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Louer un espace',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyReservationsScreen()),
              );
            },
            child: const Text(
              "Mes Réservations",
              style: TextStyle(color: kTextLightColor),
            ),
          ),
        ],*/
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
            return const Center(child: CircularProgressIndicator(color: kMainColor));
          } else if (state is LocalsLoaded && state.locals.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          'Louer un espace',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyReservationsScreen()),
                          );
                        },
                        child: const Text(
                          "Mes Réservations",
                          style: TextStyle(color: kTextLightColor),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddin / 2,
                    ),
                    child: GridView.builder(
                      itemCount: state.locals.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: kDefaultPaddin,
                        crossAxisSpacing: kDefaultPaddin,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) => LocationItemCard(
                        local: state.locals[index],
                        press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KitchenLocationScreen(
                              kitchenIds: state.locals[index].kitchens,
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
