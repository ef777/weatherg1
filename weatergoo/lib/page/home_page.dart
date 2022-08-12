import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:weatergoo/comp/Input.dart';
import 'package:weatergoo/config/config.dart';
import 'package:weatergoo/models/apimodel.dart';

// ignore: camel_case_types
class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

// ignore: camel_case_types
class _Home_pageState extends State<Home_page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  var dat;
  Future<void> api(city) async {
    getconfig.sehir = city;
    dat = await Config.fetchWeatherFromCity(getconfig.sehir);
    await Future<void>.delayed(const Duration(seconds: 2));
    Config.weatherSaved = dat;
  }

  @override
  void initState() {
    // api();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 80) / 2.2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: RefreshIndicator(
            onRefresh: () async {
              api(getconfig.sehir).then((value) => null);
            },
            child: FutureBuilder(
                future: Future.wait([api(getconfig).then((value) => null)]),
                builder: (context, AsyncSnapshot<List<dynamic>> snaphost) {
                  print("builder başladı");

                  if (snaphost.hasData) {
                    print("data geldi");
                    print(snaphost.data);

                    return CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child:
                                  SizedBox(height: 200, child: Container()))),
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child: SizedBox(
                                  height: 400,
                                  child: Container(
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(children: [
                                            Icon(Icons.map),
                                            Text(getconfig.sehir)
                                          ])),
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Icon(Icons.calendar_month),
                                              Text(DateTime.now().toString())
                                            ],
                                          )),
                                        ],
                                      ),
                                      Row(children: [
                                        Expanded(
                                            child: Row(children: [
                                          Icon(Icons.temple_buddhist_rounded),
                                          Text(
                                              "${Config.weatherSaved.main!.temp.toString()} °C")
                                        ])),
                                        Expanded(
                                            child: Row(children: [
                                          Icon(Icons.calendar_month),
                                          Text(Config.weatherSaved.clouds!.all
                                              .toString())
                                        ]))
                                      ]),
                                    ]),
                                  )))),
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child: SizedBox(
                                  height: 200,
                                  child: Container(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Form(
                                              key: _formKey,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          1, 5, 1, 5),
                                                  child: SizedBox(
                                                      height: 80,
                                                      child: Stack(children: [
                                                        Input(
                                                          label:
                                                              getconfig.sehir,
                                                          inputype:
                                                              TextInputType
                                                                  .text,
                                                          borderColors:
                                                              Colors.grey,
                                                          textval: (text) => {
                                                            getconfig.sehir =
                                                                text
                                                          },
                                                          errorText:
                                                              "Please enter a valid city name",
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(Icons
                                                                      .search),
                                                                  onPressed:
                                                                      () {
                                                                    api(getconfig
                                                                        .sehir);
                                                                  },
                                                                ))),
                                                      ]))))),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              child: Container(
                                                  child: IconButton(
                                                icon: Icon(Icons.location_city),
                                                onPressed: () {
                                                  Config.displayDialog(context);
                                                },
                                              ))))
                                    ],
                                  ))))),
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child:
                                  SizedBox(height: 200, child: Container()))),
                    ]);
                  } else {
                    return const Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                    );
                  }
                })));
  }
}
