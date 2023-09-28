import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '/models/menu.dart';
import '../widgets/menu_item.dart';
import '/config/utils.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JelloIn(
                    child: const Text(
                      "Menu principal",
                      style: TextStyle(
                        color: defaultTextColor,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ZoomIn(
                    child: const Text(
                      "Veuillez cliquer sur un menu en dessous pour effectuer differentes tâches !",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 180).toInt(),
                childAspectRatio: 2.2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                var item = menus[index];
                return ZoomIn(child: MenuItem(item: item));
              },
            )
          ],
        ),
      ),
    );
  }
}
