import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../models/compte.dart';
import '/services/db.service.dart';
import '../../../models/client.dart';
import '../../widgets/empty_state.dart';
import '/config/utils.dart';
import '/ui/widgets/search_input.dart';

import '../util.dart';

Future<void> showCompteFilterModal(context,
    {required Function(Compte compte) onSelected}) async {
  List<Compte> comptes = await getComptes();
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
                SearchInput(
                  hinteText: "Rechercher client...",
                  onSearched: (val) async {
                    var db = await DBService.initDb();
                    try {
                      var allComptes = await db.rawQuery(
                          "SELECT * FROM comptes WHERE NOT compte_state='deleted' AND compte_libelle LIKE '%$val%'");
                      setter(() {
                        comptes.clear();
                        for (var e in allComptes) {
                          comptes.add(Compte.fromMap(e));
                        }
                      });
                    } catch (e) {}
                  },
                ),
                if (comptes.isEmpty) ...[
                  const EmptyState()
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: comptes.length,
                    itemBuilder: (context, index) {
                      return CompteFilterCard(
                        compte: comptes[index],
                        onSelected: onSelected,
                      );
                    },
                  )
                ]
              ],
            ),
          )
        ],
      );
    }),
  );
}

Future<List<Compte>> getComptes() async {
  final db = await DBService.initDb();
  var json = await db
      .rawQuery("SELECT * FROM comptes WHERE NOT compte_state='deleted'");
  List<Compte> comptes = <Compte>[];
  for (var e in json) {
    comptes.add(Compte.fromMap(e));
  }
  return comptes;
}

class CompteFilterCard extends StatelessWidget {
  final Compte compte;
  final Function(Compte) onSelected;
  const CompteFilterCard({
    super.key,
    required this.onSelected,
    required this.compte,
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
              onSelected.call(compte);
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
                      "assets/icons/money-bag.svg",
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
                      compte.compteLibelle!,
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
