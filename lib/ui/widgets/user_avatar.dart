import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../models/user.dart';
import '../modals/util.dart';
import '/global/controllers.dart';

import '../../config/utils.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => authController.user.value.userId != null
        ? PopupMenuButton(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor,
                        ],
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/user.svg",
                        colorFilter:
                            const ColorFilter.mode(lightColor, BlendMode.srcIn),
                        height: 15.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authController.user.value.userName!,
                        style: const TextStyle(
                          color: defaultTextColor,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        authController.user.value.userRole!,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 1:
                  DGCustomDialog.showInteraction(context,
                      message:
                          "Etes-vous sûr de vouloir vous deconnecter de votre compte ?",
                      onValidated: () {
                    authController.user.value = User();
                  });
                  break;
                case 2:
                  DGCustomDialog.showInteraction(context,
                      message:
                          "Etes-vous sûr de vouloir fermer l'application ?",
                      onValidated: () {
                    exit(0);
                  });
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/icons/logout-circle.svg",
                      height: 18.0,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Deconnexion',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/icons/exit.svg",
                      height: 18.0,
                      colorFilter: const ColorFilter.mode(
                        Colors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Quitter l\'appli.',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink());
  }
}
