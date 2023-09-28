import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/global/controllers.dart';
import '/services/db.service.dart';
import '/ui/modals/util.dart';
import '../../models/client.dart';
import '/config/utils.dart';

class ClientCard extends StatelessWidget {
  final Client item;
  const ClientCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/user.svg",
                  colorFilter: const ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                  height: 25.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.clientNom!,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: defaultTextColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      item.clientTel!,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.brown,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  30.0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                  onTap: () {
                    deleteClient(context, item);
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/delete.svg",
                      height: 14.0,
                      colorFilter: const ColorFilter.mode(
                        Colors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteClient(context, Client client) async {
    var db = await DBService.initDb();
    DGCustomDialog.showInteraction(context,
        message:
            "Etes-vous sûr de vouloir supprimer définitivement ce client ?",
        onValidated: () {
      db
          .update("clients", {"client_state": "deleted"},
              where: "client_id=?", whereArgs: [client.clientId])
          .then((value) => dataController.loadClients());
    });
  }
}
