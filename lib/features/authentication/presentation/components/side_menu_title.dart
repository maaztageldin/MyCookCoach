import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class SideMenuTitle extends StatelessWidget {
  SideMenuTitle(
      {super.key,
      required this.menu,
      required this.riveOnInit,
      required this.isActive,
      required this.press});

  final RiveAsset menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.white24,
            height: 1,
          ),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              height: 56,
              width: isActive ? 288 : 0,
              left: 0,
              child: Container(
                decoration: const BoxDecoration(
                    //color: Color(0xFFD3A984),
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            ListTile(
              onTap: press,
              leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: RiveAnimation.asset(
                    menu.src,
                    artboard: menu.artboard,
                    onInit: riveOnInit,
                  )),
              title: Text(
                menu.title,

              ),
            ),
          ],
        )
      ],
    );
  }
}
