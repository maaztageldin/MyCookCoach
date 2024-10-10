import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/favorites_page.dart';
import 'package:mycookcoach/features/Notifications%20et%20alertes/presentation/pages/notifications_page.dart';
import 'package:mycookcoach/features/authentication/data/models/menu_btn.dart';
import 'package:mycookcoach/features/authentication/presentation/components/side_menu.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/home_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/orders_screen.dart';
import 'package:rive/rive.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;
  bool isSideMenuClosed = true;

  String _selectedPage = 'Home';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B4513),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          // Side Menu
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(
              onMenuSelected: (String selectedPage) {
                setState(() {
                  _selectedPage = selectedPage;
                  isSideMenuClosed = true;
                  _animationController.reverse();
                });
              },
            ),
          ),

          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((animation.value - 30 * animation.value * pi / 250)),
            child: Transform.translate(
              offset: Offset(animation.value * 280, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: _selectedPage == 'Home'
                      ? const PrestationScreen()
                      : _selectedPage == 'Mes commandes'
                          ? OrdersScreen()
                          : _selectedPage == 'Favorites'
                              ? FavoritesPage()
                              : _selectedPage == 'Notification'
                                  ? NotificationsPage()
                                  : PrestationScreen(),
                ),
              ),
            ),
          ),

          // Menu Button
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 245,
            top: 16,
            child: MenuBtn(
              riveOnInit: (Artboard artboard) {
                final controller = RiveUtil.getRiveController(artboard,
                    stateMachineName: "State Machine 1");

                final isSideBarClosed = controller.findSMI<SMIBool>("isOpen");
                if (isSideBarClosed != null) {
                  isSideBarClosed.value = true;
                }
              },
              press: () {
                setState(() {
                  if (isSideMenuClosed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                  isSideMenuClosed = !isSideMenuClosed;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
