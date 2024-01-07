import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../global/controllers.dart';
import '../../../services/api.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showCreateUserModal(context) async {
  final txtUserName = TextEditingController();
  final txtUserPass = TextEditingController();
  String? userRole;
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
            "Création comptes utilisateurs",
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
                  selectedValue: userRole,
                  dropItems: const [
                    "admin",
                    "utilisateur",
                    "gestionnaire stock",
                  ],
                  isDropdown: true,
                  onChangedDrop: (val) {
                    setter(() {
                      userRole = val;
                    });
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
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
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
                        try {
                          setter(() => isLoading = true);
                          var map = {
                            "name": txtUserName.text,
                            "password": txtUserPass.text,
                            "role": userRole.toString(),
                            /* "user_id":
                                authController.selectedEditUser.value.userId !=
                                        0
                                    ? int.tryParse(authController
                                        .selectedEditUser.value.userId!
                                        .toString())
                                    : null */
                          };
                          setter(() => isLoading = true);
                          Api.request(
                                  url: 'user.create', method: 'post', body: map)
                              .then((res) {
                            setter(() => isLoading = false);
                            if (res.containsKey('errors')) {
                              EasyLoading.showToast(res['errors'].toString());
                              return;
                            }
                            if (res.containsKey('status')) {
                              /*  authController.selectedEditUser.value =
                                  User(userId: 0); */
                              dataController.refreshConfigs();
                              txtUserName.clear();
                              txtUserPass.clear();
                              String? role;
                              setter(() {
                                userRole = role;
                              });
                            }
                          }).catchError((error) {
                            setter(() => isLoading = false);
                            EasyLoading.showToast(
                                "Echec de traitement de la requête !");
                          });
                        } catch (err) {
                          setter(() => isLoading = false);
                          EasyLoading.showToast(
                              "Echec de traitement de la requête !");
                        }
                      },
                      color: Colors.green,
                      icon: authController.selectedEditUser.value.userId == 0
                          ? CupertinoIcons.person_badge_plus
                          : Icons.edit,
                      label: "Valider & soumettre",
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
