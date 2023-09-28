import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/ui/widgets/empty_state.dart';
import '/services/db.service.dart';
import '/ui/widgets/search_input.dart';
import '../../global/controllers.dart';
import '../../models/facture.dart';
import '/ui/modals/public/update_currency.dart';
import '../widgets/dash_card.dart';
import '../widgets/facture_card.dart';
import '../widgets/synthese_card.dart';
import '/ui/components/custom_appbar.dart';
import '/ui/pages/facture_create_page.dart';
import '../../config/utils.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  rechercheClient(String k) async {
    var db = await DBService.initDb();
    var json = await db.rawQuery(
        "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut = 'en cours' AND NOT factures.facture_state='deleted' AND clients.client_nom LIKE '%$k%'");
    dataController.factures.clear();
    for (var e in json) {
      dataController.factures.add(Facture.fromMap(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Tableau de bord"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDashboardItems(context),
              const SizedBox(
                height: 15.0,
              ),
              _buildPrices(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Factures en attente",
                      style: TextStyle(
                        fontFamily: defaultFont,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SearchInput(
                            hinteText: "Recherche facture du client...",
                            onSearched: (k) {
                              rechercheClient(k!);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(40.0),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(40.0),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FactureCreatePage(),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: const Icon(
                                CupertinoIcons.add,
                                size: 16.0,
                                color: lightColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              _builBillWaiting(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _builBillWaiting(context) {
    return Obx(
      () => dataController.factures.isEmpty
          ? const EmptyState()
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 300).toInt(),
                childAspectRatio: 2.2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemCount: dataController.factures.length,
              itemBuilder: (context, index) {
                var item = dataController.factures[index];
                return FactureCard(
                  item: item,
                );
              },
            ),
    );
  }

  Widget _buildDashboardItems(context) {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (MediaQuery.of(context).size.width ~/ 250).toInt(),
          childAspectRatio: 3.5,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
        ),
        itemCount: dataController.dashboardCounts.length,
        itemBuilder: (context, index) {
          var item = dataController.dashboardCounts[index];
          return DashCard(
            item: item,
          );
        },
      ),
    );
  }

  Widget _buildPrices() {
    return Row(
      children: [
        Flexible(
          child: FadeInRight(
            child: Obx(
              () => _currencyCard(
                icon: "assets/icons/dailly.svg",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => dailySell(context),
                  );
                },
                title: "Ventes journalières",
                value:
                    "${dataController.daySellCount.value.toStringAsFixed(2)} USD",
                btnIcon: CupertinoIcons.eye_fill,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Flexible(
          child: FadeInLeft(
            child: Obx(
              () => _currencyCard(
                icon: "assets/icons/taux.svg",
                onPressed: () {
                  showUpdateCurrencyModal(context);
                },
                title: "Taux du jour",
                value: "${dataController.currency.value.currencyValue} CDF",
                btnIcon: Icons.edit,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currencyCard(
      {String? title,
      String? value,
      String? icon,
      IconData? btnIcon,
      VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  icon ?? "assets/icons/dashboardii.svg",
                  height: 28.0,
                  colorFilter:
                      const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        color: defaultTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      value!,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        color: defaultTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(40.0),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  onTap: onPressed,
                  child: Icon(
                    btnIcon,
                    size: 16.0,
                    color: lightColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dailySell(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170.0,
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
                    Icons.calendar_month_outlined,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Paiements journaliers",
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
            child: Obx(
              () => Row(
                children: dataController.dailySums
                    .map(
                      (e) => Flexible(
                        child: SyntheseInfo(
                          amount: e.sum,
                          currency: "USD",
                          title: e.title,
                          icon: e.icon,
                          thikness: .1,
                          titleColor: primaryColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
