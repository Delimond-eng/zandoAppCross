import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/client.dart';
import '../models/compte.dart';
import '../models/currency.dart';
import '../models/facture.dart';
import '../models/operation.dart';
import '../models/stock.dart';
import '../models/user.dart';
import '../reports/models/daily_count.dart';
import '../reports/models/dashboard_count.dart';
import '../reports/report.dart';
import '../services/db.service.dart';
import '../services/synchonisation.dart';
import '../services/utils.dart';

class DataController extends GetxController {
  static DataController instance = Get.find();
  var users = <User>[].obs;
  var factures = <Facture>[].obs;
  var filteredFactures = <Facture>[].obs;
  var clients = <Client>[].obs;
  var clientFactures = <Client>[].obs;
  var comptes = <Compte>[].obs;
  var allComptes = <Compte>[].obs;
  var currency = Currency().obs;
  var dashboardCounts = <DashboardCount>[].obs;
  var dailySums = <DailyCount>[].obs;
  var paiements = <Operations>[].obs;
  var paiementDetails = <Operations>[].obs;
  var inventories = <Operations>[].obs;
  var stockEntrees = <Entree>[].obs;
  var stockSorties = <Sortie>[].obs;
  var allSorties = <Sortie>[].obs;
  var daySellCount = 0.0.obs;
  var dataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadActivatedComptes();
    refreshDatas();
  }

  Future<void> refreshDatas() async {
    await loadFacturesEnAttente();
    await loadFilterFactures("all");
    await refreshCurrency();
    await refreshDayCompteSum();
    await refreshDashboardCounts();
    await countDaySum();
    /* loadActivatedComptes();
    loadClients(); */
  }

  //* Load all users list*//
  loadUsers() async {
    var db = await DBService.initDb();
    var userData = await db.query("users");
    users.clear();
    for (var e in userData) {
      users.add(User.fromMap(e));
    }
    users.removeWhere((user) => user.userName!.contains("ad"));
  }

  Future loadFilterFactures(String key) async {
    var db = await DBService.initDb();
    try {
      var query;
      if (key == "all") {
        query = await db.rawQuery(
            "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT factures.facture_state='deleted' ORDER BY factures.facture_id DESC");
      }
      if (key == "pending") {
        query = await db.rawQuery(
            "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut = 'en cours' OR factures.facture_statut = 'en attente'  AND NOT factures.facture_state='deleted' ORDER BY factures.facture_id DESC");
      }

      if (key == "completed") {
        query = await db.rawQuery(
            "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut='paie' AND NOT factures.facture_state='deleted' ORDER BY factures.facture_id DESC");
      }

      List<Facture> tmps = <Facture>[];
      for (var e in query) {
        await Future.delayed(const Duration(microseconds: 1000));
        tmps.add(Facture.fromMap(e));
      }
      filteredFactures.clear();
      filteredFactures.addAll(tmps);
    } catch (e) {
      if (kDebugMode) {
        print("orr : $e");
      }
    }
    return true;
  }

  refreshDashboardCounts() async {
    var counts = await Report.getCount();
    dashboardCounts.clear();
    await Future.delayed(const Duration(milliseconds: 100));
    dashboardCounts.addAll(counts);
  }

  refreshDayCompteSum() async {
    await countDaySum();
    var sums = await Report.getDayAccountSums();
    dailySums.clear();
    await Future.delayed(const Duration(milliseconds: 100));
    dailySums.addAll(sums);
  }

  refreshCurrency() async {
    var db = await DBService.initDb();
    var taux = await db.query("currencies");
    if (taux.isNotEmpty) {
      currency.value = Currency.fromMap(taux.first);
    } else {
      editCurrency();
    }
  }

  countDaySum() async {
    var s = await Report.dayAll();
    daySellCount.value = double.parse(s.toString());
  }

  Future loadFacturesEnAttente() async {
    try {
      var db = await DBService.initDb();
      var allFactures = await db.rawQuery(
          "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_statut = 'en cours' AND NOT factures.facture_state='deleted' ORDER BY factures.facture_id DESC");
      List<Facture> tempsList = <Facture>[];
      for (var e in allFactures) {
        await Future.delayed(const Duration(microseconds: 1000));
        tempsList.add(Facture.fromMap(e));
      }
      factures.clear();
      factures.addAll(tempsList);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return "end";
  }

  Future loadClients() async {
    try {
      var db = await DBService.initDb();
      var allClients = await db.rawQuery(
          "SELECT * FROM clients WHERE NOT client_state ='deleted' ORDER BY client_id DESC");
      List<Client> tempsList = <Client>[];
      for (var e in allClients) {
        await Future.delayed(const Duration(microseconds: 1000));
        tempsList.add(Client.fromMap(e));
      }
      clients.clear();
      clients.addAll(tempsList);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return true;
  }

  Future loadPayments(String key, {field}) async {
    var db = await DBService.initDb();
    switch (key) {
      case "all":
        var query = await db.rawQuery(
          "SELECT SUM(operations.operation_montant) AS totalPay, * FROM factures INNER JOIN operations ON factures.facture_id = operations.operation_facture_id INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT operations.operation_state='deleted' GROUP BY operations.operation_facture_id ORDER BY operations.operation_facture_id DESC",
        );
        List<Operations> tempsList = <Operations>[];
        for (var e in query) {
          await Future.delayed(const Duration(microseconds: 1000));
          tempsList.add(Operations.fromMap(e));
        }
        paiements.clear();
        paiements.addAll(tempsList);
        break;
      case "client":
        var query = await db.rawQuery(
          "SELECT SUM(operations.operation_montant) AS totalPay, * FROM factures INNER JOIN operations ON factures.facture_id = operations.operation_facture_id INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT operations.operation_state='deleted' AND clients.client_id=$field GROUP BY operations.operation_facture_id ORDER BY operations.operation_facture_id DESC",
        );
        List<Operations> tempsList = <Operations>[];
        for (var e in query) {
          await Future.delayed(const Duration(microseconds: 1000));
          tempsList.add(Operations.fromMap(e));
        }
        paiements.clear();
        paiements.addAll(tempsList);
        break;
      case "details":
        var query = await db.rawQuery(
          "SELECT SUM(operations.operation_montant) AS totalPay, * FROM factures INNER JOIN operations ON factures.facture_id = operations.operation_facture_id INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT operations.operation_state='deleted' AND operations.operation_create_At = '$field' GROUP BY operations.operation_facture_id ORDER BY operations.operation_id DESC",
        );
        List<Operations> tempsList = <Operations>[];
        for (var e in query) {
          await Future.delayed(const Duration(microseconds: 1000));
          tempsList.add(Operations.fromMap(e));
        }
        paiements.clear();
        paiements.addAll(tempsList);
        break;
      case "date":
        var query = await db.rawQuery(
          "SELECT SUM(operations.operation_montant) AS totalPay, * FROM factures INNER JOIN operations ON factures.facture_id = operations.operation_facture_id INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT operations.operation_state='deleted' AND operations.operation_create_At = '$field'  GROUP BY operations.operation_facture_id ORDER BY operations.operation_facture_id DESC",
        );
        List<Operations> tempsList = <Operations>[];
        for (var e in query) {
          await Future.delayed(const Duration(microseconds: 1000));
          tempsList.add(Operations.fromMap(e));
        }
        paiements.clear();
        paiements.addAll(tempsList);
        break;
    }
    return true;
  }

  Future showPaiementDetails(int factureId) async {
    var db = await DBService.initDb();
    var query = await db.rawQuery(
        "SELECT * FROM factures INNER JOIN operations ON factures.facture_id = operations.operation_facture_id INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE NOT operations.operation_state='deleted' AND operations.operation_facture_id = $factureId");
    List<Operations> tempsList = <Operations>[];
    for (var e in query) {
      await Future.delayed(const Duration(microseconds: 1000));
      tempsList.add(Operations.fromMap(e));
    }
    paiementDetails.clear();
    paiementDetails.addAll(tempsList);
    return true;
  }

  Future loadInventories(String fword, {fkey}) async {
    var db = await DBService.initDb();
    try {
      switch (fword) {
        case "all":
          var query = await db.rawQuery(
              "SELECT SUM(operations.operation_montant) AS totalPay, * FROM operations INNER JOIN comptes on operations.operation_compte_id = comptes.compte_id WHERE NOT operations.operation_state='deleted' GROUP BY operations.operation_create_At,operations.operation_compte_id ORDER BY operations.operation_id DESC");

          List<Operations> tempsList = <Operations>[];
          for (var e in query) {
            await Future.delayed(Duration.zero);
            tempsList.add(Operations.fromMap(e));
          }
          inventories.clear();
          inventories.addAll(tempsList);

          break;
        case "compte":
          var query = await db.rawQuery(
              "SELECT SUM(operations.operation_montant) AS totalPay, * FROM operations INNER JOIN comptes on operations.operation_compte_id = comptes.compte_id WHERE NOT operations.operation_state='deleted' AND operations.operation_compte_id = $fkey GROUP BY operations.operation_create_At, operations.operation_compte_id ORDER BY operations.operation_id DESC");
          List<Operations> tempsList = <Operations>[];
          for (var e in query) {
            await Future.delayed(Duration.zero);
            tempsList.add(Operations.fromMap(e));
          }
          inventories.clear();
          inventories.addAll(tempsList);
          break;
        case "type":
          var query = await db.rawQuery(
              "SELECT SUM(operations.operation_montant) AS totalPay, * FROM operations INNER JOIN comptes on operations.operation_compte_id = comptes.compte_id WHERE NOT operations.operation_state='deleted' AND operations.operation_type = '$fkey' GROUP BY operations.operation_create_At , operations.operation_compte_id ORDER BY operations.operation_create_At DESC");

          List<Operations> tempsList = <Operations>[];
          for (var e in query) {
            await Future.delayed(Duration.zero);
            tempsList.add(Operations.fromMap(e));
          }
          inventories.clear();
          inventories.addAll(tempsList);
          break;
        case "date":
          if (kDebugMode) {
            print("date $fkey");
          }
          var query = await db.rawQuery(
              "SELECT SUM(operations.operation_montant) AS totalPay, * FROM operations INNER JOIN comptes on operations.operation_compte_id = comptes.compte_id WHERE NOT operations.operation_state='deleted' AND operations.operation_create_At = '$fkey' GROUP BY operations.operation_create_At, operations.operation_compte_id ORDER BY operations.operation_id DESC");
          List<Operations> tempsList = <Operations>[];
          for (var e in query) {
            await Future.delayed(Duration.zero);
            tempsList.add(Operations.fromMap(e));
          }
          inventories.clear();
          inventories.addAll(tempsList);
          break;
        case "mois":
          var query = await db.rawQuery(
              "SELECT SUM(operations.operation_montant) AS totalPay, * FROM operations INNER JOIN comptes on operations.operation_compte_id = comptes.compte_id WHERE NOT operations.operation_state='deleted' GROUP BY operations.operation_create_At, operations.operation_compte_id ORDER BY operations.operation_id DESC");
          List<Operations> tempsList = <Operations>[];
          for (var e in query) {
            await Future.delayed(Duration.zero);
            tempsList.add(Operations.fromMap(e));
          }
          var filters = tempsList
              .where((el) =>
                  el.operationDate!.substring(3, 10).contains(fkey.toString()))
              .toList();
          inventories.clear();
          inventories.addAll(filters);
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error : $e");
      }
    }
    return true;
  }

  Future loadStockData(int index, {int? id}) async {
    var db = await DBService.initDb();
    switch (index) {
      case 0:
        var query = await db.rawQuery(
            "SELECT * FROM entrees INNER JOIN produits ON entrees.entree_produit_id = produits.produit_id WHERE NOT entrees.entree_state = 'deleted' AND NOT produits.produit_state='deleted'");
        stockEntrees.clear();
        for (var e in query) {
          stockEntrees.add(Entree.fromMap(e));
        }
        break;
      case 1:
        var query2 = await db.rawQuery(
            "SELECT *, TOTAL(sortie_qte) AS total_sortie FROM sorties WHERE NOT sorties.sortie_state = 'deleted' GROUP BY sortie_entree_id ORDER BY sortie_entree_id");

        var query = await db.rawQuery(
          """SELECT * FROM entrees
          INNER JOIN produits ON entrees.entree_produit_id = produits.produit_id
          AND NOT entrees.entree_state='deleted'
          AND NOT produits.produit_state='deleted'
          GROUP BY entrees.entree_id 
          ORDER BY entrees.entree_id DESC""",
        );

        Map<String, dynamic> map = {};
        Map<String, dynamic> emptyMap = {
          "total_sortie": 0.0,
          "sortie_id": 0,
          "sortie_motif": "",
          "sortie_entree_id": 0
        };
        stockSorties.clear();
        for (var e in query) {
          Map<String, dynamic> emap = {};
          if (query2.isNotEmpty) {
            for (var k in query2) {
              if (e['entree_id'] == k['sortie_entree_id']) {
                emap = k;
              }
            }
            if (emap.isEmpty) {
              map
                ..addAll(e)
                ..addAll(emptyMap);
            } else {
              map
                ..addAll(e)
                ..addAll(emap);
            }
          } else {
            map
              ..addAll(e)
              ..addAll(emptyMap);
          }
          stockSorties.add(Sortie.fromMap(map));
        }
        break;
      case 2:
        var query = await db.rawQuery("""SELECT * FROM sorties
            INNER JOIN entrees ON entrees.entree_id = sorties.sortie_entree_id
            INNER JOIN produits ON produits.produit_id = entrees.entree_produit_id
            WHERE entrees.entree_id=$id AND NOT sorties.sortie_state='deleted'
            AND NOT entrees.entree_state = 'deleted' 
            AND NOT produits.produit_state='deleted'
            ORDER BY sorties.sortie_id DESC
            """);
        allSorties.clear();
        for (var e in query) {
          allSorties.add(Sortie.fromMap(e));
        }
        break;
    }
    return true;
  }

  loadActivatedComptes() async {
    var db = await DBService.initDb();
    try {
      var allAccounts = await db.rawQuery(
        "SELECT * FROM comptes WHERE compte_status='actif' AND NOT compte_state='deleted'",
      );
      comptes.clear();
      for (var e in allAccounts) {
        comptes.add(Compte.fromMap(e));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  loadAllComptes() async {
    var db = await DBService.initDb();
    try {
      var json = await db
          .rawQuery("SELECT * FROM comptes WHERE NOT compte_state='deleted'");
      allComptes.clear();
      for (var e in json) {
        allComptes.add(Compte.fromMap(e));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  editCurrency({String? value}) async {
    try {
      var db = await DBService.initDb();
      var data = Currency(currencyValue: value);
      var checked = await db.query("currencies");
      if (checked.isEmpty && value == null) {
        var data = Currency(currencyValue: "2000");
        await db.insert("currencies", data.toMap());
      }
      if (value != null) {
        await db.update(
          "currencies",
          data.toMap(),
          where: "cid=?",
          whereArgs: [1],
        );
        refreshCurrency();
      }
    } catch (e) {}
  }

  Future syncUserData() async {
    var db = await DBService.initDb();
    final batch = db.batch();
    var syncDatas = await Sync.outPutData();
    try {
      if (syncDatas.users!.isNotEmpty) {
        for (var user in syncDatas.users!) {
          var check = await db.rawQuery(
            "SELECT * FROM users WHERE user_id = ?",
            [user.userId],
          );
          if (check.isEmpty) {
            batch.insert("users", user.toMap());
          } else {
            batch.update(
              "users",
              user.toMap(),
              where: "user_id=?",
              whereArgs: [user.userId],
            );
          }
          var res = await batch.commit();
          if (kDebugMode) {
            print("committed $res");
          }
        }
        return "end";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }
}
