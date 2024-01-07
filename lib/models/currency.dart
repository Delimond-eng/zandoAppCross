class Currency {
  int? currencyId;
  String? currencyValue;

  Currency({this.currencyId, this.currencyValue});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (currencyId != null) {
      data["id"] = currencyId;
    }
    data["currencie_value"] = currencyValue;
    return data;
  }

  Currency.fromMap(Map<String, dynamic> data) {
    currencyId = data["id"];
    currencyValue = data["currencie_value"];
  }
}
