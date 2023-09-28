import 'package:flutter/material.dart';

class DashItem {
  String? title;
  String? value;
  String? iconPath;
  MaterialColor? color;

  DashItem({this.title, this.value, this.iconPath, this.color});
}

List<DashItem> dashItems = [
  DashItem(
      iconPath: "assets/icons/calendar-check.svg",
      title: "Factures journalières",
      value: "25",
      color: Colors.indigo),
  DashItem(
    iconPath: "assets/icons/doc1.svg",
    title: "Factures en attente",
    value: "13",
    color: Colors.brown,
  ),
  DashItem(
    iconPath: "assets/icons/doc2.svg",
    title: "Factures payées",
    value: "23",
    color: Colors.green,
  ),
  DashItem(
    iconPath: "assets/icons/users.svg",
    title: "Clients",
    color: Colors.blue,
    value: "30",
  ),
];
