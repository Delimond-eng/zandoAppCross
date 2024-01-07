import 'package:flutter/material.dart';

import '../../../config/utils.dart';
import '../../../models/operation.dart';
import '../util.dart';

Future<void> showInventoryDetails(context, opId) async {
  /* var details = await getInventoryDetails(opId); */
  var details = null;
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.50,
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
                  itemCount: details.length,
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
    return Column(
      children: [
        /* Container(
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
                          fontWeight: FontWeight.w700,
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
                        "${detail.operationMontant} ${detail.operationDevise}",
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w700,
                          color: defaultTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DashedLine(
          space: 5.0,
          color: Colors.grey.shade400,
          height: .5,
        ) */
      ],
    );
  }
}
