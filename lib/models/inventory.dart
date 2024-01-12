class Inventory {
  String? operationCreateAt;
  double? totalAmount;
  String? devise;
  int? compteId;
  String? compteLibelle;

  Inventory(
      {this.operationCreateAt,
      this.totalAmount,
      this.devise,
      this.compteId,
      this.compteLibelle});

  Inventory.fromJson(Map<String, dynamic> json) {
    operationCreateAt = json['operation_create_At'];
    totalAmount = double.parse(json['total_amount'].toString());
    devise = json['devise'];
    if (json['compte_id'] != null) {
      compteId = json['compte_id'];
      compteLibelle = json['compte_libelle'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operation_create_At'] = operationCreateAt;
    data['total_amount'] = totalAmount;
    data['devise'] = devise;
    return data;
  }
}
