import 'dart:convert';

import '/services/db.service.dart';

import '../models/invoice.dart';

class DataManager {
  static Future<Invoice> getFactureInvoice({int? factureId}) async {
    var db = await DBService.initDb();
    var jsonResponse;
    try {
      var facture = await db.rawQuery(
          "SELECT * FROM factures INNER JOIN clients ON factures.facture_client_id = clients.client_id WHERE factures.facture_id = '$factureId'");
      if (facture.isNotEmpty) {
        var details = await db.query(
          "facture_details",
          where: "facture_id=?",
          whereArgs: [factureId!],
        );

        if (details.isNotEmpty) {
          jsonResponse = jsonEncode(
              {"facture": facture.first, "facture_details": details});
        }
      }
    } catch (ex) {
      print("error from $ex");
    }

    if (jsonResponse != null) {
      var invoice = Invoice.fromMap(jsonDecode(jsonResponse));
      return invoice;
    } else {
      // ignore: null_check_always_fails
      return null!;
    }
  }
}
