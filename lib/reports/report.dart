import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'models/daily_count.dart';
import 'models/dashboard_count.dart';
import 'models/month.dart';

class Report {
  static Future<Object> dayAll() async {
    double count = 0;
    var res = await Api.request(url: 'dashboard.all');
    if (res.containsKey('day_count')) {
      count = double.parse(res['day_count'].toString());
    }
    return count;
  }

  static Future<List<DailyCount>> getDayAccountSums() async {
    final List<DailyCount> data = <DailyCount>[];
    var res = await Api.request(url: 'dashboard.all');
    if (res.containsKey('dash_counts')) {
      int len = res['day_payments'].length;
      for (int i = 0; i < len; i++) {
        var item = res['day_payments'][i];
        data.add(
          DailyCount(
            icon: buildIcon(i),
            sum: double.parse(item['sum'].toString()),
            title: item['title'],
          ),
        );
      }
    }
    return data;
  }

  static Future<List<DashboardCount>> getCount() async {
    List<DashboardCount> counts = [];
    var res = await Api.request(url: 'dashboard.all');
    if (res.containsKey('dash_counts')) {
      int len = res['dash_counts'].length;
      for (int i = 0; i < len; i++) {
        var item = res['dash_counts'][i];
        counts.add(
          DashboardCount(
            countValue: int.parse(item['count'].toString()),
            icon: item['icon'],
            title: item['title'],
            color: buildColor(i),
          ),
        );
      }
    }
    return counts;
  }

  //**get List of months**//
  static Future<List<Month>> getMonths() async {
    List<Month> data = <Month>[];
    List<String> months = [
      "Janvier",
      "Février.",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre",
    ];
    var dateNow = DateTime.now();
    for (int i = 0; i < months.length; i++) {
      var m = months[i];
      var t = Month(
          label: m,
          value: "${(i + 1).toString().padLeft(2, "0")}-${dateNow.year}");
      data.add(t);
    }
    return data;
  }
}

MaterialColor buildColor(int index) {
  if (index == 0) {
    return Colors.indigo;
  } else if (index == 1) {
    return Colors.brown;
  } else if (index == 2) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}

IconData buildIcon(int index) {
  if (index == 0) {
    return CupertinoIcons.money_dollar_circle_fill;
  } else if (index == 1) {
    return Icons.mobile_friendly_sharp;
  } else if (index == 2) {
    return CupertinoIcons.arrow_right_arrow_left_circle_fill;
  } else {
    return CupertinoIcons.doc_append;
  }
}
