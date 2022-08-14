import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          String donus = "assets/sun.svg";
          return donus;
        }
      case "Description.BROKEN_CLOUDS":
        {
          String donus = "assets/partly_cloudy_day.svg";
          return donus;
        }
    }
    return "assets/windy_weather.svg";
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("${gun}"), Text(" ${fixedcurrentdate} ")]),
            SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset((idtoname(weather)),
                    semanticsLabel: 'Acme Logo', fit: BoxFit.scaleDown)),
            Text(" ${max.toString()} °C"),
            Text(" ${min.toString()} °C")
          ],
        ));
  }
}
