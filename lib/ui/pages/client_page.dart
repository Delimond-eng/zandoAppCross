// ignore_for_file: empty_catches

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '/config/utils.dart';
import '/global/controllers.dart';
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
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      dataController.dataLoading.value = true;
      dataController.loadClients().then((res) {
        dataController.dataLoading.value = false;
      });
    });
    dataController.clients.listen((data) {
      if (mounted) {
        setState(() {
          clients = List.from(data);
        });
      }
    });
  }

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
                await searchClient(kword!);
              },
            ),
          ),
          Expanded(
            child: clients.isEmpty
                ? const EmptyState()
                : GridView.builder(
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
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      var item = clients[index];
                      return ClientCard(
                        item: item,
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  searchClient(String kword) async {
    if (kword.isEmpty) {
      setState(() {
        clients = List.from(dataController.clients);
      });
    } else {
      setState(() {
        clients = dataController.clients
            .where((item) =>
                item.clientNom!.toLowerCase().contains(kword.toLowerCase()))
            .toList();
      });
    }
  }
}
