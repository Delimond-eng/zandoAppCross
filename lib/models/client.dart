import '../global/controllers.dart';
import '../services/utils.dart';

class Client {
  dynamic clientId;
  dynamic userId;
  String? clientNom;
  String? clientTel;
  String? clientAdresse;
  String? clientCreatAt;
  String? clientState;
  dynamic clientTimestamp;

  bool isSelected = false;
  Client({
    this.clientId,
    this.userId,
    this.clientNom,
    this.clientTel,
    this.clientAdresse,
    this.clientCreatAt,
    this.clientTimestamp,
    this.clientState,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (clientId != null) {
      data["client_id"] = int.parse(clientId.toString());
    }
    if (clientNom != null) {
      data["client_nom"] = clientNom!.toLowerCase();
    }
    data["client_tel"] = clientTel ?? "";
    data["client_adresse"] = clientAdresse ?? "";
    if (userId == null) {
      data["user_id"] = authController.user.value.userId;
    } else {
      data["user_id"] = int.parse(userId.toString());
    }
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (clientTimestamp == null) {
      data["client_create_At"] = dateToString(now);
    } else {
      data["client_create_At"] = clientTimestamp.toString();
    }
    data["client_state"] = clientState ?? "allowed";
    return data;
  }

  Client.fromMap(Map<String, dynamic> data) {
    clientId = data["client_id"];
    clientNom = data["client_nom"];
    clientTel = data["client_tel"];
    clientAdresse = data["client_adresse"];
    if (data["client_state"] != null) {
      clientState = data["client_state"];
    }
    if (data["user_id"] != null) {
      userId = data["user_id"];
    }
    if (data["client_create_At"] != null) {
      try {
        clientTimestamp = data["client_create_At"];
        DateTime date = parseTimestampToDate(data["client_create_At"]);
        clientCreatAt = dateToString(date);
      } catch (err) {}
    }
  }
}
