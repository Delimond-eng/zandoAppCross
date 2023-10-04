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
      data["user_id"] = int.parse(userId.toString());
    }
    if (userName != null) {
      data["user_name"] = userName!.toString();
    }
    if (userRole != null) {
      data["user_role"] = userRole!.toString();
    }
    if (userPass != null) {
      if (userPass!.length > 20) {
        data["user_pass"] = userPass!;
      } else {
        data["user_pass"] = Cryptage.encrypt(userPass!).toString();
      }
    }
    if (userAccess != null) {
      data["user_access"] = userAccess!.toString();
    } else {
      data["user_access"] = "allowed";
    }
    return data;
  }

  User.fromMap(Map<String, dynamic> map) {
    userId = map["user_id"];
    userName = map["user_name"];
    userRole = map["user_role"];
    if (map['user_pass'] != null) {
      userPass = Cryptage.decrypt(map["user_pass"]);
    }
    userAccess = map["user_access"];
    accessStr = map["user_access"] == "allowed" ? "actif" : "inactif";
  }
}
