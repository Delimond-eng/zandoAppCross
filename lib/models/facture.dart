import '../global/controllers.dart';
import '../services/utils.dart';
import 'client.dart';
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
    factureId = data["facture_id"];
    factureMontant = data["facture_montant"].toString();
    factureDevise = data["facture_devise"];
    factureClientId = data["facture_client_id"];
    factureStatut = data["facture_statut"];
    factureTimestamp = data["facture_create_At"].toString();
    factureState = data["facture_state"];
    if (data["client_id"] != null) {
      client = Client.fromMap(data);
    }
    if (data["user_id"] != null) {
      user = User.fromMap(data);
    }
    try {
      factureDateCreate = data["facture_create_At"];
    } catch (err) {}
  }
}
