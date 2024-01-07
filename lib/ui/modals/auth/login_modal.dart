import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../services/api.dart';
import '/services/db.service.dart';
import '/ui/modals/util.dart';
import '/ui/widgets/custom_field.dart';

import '../../../global/controllers.dart';
import '../../../models/user.dart';
import '/config/utils.dart';

Future<void> showLoginModal(context, {VoidCallback? onLoggedIn}) async {
  final userName = TextEditingController();
  final userPass = TextEditingController();
  bool isLoading = false;
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
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
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
                          setter(() => isLoading = true);
                          Api.request(method: 'post', url: "user.login", body: {
                            "name": userName.text,
                            "password": userPass.text,
                          }).then((res) {
                            setter(() => isLoading = false);
                            if (res.containsKey('errors')) {
                              EasyLoading.showToast(res['errors'].toString());
                              return;
                            }
                            if (res['status'] == 'success') {
                              User connected = User.fromMap(res['user']);
                              authController.user.value = connected;
                              Future.delayed(Duration.zero, () {
                                Navigator.pop(context);
                              });
                              onLoggedIn!.call();
                              EasyLoading.showToast(
                                'Bienvenue !, connexion établie avec succès !',
                              );
                            }
                          }).catchError((e) {
                            debugPrint(e.toString());
                            setter(() => isLoading = false);
                          });
                        } catch (err) {
                          setter(() => isLoading = false);
                          if (kDebugMode) {
                            print("error from connect user statment: $err");
                          }
                        }
                      },
                      icon: Icons.lock_open_rounded,
                      label: "S'Authentifier",
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

Future<void> createDefaultUser() async {
  final db = await DBService.initDb();
  var users =
      await db.query("users", where: "user_name=?", whereArgs: ['admin']);
  if (kDebugMode) {
    print(users);
  }
  if (users.isEmpty) {
    var usr = User(
      userName: "admin",
      userPass: "12345",
      userRole: "admin",
    );
    var lastUserId = await db.insert("users", usr.toMap());
    if (kDebugMode) {
      print(lastUserId);
    }
  }
}
