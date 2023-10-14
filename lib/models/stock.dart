import 'package:zandoprintapp/services/utils.dart';

class Entree {
  int? entreeId;
  double? entreeQte;
  double? entreePrixAchat;
  String? entreePrixDevise;
  String? entreeCreateAt;
  String? entreeState;
  int? entreeProduitId;
  double? totalEntrees;
  Entree({
    this.entreeId,
    this.entreeQte,
    this.entreePrixAchat,
    this.entreePrixDevise,
    this.entreeCreateAt,
    this.entreeState,
    this.entreeProduitId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (entreeId != null) {
      data['entree_id'] = entreeId;
    }
    data['entree_qte'] = entreeQte;
    data['entree_prix_achat'] = entreePrixAchat;
    data['entree_prix_devise'] = entreePrixDevise;
    var dateNow = DateTime.now();
    data['entree_create_At'] = entreeCreateAt ?? dateToString(dateNow);
    data['entree_produit_id'] = entreeProduitId;
    data['entree_state'] = entreeState ?? 'allowed';

    return data;
  }

  Entree.fromMap(Map<String, dynamic> data) {
    entreeId = data['entree_id'];
    entreeQte = data['entree_qte'];
    entreePrixAchat = data['entree_prix_achat'];
    entreePrixDevise = data['entree_prix_devise'];
    entreeCreateAt = data['entree_create_At'];
    entreeProduitId = data['entree_produit_id'];
    if (data['total_entrees'] != null) {
      totalEntrees = data['total_entrees'];
    }
  }
}

class Sortie {
  int? sortieId;
  double? sortieQte;
  String? sortieMotif;
  String? sortieCreateAt;
  double? totalSorties;
  String? sortieState;
  int? sortieProduitId;

  Sortie({
    this.sortieId,
    this.sortieQte,
    this.sortieMotif,
    this.sortieProduitId,
    this.sortieCreateAt,
    this.sortieState,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (sortieId != null) {
      data['sortie_id'] = sortieId;
    }
    data['sortie_qte'] = sortieQte;
    data['sortie_motif'] = sortieMotif!.isEmpty ? "sortie stock" : sortieMotif;
    data['sortie_produit_id'] = sortieProduitId;
    var dateNow = DateTime.now();
    data['sortie_create_At'] = sortieCreateAt ?? dateToString(dateNow);
    data['sortie_state'] = sortieState ?? 'allowed';
    return data;
  }

  Sortie.fromMap(Map<String, dynamic> data) {
    sortieId = data['sortie_id'];
    sortieQte = data['sortie_qte'];
    sortieMotif = data['sortie_motif'];
    sortieCreateAt = data['sortie_create_At'];
    sortieProduitId = data['sortie_produit_id'];
    sortieState = data['sortie_state'];
    if (data['total_sorties'] != null) {
      totalSorties = data['total_sorties'];
    }
  }
}

class Produit {
  int? produitId;
  String? produitLibelle;
  String? produitCreateAt;
  String? produitState;
  Entree? entree;
  Sortie? sortie;
  Produit({
    this.produitId,
    this.produitLibelle,
    this.produitCreateAt,
    this.produitState,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (produitId != null) {
      data['produit_id'] = produitId;
    }
    data['produit_libelle'] = produitLibelle;
    var dateNow = DateTime.now();
    data['produit_create_At'] = produitCreateAt ?? dateToString(dateNow);
    data['produit_state'] = produitState ?? "allowed";
    return data;
  }

  Produit.fromMap(Map<String, dynamic> data) {
    produitId = data['produit_id'];
    produitLibelle = data['produit_libelle'];
    produitCreateAt = data['produit_create_At'];
    produitState = data['produit_state'];
    if (data['entree_id'] != null) {
      entree = Entree.fromMap(data);
    }

    if (data['sortie_id'] != null) {
      sortie = Sortie.fromMap(data);
    }
  }

  double get solde {
    return (entree!.totalEntrees! - sortie!.totalSorties!);
  }

  @override
  String toString() {
    return produitLibelle!;
  }
}
