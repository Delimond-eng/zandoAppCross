import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/utils.dart';

class CustomBtnIcon extends StatelessWidget {
  const CustomBtnIcon({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      width: 30.0,
      margin: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        color: lightColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(40.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(40.0),
          onTap: onPressed,
          child: const Center(
            child: Icon(
              CupertinoIcons.xmark,
              color: Colors.red,
              size: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
