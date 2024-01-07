import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../widgets/inventory_card.dart';
import '/ui/modals/public/compte_filter_modal.dart';
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

  List<Month> months = <Month>[];

  initData() async {
    var m = await Report.getMonths();
    /*  */
    setState(() {
      months.clear();
      months.addAll(m);
    });
  }

  double _entrees = 0;
  double _sorties = 0;

  double get _solde => _entrees - _sorties;

  /* initTot({String? key}) async {
    double en = 0;
    double so = 0;
    if (key == "all") {
      await dataController.loadInventories(key!);
    }
    for (var e in dataController.inventories) {
      if (e.operationType!.toLowerCase() == 'entrée') {
        en += e.totalPayment!;
      }
      if (e.operationType!.toLowerCase() == 'sortie') {
        so += e.totalPayment!;
      }
    }
    _entrees = en;
    _sorties = so;
  }
 */
  @override
  void initState() {
    super.initState();
    initData();
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
                              setState(() {
                                date = idate;
                              });
                              /* await dataController.loadInventories("date",
                                  fkey: date); */
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
                                            setState(() {
                                              date = null;
                                            });
                                            /* await dataController
                                                .loadInventories("all"); */
                                            /* initTot(key: "all"); */
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
                      width: 15.0,
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
                              showCompteFilterModal(context,
                                  onSelected: (Compte val) async {
                                setState(() {
                                  compte = val;
                                });
                                /* await dataController.loadInventories("compte",
                                    fkey: val.compteId); */
                                setState(() {});
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
                                              setState(() {
                                                compte = null;
                                              });
                                              /* await dataController
                                                  .loadInventories("all"); */
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
                      width: 15.0,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: CustomField(
                          dropItems: months,
                          isDropdown: true,
                          hintText: "Mois",
                          iconPath: "assets/icons/calendar-check.svg",
                          borderColor: primaryColor.withOpacity(.5),
                          onChangedDrop: (val) {
                            setState(() {
                              mois = val;
                            });
                            /* dataController.loadInventories(
                              "mois",
                              fkey: mois!.value,
                            ); */
                          }),
                    )
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => Expanded(
              child: dataController.inventories.isEmpty
                  ? const EmptyState()
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width ~/ 300).toInt(),
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                      ),
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
                    amount: _entrees,
                    currency: "USD",
                    title: "Total des entrées",
                    icon: CupertinoIcons.up_arrow,
                    thikness: .1,
                    titleColor: Colors.green[700]!,
                  ),
                ),
                Flexible(
                  child: SyntheseInfo(
                    amount: _sorties,
                    currency: "USD",
                    title: "Total des sorties",
                    titleColor: Colors.red,
                    icon: CupertinoIcons.down_arrow,
                    thikness: .1,
                  ),
                ),
                Flexible(
                  child: SyntheseInfo(
                    amount: _solde,
                    currency: "USD",
                    title: "Solde",
                    titleColor: Colors.indigo,
                    icon: CupertinoIcons.money_dollar_circle_fill,
                    thikness: .1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
