class Item {
  int? id;
  String? itemLibelle;
  String? itemState;
  String? itemCreateAt;
  List<Nature>? natures; // Modifier le type de List<Natures> à List<Nature>?

  Item({
    this.id,
    this.itemLibelle,
    this.itemState,
    this.itemCreateAt,
    this.natures,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemLibelle: json['item_libelle'],
      itemState: json['item_state'],
      itemCreateAt: json['item_create_At'],
      natures: (json['natures'] as List<dynamic>?)
          ?.map((e) => Nature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_libelle'] = itemLibelle;
    data['item_state'] = itemState;
    data['item_create_At'] = itemCreateAt;
    if (natures != null) {
      data['natures'] = natures!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return itemLibelle!;
  }
}

class Nature {
  int? id;
  String? itemNatureLibelle;
  String? itemNaturePrix;
  String? itemNaturePrixDevise;
  String? itemNatureState;
  String? itemNatureCreateAt;
  int? itemId;

  Nature({
    this.id,
    this.itemNatureLibelle,
    this.itemNaturePrix,
    this.itemNaturePrixDevise,
    this.itemNatureState,
    this.itemNatureCreateAt,
    this.itemId,
  });

  factory Nature.fromJson(Map<String, dynamic> json) {
    return Nature(
      id: json['id'],
      itemNatureLibelle: json['item_nature_libelle'],
      itemNaturePrix: json['item_nature_prix'],
      itemNaturePrixDevise: json['item_nature_prix_devise'],
      itemNatureState: json['item_nature_state'],
      itemNatureCreateAt: json['item_nature_create_At'],
      itemId: json['item_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_nature_libelle'] = itemNatureLibelle;
    data['item_nature_state'] = itemNatureState;
    data['item_nature_create_At'] = itemNatureCreateAt;
    data['item_id'] = itemId;
    return data;
  }

  @override
  String toString() {
    return itemNatureLibelle!;
  }
}
