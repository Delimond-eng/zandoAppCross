import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../global/controllers.dart';
import '../../../models/compte.dart';
import '../../../services/api.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '/ui/modals/util.dart';

Future<void> showCreateCompteModal(context) async {
  final _libelle = TextEditingController();
  String? _devise;
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
            "Création compte",
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
                  selectedValue: _devise,
                  onChangedDrop: (val) {
                    _devise = val!;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  width: 180.0,
                  child: ZoomIn(
                    child: SubmitButton(
                      loading: isLoading,
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
                        var compte = Compte(
                          compteDevise: _devise,
                          compteLibelle: _libelle.text,
                        );
                        setter(() => isLoading = true);
                        Api.request(
                          method: 'post',
                          url: 'compte.create',
                          body: compte.toMap(),
                        ).then((res) {
                          setter(() => isLoading = false);
                          if (res.containsKey('errors')) {
                            EasyLoading.showToast(res['errors'].toString());
                            return;
                          }
                          if (res.containsKey('status')) {
                            dataController.refreshConfigs();
                            String? d;
                            setter(() {
                              _devise = d;
                              _libelle.clear();
                            });
                            EasyLoading.showSuccess(
                                "Compte créé avec succès !");
                          }
                        }).catchError((e) {
                          setter(() => isLoading = false);
                        });
                      },
                      color: Colors.green,
                      icon: Icons.check,
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
