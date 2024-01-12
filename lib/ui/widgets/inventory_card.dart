import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zandoprintapp/global/controllers.dart';
import 'package:zandoprintapp/models/inventory.dart';
import 'package:zandoprintapp/ui/modals/public/inventory_details_modal.dart';

import '../../config/utils.dart';
import '../../utilities/modals.dart';
import 'ticket_card.dart';

class InventoryCard extends StatelessWidget {
  final Inventory item;
  const InventoryCard({
    super.key,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TicketCard(
        height: 60,
        width: size.width,
        color: lightColor,
        isCornerRounded: true,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                  item.operationCreateAt!,
                  style: const TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Montant total",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: item.totalAmount!.toStringAsFixed(2),
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: " ${item.devise}",
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
            if (item.compteId != null) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    item.compteLibelle!,
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ],
            PopupMenuButton(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  size: 16.0,
                  color: defaultTextColor,
                ),
              ),
              onSelected: (value) {
                if (value == 1) {
                  if (item.operationCreateAt!.length == 7) {
                    String monthDate =
                        item.operationCreateAt!.replaceAll('/', '-');

                    Xloading.showLottieLoading(context);
                    dataController
                        .showInventoryDetails(monthDate)
                        .then((details) {
                      Xloading.dismiss();
                      showInventoryDetails(context, details: details);
                    });
                  } else {
                    DateTime parsedDate =
                        DateFormat('dd/MM/yyyy').parse(item.operationCreateAt!);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(parsedDate);

                    Xloading.showLottieLoading(context);
                    dataController
                        .showInventoryDetails(formattedDate)
                        .then((details) {
                      Xloading.dismiss();
                      showInventoryDetails(context, details: details);
                    });
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/icons/more.svg",
                        height: 13.0,
                        colorFilter: const ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Voir détails',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
