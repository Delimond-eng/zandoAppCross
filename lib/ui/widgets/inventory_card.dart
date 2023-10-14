import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zandoprintapp/ui/modals/public/inventory_details_modal.dart';

import '../../config/utils.dart';
import '../../models/operation.dart';
import 'dashline.dart';
import 'ticket_card.dart';

class InventoryCard extends StatelessWidget {
  final Operations item;
  const InventoryCard({
    super.key,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return TicketCard(
      height: size.height,
      width: size.width,
      color: lightColor,
      isCornerRounded: true,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    item.compte!.compteLibelle!,
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: defaultTextColor,
                    ),
                  ),
                  Icon(
                    Icons.circle,
                    size: 7.0,
                    color: (item.compte!.compteStatus == "actif")
                        ? Colors.green
                        : Colors.deepOrange,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 14.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            item.operationDate!,
                            style: const TextStyle(
                              fontFamily: defaultFont,
                              fontSize: 10.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
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
                            showInventoryDetails(context, item.operationId);
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
                  const SizedBox(
                    height: 2,
                  ),
                ],
              )
            ],
          ),
          DashedLine(
            height: .5,
            color: Colors.grey.shade400,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                      text: item.totalPayment!.toStringAsFixed(2),
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: " ${item.operationDevise}",
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
            ],
          )
        ],
      ),
    );
  }
}
