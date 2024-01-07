import 'package:flutter/material.dart';
import 'package:zandoprintapp/ui/widgets/dashline.dart';
import '../../../models/facture.dart';

import '../../../config/utils.dart';
import '../../../models/facture_detail.dart';
import '../../../services/utils.dart';
import '../../pages/facture_create_page.dart';
import '../util.dart';

Future<void> showFactureDetails(context, {Facture? facture}) async {
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.30,
    child: StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
            child: Text(
              "Facture détails",
              style: TextStyle(
                fontFamily: defaultFont,
                color: defaultTextColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
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
                              facture!.factureDateCreate!,
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
                        const Text("N° Facture"),
                        Text(
                          facture.factureId.toString().padLeft(3, "0"),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Client",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.indigo,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: "Nom : "),
                              TextSpan(
                                text: facture.client!.clientNom!,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: "Contact : "),
                              TextSpan(
                                text: facture.client!.clientTel!,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const DashedLine(
                  color: Colors.grey,
                  space: 5.0,
                ),
                factureDetails(
                  context,
                  items: facture.details,
                  facture: facture,
                  pay: facture.totPay,
                )
              ],
            ),
          )
        ],
      );
    }),
  );
}

Widget factureDetails(context,
    {List<FactureDetail>? items, Facture? facture, double? pay}) {
  return Column(
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Libellé",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Nature",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "P.U",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Quantité",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Total",
                style: TextStyle(
                  color: defaultTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
      const DashedLine(
        height: 1.0,
        color: Colors.grey,
      ),
      for (var item in items!) ...[
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
                    item.factureDetailLibelle!,
                    style: const TextStyle(
                      color: defaultTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    item.factureDetailNature!,
                    style: const TextStyle(
                      color: defaultTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.factureDetailPu!.padLeft(2, "0"),
                          style: const TextStyle(
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        ),
                        TextSpan(
                          text: " ${item.factureDetailDevise}",
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
                    item.factureDetailQte.toString().padLeft(2, "0"),
                    style: const TextStyle(
                      color: defaultTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.total.toStringAsFixed(2).padLeft(2, "0"),
                          style: const TextStyle(
                            color: defaultTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        ),
                        TextSpan(
                          text: " ${item.factureDetailDevise}",
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
              ],
            ),
          ),
        ),
        DashedLine(
          color: Colors.grey.shade700,
          height: .4,
          space: 2,
        )
      ],
      Row(
        children: [
          Flexible(child: Container()),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: TotItem(
                    title: "Net à payer",
                    value: facture!.factureMontant.toString(),
                    currency: "USD",
                    color: defaultTextColor,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TotItem(
                    title: "Equivalent en CDF",
                    value: convertDollarsToCdf(
                            double.parse(facture.factureMontant.toString()))
                        .toStringAsFixed(2),
                    currency: "CDF",
                    color: defaultTextColor,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TotItem(
                    title: "Reste à payer",
                    value:
                        "${(double.parse(facture.factureMontant.toString()) - pay!)}",
                    currency: "USD",
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          )
        ],
      )
    ],
  );
}
