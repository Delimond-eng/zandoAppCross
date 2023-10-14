// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../global/controllers.dart';
import '/services/db.service.dart';

import '../models/sync_model.dart';

class Sync {
  static const String baseURL = "http://127.0.0.1/zando_sync";
  static Future<bool> inPutData() async {
    authController.isSyncIn.value = true;
    var db = await DBService.initDb();
    try {
      var users = await db.query("users");
      if (users.isNotEmpty) {
        send({"users": users});
      }
      var clients = await db.query("clients");
      if (clients.isNotEmpty) {
        await send({"clients": clients});
      }
      var factures = await db.query("factures");
      if (factures.isNotEmpty) {
        await send({"factures": factures});
      }

      var factureDetails = await db.query("facture_details");
      if (factureDetails.isNotEmpty) {
        await send({"facture_details": factureDetails});
      }

      var comptes = await db.query("comptes");
      if (comptes.isNotEmpty) {
        await send({"comptes": comptes});
      }

      var operations = await db.query("operations");
      if (operations.isNotEmpty) {
        await send({"operations": operations});
      }

      var produits = await db.query("produits");
      if (produits.isNotEmpty) {
        await send({"produits": produits});
      }

      var entrees = await db.query("entrees");
      if (entrees.isNotEmpty) {
        await send({"entrees": entrees});
      }

      var sorties = await db.query("sorties");
      if (sorties.isNotEmpty) {
        await send({"sorties": sorties});
      }

      /* await FacturationRepo.syncData(); */
    } catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
      authController.isSyncIn.value = false;
      return false;
    }
    authController.isSyncIn.value = false;
    return true;
  }

  static Future<SyncModel> outPutData() async {
    http.Client? client = http.Client();
    http.Response? response;
    try {
      response = await client.get(Uri.parse("$baseURL/datas/sync/out"));
    } catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      authController.isSyncIn.value = false;
      // ignore: null_check_always_fails
      return null!;
    }
    if (response != null) {
      if (response.statusCode == 200) {
        return SyncModel.fromMap(jsonDecode(response.body));
      } else {
        // ignore: null_check_always_fails
        return null!;
      }
    } else {
      // ignore: null_check_always_fails
      return null!;
    }
  }

  static Future send(Map<String, dynamic> map) async {
    String json = jsonEncode(map);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = "file.json";
    File file = File("$tempPath/$filename");
    file.createSync();
    file.writeAsStringSync(json);
    /* var db = await DBService.initDb();
    var users = await db.query("users");
    if (users.isNotEmpty) {
      if (users[0]['user_name'] == "admin") {
        return;
      }
    } */
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse("$baseURL/datas/sync/in"));
      request.files.add(
        http.MultipartFile.fromBytes(
          'fichier',
          file.readAsBytesSync(),
          filename: filename.split("/").last,
        ),
      );
      request.send().then((result) async {
        http.Response.fromStream(result).then((response) {
          print(response.body);
          if (response.statusCode == 200) {}
        });
      }).catchError((err) {
        if (kDebugMode) {
          print('error : $err');
        }
      }).whenComplete(() {});
    } catch (err) {
      if (kDebugMode) {
        print('error : $err');
      }
    }
  }

  static Future<bool> synData(String table, id, Map<String, dynamic> json,
      {List<dynamic>? datas}) async {
    var db = await DBService.initDb();
    String tableIndex = table.substring(0, table.length - 1);
    try {
      if (datas!.isNotEmpty) {
        for (var user in datas) {
          var check = await db.rawQuery(
            "SELECT * FROM $table WHERE $tableIndex = ?",
            [id],
          );
          if (check.isEmpty) {
            await db.insert(table, json);
          } else {
            await db.update(
              table,
              user.toMap(),
              where: "$tableIndex=?",
              whereArgs: [id],
            );
          }
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return false;
    }
    return false;
  }
}
