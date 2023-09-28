import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import '/services/db.service.dart';
import '/ui/modals/util.dart';
import '/ui/widgets/custom_field.dart';

import '../../../global/controllers.dart';
import '../../../global/data_crypt.dart';
import '../../../models/user.dart';
import '/config/utils.dart';

Future<void> showLoginModal(context, {VoidCallback? onLoggedIn}) async {
  final userName = TextEditingController();
  final userPass = TextEditingController();
  await createDefaultUser();
  showCustomModal(
    context,
    width: 380.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: FadeInUp(
            child: Lottie.asset(
              'assets/anims/lock.json',
              height: 60.0,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        ZoomIn(
          child: const Text(
            "Authentification !",
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
                controller: userName,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomField(
                hintText: "Mot de passe",
                isPassword: true,
                iconPath: "assets/icons/lock.svg",
                controller: userPass,
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: ZoomIn(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final db = await DBService.initDb();
                      if (userName.text.isEmpty) {
                        EasyLoading.showToast(
                          'Nom d\'utilisateur est requis pour la connexion !',
                        );
                        return;
                      }
                      if (userPass.text.isEmpty) {
                        EasyLoading.showToast(
                          'Nom d\'utilisateur est requis pour la connexion !',
                        );
                        return;
                      }
                      try {
                        String uname = userName.text;
                        String upass = Cryptage.encrypt(userPass.text);
                        var checkedUser = await db.rawQuery(
                            "SELECT * FROM users WHERE user_name=? AND user_pass=?",
                            [uname, upass]);
                        if (checkedUser.isNotEmpty) {
                          User connected = User.fromMap(checkedUser[0]);
                          if (connected.userAccess == "allowed") {
                            authController.user.value = connected;
                            Future.delayed(Duration.zero, () {
                              Navigator.pop(context);
                            });
                            onLoggedIn!.call();
                            EasyLoading.showToast(
                              'Bienvenue !, connexion établie avec succès !',
                            );
                            return;
                          } else {
                            EasyLoading.showToast(
                                "l'accès à ce compte est restreint, l'administrateur doit activer le compte pour vous connecter !");
                            return;
                          }
                        } else {
                          EasyLoading.showToast(
                              "Mot de passe ou nom utilisateur invalide !");
                          return;
                        }
                      } catch (err) {
                        if (kDebugMode) {
                          print("error from connect user statment: $err");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 10.0,
                      textStyle: const TextStyle(
                        fontFamily: defaultFont,
                        color: lightColor,
                        fontSize: 14.0,
                      ),
                    ),
                    icon: const Icon(Icons.lock_open_rounded, size: 16.0),
                    label: const Text(
                      "S'Authentifier",
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

Future<void> createDefaultUser() async {
  final db = await DBService.initDb();
  var users = await db.query("users");
  if (kDebugMode) {
    print(users);
  }
  if (users.isEmpty) {
    var usr = User(
      userName: "Gaston",
      userPass: "12345",
      userRole: "admin",
    );
    var lastUserId = await db.insert("users", usr.toMap());
    if (kDebugMode) {
      print(lastUserId);
    }
  }
}
