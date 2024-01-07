class FactureDetail {
  dynamic factureDetailId;
  String? factureDetailLibelle;
  dynamic factureDetailQte;
  String? factureDetailPu;
  String? factureDetailNature;
  String? factureDetailDevise;
  dynamic factureId;
  dynamic factureDetailTimestamp;
  String? factureDetailState;
  double get total =>
      double.parse(factureDetailPu.toString()) *
      double.parse(factureDetailQte.toString());
  FactureDetail({
    this.factureDetailId,
    this.factureDetailLibelle,
    this.factureDetailQte,
    this.factureDetailPu,
    this.factureDetailNature,
    this.factureDetailDevise,
    this.factureId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (factureDetailId != null) {
      data["facture_detail_id"] = int.parse(factureDetailId.toString());
    }

    if (factureDetailLibelle != null) {
      data["facture_detail_libelle"] = factureDetailLibelle;
    }
    if (factureDetailQte != null) {
      if (factureDetailQte.toString().contains(",")) {
        data["facture_detail_qte"] =
            double.parse(factureDetailQte.toString().replaceAll(",", "."));
      } else {
        data["facture_detail_qte"] = double.parse(factureDetailQte.toString());
      }
    }
    if (factureDetailPu != null) {
      if (factureDetailPu!.contains(",")) {
        data["facture_detail_pu"] =
            double.parse(factureDetailPu!.replaceAll(",", "."));
      } else {
        data["facture_detail_pu"] = double.parse(factureDetailPu!);
      }
    }
    if (factureDetailDevise != null) {
      data["facture_detail_devise"] = factureDetailDevise;
    }
    if (factureDetailNature != null) {
      data['facture_detail_nature'] = factureDetailNature;
    }
    /*   DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (factureDetailTimestamp == null) {
      data["facture_detail_create_At"] = dateToString(now);
    } else {
      data["facture_detail_create_At"] = factureDetailTimestamp.toString();
    }
    if (factureId != null) {
      data["facture_id"] = int.parse(factureId.toString());
    }
    data["facture_detail_state"] = factureDetailState ?? "allowed";
 */
    return data;
  }

  FactureDetail.fromMap(Map<String, dynamic> data) {
    factureDetailId = data["facture_detail_id"];
    factureDetailLibelle = data["facture_detail_libelle"];
    factureDetailQte = data["facture_detail_qte"];
    factureDetailPu = data["facture_detail_pu"].toString();
    factureDetailNature = data['facture_detail_nature'];
    factureDetailDevise = data["facture_detail_devise"];
    factureId = data["facture_id"];
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return factureDetailLibelle!;
      case 1:
        return factureDetailNature!;
      case 2:
        return "$factureDetailPu  $factureDetailDevise";
      case 3:
        return "$factureDetailQte";
      case 4:
        return "$total  $factureDetailDevise";
    }
    return '';
  }

  // Écrivez une méthode equals pour comparer les objets Item
  @override
  bool operator ==(other) {
    return (other is FactureDetail) &&
        other.factureDetailLibelle == factureDetailLibelle &&
        other.factureDetailNature == factureDetailNature;
  }

  @override
  int get hashCode =>
      factureDetailLibelle.hashCode ^ factureDetailLibelle.hashCode;
}
