import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class MenuBtn extends StatelessWidget {
  const MenuBtn({super.key, required this.press, required this.riveOnInit});

  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(left: 16,),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            /*boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 8,
              )
            ]*/),
        child: RiveAnimation.asset(
          RiveIcon.sliderHorizontal.getRiveAsset().src,
          artboard: 'adjustments-horizontal',
          onInit: riveOnInit,
        ),
      ),
    ));
  }
}
