import 'compte.dart';
import 'facture.dart';
import 'user.dart';

class Operation {
  int? id;
  String? operationLibelle;
  String? operationType;
  double? operationMontant;
  String? operationDevise;
  String? operationMode;
  int? userId;
  int? compteId;
  int? factureId;
  String? operationState;
  String? operationCreateAt;
  Facture? facture;
  User? user;
  Compte? compte;

  Operation(
      {this.id,
      this.operationLibelle,
      this.operationType,
      this.operationMontant,
      this.operationDevise,
      this.operationMode,
      this.userId,
      this.compteId,
      this.factureId,
      this.operationState,
      this.operationCreateAt,
      this.facture,
      this.user,
      this.compte});

  Operation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operationLibelle = json['operation_libelle'];
    operationType = json['operation_type'];
    operationMontant = double.parse(json['operation_montant'].toString());
    operationDevise = json['operation_devise'];
    operationMode = json['operation_mode'];
    userId = json['user_id'];
    compteId = json['compte_id'];
    factureId = json['facture_id'];
    operationState = json['operation_state'];
    operationCreateAt = json['operation_create_At'];
    facture = json['facture'] != null ? Facture.fromMap(json['facture']) : null;
    user = json['user'] != null ? User.fromMap(json['user']) : null;
    compte = json['compte'] != null ? Compte.fromMap(json['compte']) : null;
  }
}

class Paiement {
  double? totalPay;
  int? factureId;
  double? factureMontant;
  String? factureDevise;
  String? factureStatus;
  int? clientId;
  String? clientNom;
  String? operationCreateAt;
  String? operationType;
  String? operationLibelle;
  String? operationDevise;
  int? compteId;
  String? compteLibelle;
  int? userId;
  String? userName;

  Paiement(
      {this.totalPay,
      this.factureId,
      this.factureMontant,
      this.factureDevise,
      this.factureStatus,
      this.clientId,
      this.clientNom,
      this.operationCreateAt,
      this.operationType,
      this.operationLibelle,
      this.operationDevise,
      this.compteId,
      this.compteLibelle,
      this.userId,
      this.userName});

  Paiement.fromJson(Map<String, dynamic> json) {
    totalPay = double.tryParse(json['totalPay'].toString());
    factureId = json['facture_id'];
    factureMontant = double.tryParse(json['facture_montant'].toString());
    factureDevise = json['facture_devise'];
    factureStatus = json['facture_status'];
    clientId = json['client_id'];
    clientNom = json['client_nom'];
    operationCreateAt = json['operation_create_At'];
    operationType = json['operation_type'];
    operationLibelle = json['operation_libelle'];
    operationDevise = json['operation_devise'];
    compteId = json['compte_id'];
    compteLibelle = json['compte_libelle'];
    userId = json['user_id'];
    userName = json['user_name'];
  }

  double get rest {
    return factureMontant! - totalPay!;
  }
}
