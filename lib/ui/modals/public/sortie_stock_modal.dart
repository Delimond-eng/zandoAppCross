// ignore_for_file: unnecessary_null_comparison

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/global/controllers.dart';
import 'package:zandoprintapp/services/api.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../models/stock.dart';
import '/ui/widgets/custom_field.dart';
import '../../../config/utils.dart';
import '../util.dart';

Future<void> showSortieStockModal(context) async {
  List<Produit> produits = List.from(dataController.stocks);
  Produit? produit;
  String? date;
  double soldeStock = 0;
  final txtQte = TextEditingController();
  final txtMotif = TextEditingController();
  bool isLoading = false;
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.20,
    child: StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sortie stock",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    color: defaultTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (soldeStock != 0)
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Stock disponible : ",
                          style: TextStyle(
                            fontFamily: defaultFont,
                            color: defaultTextColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: soldeStock.toString(),
                          style: const TextStyle(
                            fontFamily: defaultFont,
                            color: Colors.green,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomField(
                        hintText: "Sélectionnez produit",
                        iconPath: "assets/icons/label.svg",
                        dropItems: produits,
                        isDropdown: true,
                        selectedValue: produit,
                        onChangedDrop: (val) async {
                          setter(() {
                            soldeStock = 0;
                            produit = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Flexible(
                      child: CustomField(
                        hintText: "Quantité sortie",
                        iconPath: "assets/icons/money.svg",
                        inputType: TextInputType.number,
                        controller: txtQte,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: CustomField(
                        hintText: "Date sortie(optionnel)",
                        isDatePicker: true,
                        iconPath: '',
                        onDatePicked: (d) {
                          setter(() => date = d);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomField(
                  hintText: "Motif(optionnel)",
                  iconPath: "assets/icons/more.svg",
                  controller: txtMotif,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  width: 200.0,
                  child: ZoomIn(
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
                        if (txtQte.text.isEmpty) {
                          EasyLoading.showToast(
                              "Veuillez saisir la quantité à sortir du stock !");
                          return;
                        }
                        if (!txtQte.text.isNum) {
                          EasyLoading.showToast(
                              "La quantité saisie est invalide !");
                          return;
                        }
                        if (produit == null) {
                          EasyLoading.showToast(
                              "Veuillez sélectionner stock des produits !");
                          return;
                        }
                        setter(() => isLoading = true);
                        Api.request(url: 'stock.reduce', method: 'post', body: {
                          "sortie_motif": txtMotif.text,
                          "sortie_qte": txtQte.text,
                          "produit_id": produit!.id
                        }).then((res) {
                          setter(() => isLoading = false);
                          if (res.containsKey('errors')) {
                            EasyLoading.showToast(res['errors'].toString());
                            return;
                          }
                          if (res.containsKey('status')) {
                            EasyLoading.showSuccess(
                                'Sortie stock effectuée avec succès !');
                            dataController.loadStockData();
                            Get.back();
                          }
                        }).catchError((err) {
                          setter(() => isLoading = true);
                        });
                      },
                      color: Colors.orange,
                      icon: CupertinoIcons.checkmark_alt,
                      label: "Valider la sortie",
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    }),
  );
}
