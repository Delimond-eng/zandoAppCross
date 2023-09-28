import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '/config/utils.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
