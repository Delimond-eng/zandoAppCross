import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/app/index.dart';
import '/services/db.service.dart';
import '/controllers/data_controller.dart';
import '/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(DataController());
  Get.put(AuthController());
  await DBService.initDb();
  if (Platform.isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  runApp(const EntryPoint());
}
