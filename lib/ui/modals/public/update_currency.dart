import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../global/controllers.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '/ui/modals/util.dart';

Future<void> showUpdateCurrencyModal(context) async {
  final cText = TextEditingController();
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
            "Mettre à jour le taux du jour",
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: CustomField(
                  controller: cText,
                  hintText: "Saisir le taux en CDF",
                  iconPath: "assets/icons/money.svg",
                  inputType: TextInputType.number,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              SizedBox(
                height: 50.0,
                child: ZoomIn(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (cText.text.isEmpty) {
                        EasyLoading.showToast(
                            'veuillez entrer un taux du jour !');
                        return;
                      }
                      await dataController
                          .editCurrency(value: cText.text)
                          .then((_) {
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                      });
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
                      "Mettre à jour",
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
