import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              compte.compteStatus == "actif"
                                                  ? Colors.red
                                                  : Colors.green,
                                          elevation: 2,
                                          padding: const EdgeInsets.all(8.0),
                                        ),
                                        child: Text(
                                          (compte.compteStatus == "actif")
                                              ? "Desactiver"
                                              : "Activer",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                            fontFamily: defaultFont,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        onPressed: () async {
                                          enableOrDisableAccount(compte);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      /* TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          elevation: 2,
                                          padding: const EdgeInsets.all(8.0),
                                        ),
                                        child: const Text(
                                          "Voir opérations",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                            fontFamily: defaultFont,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        onPressed: () async {
                                          enableOrDisableAccount(compte);
                                        },
                                      ), */
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

  enableOrDisableAccount(Compte compte) async {
    var db = await DBService.initDb();
    Map<String, dynamic> map;
    if (compte.compteStatus == "actif") {
      map = {"compte_status": "inactif"};
    } else {
      map = {"compte_status": "actif"};
    }
    db.update("comptes", map,
        where: "compte_id=?", whereArgs: [compte.compteId]).then((id) {
      dataController.loadAllComptes();
      dataController.loadActivatedComptes();
    });
  }
}
