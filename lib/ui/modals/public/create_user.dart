import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/models/user.dart';
import '/global/controllers.dart';
import '/services/db.service.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showCreateUserModal(context) async {
  /* var db = await DBService.initDb();
  await db.update(
    "clients",
    {"client_state": "allowed"},
  );
  dataController.loadClients(); */
  final txtUserName = TextEditingController();
  final txtUserPass = TextEditingController();
  String? userRole;
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
            "Création comptes utilisateurs",
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomField(
                hintText: "Nom d'utilisateur",
                iconPath: "assets/icons/user.svg",
                controller: txtUserName,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomField(
                hintText: "Rôle ou accès",
                iconPath: "assets/icons/user.svg",
                dropItems: const [
                  "admin",
                  "utilisateur",
                  "gestionnaire stock",
                ],
                isDropdown: true,
                onChangedDrop: (val) {
                  userRole = val;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomField(
                hintText: "Mot de passe",
                iconPath: "assets/icons/lock.svg",
                isPassword: true,
                controller: txtUserPass,
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ZoomIn(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final db = await DBService.initDb();

                      if (txtUserName.text.isEmpty) {
                        EasyLoading.showToast("Nom d'utilisateur requis !");
                        return;
                      }
                      if (userRole == null) {
                        EasyLoading.showToast(
                            "Veuillez sélectionner un rôle de l'utilisateur dans le système !");
                        return;
                      }
                      if (txtUserPass.text.isEmpty) {
                        EasyLoading.showToast(
                            "Mot de passe de l'utilisateur requis !");
                        return;
                      }
                      var usr = User(
                        userName: txtUserName.text,
                        userRole: userRole,
                        userPass: txtUserPass.text,
                      );

                      /* db.insert("users", usr.toMap()).then((value) {
                        EasyLoading.showSuccess(
                          "Nouveau utilisateur créé avec succès !",
                        );
                        dataController.loadUsers();
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                      }); */
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
                    icon: const Icon(CupertinoIcons.person_badge_plus),
                    label: const Text(
                      "Créer nouveau utilisateur",
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
