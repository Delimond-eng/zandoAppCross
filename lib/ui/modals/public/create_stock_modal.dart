import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/global/controllers.dart';
import '/services/db.service.dart';
import '../../../models/stock.dart';
import '/ui/widgets/custom_field.dart';

import '../../../config/utils.dart';
import '../../widgets/custom_checkbox.dart';
import '../util.dart';

Future<void> showCreateStockModal(context) async {
  bool isNew = true;
  bool isOld = false;
  Produit? produit;
  List<Produit> produits = [];

  //Fields;
  final txtLibProduit = TextEditingController();
  final txtQteProduit = TextEditingController();
  final txtPrixAchatProduit = TextEditingController();
  String devise = "USD";
  String? date;
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
                          setter(() {
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
                          setter(() {
                            isOld = true;
                            isNew = false;
                          });
                          if (isOld) {
                            var p = await getProduits();
                            setter(() => produits = p);
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
                  child: ZoomIn(
                    child: ElevatedButton.icon(
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
                        var db = await DBService.initDb();
                        int? latestProduitId;
                        var beContinued =
                            await DBService.checkAvailability("produits");
                        if (beContinued) {
                          EasyLoading.showToast(
                              "Vous utiliser une version d'essai !, pour continuer cette appli doit être activée !");
                          return;
                        }
                        if (isNew) {
                          produit = Produit(
                              produitLibelle: txtLibProduit.text,
                              produitCreateAt: date);
                          latestProduitId =
                              await db.insert("produits", produit!.toMap());
                        }

                        var entree = Entree(
                          entreePrixAchat: double.parse(
                              txtPrixAchatProduit.text.replaceAll(',', '.')),
                          entreePrixDevise: devise,
                          entreeQte: double.parse(
                              txtQteProduit.text.replaceAll(',', '.')),
                          entreeCreateAt: date,
                          entreeProduitId:
                              latestProduitId ?? produit!.produitId,
                        );
                        var beContinued2 =
                            await DBService.checkAvailability("entrees");
                        if (beContinued2) {
                          EasyLoading.showToast(
                              "Vous utiliser une version d'essai !, pour continuer cette appli doit être activée !");
                          return;
                        }
                        db.insert("entrees", entree.toMap()).then((value) {
                          setter(() {
                            txtLibProduit.clear();
                            txtQteProduit.clear();
                            txtPrixAchatProduit.clear();
                          });
                          dataController.loadStockData(1);
                          EasyLoading.showSuccess(
                            "Nouveau stock créé avec succès !",
                          );
                        }).catchError((e) {
                          if (kDebugMode) {
                            print("error from insert statment ! : $e");
                          }
                          return e;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 10.0,
                        textStyle: const TextStyle(
                          fontFamily: defaultFont,
                          color: lightColor,
                          fontSize: 14.0,
                        ),
                      ),
                      icon: const Icon(CupertinoIcons.add, size: 16.0),
                      label: const Text(
                        "Créer nouveau stock",
                      ),
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

Future<List<Produit>> getProduits() async {
  List<Produit> products = [];
  var db = await DBService.initDb();
  var query = await db
      .rawQuery("SELECT * FROM produits WHERE NOT produit_state = 'deleted'");
  for (var e in query) {
    products.add(Produit.fromMap(e));
  }
  return products;
}
