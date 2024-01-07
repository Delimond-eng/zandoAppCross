import '../global/controllers.dart';
import '../services/utils.dart';
import 'client.dart';
import 'facture_detail.dart';
import 'operation.dart';
import 'user.dart';

class Facture {
  dynamic factureId;
  String? factureMontant;
  String? factureDevise;
  dynamic factureCreateAt;
  String? factureDateCreate;
  String? factureStatut;
  String? factureState;
  dynamic factureClientId;
  String? factureTimestamp;
  int? factureUserId;
  List<FactureDetail>? details;
  List<Operation>? paiements;

  Client? client;
  User? user;

  Facture({
    this.factureId,
    this.factureMontant,
    this.factureDevise,
    this.factureClientId,
    this.factureCreateAt,
    this.factureStatut,
    this.factureTimestamp,
    this.factureState,
    this.factureUserId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (factureId != null) {
      data["facture_id"] = int.parse(factureId.toString());
    }

    if (factureMontant != null) {
      data["facture_montant"] = double.parse(
          double.parse(factureMontant.toString()).toStringAsFixed(2));
    }
    if (factureDevise != null) {
      data["facture_devise"] = factureDevise;
    }
    if (factureClientId != null) {
      data["facture_client_id"] = int.parse(factureClientId.toString());
    }

    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (factureTimestamp == null) {
      data["facture_create_At"] = dateToString(now);
    } else {
      data["facture_create_At"] = factureTimestamp.toString();
    }
    data["facture_statut"] = factureStatut ?? "en cours";
    data["user_id"] = authController.user.value.userId ?? factureUserId;
    data["facture_state"] = factureState ?? "allowed";
    return data;
  }

  Facture.fromMap(Map<String, dynamic> data) {
    factureId = data["id"];
    factureMontant = data["facture_montant"].toString();
    factureDevise = data["facture_devise"];
    factureClientId = data["client_id"];
    factureUserId = data['user_id'];
    factureStatut = data["facture_status"];
    factureTimestamp = data["facture_create_At"].toString();
    factureState = data["facture_state"];
    factureDateCreate = data["facture_create_At"];
    if (data["client"] != null) {
      client = Client.fromMap(data['client']);
    }
    if (data["user"] != null) {
      user = User.fromMap(data['user']);
    }
    if (data['details'] != null) {
      details = (data['details'] as List<dynamic>?)
          ?.map((e) => FactureDetail.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    if (data['paiements'] != null) {
      paiements = (data['paiements'] as List<dynamic>?)
          ?.map((e) => Operation.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  double get restToPay {
    double rest = 0;
    if (paiements!.isEmpty) {
      rest = double.parse(factureMontant!);
    } else {
      double amount = 0;
      for (var paie in paiements!) {
        amount += double.parse(paie.operationMontant!.toString());
      }
      rest = double.parse(
          (double.parse(factureMontant!) - amount).toStringAsFixed(2));
    }
    return rest;
  }

  double get totPay {
    double tot = 0;
    if (paiements!.isNotEmpty) {
      for (var paie in paiements!) {
        tot += double.parse(paie.operationMontant!.toString());
      }
    }
    return double.parse((tot).toStringAsFixed(2));
  }
}
