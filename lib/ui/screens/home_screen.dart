import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zandoprintapp/models/facture_detail.dart';
import 'package:zandoprintapp/models/operation.dart';
import 'package:zandoprintapp/services/db.service.dart';
import '../../models/client.dart';
import '../../models/compte.dart';
import '../../models/facture.dart';
import '../../models/user.dart';
import '../../services/utils.dart';
import '/global/controllers.dart';
import '/global/storage.dart';
import '/ui/widgets/user_avatar.dart';
import '/ui/modals/auth/login_modal.dart';
import '/ui/pages/menu_page.dart';

import '/config/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      var u = storage.read("user");
      if (u != null) {
        setState(() {
          isLoggedIn = true;
        });
      } else {
        showLoginModal(context, onLoggedIn: () {
          setState(() {
            isLoggedIn = true;
          });
        });
      }
    });
  }

  Future<bool> updateDatabase() async {
    /*Old database*/
    var olddb = await DBService.initDb(dbname: "old.db");
    /*New database*/
    var db = await DBService.initDb();

    var query = await olddb.rawQuery("SELECT * FROM users");
    for (var e in query) {
      var user = User.fromMap(e);
      var latestId = await db.rawInsert(
          "INSERT OR REPLACE INTO users(user_id,user_name, user_role, user_pass, user_access) VALUES(${user.userId},'${user.userName}','${user.userRole}','${user.userPass}','${user.userAccess}')");
      print("user : $latestId");
    }

    /*client*/
    var query1 = await olddb
        .rawQuery("SELECT * FROM clients WHERE NOT client_state = 'deleted'");
    for (var e in query1) {
      var client = Client.fromMap(e);
      var date =
          parseTimestampToDate(int.parse(client.clientTimestamp.toString()));
      client.clientTimestamp = dateToString(date);
      var latestId = await db.insert("clients", client.toMap());
      print("client : $latestId");
    }

    /*factures*/
    var query2 = await olddb
        .rawQuery("SELECT * FROM factures WHERE NOT facture_state='deleted'");
    for (var e in query2) {
      var facture = Facture.fromMap(e);
      var date =
          parseTimestampToDate(int.parse(facture.factureTimestamp.toString()));
      facture.factureTimestamp = dateToString(date);
      var latestId = await db.insert("factures", facture.toMap());
      print("facture : $latestId");
    }

    /*Facture details*/
    var query3 = await olddb.rawQuery(
        "SELECT * FROM facture_details WHERE NOT facture_detail_state='deleted'");
    for (var e in query3) {
      var detail = FactureDetail.fromMap(e);
      var date = parseTimestampToDate(
          int.parse(detail.factureDetailTimestamp.toString()));
      detail.factureDetailTimestamp = dateToString(date);
      var latestId = await db.insert("facture_details", detail.toMap());
      print("detail : $latestId");
    }

    /*compte*/
    var query4 = await olddb
        .rawQuery("SELECT * FROM comptes WHERE NOT compte_state='deleted'");
    for (var e in query4) {
      var compte = Compte.fromMap(e);
      var date =
          parseTimestampToDate(int.parse(compte.compteTimestamp.toString()));
      compte.compteTimestamp = dateToString(date);
      var latestId = await db.insert("comptes", compte.toMap());
      print("compte : $latestId");
    }

    /*operations*/
    var query5 = await olddb.rawQuery(
        "SELECT * FROM operations WHERE NOT operation_state='deleted'");
    for (var e in query5) {
      var operation = Operations.fromMap(e);
      var date = parseTimestampToDate(
          int.parse(operation.operationTimestamp.toString()));
      operation.operationTimestamp = dateToString(date);
      var latestId = await db.insert("operations", operation.toMap());
      print("operation : $latestId");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isLoggedIn
          ? Obx(
              () => ZoomIn(
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    authController.isSyncIn.value = true;
                    updateDatabase()
                        .then((value) => authController.isSyncIn.value = false);
                  },
                  child: authController.isSyncIn.value
                      ? const SizedBox(
                          height: 25.0,
                          width: 25.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.0,
                          ),
                        )
                      : SvgPicture.asset(
                          "assets/icons/sync.svg",
                          height: 24.0,
                          colorFilter: const ColorFilter.mode(
                            lightColor,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
            )
          : null,
      appBar: isLoggedIn
          ? AppBar(
              title: FadeInRight(
                child: SvgPicture.asset(
                  "assets/icons/logo.svg",
                  height: 70.0,
                ),
              ),
              actions: [
                Row(
                  children: [
                    ZoomIn(child: const UserAvatar()),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            )
          : null,
      body: Obx(() => authController.user.value.userId != null
          ? const MenuPage()
          : _starter(context)),
    );
  }

  Widget _starter(context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInUp(
                child: SvgPicture.asset(
                  "assets/icons/logo.svg",
                  height: 150.0,
                  colorFilter:
                      const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                ),
              ),
              ZoomIn(
                child: const Text(
                  "Bienvenue sur zando print app !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: defaultFont,
                    color: defaultTextColor,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ZoomIn(
                child: const Text(
                  "Cliquez sur le boutton en bas pour vous authentifier !",
                  style: TextStyle(
                    fontFamily: defaultFont,
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ZoomIn(
                child: ElevatedButton.icon(
                  onPressed: () => showLoginModal(context, onLoggedIn: () {
                    setState(() {
                      isLoggedIn = true;
                    });
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.all(18.0),
                    elevation: 10.0,
                    textStyle: const TextStyle(
                      fontFamily: defaultFont,
                      color: lightColor,
                      fontSize: 14.0,
                    ),
                  ),
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text(
                    "S'Authentifier",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


/* SafeArea(
        child: Row(
          children: [
            Container(
              height: _size.height,
              width: 80.0,
              decoration: const BoxDecoration(color: lightColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Image.asset(
                      "assets/icons/logo.png",
                      height: 70,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                        5,
                        (index) => Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 40.0,
                    width: 40.0,
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_open_rounded,
                        color: lightColor,
                        size: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Authentification",
                          style: TextStyle(
                            fontFamily: defaultFont,
                            color: defaultTextColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          height: 40.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/anims/lock.json',
                          height: 120,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                        const Text(
                          "Bienvenue sur zando print app !",
                          style: TextStyle(
                            fontFamily: defaultFont,
                            color: defaultTextColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          "Cliquez sur le boutton en bas pour vous authentifier !",
                          style: TextStyle(
                            fontFamily: defaultFont,
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.all(18.0),
                            elevation: 10.0,
                            textStyle: const TextStyle(
                                fontFamily: defaultFont,
                                color: lightColor,
                                fontSize: 14.0),
                          ),
                          icon: const Icon(Icons.lock_open_rounded),
                          label: const Text(
                            "S'Authentifier",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ) */