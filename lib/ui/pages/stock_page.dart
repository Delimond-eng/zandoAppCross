// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../global/controllers.dart';
import '../../models/stock.dart';
import '../../services/db.service.dart';
import '../modals/public/create_stock_modal.dart';
import '../modals/public/stock_sorties_details_modal.dart';
import '../modals/util.dart';
import '../widgets/empty_state.dart';
import '/ui/components/custom_appbar.dart';

import '../../config/utils.dart';
import '../modals/public/sortie_stock_modal.dart';
import '../widgets/dashline.dart';

class StockHomePage extends StatefulWidget {
  const StockHomePage({super.key});

  @override
  State<StockHomePage> createState() => _StockHomePageState();
}

class _StockHomePageState extends State<StockHomePage> {
  ScrollController controller = ScrollController();
  bool floatingBtnVisible = true;
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    dataController.loadStockData(1);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          floatingBtnVisible = false;
        });
      } else {
        if (controller.position.pixels > 200) {
          setState(() {
            floatingBtnVisible = false;
          });
        } else {
          setState(() {
            floatingBtnVisible = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Stockage des produits"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _globalView(),
          )
        ],
      ),
      floatingActionButton: floatingBtnVisible
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: "1",
                  backgroundColor: primaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  onPressed: () async {
                    showCreateStockModal(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.add,
                    size: 14.0,
                  ),
                  label: const Text(
                    "Nouvelle entrée ",
                    style:
                        TextStyle(color: Colors.white, fontFamily: defaultFont),
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                FloatingActionButton.extended(
                  heroTag: "2",
                  backgroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  onPressed: () async {
                    showSortieStockModal(context, onFinished: () {
                      dataController.loadStockData(1);
                    });
                  },
                  icon: const Icon(CupertinoIcons.minus,
                      size: 14.0, color: Colors.red),
                  label: const Text(
                    "Sortie",
                    style:
                        TextStyle(color: Colors.red, fontFamily: defaultFont),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  Widget _globalView() {
    return Obx(
      () => dataController.stocks.isEmpty
          ? const EmptyState()
          : ListView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              itemCount: dataController.stocks.length,
              itemBuilder: (BuildContext context, int index) {
                var data = dataController.stocks[index];
                return StockHomeCard(data: data);
              },
            ),
    );
  }
}

class StockHomeCard extends StatelessWidget {
  final Produit data;
  const StockHomeCard({
    super.key,
    required this.data,
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
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            data.produitCreateAt!.split('-').first,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w800,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          "${data.produitCreateAt!.split('-')[1]}/${data.produitCreateAt!.split('-').last}",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: defaultTextColor,
                          ),
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
                          "Libellé produit",
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
                          data.produitLibelle!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
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
                          "Qté Entrée",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.entree!.totalEntrees.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
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
                          "Qté sortie",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.sortie!.totalSorties.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepOrange,
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
                          "Solde",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.solde.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              dataController
                                  .loadStockData(
                                2,
                                id: data.entree!.entreeId!,
                              )
                                  .then((value) {
                                showSortiesDetailsModal(context, produit: data);
                              });
                              // ignore: use_build_context_synchronously
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/more.svg",
                                colorFilter: const ColorFilter.mode(
                                    lightColor, BlendMode.srcIn),
                                height: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              DGCustomDialog.showInteraction(context,
                                  message:
                                      "Etes-vous sûr de vouloir supprimer définitivement ce stock ?",
                                  onValidated: () async {
                                var db = await DBService.initDb();
                                var id = await db.update(
                                    "produits", {"produit_state": "deleted"},
                                    where: "produit_id = ?",
                                    whereArgs: [data.produitId]);
                                if (id != null) {
                                  await db.update(
                                      "sorties", {"sortie_state": "deleted"},
                                      where: "sortie_produit_id = ?",
                                      whereArgs: [data.produitId]);
                                  await db.update(
                                      "entrees", {"entree_state": "deleted"},
                                      where: "entree_produit_id = ?",
                                      whereArgs: [data.produitId]);
                                  dataController.loadStockData(1);
                                  EasyLoading.showSuccess(
                                      "Suppression effectuée !");
                                }
                              });
                            },
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.trash,
                                size: 16.0,
                                color: lightColor,
                              ),
                            ),
                          ),
                        ),
                      )
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
