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
import '../../widgets/custom_checkbox.dart';
import '../util.dart';

Future<void> showCreateStockModal(context) async {
  bool isNew = true;
  bool isOld = false;
  Produit? produit;
  List<Produit> produits = List.from(dataController.stocks);
  //Fields;
  final txtLibProduit = TextEditingController();
  final txtQteProduit = TextEditingController();
  final txtPrixAchatProduit = TextEditingController();
  String devise = "USD";
  String? date;
  bool isLoading = false;
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
          child: Text(
            "Nouveau stock",
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
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomCheckBox(
                        title: "Stock pour un nouveau produit",
                        value: isNew,
                        onChanged: () {
                          Produit? p;
                          setter(() {
                            produit = p;
                            isNew = true;
                            isOld = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: CustomCheckBox(
                        title: "Stock pour un produit existant",
                        value: isOld,
                        onChanged: () async {
                          Produit? p;
                          setter(() {
                            produit = p;
                            isOld = true;
                            isNew = false;
                          });
                          if (isOld) {
                            setter(() =>
                                produits = List.from(dataController.stocks));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: CustomField(
                        hintText: isOld
                            ? (produits.isEmpty)
                                ? "Aucun produit répertorié !"
                                : "Sélectionner libellé produit"
                            : "Libellé produit",
                        controller: txtLibProduit,
                        iconPath: "assets/icons/label.svg",
                        dropItems: produits,
                        isDropdown: isOld,
                        selectedValue: produit,
                        onChangedDrop: (val) {
                          setter(() => produit = val);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: CustomField(
                        hintText: "Entrée quantité",
                        controller: txtQteProduit,
                        inputType: TextInputType.number,
                        iconPath: "assets/icons/label.svg",
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
                        hintText: "Prix d'achat",
                        iconPath: "assets/icons/money.svg",
                        controller: txtPrixAchatProduit,
                        inputType: TextInputType.number,
                        isCurrency: true,
                        onChangedCurrency: (cu) {
                          setter(() => devise = cu!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: CustomField(
                        hintText: "Date entrée(optionnel)",
                        isDatePicker: true,
                        iconPath: '',
                        onDatePicked: (d) {
                          setter(() => date = d!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  width: 220.0,
                  child: ZoomIn(
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
                        if (txtPrixAchatProduit.text.isEmpty) {
                          EasyLoading.showToast("Prix d'achat requis !");
                          return;
                        }
                        if (txtPrixAchatProduit.text.isEmpty) {
                          EasyLoading.showToast("Prix d'achat requis !");
                          return;
                        }
                        if (!txtQteProduit.text.isNum) {
                          EasyLoading.showToast("Quantité stock invalide !");
                          return;
                        }
                        if (isNew) {
                          setter(() => isLoading = true);
                          Api.request(
                                  url: 'product.create',
                                  method: 'post',
                                  body: {"produit_libelle": txtLibProduit.text})
                              .then((res) async {
                            setter(() => isLoading = false);
                            if (res.containsKey("errors")) {
                              EasyLoading.showToast(res['errors'].toString());
                            }
                            if (res.containsKey('status')) {
                              int produitId =
                                  int.parse(res['produit']['id'].toString());
                              Api.request(
                                  url: 'stock.append',
                                  method: 'post',
                                  body: {
                                    "entree_qte": txtQteProduit.text,
                                    "entree_prix_achat":
                                        txtPrixAchatProduit.text,
                                    "entree_prix_devise": devise,
                                    "produit_id": produitId
                                  }).then((value) {
                                Produit? p;
                                setter(() {
                                  produit = p;
                                  txtLibProduit.clear();
                                  txtQteProduit.clear();
                                  txtPrixAchatProduit.clear();
                                });
                                dataController.loadStockData();
                                EasyLoading.showSuccess(
                                  "Nouveau stock créé avec succès !",
                                );
                              });
                            }
                          }).catchError((e) {
                            setter(() => isLoading = false);
                          });
                        } else {
                          setter(() => isLoading = true);
                          Api.request(
                              url: 'stock.append',
                              method: 'post',
                              body: {
                                "entree_qte": txtQteProduit.text,
                                "entree_prix_achat": txtPrixAchatProduit.text,
                                "entree_prix_devise": devise,
                                "produit_id": produit!.id
                              }).then((res) {
                            Produit? p;
                            setter(() {
                              produit = p;
                              isLoading = false;
                              txtLibProduit.clear();
                              txtQteProduit.clear();
                              txtPrixAchatProduit.clear();
                            });
                            dataController.loadStockData();
                            EasyLoading.showSuccess(
                              "Nouveau stock créé avec succès !",
                            );
                          });
                        }
                      },
                      color: Colors.green,
                      icon: CupertinoIcons.add,
                      label: "Créer nouveau stock",
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
