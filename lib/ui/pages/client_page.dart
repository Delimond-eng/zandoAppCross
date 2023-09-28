import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/config/utils.dart';
import '/global/controllers.dart';
import '/services/db.service.dart';
import '/ui/components/custom_appbar.dart';
import '/ui/modals/public/create_client.dart';
import '/ui/widgets/client_card.dart';
import '/ui/widgets/empty_state.dart';
import '/ui/widgets/search_input.dart';

import '../../models/client.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<Client> clients = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showCreateClientModal(context);
        },
        child: const Icon(
          CupertinoIcons.add,
          color: lightColor,
        ),
      ),
      appBar: const CustomAppBar(title: "Clients"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0.0),
            child: SearchInput(
              hinteText: "Recherche client...",
              onSearched: (kword) async {
                if (Platform.isAndroid) {
                  await searchClient(kword!);
                }
              },
            ),
          ),
          Obx(
            () => dataController.clients.isEmpty && clients.isEmpty
                ? const Expanded(child: EmptyState())
                : Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width ~/ 250).toInt(),
                        childAspectRatio: 4.2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: clients.isEmpty
                          ? dataController.clients.length
                          : clients.length,
                      itemBuilder: (context, index) {
                        var item = clients.isEmpty
                            ? dataController.clients[index]
                            : clients[index];
                        return ClientCard(
                          item: item,
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }

  searchClient(String kword) async {
    var db = await DBService.initDb();
    try {
      var allClients = await db.rawQuery(
          "SELECT * FROM clients WHERE NOT client_state='deleted' AND client_nom LIKE '%$kword%'");
      setState(() {
        if (allClients.isNotEmpty) {
          clients.clear();
          for (var e in allClients) {
            clients.add(Client.fromMap(e));
          }
        }
      });
    } catch (e) {}
  }
}
