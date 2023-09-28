import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/config/utils.dart';
import '/ui/widgets/user_avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: JelloIn(
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: defaultFont,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),
      actions: const [
        Row(
          children: [
            UserAvatar(),
            SizedBox(
              width: 10,
            ),
          ],
        )
      ],
    );
  }
}
