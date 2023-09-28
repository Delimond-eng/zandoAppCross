import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:path/path.dart';

class DBService {
  static Future<Database> initDb({String? dbname}) async {
    if (Platform.isWindows) {
      ffi.sqfliteFfiInit();
      var databaseFactory = ffi.databaseFactoryFfi;
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      //Create path for database
      String dbPath =
          join(appDocumentsDir.path, "databases", dbname ?? "zandodb.db");
      var db = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          onCreate: _onCreate,
          version: 1,
        ),
      );
      return db;
    } else {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'zandodb.db');
      Database database =
          await openDatabase(path, version: 1, onCreate: _onCreate);
      return database;
    }
  }

  static void _onCreate(Database db, int version) async {
    try {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS users(user_id INTEGER NOT NULL PRIMARY KEY, user_name TEXT, user_role TEXT, user_pass TEXT, user_access TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS currencies(cid INTEGER NOT NULL PRIMARY KEY, cvalue TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS clients(client_id INTEGER NOT NULL PRIMARY KEY, client_nom TEXT,client_tel TEXT, client_adresse TEXT, client_state TEXT, user_id INTEGER, client_create_At TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS factures(facture_id INTEGER NOT NULL PRIMARY KEY, facture_montant REAL, facture_devise TEXT, facture_client_id INTEGER NOT NULL, facture_create_At TEXT, facture_statut TEXT, facture_state TEXT, user_id INTEGER)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS facture_details(facture_detail_id INTEGER NOT NULL PRIMARY KEY, facture_detail_libelle TEXT, facture_detail_qte REAL, facture_detail_pu REAL, facture_detail_devise TEXT, facture_detail_create_At TEXT,facture_detail_state TEXT, facture_id INTEGER)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS comptes(compte_id INTEGER NOT NULL PRIMARY KEY, compte_libelle TEXT, compte_devise TEXT,compte_status TEXT, compte_create_At TEXT, compte_state TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS operations(operation_id INTEGER NOT NULL PRIMARY KEY,operation_libelle TEXT,operation_type TEXT,operation_montant REAL, operation_devise TEXT, operation_compte_id INTEGER, operation_facture_id INTEGER, operation_mode TEXT, operation_user_id INTEGER, operation_state TEXT, operation_create_At INTEGER)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS sorties(sortie_id INTEGER NOT NULL PRIMARY KEY,sortie_qte REAL, sortie_motif TEXT, sortie_create_At TEXT, sortie_entree_id INTEGER, sortie_state TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS entrees(entree_id INTEGER NOT NULL PRIMARY KEY, entree_ref TEXT, entree_qte REAL, entree_prix_achat REAL, entree_prix_devise TEXT, entree_create_At TEXT, entree_produit_id INTEGER, entree_state TEXT)");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS produits(produit_id INTEGER NOT NULL PRIMARY KEY, produit_libelle TEXT, produit_create_At TEXT, produit_state TEXT)");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<bool> checkAvailability(String table) async {
    /* var db = await initDb();
    var query = await db.query(table);
    if (query.length >= 10) {
      return true;
    } */
    return false;
  }
}
