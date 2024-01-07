import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/models/operation.dart';
import '../../services/api.dart';
import '../../utilities/modals.dart';
import '../modals/public/paiment_detail_modal.dart';
import '../modals/util.dart';
import '/ui/widgets/dashline.dart';
import '../../global/controllers.dart';
import '../widgets/custom_btn_icon.dart';
import '../widgets/empty_state.dart';
import '/services/utils.dart';
import '/ui/modals/public/client_filter_modal.dart';
import '../../models/client.dart';
import '/ui/components/custom_appbar.dart';

import '../../config/utils.dart';

class PaiementPage extends StatefulWidget {
  const PaiementPage({super.key});

  @override
  State<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  String? date;
  Client? selectClient;

  List<Paiement> filteredList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      dataController.dataLoading.value = true;
      dataController.loadFacturesEnAttente().then((res) {
        dataController.dataLoading.value = false;
      });
    });
    dataController.paiements.listen((data) {
      if (mounted) {
        setState(() {
          filteredList = List.from(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Paiements"),
      floatingActionButton: Obx(
        () => ZoomIn(
          child: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () async {
              dataController.dataLoading.value = true;
              dataController.loadPayments("all").then((value) {
                dataController.dataLoading.value = false;
              });
            },
            child: dataController.dataLoading.value
                ? const SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3.0,
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
          ),
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
                        height: 45.0,
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
                                filteredList = dataController.paiements
                                    .where((item) => item.operationCreateAt!
                                        .toLowerCase()
                                        .contains(idate))
                                    .toList();
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
                                          CustomBtnIcon(onPressed: () {
                                            setState(() {
                                              date = null;
                                            });
                                            dataController.loadPayments("all");
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
                        height: 45.0,
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
                              showClientFilterModal(context,
                                  onSelected: (client) {
                                setState(() {
                                  selectClient = client;
                                  filteredList = dataController.paiements
                                      .where((item) => item.clientNom!
                                          .toLowerCase()
                                          .contains(
                                              client.clientNom!.toLowerCase()))
                                      .toList();
                                });
                              });
                            },
                            borderRadius: BorderRadius.circular(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/user.svg",
                                    colorFilter: ColorFilter.mode(
                                      selectClient == null
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
                                          selectClient != null
                                              ? selectClient!.clientNom!
                                              : "Sélectionner un client...",
                                          style: TextStyle(
                                            fontSize: selectClient != null
                                                ? 12
                                                : 11.0,
                                            fontFamily: defaultFont,
                                            fontWeight: FontWeight.w400,
                                            color: selectClient != null
                                                ? defaultTextColor
                                                : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        if (selectClient != null) ...[
                                          CustomBtnIcon(
                                            onPressed: () {
                                              setState(() {
                                                selectClient = null;
                                              });
                                              dataController
                                                  .loadPayments("all");
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
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var payment = filteredList[index];
                      return PayCard(
                        paiement: payment,
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

class PayCard extends StatelessWidget {
  final Paiement paiement;
  const PayCard({
    super.key,
    required this.paiement,
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
                            color: Colors.grey.shade700,
                            size: 16.0,
                          ),
                          Text(
                            paiement.operationCreateAt!,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
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
                          "N°Facture",
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
                          paiement.factureId.toString().padLeft(3, "0"),
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
                          "Montant",
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
                          "${paiement.factureMontant!} ${paiement.factureDevise}",
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
                          "Paiement",
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
                          "${paiement.totalPay} ${paiement.operationDevise}",
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
                          "Restant",
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
                          "${paiement.rest} ${paiement.operationDevise}",
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w600,
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
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/user.svg",
                              height: 12.0,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              "Client",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: defaultFont,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          paiement.clientNom!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        paiement.operationType!,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                      const SizedBox(
                        width: 2.0,
                      ),
                      Icon(Icons.circle,
                          size: 7.0,
                          color: paiement.factureStatus! != 'paie'
                              ? Colors.deepOrange
                              : Colors.green),
                    ],
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
                          getPaiementDetails(
                            context,
                            paiement: paiement,
                          );
                          break;
                        case 2:
                          deleteAll(context, paiement);
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

  Future<void> getPaiementDetails(context, {Paiement? paiement}) async {
    Xloading.showLottieLoading(context);
    dataController.showPaiementDetails(paiement!.factureId!).then((value) {
      Xloading.dismiss();
      showPaiementDetail(context);
    });
  }

  Future<void> deleteAll(context, Paiement data) async {
    if (authController.user.value.userRole != 'admin') {
      EasyLoading.showInfo(
          "Vous n'avez pas les autorisations requises pour effectuer cette operation ! ");
      return;
    }
    // ignore: use_build_context_synchronously
    DGCustomDialog.showInteraction(context,
        message:
            "Etes-vous sûr de vouloir supprimer définitivement ces paiements ?",
        onValidated: () {
      Xloading.showLottieLoading(context);
      Api.request(
        url: 'data.delete',
        method: 'post',
        body: {
          "table": "operations",
          "id": int.tryParse(data.factureId.toString()),
          "id_field": "facture_id",
          "state": "operation_state",
        },
      ).then((value) async {
        Xloading.dismiss();
        await Api.request(url: "data.disable", method: "post", body: {
          "table": "factures",
          "id": int.tryParse(data.factureId.toString()),
          "state": "facture_status",
          "state_val": "en attente",
        });
        dataController.loadPayments("all");
      }).catchError((e) {
        EasyLoading.showToast("Echec de traitement des informations !");
        Xloading.dismiss();
      });
    });
  }
}
