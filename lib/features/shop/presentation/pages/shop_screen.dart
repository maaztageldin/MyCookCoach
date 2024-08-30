import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_state.dart';
import 'package:mycookcoach/features/shop/presentation/pages/categorries.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_details_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_item_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    context.read<KitchenItemBloc>().add(FetchKitchenItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KitchenItemBloc, KitchenItemState>(
      listener: (context, state) {
        if (state is KitchenItemErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset("assets/shop/icons/back.svg"),
              onPressed: () {},
            ),
            actions: <Widget>[
              IconButton(
                icon: SvgPicture.asset(
                  "assets/shop/icons/search.svg",
                  colorFilter:
                      const ColorFilter.mode(kTextColor, BlendMode.srcIn),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/shop/icons/cart.svg",
                  colorFilter:
                      const ColorFilter.mode(kTextColor, BlendMode.srcIn),
                ),
                onPressed: () {
                  _showCartDetails(context);
                },
              ),
              const SizedBox(width: kDefaultPaddin / 2)
            ],
          ),
          body: BlocConsumer<KitchenItemBloc, KitchenItemState>(
            listener: (context, state) {
              if (state is KitchenItemErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is KitchenItemLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is KitchenItemLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPaddin),
                      child: Text(
                        "Cuisine",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Categories(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPaddin),
                        child: GridView.builder(
                          itemCount: state.items.length, //products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: kDefaultPaddin,
                            crossAxisSpacing: kDefaultPaddin,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) => ItemCard(
                            product: state.items[index], // products[index],
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  product:
                                      state.items[index], //products[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is KitchenItemErrorState) {
                return Center(
                  child: Text(
                    "une erreur est survenu",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Center(
                  child: Text("Pas de produits"),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _showCartDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mon Panier",
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
             /* if (widget.formation.imageUrl.isNotEmpty)
                Image.network(
                  widget.formation.imageUrl,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),*/
              SizedBox(height: 8.0),
              Text(
                "descr lknfn ovcnjkjfd",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                "Prix: 8",
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                "quentité: 3",
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
