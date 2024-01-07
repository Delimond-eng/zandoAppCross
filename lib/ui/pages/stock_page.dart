// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../global/controllers.dart';
import '../../models/stock.dart';
import '../../services/api.dart';
import '../modals/public/create_stock_modal.dart';
import '../modals/public/stock_sorties_details_modal.dart';
import '../modals/util.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_input.dart';
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
  List<Produit> stocks = [];
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      dataController.dataLoading.value = true;
      dataController.loadStockData().then((res) {
        dataController.dataLoading.value = false;
      });
    });
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
    dataController.stocks.listen((data) {
      if (mounted) {
        setState(() {
          stocks = List.from(data);
        });
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchInput(
              hinteText: "Recherche produit...",
              onSearched: (value) {
                if (value!.isEmpty) {
                  setState(() {
                    stocks = List.from(dataController.stocks);
                  });
                } else {
                  setState(() {
                    stocks = dataController.stocks
                        .where((item) => item.produitLibelle!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: stocks.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: stocks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = stocks[index];
                      return StockHomeCard(data: data);
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: floatingBtnVisible
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    backgroundColor: Colors.green.shade700,
                  ),
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    backgroundColor: Colors.orange.shade800,
                  ),
                  onPressed: () async {
                    showSortieStockModal(context);
                  },
                  icon: const Icon(CupertinoIcons.minus_circle_fill,
                      size: 14.0, color: Colors.white),
                  label: const Text(
                    "Sortie",
                    style:
                        TextStyle(color: Colors.white, fontFamily: defaultFont),
                  ),
                ),
              ],
            )
          : null,
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
            color: data.solde == 0 ? Colors.orange.shade700 : Colors.white,
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
                            color: data.solde == 0
                                ? Colors.white
                                : Colors.grey.shade800,
                            size: 16.0,
                          ),
                          Text(
                            data.produitCreateAt!,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
                              color: data.solde == 0
                                  ? Colors.white
                                  : defaultTextColor,
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
                          "Libellé produit",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w400,
                            color: data.solde == 0
                                ? Colors.white
                                : Colors.grey.shade800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.produitLibelle!,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: data.solde == 0
                                ? Colors.white
                                : defaultTextColor,
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
                            color: data.solde == 0
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.totEntree.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: data.solde == 0 ? Colors.white : Colors.blue,
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
                            color: data.solde == 0
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.totSortie.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color: data.solde == 0
                                ? Colors.white
                                : Colors.deepOrange,
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
                            color: data.solde == 0
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          data.solde.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w700,
                            color:
                                data.solde == 0 ? Colors.white : Colors.green,
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 1.5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              showSortiesDetailsModal(context, produit: data);
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/more.svg",
                                colorFilter: const ColorFilter.mode(
                                  lightColor,
                                  BlendMode.srcIn,
                                ),
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
                          color: data.solde == 0 ? Colors.white : Colors.brown,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 1.5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              DGCustomDialog.showInteraction(context,
                                  message:
                                      "Etes-vous sûr de vouloir supprimer définitivement ce produit ? Attention ! cette action est irreversible !",
                                  onValidated: () async {
                                Api.request(
                                    url: 'data.delete',
                                    method: 'post',
                                    body: {
                                      "table": "produits",
                                      "id": data.id,
                                      "state": "produit_state"
                                    }).then((res) async {
                                  await Api.request(
                                      url: 'data.delete',
                                      method: 'post',
                                      body: {
                                        "table": "entrees",
                                        "id": data.id,
                                        "id_field": "produit_id",
                                        "state": "entree_state"
                                      });
                                  await Api.request(
                                      url: 'data.delete',
                                      method: 'post',
                                      body: {
                                        "table": "sorties",
                                        "id": data.id,
                                        "id_field": "produit_id",
                                        "state": "sortie_state"
                                      });
                                });
                                dataController.loadStockData();
                              });
                            },
                            child: Center(
                              child: Icon(
                                CupertinoIcons.trash,
                                size: 16.0,
                                color:
                                    data.solde == 0 ? Colors.red : lightColor,
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
