
class Compte {
  dynamic compteId;
  dynamic compteTimestamp;
  String? compteLibelle;
  String? compteDevise;
  String? compteStatus;
  String? compteState;
  String? compteDate;

  bool isSelected = false;
  Compte({
    this.compteId,
    this.compteLibelle,
    this.compteDevise,
    this.compteStatus,
    this.compteState,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    if (compteId != null) {
      data["id"] = int.parse(compteId.toString());
    }
    if (compteLibelle != null) {
      data["compte_libelle"] = compteLibelle;
    }
    if (compteDevise != null) {
      data["compte_devise"] = compteDevise;
    }
    return data;
  }

  Compte.fromMap(Map<String, dynamic> data) {
    compteId = int.parse(data["id"].toString());
    compteLibelle = data["compte_libelle"];
    compteDevise = data["compte_devise"];
    compteStatus = data["compte_status"];
    compteTimestamp = data["compte_create_At"].toString();
    compteState = data["compte_state"];
    compteDate = data["compte_create_At"].toString();
  }

  @override
  String toString() {
    return compteLibelle!;
  }
}
