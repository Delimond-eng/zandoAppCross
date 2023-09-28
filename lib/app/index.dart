import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/config/utils.dart';
import '/ui/screens/home_screen.dart';

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'zando print application',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR')],
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch: primaryColor,
        scaffoldBackgroundColor: scaffoldColor,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: lightColor, size: 18.0),
          actionsIconTheme: IconThemeData(color: primaryColor, size: 15.0),
        ),
      ),
      builder: EasyLoading.init(),
      home: Builder(builder: ((context) => const HomeScreen())),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 30.0
    ..radius = 5.0
    ..userInteractions = true
    ..dismissOnTap = false;
}
