import 'package:get/get.dart';
import 'package:zandoprintapp/global/storage.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  var user = User().obs;
  var selectedEditUser = User().obs;
  var isUpdated = false.obs;
  var isSyncIn = false.obs;

  bool get checkUser {
    if (user.value.userRole!.contains("admin")) {
      return true;
    }
    if (user.value.userRole!.contains("utilisateur")) {
      return true;
    }
    return false;
  }

  @override
  onInit() {
    super.onInit();
    init();
  }

  init() async {
    var umap = storage.read("user");
    if (umap != null) {
      user.value = User.fromMap(umap);
    }
  }
}
