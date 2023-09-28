import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/global/controllers.dart';
import '/models/client.dart';
import '/services/db.service.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showCreateClientModal(context) async {
  /* var db = await DBService.initDb();
  await db.update(
    "clients",
    {"client_state": "allowed"},
  );
  dataController.loadClients(); */
  final clientNom = TextEditingController();
  final clientTel = TextEditingController();
  final clientAdresse = TextEditingController();
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
        Padding(
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
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final db = await DBService.initDb();

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
                      var latestClientId =
                          await db.insert("clients", client.toMap());
                      if (latestClientId != null) {
                        dataController.loadClients();
                        dataController.refreshDashboardCounts();
                        Future.delayed(Duration.zero, () {
                          Get.back();
                          EasyLoading.showSuccess(
                              "Nouveau client ajouté avec succès !");
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.all(16.0),
                      elevation: 10.0,
                      textStyle: const TextStyle(
                        fontFamily: defaultFont,
                        color: lightColor,
                        fontSize: 14.0,
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text(
                      "Enregistrer",
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
