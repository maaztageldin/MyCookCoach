import 'package:flutter/material.dart';
import 'package:mycookcoach/features/authentication/presentation/components/info_card.dart';
import 'package:mycookcoach/features/authentication/presentation/components/side_menu_title.dart';
import 'package:rive/rive.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class SideMenu extends StatefulWidget {
  final ValueChanged<String> onMenuSelected;

  const SideMenu({super.key, required this.onMenuSelected});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectedMenu = sidMenu.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF17203A),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: 'Adam Thomas',
                role: 'Chef',
              ),
              // animated asset
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Parcourir".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),

              ...sidMenu.map((menu) => SideMenuTitle(
                    menu: menu,
                    riveOnInit: (artboard) {
                      StateMachineController controller =
                          RiveUtil.getRiveController(artboard,
                              stateMachineName: menu.stateMachineName!);
                      menu.input = controller.findSMI("active") as SMIBool;
                    },
                    press: () {
                      menu.input!.change(true);
                      Future.delayed(Duration(seconds: 1), () {
                        menu.input!.change(false);
                      });
                      setState(() {
                        selectedMenu = menu;
                        widget.onMenuSelected(menu.title);
                      });
                    },
                    isActive: selectedMenu == menu,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 42, bottom: 16),
                child: Text(
                  "Historique".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidMenu2.map((menu) => SideMenuTitle(
                    menu: menu,
                    riveOnInit: (Artboard artboard) {
                      StateMachineController controller =
                          RiveUtil.getRiveController(artboard,
                              stateMachineName: menu.stateMachineName!);
                      menu.input = controller.findSMI("active") as SMIBool;
                    },
                    press: () {
                      menu.input!.change(true);
                      Future.delayed(Duration(seconds: 1), () {
                        menu.input!.change(false);
                      });
                      setState(() {
                        selectedMenu = menu;
                        widget.onMenuSelected(menu.title);
                      });
                    },
                    isActive: selectedMenu == menu,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

List<RiveAsset> sidMenu = [
  RiveAsset(
    src: Asset.iconSet1,
    artboard: 'HOME',
    stateMachineName: 'HOME_interactivity',
    title: 'Home',
    shapeStrokeTitle: 'home',
  ),
  RiveAsset(
      stateMachineName: "SEARCH_Interactivity",
      title: "Recherche",
      src: Asset.iconSet1,
      artboard: 'SEARCH'),
  RiveAsset(
    src: Asset.iconSet3,
    artboard: 'Dots-CLICK',
    title: 'Prestation',
    shapeStrokeTitle: 'dots',
    stateMachineName: 'State-machine',
  ),
];

List<RiveAsset> sidMenu2 = [
  RiveAsset(
    src: Asset.iconSet1,
    artboard: 'LIKE/STAR',
    stateMachineName: 'STAR_Interactivity',
    title: 'Favorites',
    shapeStrokeTitle: 'star',
  ),
  RiveAsset(
    src: Asset.iconSet1,
    artboard: 'BELL',
    stateMachineName: 'BELL_Interactivity',
    title: 'Notification',
    shapeStrokeTitle: 'bell',
  ),
];
