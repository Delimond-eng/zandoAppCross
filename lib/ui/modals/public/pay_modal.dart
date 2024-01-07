// ignore_for_file: unnecessary_null_comparison

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../services/api.dart';
import '/services/utils.dart';
import '../../../models/facture.dart';
import '/global/controllers.dart';
import '/models/compte.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showPayModal(context, {required Facture facture}) async {
  final textMontant = TextEditingController();
  Compte? selectCompte;
  String? modePaie;
  String devise = "USD";
  textMontant.text = facture.restToPay.toString();
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
            "Paiement de la facture",
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
                hintText: "Montant paiement",
                iconPath: "assets/icons/money.svg",
                inputType: TextInputType.phone,
                controller: textMontant,
                isCurrency: true,
                onChangedCurrency: (value) {
                  devise = value!;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomField(
                      hintText: "Mode paiement",
                      iconPath: "assets/icons/money-receive.svg",
                      dropItems: const [
                        "Cash",
                        "Paiement mobile",
                        "Virement",
                        "Chèque",
                      ],
                      isDropdown: true,
                      onChangedDrop: (val) {
                        modePaie = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: CustomField(
                      hintText: "Compte",
                      iconPath: "assets/icons/money-bag.svg",
                      dropItems: dataController.comptes,
                      isDropdown: true,
                      onChangedDrop: (val) {
                        selectCompte = val;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              StatefulBuilder(builder: (context, setter) {
                return SizedBox(
                  height: 50.0,
                  width: 200.0,
                  child: ZoomIn(
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
                        /* check empty fields */
                        if (textMontant.text.isEmpty) {
                          EasyLoading.showToast(
                              "Vous devez entrer le montant du paiement !");
                          return;
                        }
                        if (devise == null) {
                          EasyLoading.showToast(
                              "Vous devez sélectionner une devise !");
                          return;
                        }
                        if (modePaie == null) {
                          EasyLoading.showToast(
                              "Vous devez sélectionner un mode de paiement !");
                          return;
                        }
                        if (selectCompte == null) {
                          EasyLoading.showToast(
                              "Veuillez sélectionner le compte pour percevoir ce paiement !");
                          return;
                        }

                        var convertedInputAmount =
                            double.parse(textMontant.text);
                        if (devise == "CDF") {
                          convertedInputAmount = double.parse(
                            convertCdfToDollars(convertedInputAmount)
                                .toStringAsFixed(2),
                          );
                        }
                        setter(() => isLoading = true);

                        Api.request(url: 'facture.pay', method: 'post', body: {
                          "facture_montant":
                              double.parse(facture.factureMontant.toString()),
                          "operation_montant": convertedInputAmount,
                          "operation_devise": devise,
                          "operation_mode": modePaie,
                          "facture_id": int.parse(facture.factureId.toString()),
                          "user_id": int.parse(
                              authController.user.value.userId.toString()),
                          "compte_id":
                              int.parse(selectCompte!.compteId.toString())
                        }).then((res) {
                          setter(() => isLoading = false);
                          if (res.containsKey('errors')) {
                            EasyLoading.showInfo(res['errors'].toString());
                            return;
                          }
                          if (res.containsKey('status')) {
                            if (res['status'] == 'success') {
                              Get.back();
                              EasyLoading.showSuccess(
                                  "Paiement effectué avec succès !");
                              dataController.loadFacturesEnAttente();
                              dataController.refreshDashboardCounts();
                              dataController.refreshDayCompteSum();
                              dataController.countDaySum();
                              dataController.loadFilterFactures("all");
                            }
                          }
                        });
                      },
                      color: Colors.green,
                      icon: Icons.check,
                      label: "Valider le paiement",
                    ),
                  ),
                );
              })
            ],
          ),
        )
      ],
    ),
  );
}
