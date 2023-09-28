import 'package:zandoprintapp/services/utils.dart';

class Entree {
  int? entreeId;
  double? entreeQte;
  double? entreePrixAchat;
  String? entreePrixDevise;
  String? entreeCreateAt;
  String? entreeRef;
  String? entreeState;
  int? entreeProduitId;
  Produit? produit;
  Entree({
    this.entreeId,
    this.entreeQte,
    this.entreePrixAchat,
    this.entreePrixDevise,
    this.entreeCreateAt,
    this.entreeRef,
    this.entreeState,
    this.entreeProduitId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (entreeId != null) {
      data['entree_id'] = entreeId;
    }
    data['entree_qte'] = entreeQte;
    data['entree_ref'] = entreeRef;
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
    entreeRef = data['entree_ref'];
    entreeState = data['entree_state'];
    if (data['produit_id'] != null) {
      produit = Produit.fromMap(data);
    }
  }

  @override
  String toString() {
    return entreeRef!;
  }
}

class Sortie {
  int? sortieId;
  double? sortieQte;
  String? sortieMotif;
  String? sortieCreateAt;
  int? sortieEntreeId;
  double? totalSorties;
  String? sortieState;
  Entree? entree;

  Sortie({
    this.sortieId,
    this.sortieQte,
    this.sortieMotif,
    this.sortieEntreeId,
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
    data['sortie_entree_id'] = sortieEntreeId;
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
    sortieEntreeId = data['sortie_entree_id'];
    sortieEntreeId = data['sortie_entree_id'];
    sortieState = data['sortie_state'];
    if (data['total_sortie'] != null) {
      totalSorties = data['total_sortie'];
    }
    if (data['entree_id'] != null) {
      entree = Entree.fromMap(data);
    }
  }

  double get solde {
    return (entree!.entreeQte! - totalSorties!);
  }
}

class Produit {
  int? produitId;
  String? produitLibelle;
  String? produitCreateAt;
  String? produitState;
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
  }

  @override
  String toString() {
    return produitLibelle!;
  }
}
