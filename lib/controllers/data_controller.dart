import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/client.dart';
import '../models/compte.dart';
import '../models/currency.dart';
import '../models/facture.dart';
import '../models/inventory.dart';
import '../models/operation.dart';
import '../models/stock.dart';
import '../models/user.dart';
import '../models/item.dart';
import '../reports/models/daily_count.dart';
import '../reports/models/dashboard_count.dart';
import '../reports/report.dart';
import '../services/api.dart';

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
  var items = <Item>[].obs;
  var dashboardCounts = <DashboardCount>[].obs;
  var dailySums = <DailyCount>[].obs;
  var paiements = <Paiement>[].obs;
  var paiementDetails = <Operation>[].obs;
  var inventories = <Inventory>[].obs;
  var daySellCount = 0.0.obs;
  var dataLoading = false.obs;
  var stocks = <Produit>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshDatas();
  }

  Future<bool> refreshDatas() async {
    await refreshConfigs();
    await loadFacturesEnAttente();
    await refreshDashboardCounts();
    await refreshDayCompteSum();
    await countDaySum();
    await loadClients();
    return true;
  }

  Future loadFilterFactures(String key) async {
    var datas = await Api.request(url: 'factures.view/$key');
    if (datas.containsKey('results')) {
      filteredFactures.clear();
      for (var e in datas['results']) {
        filteredFactures.add(Facture.fromMap(e));
      }
    }
    return true;
  }

  refreshDashboardCounts() async {
    var counts = await Report.getCount();
    dashboardCounts.clear();
    await Future.delayed(Duration.zero);
    dashboardCounts.addAll(counts);
  }

  refreshDayCompteSum() async {
    var sums = await Report.getDayAccountSums();
    dailySums.clear();
    await Future.delayed(Duration.zero);
    dailySums.addAll(sums);
  }

  /// Recharger les données de la configuration
  Future<bool> refreshConfigs() async {
    dataLoading.value = true;
    var res = await Api.request(url: 'configs.all');
    dataLoading.value = false;
    if (res.containsKey('users')) {
      var usersMap = res["users"];
      users.clear();
      for (var e in usersMap) {
        users.add(User.fromMap(e));
      }
    }
    if (res.containsKey('status')) {
      currency.value = Currency.fromMap(res['currencie']);
      if (res.containsKey('all_comptes')) {
        var comptesArr = res['all_comptes'];
        allComptes.clear();
        for (var e in comptesArr) {
          allComptes.add(Compte.fromMap(e));
        }
      }
      if (res.containsKey('activated_comptes')) {
        var activeComptesArr = res['activated_comptes'];
        comptes.clear();
        for (var e in activeComptesArr) {
          comptes.add(Compte.fromMap(e));
        }
      }
      if (res.containsKey('items')) {
        items.clear();
        for (var i in res['items']) {
          items.add(Item.fromJson(i));
        }
      }
    }
    return true;
  }

  //COMPTE LA SOMME DE PAIEMENT JOURNALIER
  countDaySum() async {
    var s = await Report.dayAll();
    daySellCount.value = double.parse(s.toString());
  }

  //RECHARGE LES FACTURES EN COURS
  Future loadFacturesEnAttente() async {
    try {
      var res = await Api.request(url: 'factures.view/pending');
      var allFactures = res['results'];
      factures.clear();
      for (var e in allFactures) {
        await Future.delayed(const Duration(microseconds: 1000));
        factures.add(Facture.fromMap(e));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return "end";
  }

  //RECHARGE LES CLIENTS
  Future loadClients() async {
    try {
      var res = await Api.request(url: 'clients.all');
      if (res.containsKey('status')) {
        var allClients = res['clients'];
        clients.clear();
        for (var e in allClients) {
          await Future.delayed(const Duration(microseconds: 1000));
          clients.add(Client.fromMap(e));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    return true;
  }

  //RECHARGE LES PAIEMENTS
  Future loadPayments(String key, {field}) async {
    switch (key) {
      case "all":
        dataLoading.value = true;
        var res = await Api.request(url: 'payments/all');
        dataLoading.value = false;
        if (res.containsKey('results')) {
          paiements.clear();
          for (var e in res['results']) {
            paiements.add(Paiement.fromJson(e));
          }
        }
        break;
      case "date":
        dataLoading.value = true;
        var res = await Api.request(url: 'payments/date/$field');
        dataLoading.value = false;
        if (res.containsKey('results')) {
          paiements.clear();
          for (var e in res['results']) {
            paiements.add(Paiement.fromJson(e));
          }
        }
        break;
    }
    return true;
  }

  //VOIR LES DETAILS D'UN PAIEMENT
  Future showPaiementDetails(int factureId) async {
    var res = await Api.request(url: 'payment.details/$factureId');
    if (res.containsKey('status')) {
      var datas = res['details'];
      paiementDetails.clear();
      for (var e in datas) {
        paiementDetails.add(Operation.fromJson(e));
      }
    }
    return true;
  }

  Future<bool> loadInventories({fkey, keyVal}) async {
    dataLoading.value = true;
    if (keyVal == null) {
      var res = await Api.request(url: 'inventories.load/$fkey');
      dataLoading.value = false;
      if (res.containsKey('status')) {
        var datas = res['results'];
        inventories.clear();
        for (var e in datas) {
          inventories.add(Inventory.fromJson(e));
        }
      }
    } else {
      var res = await Api.request(url: 'inventories.load/$fkey/$keyVal');
      dataLoading.value = false;
      if (res.containsKey('status')) {
        var datas = res['results'];
        inventories.clear();
        for (var e in datas) {
          inventories.add(Inventory.fromJson(e));
        }
      }
    }
    return true;
  }

  Future<List<Operation>> showInventoryDetails(date) async {
    List<Operation> details = [];
    var res = await Api.request(url: 'inventory.details/$date');
    if (res.containsKey('status')) {
      var datas = res['results'];
      for (var e in datas) {
        details.add(Operation.fromJson(e));
      }
    }
    return details;
  }

  Future loadStockData() async {
    var res = await Api.request(url: 'stocks.view');
    if (res.containsKey('status')) {
      var datas = res['results'];
      stocks.clear();
      for (var e in datas) {
        stocks.add(Produit.fromJson(e));
      }
    }
  }

  //MISE A JOUR DU TAUX DU JOUR
  editCurrency({String? value}) async {
    try {
      var res = await Api.request(
          url: 'currencie.create',
          method: 'post',
          body: {
            "currencie_value": value,
            "currencie_id": currency.value.currencyId
          });
      if (res.containsKey('status')) {
        refreshConfigs();
      }
    } catch (e) {}
  }
}





/* import 'package:flutter/foundation.dart';
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
  var allEntrees = <Produit>[].obs;
  var stocks = <Produit>[].obs;
  var allSorties = <Produit>[].obs;
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
    /* var db = await DBService.initDb();
    switch (index) {
      case 0:
        var query = await db.rawQuery("""SELECT * FROM entrees 
            INNER JOIN produits ON
            entrees.entree_produit_id = produits.produit_id 
            WHERE NOT entrees.entree_state = 'deleted'
            AND NOT produits.produit_state='deleted' AND produits.produit_id=$id""");
        allEntrees.clear();
        for (var e in query) {
          allEntrees.add(Produit.fromMap(e));
        }
        break;
      case 1:
        var querySorties = await db.rawQuery(
            "SELECT *, TOTAL(sortie_qte) AS total_sorties FROM sorties WHERE NOT sorties.sortie_state = 'deleted' GROUP BY sortie_produit_id");

        var queryEntrees = await db.rawQuery(
            "SELECT *,TOTAL(entree_qte) AS total_entrees FROM entrees WHERE NOT entrees.entree_state = 'deleted' GROUP BY entree_produit_id");

        var query = await db.rawQuery(
          """SELECT * FROM produits WHERE NOT produit_state='deleted' 
          ORDER BY produit_id DESC""",
        );

        Map<String, dynamic> map = {};
        Map<String, dynamic> emptySMap = {
          "total_sorties": 0.0,
          "sortie_id": 0,
          "sortie_motif": "",
          "sortie_produit_id": 0
        };
        Map<String, dynamic> emptyEMap = {
          "total_entrees": 0.0,
          "entree_id": 0,
          "entree_produit_id": 0
        };
        stocks.clear();
        for (var e in query) {
          Map<String, dynamic> smap = {};
          Map<String, dynamic> emap = {};
          if (queryEntrees.isNotEmpty) {
            for (var k in queryEntrees) {
              if (e['produit_id'] == k['entree_produit_id']) {
                emap = k;
              }
            }
            if (emap.isEmpty) {
              map
                ..addAll(e)
                ..addAll(emptyEMap);
            } else {
              map
                ..addAll(e)
                ..addAll(emap);
            }
          } else {
            map
              ..addAll(e)
              ..addAll(emptyEMap);
          }
          if (querySorties.isNotEmpty) {
            for (var k in querySorties) {
              if (e['produit_id'] == k['sortie_produit_id']) {
                smap = k;
              }
            }
            if (smap.isEmpty) {
              map
                ..addAll(e)
                ..addAll(emptySMap);
            } else {
              map
                ..addAll(e)
                ..addAll(smap);
            }
          } else {
            map
              ..addAll(e)
              ..addAll(emptySMap);
          }
          stocks.add(Produit.fromMap(map));
        }
        break;
      case 2:
        var query = await db.rawQuery("""SELECT * FROM sorties
            INNER JOIN produits ON produits.produit_id = sorties.sortie_produit_id
            WHERE produits.produit_id=$id AND NOT sorties.sortie_state='deleted'
            AND NOT produits.produit_state='deleted'
            ORDER BY sorties.sortie_id DESC
            """);
        allSorties.clear();
        for (var e in query) {
          allSorties.add(Produit.fromMap(e));
        }
        break;
    } */
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

  /* Future syncUserData() async {
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
  } */
}
 */