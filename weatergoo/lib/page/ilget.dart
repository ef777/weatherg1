import 'package:flutter/material.dart';
import 'package:weatergoo/config/config.dart';

class Ilgetir extends StatefulWidget {
  const Ilgetir({Key? key}) : super(key: key);

  @override
  State<Ilgetir> createState() => _IlgetirState();
}

class _IlgetirState extends State<Ilgetir> {
  // late final Future<List<Ilmodel>> illiste;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (context, index) {
        var datam = Config.illiste[index];
        List<String> avatar = datam.ilAdi!.split("");
        return ListTile(
          onTap: () {
            print(datam.ilAdi.toString());
            getconfig.sehir = datam.ilAdi.toString();
            Navigator.pop(context);
          },
          leading: CircleAvatar(child: Text(avatar[0])),
          title: Text(datam.ilAdi.toString()),
        );
      },
      itemCount: Config.illiste.length,
    ));
  }
}
