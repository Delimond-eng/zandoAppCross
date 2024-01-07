import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/ui/modals/public/create_config.dart';
import 'package:zandoprintapp/ui/modals/public/create_config_details.dart';
import '../../models/item.dart';
import '../../services/api.dart';
import '../../utilities/modals.dart';
import '../modals/util.dart';
import '/ui/widgets/dashline.dart';
import '../../global/controllers.dart';
import '../widgets/empty_state.dart';
import '/ui/components/custom_appbar.dart';

import '../../config/utils.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Configurations"),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          CupertinoIcons.add,
          size: 15.0,
          color: Colors.white,
        ),
        onPressed: () {
          showCreateItemModal(context);
        },
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: dataController.items.isEmpty
                  ? const EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: dataController.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = dataController.items[index];
                        return ItemCard(
                          item: item,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.zero,
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
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey.shade800,
                            size: 17.0,
                          ),
                          Text(
                            item.itemCreateAt!,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w700,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Produit item libellé",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          item.itemLibelle!,
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
                        Text(
                          "Nbre natures",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: const BoxDecoration(
                              color: Colors.indigo, shape: BoxShape.circle),
                          child: Text(
                            item.natures!.length.toString().padLeft(2, "0"),
                            style: const TextStyle(
                              fontSize: 8.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    onSelected: (value) async {
                      switch (value) {
                        case 1:
                          showItemDatilsModal(context, item: item);
                          break;
                        case 2:
                          showCreateItemModal(context, item: item);
                          break;
                        case 3:
                          DGCustomDialog.showInteraction(context,
                              message:
                                  "Etes-vous sûr de vouloir supprimer définitivement ce paiement facture ?",
                              onValidated: () {
                            Xloading.showLottieLoading(context);
                            Api.request(
                              url: 'data.delete',
                              method: 'post',
                              body: {
                                "table": "items",
                                "id": item.id,
                                "state": "item_state",
                              },
                            ).then((value) async {
                              Xloading.dismiss();
                              await Api.request(
                                  url: "data.delete",
                                  method: "post",
                                  body: {
                                    "table": "item_natures",
                                    "id": item.id,
                                    "id_field": "item_id",
                                    "state": "item_nature_state",
                                  });
                              dataController.refreshConfigs();
                            }).catchError((e) {
                              EasyLoading.showToast(
                                  "Echec de traitement des informations !");
                              Xloading.dismiss();
                            });
                          });

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
                              height: 14.0,
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
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/icons/add.svg",
                              height: 16.0,
                              colorFilter: const ColorFilter.mode(
                                primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Ajout nature',
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
}
