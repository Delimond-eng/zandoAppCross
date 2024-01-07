// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zandoprintapp/global/controllers.dart';
import '../../../models/stock.dart';
import '../../../services/api.dart';
import '../../widgets/dashline.dart';
import '../../widgets/empty_state.dart';

import '../../../config/utils.dart';
import '../util.dart';

Future<void> showSortiesDetailsModal(context, {Produit? produit}) async {
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
            padding: const EdgeInsets.fromLTRB(40, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Details stock du produit : ${produit!.produitLibelle}",
                  style: const TextStyle(
                    fontFamily: defaultFont,
                    color: defaultTextColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    TabButton(
                      label: "Sorties",
                      isActive: current == 0,
                      onPressed: () {
                        setter(() => current = 0);
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
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          DashedLine(
            space: 4.0,
            color: Colors.grey.withOpacity(.4),
          ),
          if (current == 0) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
              child: produit.sorties!.isEmpty
                  ? const EmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      itemCount: produit.sorties!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = produit.sorties![index];
                        return SortieCard(
                          data: data,
                          onDeleted: () {
                            DGCustomDialog.showInteraction(context,
                                message:
                                    "Etes-vous sûr de vouloir supprimer cette sortie stock ?",
                                onValidated: () async {
                              Api.request(
                                  url: 'data.delete',
                                  method: 'post',
                                  body: {
                                    "table": "sorties",
                                    "id": data.id,
                                    "state": "sortie_state"
                                  }).then((res) async {
                                if (res.containsKey('status')) {
                                  int index = produit.sorties!.indexOf(data);
                                  setter(() {
                                    produit.sorties!.removeAt(index);
                                    dataController.loadStockData();
                                  });
                                }
                              });
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
          if (current == 1) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
              child: produit.entrees!.isEmpty
                  ? const EmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      itemCount: produit.entrees!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = produit.entrees![index];
                        return EntreeCard(
                          data: data,
                          onDeleted: () {
                            DGCustomDialog.showInteraction(context,
                                message:
                                    "Etes-vous sûr de vouloir supprimer cette entrée stock ?",
                                onValidated: () async {
                              Api.request(
                                  url: 'data.delete',
                                  method: 'post',
                                  body: {
                                    "table": "entrees",
                                    "id": data.id,
                                    "state": "entree_state"
                                  }).then((res) async {
                                if (res.containsKey('status')) {
                                  int index = produit.entrees!.indexOf(data);
                                  setter(() {
                                    produit.entrees!.removeAt(index);
                                    dataController.loadStockData();
                                  });
                                }
                              });
                            });
                          },
                        );
                      },
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
  final Sortie data;
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
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey.shade700,
                            size: 16.0,
                          ),
                          Text(
                            data.sortieCreateAt!,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                          data.sortieMotif!,
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
                          data.sortieQte!.toString(),
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
                      color: Colors.orange,
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
                          color: Colors.white,
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
  final Entree data;
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
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey.shade700,
                            size: 16.0,
                          ),
                          Text(
                            data.entreeCreateAt!,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                          data.entreeQte.toString(),
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
                          '${data.entreePrixAchat} ${data.entreePrixDevise}',
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
                      color: Colors.orange.shade700,
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
                          color: Colors.white,
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
