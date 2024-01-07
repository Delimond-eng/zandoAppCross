import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zandoprintapp/global/controllers.dart';
import '/config/utils.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(40.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (dataController.dataLoading.value) ...[
                  const SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Chargement en cours...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 14.0,
                      color: Colors.grey.shade700,
                    ),
                  )
                ] else ...[
                  Lottie.asset("assets/anims/empty.json", height: 100.0),
                  Text(
                    "Aucune donnée répertoriée !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 14.0,
                      color: Colors.grey.shade700,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
