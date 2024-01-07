import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../models/facture.dart';
import '/global/controllers.dart';
import '/ui/widgets/empty_state.dart';
import '/ui/widgets/search_input.dart';

import '../../config/utils.dart';
import '../components/custom_appbar.dart';
import '../widgets/facture_card.dart';
import 'facture_create_page.dart';

class FacturesPage extends StatefulWidget {
  const FacturesPage({super.key});

  @override
  State<FacturesPage> createState() => _FacturesPageState();
}

class _FacturesPageState extends State<FacturesPage> {
  String filter = "Vue globale";
  List<Facture> factures = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      dataController.dataLoading.value = true;
      dataController.loadFilterFactures("all").then((res) {
        dataController.dataLoading.value = false;
      });
    });

    dataController.filteredFactures.listen((data) {
      if (mounted) {
        setState(() {
          factures = List.from(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Factures"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FactureCreatePage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          CupertinoIcons.add,
          color: lightColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 47.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.7),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/filter.svg",
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                            height: 12.0,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                            child: DropdownButton(
                              menuMaxHeight: 200,
                              focusColor: Colors.transparent,
                              dropdownColor: Colors.white,
                              alignment: Alignment.centerLeft,
                              borderRadius: BorderRadius.circular(4.0),
                              style: const TextStyle(
                                fontFamily: defaultFont,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                              value: filter,
                              underline: const SizedBox(),
                              hint: const Text(
                                "Filtrer par...",
                                style: TextStyle(
                                  fontFamily: defaultFont,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.0,
                                ),
                              ),
                              isExpanded: true,
                              items: ["Vue globale", "En attente", "Payées"]
                                  .map((e) {
                                return DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontFamily: defaultFont,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                switch (value) {
                                  case "Vue globale":
                                    await dataController
                                        .loadFilterFactures("all");

                                    break;
                                  case "En attente":
                                    await dataController
                                        .loadFilterFactures("pending");

                                    break;
                                  default:
                                    await dataController
                                        .loadFilterFactures("completed");
                                }
                                setState(() {
                                  filter = value!;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    child: SearchInput(
                      hinteText: "Recherche par client...",
                      onSearched: onSearch,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: factures.isEmpty
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
                      itemCount: factures.length,
                      itemBuilder: (context, index) {
                        var item = factures[index];
                        return FactureCard(
                          item: item,
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  void onSearch(String? value) async {
    if (value!.isEmpty) {
      setState(() {
        factures = List.from(dataController.filteredFactures);
      });
    } else {
      setState(() {
        factures = dataController.filteredFactures
            .where((item) => item.client!.clientNom!
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
      });
    }
  }
}

class FilterBtn extends StatelessWidget {
  final bool? active;
  final String label;
  const FilterBtn({
    super.key,
    this.active = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: active! ? primaryColor : scaffoldColor,
        border: Border.all(width: active! ? .8 : 0, color: primaryColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 15.0,
              color: active! ? scaffoldColor : primaryColor,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: defaultFont,
                fontSize: 12.0,
                color: active! ? scaffoldColor : defaultTextColor,
                fontWeight: active! ? FontWeight.w500 : FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
