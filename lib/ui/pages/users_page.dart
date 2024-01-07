import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../services/api.dart';
import '/global/controllers.dart';
import '/ui/modals/public/create_user.dart';
import '/ui/widgets/empty_state.dart';
import '/config/utils.dart';
import '/ui/components/custom_appbar.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String changeLoading = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showCreateUserModal(context);
        },
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: const CustomAppBar(title: "Utilisateurs"),
      body: Obx(
        () => dataController.users.isEmpty
            ? const EmptyState()
            : GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (MediaQuery.of(context).size.width ~/ 250).toInt(),
                  childAspectRatio: 4.2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: dataController.users.length,
                itemBuilder: (context, index) {
                  var usr = dataController.users[index];
                  return ZoomIn(
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/user.svg",
                                  colorFilter: const ColorFilter.mode(
                                      primaryColor, BlendMode.srcIn),
                                  height: 25.0,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      usr.userName!,
                                      style: const TextStyle(
                                        fontFamily: defaultFont,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: defaultTextColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      usr.userRole!,
                                      style: const TextStyle(
                                        fontFamily: defaultFont,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.brown,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            if (changeLoading == usr.userId.toString()) ...[
                              const SizedBox(
                                height: 18.0,
                                width: 18.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                              ),
                            ] else ...[
                              Switch(
                                value: usr.userAccess == 'allowed',
                                onChanged: (value) {
                                  setState(() {
                                    changeLoading = usr.userId.toString();
                                  });
                                  Api.request(
                                    url: 'data.disable',
                                    method: 'post',
                                    body: {
                                      "table": "users",
                                      "id": int.parse(usr.userId.toString()),
                                      "state": "access",
                                      "state_val": usr.userAccess == "allowed"
                                          ? "denied"
                                          : "allowed"
                                    },
                                  ).then((value) async {
                                    await dataController.refreshConfigs();
                                    setState(() {
                                      changeLoading = '';
                                    });
                                    if (usr.userAccess == "allowed") {
                                      EasyLoading.showToast(
                                          'utilisateur désactivé !');
                                    } else {
                                      EasyLoading.showToast(
                                          'utilisateur activé !');
                                    }
                                  }).catchError((err) {
                                    setState(() {
                                      changeLoading = '';
                                    });
                                  });
                                },
                                activeColor: Colors
                                    .green, // Change the active color of the switch
                                activeTrackColor: Colors
                                    .lightGreen, // Change the track color when the switch is on
                                inactiveThumbColor: Colors
                                    .grey, // Change the color of the switch when it is off
                                inactiveTrackColor: Colors.grey.withOpacity(
                                    0.5), // Change the track color when the switch is off
                              ),
                            ]

                            /* Container(
                              height: 20.0,
                              width: 20.0,
                              decoration: BoxDecoration(
                                color: usr.userAccess == 'allowed'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20.0),
                                  onTap: () async {
                                    /* var db = await DBService.initDb(); */
                                    String access = usr.userAccess == 'allowed'
                                        ? 'denied'
                                        : 'allowed';
                                    /* db
                                        .update(
                                            "users", {"user_access": access},
                                            where: "user_id=?",
                                            whereArgs: [usr.userId])
                                        .then((value) {
                                      dataController.loadUsers();
                                    }); */
                                  },
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.checkmark_alt,
                                      size: 15.0,
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                ),
                              ),
                            ) */
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
