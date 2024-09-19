import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_state.dart';
import 'package:mycookcoach/features/shop/presentation/components/order_item_card.dart';
import 'package:mycookcoach/features/shop/presentation/pages/orders_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final String userId = FirebaseUserRepo().currentUser!.uid;

  @override
  void initState() {
    super.initState();
    context.read<PurchaseBloc>().add(LoadOrders(userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[const SizedBox(width: kDefaultPaddin / 2)],
      ),
      body: BlocConsumer<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PurchaseLoading) {
            return const Center(child: CircularProgressIndicator(color: kMainColor));
          } else if (state is OrdersLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Mes commandes",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) => OrderItemCard(
                        order: state.items[index],
                        press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersDetailsScreen(
                              order: state.items[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  //),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Aucune commande disponible.'));
          }
        },
      ),
    );
  }
}
