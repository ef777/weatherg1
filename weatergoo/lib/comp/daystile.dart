import 'package:flutter/material.dart';

class daystile extends StatelessWidget {
  daystile({
    Key? key,
  }) : super(key: key);
  String idtoname(id) {
    switch (id) {
      case "1":
        {
          String donus = "g";
          return donus;
        }
      case "2":
        {
          String donus = "g2";
          return donus;
        }
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [],
        ));
  }
}
