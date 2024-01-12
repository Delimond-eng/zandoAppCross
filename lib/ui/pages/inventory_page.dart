import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/ui/modals/public/compte_filter_modal.dart';
import '../widgets/inventory_card.dart';
import '/ui/widgets/custom_field.dart';
import '../../config/utils.dart';
import '../../global/controllers.dart';
import '../../models/compte.dart';
import '../../reports/models/month.dart';
import '../../reports/report.dart';
import '../../services/utils.dart';
import '../widgets/custom_btn_icon.dart';
import '../widgets/empty_state.dart';
import '../widgets/synthese_card.dart';
import '/ui/components/custom_appbar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Compte? compte;
  String? date;
  Month? mois;
  int? annee;

  double totaux = 0;

  List<Month> months = <Month>[];
  List<int> years = [];

  initData() async {
    var m = await Report.getMonths();
    years = getListOfYears();
    /*  */
    setState(() {
      months.clear();
      months.addAll(m);
    });
  }

  initTot() async {
    totaux = 0;
    for (var e in dataController.inventories) {
      totaux += e.totalAmount!;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      dataController.dataLoading.value = true;
      dataController.loadInventories(fkey: 'all').then((res) {
        dataController.dataLoading.value = false;
      });
    });
    dataController.inventories.listen((data) {
      if (mounted) {
        initTot();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Inventaires"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return globalview(context);
              });
        },
        label: const Text(
          "Vue synthétique",
          style:
              TextStyle(fontFamily: defaultFont, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filtrer par",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: defaultFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: lightColor.withOpacity(.7),
                          border: Border.all(
                            color: primaryColor.shade400,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5.0),
                          child: InkWell(
                            onTap: () async {
                              var idate = await showDatePicked(context);
                              if (idate != null) {
                                dataController
                                    .loadInventories(
                                        fkey: 'date', keyVal: idate)
                                    .then((v) {
                                  setState(() {
                                    compte = null;
                                    int? a;
                                    Month? m;

                                    annee = a;
                                    mois = m;
                                  });
                                });
                              }
                              setState(() {
                                date = idate;
                              });
                            },
                            borderRadius: BorderRadius.circular(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: date != null
                                        ? primaryColor
                                        : Colors.grey,
                                    size: 14.0,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          date ?? "Sélectionner date...",
                                          style: TextStyle(
                                            fontSize:
                                                date != null ? 12.0 : 11.0,
                                            fontFamily: defaultFont,
                                            fontWeight: FontWeight.w400,
                                            color: date != null
                                                ? defaultTextColor
                                                : Colors.grey,
                                          ),
                                        ),
                                        if (date != null) ...[
                                          CustomBtnIcon(onPressed: () async {
                                            dataController.loadInventories(
                                                fkey: 'all');
                                            setState(() {
                                              date = null;
                                              int? a;
                                              Month? m;

                                              annee = a;
                                              mois = m;
                                            });
                                          }),
                                        ]
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: lightColor.withOpacity(.7),
                          border: Border.all(
                            color: primaryColor.shade400,
                            width: 1.0,
                          ),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showCompteFilterModal(context, onSelected: (co) {
                                setState(() {
                                  compte = co;
                                });
                                dataController
                                    .loadInventories(
                                        fkey: 'compte',
                                        keyVal: compte!.compteId)
                                    .then((value) {
                                  setState(() {
                                    date = null;
                                    int? a;
                                    Month? m;

                                    annee = a;
                                    mois = m;
                                  });
                                });
                              });
                            },
                            borderRadius: BorderRadius.circular(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/money-bag.svg",
                                    colorFilter: ColorFilter.mode(
                                      compte == null
                                          ? Colors.grey
                                          : primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                    height: 12.0,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          compte != null
                                              ? compte!.compteLibelle!
                                              : "Sélectionner un compte...",
                                          style: TextStyle(
                                            fontSize:
                                                compte != null ? 12 : 11.0,
                                            fontFamily: defaultFont,
                                            fontWeight: FontWeight.w400,
                                            color: compte != null
                                                ? defaultTextColor
                                                : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        if (compte != null) ...[
                                          CustomBtnIcon(
                                            onPressed: () async {
                                              dataController.loadInventories(
                                                  fkey: 'all');
                                              setState(() {
                                                compte = null;
                                                int? a;
                                                Month? m;

                                                annee = a;
                                                mois = m;
                                              });
                                            },
                                          ),
                                        ] else ...[
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            size: 12,
                                          )
                                        ]
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                      child: Center(child: Text('OU')),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: CustomField(
                          dropItems: months,
                          isDropdown: true,
                          hintText: "Mois",
                          selectedValue: mois,
                          iconPath: "assets/icons/calendar-check.svg",
                          borderColor: primaryColor.withOpacity(.5),
                          onChangedDrop: (val) {
                            setState(() {
                              mois = val;
                            });
                          }),
                    ),
                    const SizedBox(
                      width: 20.0,
                      child: Icon(
                        CupertinoIcons.minus,
                        size: 16.0,
                      ),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: CustomField(
                          dropItems: years,
                          isDropdown: true,
                          hintText: "Année",
                          iconPath: "assets/icons/calendar-check.svg",
                          borderColor: primaryColor.withOpacity(.5),
                          selectedValue: annee,
                          onChangedDrop: (val) {
                            setState(() {
                              annee = int.parse(val.toString());
                            });
                            /* dataController.loadInventories(
                              "mois",
                              fkey: mois!.value,
                            ); */
                          }),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        border: Border.all(color: Colors.blue.shade500),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4.0),
                          onTap: () {
                            if (mois == null) {
                              EasyLoading.showToast(
                                  'Veuillez sélectionner un mois !');
                              return;
                            }

                            if (annee == null) {
                              EasyLoading.showToast(
                                  'Veuillez sélectionner une année !');
                              return;
                            }
                            String key = '${mois!.value}-$annee';
                            dataController
                                .loadInventories(fkey: 'mois', keyVal: key)
                                .then((value) {
                              setState(() {
                                compte = null;
                                mois = null;
                              });
                            });
                          },
                          child: Obx(
                            () => Center(
                              child: dataController.dataLoading.value
                                  ? const SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      CupertinoIcons.search,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => Expanded(
              child: dataController.inventories.isEmpty
                  ? const EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: dataController.inventories.length,
                      itemBuilder: (context, index) {
                        var item = dataController.inventories[index];
                        return InventoryCard(
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

  Widget globalview(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: primaryColor,
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 3,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Vue synthétique",
                    style: TextStyle(
                      fontFamily: defaultFont,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: SyntheseInfo(
                    amount: totaux,
                    currency: "USD",
                    title: "Total Général",
                    icon: CupertinoIcons.money_dollar_circle_fill,
                    thikness: .1,
                    titleColor: Colors.green[700]!,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<int> getListOfYears() {
    var now = DateTime.now();
    List<int> years = [];
    for (int year = 2022; year <= now.year + 1; year++) {
      years.add(year);
    }
    return years;
  }
}
