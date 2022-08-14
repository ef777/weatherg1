import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class daystile extends StatelessWidget {
  final String? id, weather, max, min;
  final int? day;
  daystile({
    this.id,
    this.day,
    this.weather,
    this.max,
    this.min,
    Key? key,
  }) : super(key: key);
  String idtoname(weather) {
    switch (weather) {
      case "Description.CLEAR_SKY":
        {
          String donus = "Bulutsuz";
          return donus;
        }
      case "Description.BROKEN_CLOUDS":
        {
          String donus = "Hafif Bulutlu";
          return donus;
        }
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    var days = DateTime.fromMillisecondsSinceEpoch(day! * 1000);

    String gun = DateFormat('EEEE').format(days);
    String datetxt = days.toString();
    print(weather);
    String fixedcurrentdate = datetxt.substring(5, datetxt.length - 7);

    /// e.g Thursday

    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Column(children: [Text("${gun}"), Text(" ${fixedcurrentdate} ")]),
            Text(" ${idtoname(weather)} "),
            Text(" ${max.toString()} °C"),
            Text(" ${min.toString()} °C")
          ],
        ));
  }
}
