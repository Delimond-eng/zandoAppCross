import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/global/controllers.dart';
import '/services/db.service.dart';
import '../../../models/client.dart';
import '../../widgets/empty_state.dart';
import '/config/utils.dart';
import '/ui/widgets/search_input.dart';

import '../util.dart';
import 'create_client.dart';

Future<void> showClientFilterModal(context,
    {required Function(Client client) onSelected}) async {
  await dataController.loadClients();
  List<Client> clients = [];
  showCustomModal(
    context,
    width: MediaQuery.of(context).size.width / 1.5,
    child: StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: SearchInput(
                        hinteText: "Rechercher client...",
                        onSearched: (val) async {
                          var db = await DBService.initDb();
                          try {
                            var allClients = await db.rawQuery(
                                "SELECT * FROM clients WHERE NOT client_state='deleted' AND client_nom LIKE '%$val%'");
                            setter(() {
                              clients.clear();
                              for (var e in allClients) {
                                clients.add(Client.fromMap(e));
                              }
                            });
                          } catch (e) {}
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: ZoomIn(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Get.back();
                            await showCreateClientModal(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 10.0,
                            textStyle: const TextStyle(
                              fontFamily: defaultFont,
                              color: lightColor,
                              fontSize: 14.0,
                            ),
                          ),
                          icon: const Icon(CupertinoIcons.plus, size: 16.0),
                          label: const Text(
                            "Ajout client",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Obx(
                  () => dataController.clients.isEmpty
                      ? const EmptyState()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: clients.isEmpty
                              ? dataController.clients.length
                              : clients.length,
                          itemBuilder: (context, index) {
                            return ClientFilterCard(
                              client: clients.isEmpty
                                  ? dataController.clients[index]
                                  : clients[index],
                              onSelected: onSelected,
                            );
                          },
                        ),
                )
              ],
            ),
          )
        ],
      );
    }),
  );
}

Future<List<Client>> getClients() async {
  final db = await DBService.initDb();
  var json = await db
      .rawQuery("SELECT * FROM clients WHERE NOT client_state='deleted'");
  List<Client> clients = <Client>[];
  for (var e in json) {
    clients.add(Client.fromMap(e));
  }
  return clients;
}

class ClientFilterCard extends StatelessWidget {
  final Client client;
  final Function(Client) onSelected;
  const ClientFilterCard({
    super.key,
    required this.client,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: .5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Future.delayed(Duration.zero, () {
              onSelected.call(client);
            });
            Get.back();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/user.svg",
                      height: 15.0,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      client.clientNom!,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        color: defaultTextColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 15.0,
                    color: Colors.grey.shade100,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
