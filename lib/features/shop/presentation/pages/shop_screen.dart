import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_state.dart';
import 'package:mycookcoach/features/shop/presentation/components/cart.dart';
import 'package:mycookcoach/features/shop/presentation/pages/categorries.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_details_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_item_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String userId = FirebaseUserRepo().currentUser!.uid;
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<KitchenItemBloc>().add(FetchKitchenItemsEvent());
  }

  void _onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });

    if (index == 0) {
      context.read<KitchenItemBloc>().add(FetchKitchenItemsEvent());
    } else {
      context.read<KitchenItemBloc>().add(FetchKitchenItemsByCategoryEvent(
          categoryIndex: index - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        /*leading: IconButton(
              icon: SvgPicture.asset("assets/shop/icons/back.svg"),
              onPressed: () {},
            ),*/
        actions: <Widget>[
          /*IconButton(
                icon: SvgPicture.asset(
                  "assets/shop/icons/search.svg",
                  colorFilter:
                      const ColorFilter.mode(kTextColor, BlendMode.srcIn),
                ),
                onPressed: () {},
              ),*/
          IconButton(
            icon: SvgPicture.asset(
              "assets/shop/icons/cart.svg",
              colorFilter: const ColorFilter.mode(kTextColor, BlendMode.srcIn),
            ),
            onPressed: () {
              context
                  .read<CartBloc>()
                  .add(FetchCartItemsByUserIdEvent(userId: userId));
              CartBottomSheet.show(context);
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
            return const Center(child: CircularProgressIndicator(color: kMainColor));
          } else if (state is KitchenItemLoadedState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                  child: Text(
                    "Equipe ta Cuisine",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Categories(onCategorySelected: _onCategorySelected),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPaddin,
                    ),
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
                              product: state.items[index],
                              userId: userId, //products[index],
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
  }
}
