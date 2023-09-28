import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../global/controllers.dart';
import '../../../models/stock.dart';
import '../../../services/db.service.dart';
import '/ui/widgets/custom_field.dart';
import '../../../config/utils.dart';
import '../util.dart';

Future<void> showSortieStockModal(context, {VoidCallback? onFinished}) async {
  var produits = await getProduits();
  List<Entree> entrees = [];

  Produit? produit;
  Entree? entree;
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
                        hintText: "Libellé produit",
                        iconPath: "assets/icons/label.svg",
                        dropItems: produits,
                        isDropdown: true,
                        onChangedDrop: (val) async {
                          Produit prod = val;
                          var list = await getEntrees(prod.produitId!);
                          Entree? emptyEntree;
                          setter(() {
                            entree = emptyEntree;
                            entrees = list;
                            soldeStock = 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(.7),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/label.svg",
                                    colorFilter: const ColorFilter.mode(
                                      primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                    width: 20.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: DropdownButtonFormField<Entree>(
                                  menuMaxHeight: 300,
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.white,
                                  isExpanded: true,
                                  alignment: Alignment.centerLeft,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 12.0,
                                  ),
                                  value: entree,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: "Sélectionner réference stock",
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    counterText: '',
                                  ),
                                  items: entrees.map((e) {
                                    return DropdownMenuItem<Entree>(
                                      value: e,
                                      child: Text(
                                        e.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          fontFamily: "Poppins",
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) async {
                                    Entree en = val!;
                                    double sommeOfSortie =
                                        await getCountSorties(en.entreeId!);

                                    double solde =
                                        en.entreeQte! - sommeOfSortie;
                                    setter(() {
                                      entree = en;
                                      soldeStock = solde;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        hintText: "Date entrée(optionnel)",
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
                        if (entree == null) {
                          EasyLoading.showToast(
                              "La Réference du stock est requise !");
                          return;
                        }
                        double qte =
                            double.parse(txtQte.text.replaceAll(',', ','));
                        double sommeOfSortie =
                            await getCountSorties(entree!.entreeId!);
                        /**
                         * check la quantité existante par rapport à la qté de sortie 
                         * pour valider une sortie
                        */
                        double solde = entree!.entreeQte! - sommeOfSortie;
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
                          sortieEntreeId: entree!.entreeId!,
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

Future<double> getCountSorties(int entreeId) async {
  var db = await DBService.initDb();
  var query = await db.rawQuery(
      "SELECT SUM(sortie_qte) AS somme FROM sorties WHERE NOT sortie_state = 'deleted' AND sortie_entree_id=$entreeId");
  if (query.first['somme'] == null) {
    return 0;
  }
  return double.parse(query.first['somme'].toString());
}
