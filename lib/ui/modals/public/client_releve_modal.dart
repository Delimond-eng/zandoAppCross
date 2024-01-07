import 'package:flutter/material.dart';
import 'package:zandoprintapp/ui/widgets/dashline.dart';
import '../../../models/client.dart';

import '../../../config/utils.dart';
import '../../../models/operation.dart';
import '../util.dart';

Future<void> showClientReleve(context, {Client? client}) async {
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.30,
    child: StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
            child: Text(
              "Relevés du client : ${client!.clientNom}",
              style: const TextStyle(
                fontFamily: defaultFont,
                color: defaultTextColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          for (var e in client.factures!) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 2),
              decoration: BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 14.0,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  e.factureDateCreate!,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.indigo,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(text: "N° Facture : "),
                                  TextSpan(
                                    text:
                                        e.factureId.toString().padLeft(3, "0"),
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const DashedLine(
                      color: Colors.grey,
                      space: 5.0,
                    ),
                    factureDetails(
                      context,
                      paiements: e.paiements,
                    )
                  ],
                ),
              ),
            ),
          ]
        ],
      );
    }),
  );
}

Widget factureDetails(context, {List<Operation>? paiements}) {
  return Column(
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Date",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Montant",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Mode de paiement",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Caissier",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      const DashedLine(
        height: 1.0,
        color: Colors.grey,
      ),
      for (var item in paiements!) ...[
        Container(
          margin: const EdgeInsets.only(bottom: 2.0),
          height: 40.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: lightColor,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.operationCreateAt!,
                    style: const TextStyle(
                      color: defaultTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.operationMontant.toString(),
                          style: const TextStyle(
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0,
                          ),
                        ),
                        TextSpan(
                          text: " ${item.operationDevise}",
                          style: const TextStyle(
                            color: defaultTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    item.operationMode!,
                    style: const TextStyle(
                      color: defaultTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    item.user!.userName!,
                    style: const TextStyle(
                      color: defaultTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}
