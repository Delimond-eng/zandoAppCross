import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '/global/controllers.dart';
import '/services/db.service.dart';

import '../../../config/utils.dart';
import '../../../models/operation.dart';
import '../../widgets/dashline.dart';
import '../util.dart';

Future<void> showPaiementDetail(context) async {
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width - 20.0,
    child: StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Text(
                    "Paiement détails",
                    style: TextStyle(
                      fontFamily: defaultFont,
                      color: defaultTextColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataController.paiementDetails.length,
                    itemBuilder: (context, index) {
                      var detail = dataController.paiementDetails[index];
                      return PaiementDetailCard(
                        detail: detail,
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

class PaiementDetailCard extends StatelessWidget {
  final Operations detail;
  const PaiementDetailCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 2,
            ),
          ),
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
                          size: 15.0,
                        ),
                        Text(
                          detail.operationDate!.split('-').first,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w800,
                            color: defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${detail.operationDate!.split('-')[1]}/${detail.operationDate!.split('-').last}",
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w500,
                        color: defaultTextColor,
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
                        "N°Facture",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade800,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        detail.facture!.factureId.toString().padLeft(3, "0"),
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
                        "Montant",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        "${detail.facture!.factureMontant!} ${detail.facture!.factureDevise}",
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
                        "Paiement",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        "${detail.operationMontant} ${detail.operationDevise}",
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w600,
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
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/user.svg",
                            height: 12.0,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Client",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        detail.client!.clientNom!,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      detail.operationMode!,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.w600,
                        color: defaultTextColor,
                      ),
                    ),
                    const SizedBox(
                      width: 2.0,
                    ),
                  ],
                ),
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                      onTap: () {
                        deletePaiement(context, detail);
                      },
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/delete.svg",
                          height: 14.0,
                          colorFilter: const ColorFilter.mode(
                            Colors.red,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
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

  deletePaiement(BuildContext context, Operations data) async {
    var db = await DBService.initDb();
    // ignore: use_build_context_synchronously
    DGCustomDialog.showInteraction(context,
        message: "Etes-vous sûr de vouloir supprimer ce paiement ?",
        onValidated: () {
      db
          .update(
        'factures',
        {'facture_statut': 'en cours'},
        where: 'facture_id = ?',
        whereArgs: [data.operationFactureId],
      )
          .then((id) {
        db.update(
          "operations",
          {"operation_state": "deleted"},
          where: "operation_id=?",
          whereArgs: [data.operationId],
        );
        dataController.loadPayments("all");
        Get.back();
      });
    });
  }
}
