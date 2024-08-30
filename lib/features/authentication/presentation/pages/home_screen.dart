import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/Cours/recipe_screen.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/formation_screen/formation_screen.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class PrestationScreen extends StatefulWidget {
  const PrestationScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PrestationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // SideMenu(),
    HomeRecipeScreen(),
    Center(child: Text('Shop')),
    Center(child: Text('Location d\'éspace')),
    FormationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: Color(0xFF394053).withOpacity(0.8)),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _signOut(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text('Sign Out'),
      ),
    );
  }
}

/*
class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late SMIBool isSideBarClosed;
    bool isSideMenuClosed = false;
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
              width: 270,
              left: isSideMenuClosed ? -270 : 0,
              height: MediaQuery.of(context).size.height,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              child: SideMenu()
          ),
          Transform.translate(
            offset: Offset(isSideMenuClosed? 0 : 270, 0),
            child: Transform.scale(
                scale: isSideMenuClosed ? 1 : 0.8,
                child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(24),),
                child: const HomeScreen())),
          ),
          MenuBtn(
            riveOnInit: (Artboard value) {
              StateMachineController controller = RiveUtil.getRiveController(
                  value,
                  stateMachineName: "State Machine");
              isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
            },
            press: () {
              isSideBarClosed.value = !isSideBarClosed.value;
             /* setState(() {
                isSideMenuClosed = isSideMenuClosed.value;
              });*/

            },
          ),
        ],
      ),
    );
  }
}
*/
