// ignore_for_file: unnecessary_null_comparison

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zandoprintapp/global/controllers.dart';
import 'package:zandoprintapp/services/api.dart';
import 'package:zandoprintapp/ui/widgets/submit_btn.dart';
import '../../../models/item.dart';
import '/ui/widgets/custom_field.dart';
import '/config/utils.dart';

import '../util.dart';

Future<void> showCreateItemModal(context, {Item? item}) async {
  final txtLibelle = TextEditingController();
  var defaultItem = ItemField();
  defaultItem.label = TextEditingController();
  defaultItem.price = TextEditingController();
  defaultItem.devise = "USD";
  List<ItemField> fields = [defaultItem];
  bool isLoading = false;
  if (item != null) {
    txtLibelle.text = item.itemLibelle!;
  } else {
    txtLibelle.clear();
  }
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
          child: Text(
            "Configuration item & natures",
            style: TextStyle(
              fontFamily: defaultFont,
              color: defaultTextColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: StatefulBuilder(builder: (context, setter) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomField(
                  hintText: "Item libellé",
                  iconPath: "assets/icons/setting.svg",
                  controller: txtLibelle,
                  readOnly: item != null,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                for (var e in fields) ...[
                  Row(
                    children: [
                      Flexible(
                        child: CustomField(
                          hintText: "Nature Libellé",
                          iconPath: "assets/icons/label2.svg",
                          inputType: TextInputType.text,
                          controller: e.label,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: CustomField(
                          hintText: "Nature prix",
                          iconPath: "assets/icons/price.svg",
                          inputType: TextInputType.number,
                          isCurrency: true,
                          controller: e.price,
                          onChangedCurrency: (val) {
                            e.devise = val!;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            var item = ItemField();
                            item.label = TextEditingController();
                            item.price = TextEditingController();
                            item.devise = "USD";
                            setter(() {
                              fields.add(item);
                            });
                          },
                          child: const Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  child: ZoomIn(
                    child: SubmitButton(
                      loading: isLoading,
                      onPressed: () async {
                        if (txtLibelle.text.isEmpty) {
                          EasyLoading.showToast("Le libellé de item requis !");
                          return;
                        }
                        List<Map<String, dynamic>> maps = [];
                        for (var e in fields) {
                          if (e.label.text.isNotEmpty &&
                              e.label.text.isNotEmpty) {
                            maps.add({
                              "item_nature_libelle": e.label.text,
                              "item_nature_prix": e.price.text,
                              "item_nature_prix_devise": e.devise
                            });
                          }
                        }
                        setter(() => isLoading = true);
                        Api.request(url: 'item.create', method: 'post', body: {
                          "item_libelle": txtLibelle.text,
                          "item_id": item?.id,
                          "natures": maps
                        }).then((res) {
                          setter(() => isLoading = false);
                          if (res.containsKey('errors')) {
                            EasyLoading.showToast(res['errors'].toString());
                            return;
                          }
                          if (res.containsKey('status')) {
                            dataController.refreshConfigs();
                            EasyLoading.showSuccess(
                                "Configuration effectuée avec succès !");
                            txtLibelle.clear();
                            setter(() {
                              var defaultItem = ItemField();
                              defaultItem.label = TextEditingController();
                              defaultItem.price = TextEditingController();
                              defaultItem.devise = "USD";
                              fields = [defaultItem];
                            });
                          }
                        }).catchError((err) {
                          setter(() => isLoading = false);
                          if (kDebugMode) {
                            print(err);
                          }
                        });
                      },
                      icon: Icons.check,
                      label: "Enregistrer",
                    ),
                  ),
                )
              ],
            );
          }),
        )
      ],
    ),
  );
}

class ItemField {
  TextEditingController label = TextEditingController();
  TextEditingController price = TextEditingController();
  String devise = "USD";
}
