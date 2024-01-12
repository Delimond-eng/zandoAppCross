import 'package:flutter/material.dart';

import '../../../config/utils.dart';
import '../../../models/operation.dart';
import '../../widgets/ticket_card.dart';
import '../util.dart';

Future<void> showInventoryDetails(context, {List<Operation>? details}) async {
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width,
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
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    "Inventaires détails",
                    style: TextStyle(
                      fontFamily: defaultFont,
                      color: defaultTextColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: details!.length,
                  itemBuilder: (context, index) {
                    var detail = details[index];
                    return InventoryDetailsCard(
                      detail: detail,
                    );
                  },
                )
              ],
            ),
          )
        ],
      );
    }),
  );
}

class InventoryDetailsCard extends StatelessWidget {
  final Operation detail;
  const InventoryDetailsCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TicketCard(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: lightColor,
        isCornerRounded: true,
        borderColor: Colors.grey.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 14.0,
                  color: Colors.indigo,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  detail.operationCreateAt!,
                  style: const TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "N° facture",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: detail.facture!.factureId.toString().padLeft(3, '0'),
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Facture montant",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: detail.facture!.factureMontant.toString(),
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: " ${detail.facture!.factureDevise}",
                        style: const TextStyle(
                          fontSize: 8.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w500,
                          color: defaultTextColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Paiement",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: detail.facture!.totPay.toString(),
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: " ${detail.facture!.factureDevise}",
                        style: const TextStyle(
                          fontSize: 8.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w500,
                          color: defaultTextColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Compte",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  detail.compte!.compteLibelle!,
                  style: const TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Caissier",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  detail.facture!.user!.userName!,
                  style: const TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
