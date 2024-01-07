import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/services/db.service.dart';
import '../../../global/controllers.dart';
import '../../../models/compte.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '/ui/modals/util.dart';

Future<void> showCreateCompteModal(context) async {
  final _libelle = TextEditingController();
  String? _devise;
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
            "Création compte",
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
                hintText: "Libellé du compte",
                iconPath: "assets/icons/label.svg",
                controller: _libelle,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomField(
                hintText: "Devise",
                iconPath: "assets/icons/money.svg",
                dropItems: const ["CDF", "USD"],
                isDropdown: true,
                onChangedDrop: (val) {
                  _devise = val!;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 50.0,
                child: ZoomIn(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_libelle.text.isEmpty) {
                        EasyLoading.showToast("Libellé du compte requis !");
                        return;
                      }
                      if (_devise == null) {
                        EasyLoading.showToast(
                            "Veuillez sélectionner une devise !");
                        return;
                      }
                      var db = await DBService.initDb();
                      var compte = Compte(
                        compteDevise: _devise,
                        compteLibelle: _libelle.text,
                      );
                      /* await db.insert("comptes", compte.toMap()).then(
                        (id) {
                          dataController.loadAllComptes();
                          dataController.loadActivatedComptes();
                          Get.back();
                        },
                      ); */
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
