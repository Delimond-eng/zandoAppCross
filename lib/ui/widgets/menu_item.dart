import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/ui/pages/stock_page.dart';
import '../../global/controllers.dart';
import '/ui/pages/inventory_page.dart';
import '/ui/pages/users_page.dart';
import '/ui/pages/compte_page.dart';
import '/ui/pages/paiement_page.dart';
import '/ui/pages/factures_page.dart';
import '/config/utils.dart';
import '/ui/pages/dashboard_page.dart';

import '/ui/pages/client_page.dart';
import '/models/menu.dart';

class MenuItem extends StatelessWidget {
  final Menu item;
  const MenuItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: lightColor,
      margin: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.0),
        elevation: 0,
        child: InkWell(
          splashColor: primaryColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            switch (item.title) {
              case "Clients":
                dataController.loadClients();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClientPage(),
                  ),
                );
                break;
              case "Tableau de bord":
                dataController.refreshDatas();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
                break;
              case "Factures":
                dataController.loadFilterFactures("all");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FacturesPage(),
                  ),
                );
                break;
              case "Paiements":
                dataController.loadPayments("all");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaiementPage(),
                  ),
                );
                break;
              case "Trésoreries":
                dataController.loadAllComptes();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComptePage(),
                  ),
                );
                break;
              case "Inventaires":
                dataController.loadInventories("all");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventoryPage(),
                  ),
                );
                break;
              case "Utilisateurs":
                dataController.loadUsers();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersPage(),
                  ),
                );
                break;
              case "Stockage":
                dataController.loadStockData(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockHomePage(),
                  ),
                );
                break;
              default:
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.shade200,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      item.icon!,
                      height: 20.0,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      colorFilter:
                          const ColorFilter.mode(lightColor, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Flexible(
                  child: Text(
                    item.title!,
                    style: const TextStyle(
                      fontFamily: defaultFont,
                      color: defaultTextColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
