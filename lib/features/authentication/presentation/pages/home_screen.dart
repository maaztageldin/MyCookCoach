import 'package:flutter/material.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/Cours/recipe_screen.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/formation_screen/formation_screen.dart';
import 'package:mycookcoach/features/location_espace/presentation/pages/location_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_screen.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class PrestationScreen extends StatefulWidget {
  const PrestationScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PrestationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeRecipeScreen(),
    const ShopScreen(),
    const LocationScreen(),
    const FormationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: Color(0xFFD3A984)),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedLabelStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: RiveAnimatedIcon(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                riveIcon: RiveIcon.zap,
                width: 30,
                height: 30,
                color: Colors.white,
                strokeWidth: 8,
                loopAnimation: false,
              ),
              label: 'Cours',
            ),
            BottomNavigationBarItem(
              icon: RiveAnimatedIcon(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                riveIcon: RiveIcon.device,
                width: 30,
                height: 30,
                color: Colors.white,
                strokeWidth: 3,
                loopAnimation: false,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: RiveAnimatedIcon(
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                riveIcon: RiveIcon.bell,
                width: 30,
                height: 30,
                color: Colors.white,
                strokeWidth: 3,
                loopAnimation: false,
              ),
              label: 'location',
            ),
            BottomNavigationBarItem(
              icon: RiveAnimatedIcon(
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                riveIcon: RiveIcon.edit,
                width: 30,
                height: 30,
                color: Colors.white,
                strokeWidth: 3,
                loopAnimation: false,
              ),
              label: 'formation',
            ),
          ],
        ),
      ),
    );
  }
}
