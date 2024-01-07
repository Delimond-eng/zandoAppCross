// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zandoprintapp/global/controllers.dart';
import '../../../models/item.dart';
import '../../../services/api.dart';
import '../../../utilities/modals.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showItemDatilsModal(context, {Item? item}) async {
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.8,
    child: StatefulBuilder(
      builder: (context, setter) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
            child: Text(
              "Item: ${item!.itemLibelle!}",
              style: const TextStyle(
                fontFamily: defaultFont,
                color: defaultTextColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var e in item.natures!) ...[
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/icons/label2.svg",
                    height: 22,
                    colorFilter:
                        const ColorFilter.mode(Colors.indigo, BlendMode.srcIn),
                  ),
                  title: Text(
                    e.itemNatureLibelle!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                  subtitle: Text(
                    '${e.itemNaturePrix} ${e.itemNaturePrixDevise}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: "Suppression item nature !",
                    onPressed: () {
                      XDialog.show(context,
                          message:
                              "Etes-vous sûr de vouloir supprimer définitivement ce paiement facture ?",
                          onValidated: () {
                        Xloading.showLottieLoading(context);
                        Api.request(
                          url: 'data.delete',
                          method: 'post',
                          body: {
                            "table": "item_natures",
                            "id": e.id,
                            "state": "item_nature_state",
                          },
                        ).then((res) async {
                          Xloading.dismiss();
                          if (res.containsKey('status')) {
                            dataController.refreshConfigs();
                            var index = item.natures!.indexOf(e);
                            setter(() {
                              item.natures!.removeAt(index);
                            });
                          }
                        }).catchError((e) {
                          EasyLoading.showToast(
                              "Echec de traitement des informations !");
                          Xloading.dismiss();
                        });
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.trash,
                      size: 16.0,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 1.0,
                ),
              ]
            ],
          )
        ],
      ),
    ),
  );
}

class ItemField {
  TextEditingController label = TextEditingController();
  TextEditingController price = TextEditingController();
  String devise = "USD";
}
