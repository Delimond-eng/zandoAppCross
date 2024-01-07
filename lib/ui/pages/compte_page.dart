import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../services/api.dart';
import '../../services/db.service.dart';
import '/config/utils.dart';
import '/global/controllers.dart';
import '/ui/components/custom_appbar.dart';
import '/ui/modals/public/create_compte.dart';
import '/ui/widgets/empty_state.dart';
import '/models/compte.dart';

class ComptePage extends StatefulWidget {
  const ComptePage({super.key});

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showCreateCompteModal(context);
        },
        child: const Icon(
          CupertinoIcons.add,
          color: lightColor,
        ),
      ),
      appBar: const CustomAppBar(title: "Trésoreries"),
      body: Column(
        children: [
          Obx(
            () => dataController.allComptes.isEmpty
                ? const Expanded(child: EmptyState())
                : Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width ~/ 300).toInt(),
                        childAspectRatio: 4.5,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: dataController.allComptes.length,
                      itemBuilder: (BuildContext context, int index) {
                        var compte = dataController.allComptes[index];
                        return SizedBox(
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Libellé",
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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 7.0,
                                            color:
                                                compte.compteStatus != "actif"
                                                    ? Colors.deepOrange
                                                    : Colors.green,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            compte.compteLibelle!,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: defaultFont,
                                              fontWeight: FontWeight.w500,
                                              color: defaultTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Devise",
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
                                          compte.compteDevise!,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [enableBtn(compte)],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget enableBtn(Compte compte) {
    bool loading = false;
    return StatefulBuilder(builder: (context, setter) {
      return SizedBox(
        height: 35.0,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                compte.compteStatus == "actif" ? Colors.red : Colors.green,
            disabledBackgroundColor: compte.compteStatus == "actif"
                ? Colors.red[200]
                : Colors.green[200],
            elevation: 2,
            padding: const EdgeInsets.all(5.0),
          ),
          onPressed: loading == true
              ? null
              : () async {
                  setter(() => loading = true);
                  Api.request(url: 'data.disable', method: 'post', body: {
                    "table": "comptes",
                    "id": int.parse(compte.compteId.toString()),
                    "state": "compte_status",
                    "state_val":
                        compte.compteStatus == "actif" ? "inactif" : "actif"
                  }).then((value) {
                    setter(() => loading = true);
                    dataController.refreshConfigs();
                  });
                },
          child: loading == true
              ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 12.0,
                )
              : Text(
                  (compte.compteStatus == "actif") ? "Désactiver" : "Activer",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
        ),
      );
    });
  }
}
