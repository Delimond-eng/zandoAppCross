// ignore_for_file: unnecessary_null_comparison

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../services/api.dart';
import '/global/controllers.dart';
import '/models/client.dart';
import '/services/db.service.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showCreateClientModal(context) async {
  final clientNom = TextEditingController();
  final clientTel = TextEditingController();
  final clientAdresse = TextEditingController();
  bool isLoading = false;
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
          child: Text(
            "Création clients",
            style: TextStyle(
              fontFamily: defaultFont,
              color: defaultTextColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        StatefulBuilder(builder: (context, setter) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomField(
                  hintText: "Nom complet",
                  iconPath: "assets/icons/user.svg",
                  controller: clientNom,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomField(
                  hintText: "Téléphone",
                  iconPath: "assets/icons/tel.svg",
                  inputType: TextInputType.phone,
                  controller: clientTel,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomField(
                  hintText: "Adresse",
                  iconPath: "assets/icons/home-2.svg",
                  controller: clientAdresse,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  child: ZoomIn(
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
                        if (clientNom.text.isEmpty) {
                          EasyLoading.showToast("Nom du client requis !");
                          return;
                        }
                        if (clientTel.text.isEmpty) {
                          EasyLoading.showToast(
                              "Numéro de téléphone du client requis !");
                          return;
                        }
                        var client = Client(
                          clientAdresse: clientAdresse.text,
                          clientNom: clientNom.text,
                          clientTel: clientTel.text,
                        );

                        setter(() => isLoading = true);
                        Api.request(
                                url: 'client.create',
                                method: 'post',
                                body: client.toMap())
                            .then((res) {
                          setter(() => isLoading = false);
                          if (res.containsKey('status')) {
                            EasyLoading.showSuccess(
                              "client créé avec succès !",
                            );
                            clientNom.clear();
                            clientAdresse.clear();
                            clientTel.clear();
                            dataController.loadClients();
                          }
                        });
                      },
                      color: primaryColor,
                      icon: CupertinoIcons.add,
                      label: "Enregistrer",
                    ),
                  ),
                )
              ],
            ),
          );
        })
      ],
    ),
  );
}
