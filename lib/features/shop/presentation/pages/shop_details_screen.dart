import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_state.dart';
import 'package:mycookcoach/features/shop/presentation/components/add_to_cart.dart';
import 'package:mycookcoach/features/shop/presentation/components/counter_with_fav_btn.dart';
import 'package:mycookcoach/features/shop/presentation/components/description.dart';
import 'package:mycookcoach/features/shop/presentation/components/product_title_with_image.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.product});

  final KitchenItemEntity product;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late int selectedQuantity = 1; // Initialize with the default quantity

  // Method to update the quantity
  void updateQuantity(int quantity) {
    setState(() {
      selectedQuantity = quantity;
    });
  }

  @override
  void initState() {
    super.initState();

    context.read<CartBloc>().add(
      GetCartItemByUserIdAndProductIdEvent(
        userId: FirebaseUserRepo().currentUser!.uid,
        productId: widget.product.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartItemLoadedState) {
          selectedQuantity = state.item.quantity;

        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFD3A984),
          appBar: AppBar(
            backgroundColor: const Color(0xFFD3A984),
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/shop/icons/back.svg',
                colorFilter: const ColorFilter.mode(
                    Colors.white, BlendMode.srcIn),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
              IconButton(
                icon: SvgPicture.asset("assets/shop/icons/search.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset("assets/shop/icons/cart.svg"),
                onPressed: () {},
              ),
              const SizedBox(width: kDefaultPaddin / 2)
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height,
                  child: Stack(
                    children: <Widget>[
                      Container(
                            margin: EdgeInsets.only(top: size.height * 0.3),
                            padding: EdgeInsets.only(
                              top: size.height * 0.12,
                              left: kDefaultPaddin,
                              right: kDefaultPaddin,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Description(product: widget.product),
                                const SizedBox(height: kDefaultPaddin / 2),
                                CounterWithFavBtn(
                                  productId: widget.product.id,
                                  onQuantityChanged: updateQuantity,
                                  numOfItems:
                                  selectedQuantity, // Passing the callback
                                ),
                                const SizedBox(height: kDefaultPaddin / 2),
                                AddToCart(
                                    product: widget.product,
                                    quantity: selectedQuantity),
                                // Pass the selected quantity
                              ],
                            ),
                          ),
                        //},
                     //),
                      ProductTitleWithImage(product: widget.product)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
