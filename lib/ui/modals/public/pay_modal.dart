import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/services/db.service.dart';
import '/services/utils.dart';
import '/ui/widgets/action_btn.dart';
import '../../../models/facture.dart';
import '../../../models/operation.dart';
import '../../../reports/report.dart';
import '/global/controllers.dart';
import '/models/compte.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showPayModal(context, {required Facture facture}) async {
  final textMontant = TextEditingController();
  String? datePaie = dateToString(DateTime.now());
  Compte? selectCompte;
  String? modePaie;
  String devise = "USD";

  var lastPayment = await Report.checkLastPay(facture.factureId);
  if (lastPayment != null) {
    var currentAmount = double.parse(facture.factureMontant!) -
        double.parse(lastPayment.toString());
    textMontant.text = currentAmount.toStringAsFixed(2);
  } else {
    textMontant.text = facture.factureMontant!;
  }
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
              StatefulBuilder(builder: (context, setter) {
                return ActionBtn(
                  hintText: "Date paiement",
                  icon: Icons.calendar_month,
                  onClear: () {
                    setter(() {
                      datePaie = null;
                    });
                  },
                  onTap: () async {
                    var iDate = await showDatePicked(context);
                    setter(() {
                      datePaie = iDate;
                    });
                  },
                  value: datePaie,
                );
              }),
              const SizedBox(
                height: 10.0,
              ),
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
              SizedBox(
                height: 50.0,
                child: ZoomIn(
                  child: ElevatedButton.icon(
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
                      /* end check empty fields */

                      /* check last pay */
                      var lastPay =
                          await Report.checkLastPay(facture.factureId);
                      /* end check last pay */

                      var convertedInputAmount = double.parse(textMontant.text);
                      if (devise == "CDF") {
                        convertedInputAmount = double.parse(
                          convertCdfToDollars(convertedInputAmount)
                              .toStringAsFixed(2),
                        );
                      }
                      double checkAmount = 0;
                      double factureAmount =
                          double.parse(facture.factureMontant!);
                      if (lastPay == null) {
                        checkAmount = factureAmount - convertedInputAmount;
                        if (checkAmount.isNegative) {
                          EasyLoading.showToast(
                            "Le montant de paiement saisi dépasse le frais de la facture sélectionnée !",
                            duration: const Duration(milliseconds: 1000),
                          );
                          return;
                        }
                      } else {
                        double c =
                            factureAmount - double.parse(lastPay.toString());
                        checkAmount = c - convertedInputAmount;
                        if (c == 0) {
                          EasyLoading.showToast(
                            "Cette facture a été déjà payé à la totalité !",
                            duration: const Duration(milliseconds: 1000),
                          );
                          return;
                        }

                        if (checkAmount.isNegative) {
                          EasyLoading.showToast(
                            "Le montant de paiement saisi dépasse le frais restant de la facture sélectionnée !",
                            duration: const Duration(milliseconds: 1000),
                          );
                          return;
                        }
                      }
                      /**Creating payment  statment**/
                      var data = Operations(
                        operationCompteId: selectCompte!.compteId,
                        operationDevise: devise,
                        operationFactureId: facture.factureId,
                        operationLibelle: "Paiement facture",
                        operationMontant: convertedInputAmount,
                        operationType: "entrée",
                        operationUserId: authController.user.value.userId ?? 1,
                        operationMode: modePaie,
                        operationTimestamp: datePaie,
                      );
                      /* Insert data from database */
                      var db = await DBService.initDb();
                      await db
                          .insert("operations", data.toMap())
                          .then((resId) async {
                        if (checkAmount == 0) {
                          /* check if payment is all ready */
                          await db.update(
                            "factures",
                            {"facture_statut": "paie"},
                            where: "facture_id= ?",
                            whereArgs: [facture.factureId],
                          );
                          /* end statment */
                        }
                        EasyLoading.showSuccess(
                          "Paiement effectué avec succès !",
                        );
                        dataController.loadFacturesEnAttente();
                        dataController.countDaySum();
                        dataController.refreshDatas();
                        dataController.loadFilterFactures('all');
                        Get.back();
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
                      "Valider le paiement",
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
