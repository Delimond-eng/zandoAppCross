import '../global/data_crypt.dart';

class User {
  dynamic userId;
  String? userName;
  String? userRole;
  String? userPass;
  String? userAccess;
  String? accessStr;

  bool hasPassVisibility = false;
  User({
    this.userId,
    this.userName,
    this.userRole,
    this.userPass,
    this.userAccess,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (userId != null) {
      data["id"] = int.parse(userId.toString());
    }
    if (userName != null) {
      data["name"] = userName!.toString();
    }
    if (userRole != null) {
      data["role"] = userRole!.toString();
    }
    if (userPass != null) {
      data["password"] = Cryptage.encrypt(userPass!).toString();
    }
    if (userAccess != null) {
      data["access"] = userAccess!.toString();
    } else {
      data["access"] = "allowed";
    }
    return data;
  }

  User.fromMap(Map<String, dynamic> map) {
    userId = map["id"];
    userName = map["name"];
    userRole = map["role"];
    userPass = map['password'];
    userAccess = map["access"];
    accessStr = map["access"] == "allowed" ? "actif" : "inactif";
  }
}
