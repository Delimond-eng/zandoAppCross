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

Future<void> showSortiesDetailsModal(context, {Entree? selectedEntree}) async {
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
              "Stock ${selectedEntree!.entreeRef}. détails",
              style: const TextStyle(
                fontFamily: defaultFont,
                color: defaultTextColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
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
                                      whereArgs: [data.sortieId]);
                                  if (id != null) {
                                    dataController.loadStockData(2,
                                        id: data.sortieEntreeId);
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
          )
        ],
      );
    }),
  );
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
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            data.sortieCreateAt!.split('-').first,
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
                          "${data.sortieCreateAt!.split('-')[1]}/${data.sortieCreateAt!.split('-').last}",
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
                          data.entree!.produit!.produitLibelle!,
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
                          "Ref. entrée",
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
                          data.entree!.entreeRef!,
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
