// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zandoprintapp/services/db.service.dart';
import 'package:zandoprintapp/ui/modals/public/facture_detail_modal.dart';
import '../modals/util.dart';
import '/global/controllers.dart';
import '/ui/modals/public/pay_modal.dart';

import '../../config/utils.dart';
import '../../models/facture.dart';
import 'dashline.dart';
import 'ticket_card.dart';

class FactureCard extends StatelessWidget {
  final Facture item;
  const FactureCard({
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
                    "Facture n°",
                    style: TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    item.factureId.toString().padLeft(3, "0"),
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: defaultTextColor,
                    ),
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
                            item.factureDateCreate!,
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
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.ellipsis_vertical,
                            size: 16.0,
                            color: defaultTextColor,
                          ),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              showFactureDetails(context, facture: item);
                              break;
                            case 2:
                              dataController.loadAllComptes();
                              showPayModal(context, facture: item);
                              break;
                            case 3:
                              deleteFacture(context, id: item.factureId!);
                              break;
                            default:
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
                          PopupMenuItem(
                            value: 2,
                            enabled:
                                item.factureStatut != "en cours" ? false : true,
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/money-receive.svg",
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
                                  'Paiement',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: defaultFont,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 3,
                            enabled:
                                item.factureStatut != "en cours" ? false : true,
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/delete.svg",
                                  height: 15.0,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.red,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Supprimer',
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
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10.0,
                        color: item.factureStatut == "en cours"
                            ? Colors.orange
                            : Colors.green,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        item.factureStatut == "en cours"
                            ? "En attente"
                            : "Payée",
                        style: const TextStyle(
                          fontFamily: defaultFont,
                          fontSize: 10.0,
                          color: defaultTextColor,
                        ),
                      )
                    ],
                  )
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
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/user.svg",
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.client!.clientNom!,
                        style: const TextStyle(
                          fontFamily: defaultFont,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.client!.clientTel!,
                        style: const TextStyle(
                          fontFamily: defaultFont,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Montant",
                    style: TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: item.factureMontant,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: " ${item.factureDevise}",
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

  void deleteFacture(context, {int? id}) {
    DGCustomDialog.showInteraction(context,
        message:
            "Etes-vous sûr de vouloir supprimer cette facture définitivement ?",
        onValidated: () async {
      var db = await DBService.initDb();
      var requestId = await db.update("factures", {"facture_state": "deleted"},
          where: "facture_id=?", whereArgs: [id]);
      if (requestId != null) {
        await db.update("facture_details", {"facture_detail_state": "deleted"},
            where: "facture_id=?", whereArgs: [id]);
        dataController.loadFacturesEnAttente();
        dataController.loadFilterFactures("all");
        EasyLoading.showToast("Suppression effectuée !");
      }
    });
  }
}
