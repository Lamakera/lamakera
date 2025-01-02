import 'package:flutter/material.dart';
import 'package:lamakera/assets/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: primaryClr,
        ),
        child: Text(
          label,
          style: subTitleStyle2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
