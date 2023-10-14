// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/services/db.service.dart';
import '../../../models/stock.dart';
import '../../widgets/dashline.dart';
import '../../widgets/empty_state.dart';
import '/global/controllers.dart';

import '../../../config/utils.dart';
import '../util.dart';

Future<void> showSortiesDetailsModal(context, {Produit? produit}) async {
  dataController.loadStockData(2, id: produit!.produitId);
  int current = 0;
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width - 20.0,
    child: StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
            child: Text(
              "Stock : ${produit.produitLibelle!}. détails",
              style: const TextStyle(
                fontFamily: defaultFont,
                color: defaultTextColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Row(
              children: [
                TabButton(
                  label: "Sorties",
                  isActive: current == 0,
                  onPressed: () {
                    setter(() => current = 0);
                    dataController.loadStockData(2, id: produit.produitId);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                TabButton(
                  label: 'Entrées',
                  isActive: current != 0,
                  onPressed: () {
                    setter(() => current = 1);
                    dataController.loadStockData(0, id: produit.produitId);
                  },
                ),
              ],
            ),
          ),
          DashedLine(
            space: 2.0,
            color: Colors.grey.withOpacity(.4),
          ),
          if (current == 0) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => dataController.allSorties.isEmpty
                        ? const EmptyState()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            itemCount: dataController.allSorties.length,
                            itemBuilder: (BuildContext context, int index) {
                              var data = dataController.allSorties[index];
                              return SortieCard(
                                data: data,
                                onDeleted: () {
                                  DGCustomDialog.showInteraction(context,
                                      message:
                                          "Etes-vous sûr de vouloir supprimer cette sortie stock ?",
                                      onValidated: () async {
                                    var db = await DBService.initDb();
                                    var id = await db.update(
                                        "sorties", {"sortie_state": "deleted"},
                                        where: "sortie_id = ?",
                                        whereArgs: [data.sortie!.sortieId]);
                                    if (id != null) {
                                      dataController.loadStockData(2,
                                          id: data.produitId);
                                      dataController.loadStockData(1);
                                      EasyLoading.showSuccess(
                                          "Suppression effectuée !");
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ],
          if (current == 1) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => dataController.allEntrees.isEmpty
                        ? const EmptyState()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            itemCount: dataController.allEntrees.length,
                            itemBuilder: (BuildContext context, int index) {
                              var data = dataController.allEntrees[index];
                              return EntreeCard(
                                data: data,
                                onDeleted: () {
                                  DGCustomDialog.showInteraction(context,
                                      message:
                                          "Etes-vous sûr de vouloir supprimer cette entrée stock ?",
                                      onValidated: () async {
                                    var db = await DBService.initDb();
                                    var id = await db.update(
                                        "entrees", {"entree_state": "deleted"},
                                        where: "entree_id = ?",
                                        whereArgs: [data.entree!.entreeId!]);
                                    if (id != null) {
                                      dataController.loadStockData(0,
                                          id: data.produitId);
                                      dataController.loadStockData(1);
                                      EasyLoading.showSuccess(
                                          "Suppression effectuée !");
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ]
        ],
      );
    }),
  );
}

class TabButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;
  final String label;
  const TabButton({
    super.key,
    this.isActive = false,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : primaryColor.shade100,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : primaryColor.shade900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SortieCard extends StatelessWidget {
  final Produit data;
  final VoidCallback? onDeleted;
  const SortieCard({
    super.key,
    required this.data,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            data.sortie!.sortieCreateAt!.split('-').first,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w800,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          "${data.sortie!.sortieCreateAt!.split('-')[1]}/${data.sortie!.sortieCreateAt!.split('-').last}",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Libellé produit",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.produitLibelle!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Motif",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.sortie!.sortieMotif!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Qté Sortie",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.sortie!.sortieQte!.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: onDeleted,
                        child: const Icon(
                          CupertinoIcons.trash,
                          size: 16.0,
                          color: defaultTextColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        DashedLine(
          space: 5.0,
          color: Colors.grey.shade400,
          height: .5,
        )
      ],
    );
  }
}

class EntreeCard extends StatelessWidget {
  final Produit data;
  final VoidCallback? onDeleted;
  const EntreeCard({
    super.key,
    required this.data,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            data.entree!.entreeCreateAt!.split('-').first,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w800,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          "${data.entree!.entreeCreateAt!.split('-')[1]}/${data.entree!.entreeCreateAt!.split('-').last}",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Libellé produit",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.produitLibelle!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Qté Entrée",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.entree!.entreeQte.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Prix d'achat",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          '${data.entree!.entreePrixAchat} ${data.entree!.entreePrixDevise}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: onDeleted,
                        child: const Icon(
                          CupertinoIcons.trash,
                          size: 16.0,
                          color: defaultTextColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        DashedLine(
          space: 5.0,
          color: Colors.grey.shade400,
          height: .5,
        )
      ],
    );
  }
}
