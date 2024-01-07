import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zandoprintapp/ui/modals/public/client_releve_modal.dart';
import '../../services/api.dart';
import '/global/controllers.dart';
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
                  color: Colors.black,
                ),
              ),
              onSelected: (value) async {
                switch (value) {
                  case 1:
                    if (item.factures!.isNotEmpty) {
                      showClientReleve(context, client: item);
                    } else {
                      EasyLoading.showToast(
                          'Aucune information disponible pour ce client !');
                    }
                    break;
                  case 2:
                    deleteClient(context, item);
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
                        "assets/icons/doc1.svg",
                        height: 14.0,
                        colorFilter: const ColorFilter.mode(
                          Colors.green,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Voir relevés',
                        style: TextStyle(
                          fontSize: 12.0,
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
                        height: 17.0,
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
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteClient(context, Client client) async {
    DGCustomDialog.showInteraction(context,
        message:
            "Etes-vous sûr de vouloir supprimer définitivement ce client ?",
        onValidated: () {
      Api.request(url: 'data.delete', method: 'post', body: {
        "table": "clients",
        "id": int.parse(client.clientId.toString()),
        "state": "client_state"
      }).then((res) {
        if (res.containsKey('errors')) {
          EasyLoading.showToast(res['errors'].toString());
          return;
        }
        if (res.containsKey('status')) {
          dataController.loadClients();
        }
      });
    });
  }
}
