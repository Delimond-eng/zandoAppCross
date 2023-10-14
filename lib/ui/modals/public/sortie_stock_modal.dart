// ignore_for_file: unnecessary_null_comparison

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../global/controllers.dart';
import '../../../models/stock.dart';
import '../../../services/db.service.dart';
import '/ui/widgets/custom_field.dart';
import '../../../config/utils.dart';
import '../util.dart';

Future<void> showSortieStockModal(context, {VoidCallback? onFinished}) async {
  var produits = await getProduits();

  Produit? produit;
  String? date;
  double soldeStock = 0;
  final txtQte = TextEditingController();
  final txtMotif = TextEditingController();
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
                        onChangedDrop: (val) async {
                          setter(() {
                            soldeStock = 0;
                            produit = val as Produit;
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
                  child: ZoomIn(
                    child: ElevatedButton.icon(
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
                        double qte =
                            double.parse(txtQte.text.replaceAll(',', ','));
                        double sommeOfSortie =
                            await getCountSorties(produit!.produitId!);
                        double sommeOfEntree =
                            await getCountEntrees(produit!.produitId!);
                        /**
                         * check la quantité existante par rapport à la qté de sortie 
                         * pour valider une sortie
                        */
                        double solde = sommeOfEntree - sommeOfSortie;
                        double checkSum = solde - qte;
                        if (checkSum.isNegative) {
                          EasyLoading.showToast(
                            "La quantité du stock restant est inférieur à la quantité saisie \n La quantité du stock actuel est de : $solde unités",
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }
                        /**
                         * Insertion des données dans la base de données !
                        */
                        var db = await DBService.initDb();
                        var data = Sortie(
                          sortieProduitId: produit!.produitId!,
                          sortieMotif: txtMotif.text,
                          sortieQte:
                              double.parse(txtQte.text.replaceAll(',', '.')),
                          sortieCreateAt: date,
                        );
                        db.insert("sorties", data.toMap()).then((value) {
                          EasyLoading.showSuccess(
                              "Une sortie est effectué avec succès !");
                          dataController.loadStockData(1);
                          Get.back();
                        }).catchError((e) {
                          if (kDebugMode) {
                            print(e);
                          }
                          return e;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        elevation: 10.0,
                        textStyle: const TextStyle(
                          fontFamily: defaultFont,
                          color: lightColor,
                          fontSize: 14.0,
                        ),
                      ),
                      icon:
                          const Icon(CupertinoIcons.checkmark_alt, size: 16.0),
                      label: const Text(
                        "Valider la sortie",
                      ),
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

Future<List<Entree>> getEntrees(int produitId) async {
  List<Entree> entrees = [];
  var db = await DBService.initDb();
  var query = await db.rawQuery(
      "SELECT * FROM entrees WHERE NOT entree_state = 'deleted' AND entree_produit_id=$produitId");
  for (var e in query) {
    entrees.add(Entree.fromMap(e));
  }
  return entrees;
}

Future<double> getCountSorties(int produitId) async {
  var db = await DBService.initDb();
  var query = await db.rawQuery(
      "SELECT TOTAL(sortie_qte) AS total_sorties FROM sorties WHERE NOT sortie_state = 'deleted' AND sortie_produit_id=$produitId");
  if (query.first['total_sorties'] == null) {
    return 0;
  }
  return double.parse(query.first['total_sorties'].toString());
}

Future<double> getCountEntrees(int produitId) async {
  var db = await DBService.initDb();
  var query = await db.rawQuery(
      "SELECT TOTAL(entree_qte) AS total_entrees FROM entrees WHERE NOT entree_state = 'deleted' AND entree_produit_id=$produitId");
  if (query.first['total_entrees'] == null) {
    return 0;
  }
  return double.parse(query.first['total_entrees'].toString());
}
