import 'package:flutter/material.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/Cours/recipe_screen.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/formation_screen/formation_screen.dart';
import 'package:mycookcoach/features/location_espace/presentation/pages/location_screen.dart';
import 'package:mycookcoach/features/shop/presentation/pages/shop_screen.dart';

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
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Color(0xFF8B4513),
        ),
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
          const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined, size: 25, color: Colors.white),
              label: 'Cours',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 25, color: Colors.white),
              label: 'Boutique',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined, size: 25, color: Colors.white),
              label: 'Location',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined, size: 25, color: Colors.white),
              label: 'Formation',
            ),
          ],
        ),
      ),
    );
  }
}
