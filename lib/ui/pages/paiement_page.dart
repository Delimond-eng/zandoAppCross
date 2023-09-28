import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/models/operation.dart';
import '/ui/modals/public/paiment_detail_modal.dart';
import '/ui/modals/util.dart';
import '/ui/widgets/dashline.dart';
import '../../global/controllers.dart';
import '../../services/db.service.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Paiements"),
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
                              });
                              await dataController.loadPayments('date',
                                  field: idate);
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
                                });
                                dataController.loadPayments("client",
                                    field: client.clientId);
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
          Obx(
            () => Expanded(
              child: dataController.paiements.isEmpty
                  ? const EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: dataController.paiements.length,
                      itemBuilder: (BuildContext context, int index) {
                        var payment = dataController.paiements[index];
                        return PayCard(
                          paiement: payment,
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

class PayCard extends StatelessWidget {
  final Operations paiement;
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
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            paiement.operationDate!.split('-').first,
                            style: const TextStyle(
                              fontSize: 14.0,
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
                          "${paiement.operationDate!.split('-')[1]}/${paiement.operationDate!.split('-').last}",
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
                          paiement.facture!.factureId
                              .toString()
                              .padLeft(3, "0"),
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
                          "${paiement.facture!.factureMontant!} ${paiement.facture!.factureDevise}",
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
                          "${paiement.operationMontant} ${paiement.operationDevise}",
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
                          "${((double.parse(paiement.facture!.factureMontant!) - paiement.totalPayment!)).toStringAsFixed(2)} ${paiement.operationDevise}",
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
                          paiement.client!.clientNom!,
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
                        paiement.operationMode!,
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
                          color: paiement.facture!.factureStatut! == 'en cours'
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
                            paiement.facture!.factureId!,
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

  Future<void> getPaiementDetails(context, int factureId) async {
    var db = await DBService.initDb();
    var query = await db.rawQuery(
        "SELECT * FROM factures INNER JOIN operations ON factures.facture_id = operations.operation_facture_id INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT operations.operation_state='deleted' AND operations.operation_facture_id = $factureId");
    if (query.isNotEmpty) {
      List<Operations> tempsList = <Operations>[];
      for (var e in query) {
        tempsList.add(Operations.fromMap(e));
      }
      dataController.paiementDetails.clear();
      dataController.paiementDetails.addAll(tempsList);
    }
    Future.delayed(Duration.zero, () {
      showPaiementDetail(context);
    });
  }

  Future<void> deleteAll(context, Operations data) async {
    var db = await DBService.initDb();
    // ignore: use_build_context_synchronously
    DGCustomDialog.showInteraction(context,
        message:
            "Etes-vous sûr de vouloir supprimer définitivement ces paiements ?",
        onValidated: () {
      db
          .update(
        'factures',
        {'facture_statut': 'en cours'},
        where: 'facture_id = ?',
        whereArgs: [data.operationFactureId],
      )
          .then((id) {
        db.update(
          "operations",
          {"operation_state": "deleted"},
          where: "operation_facture_id=?",
          whereArgs: [data.operationFactureId],
        );
        dataController.loadPayments("all");
      });
    });
  }
}
