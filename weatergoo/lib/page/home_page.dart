import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:weatergoo/comp/Input.dart';
import 'package:weatergoo/comp/daystile.dart';
import 'package:weatergoo/config/config.dart';
import 'package:weatergoo/models/apimodel.dart';
import 'package:weatergoo/models/apimodel2.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class Home_page extends StatefulWidget {
  Home_page({
    Key? key,
  }) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

// ignore: camel_case_types
class _Home_pageState extends State<Home_page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  String aranansehir = "";
  String konumdangelen = "";

  var a;
  var b;

  Future<OpenWeather> currenti(String city) async {
    print("api başladı");
    getconfig.sehir = city.toString();

    a = await Config.fetchWeatherFromCitynow(city);

    print("current: $a");

    return a;
  }

  Future<OpenWeatherForecast> forecasti(String city) async {
    print("api2 başladı");
    getconfig.sehir = city.toString();
    b = await Config.fetchWeatherFromCityforecast(city);

    print("forecast: $b");

    return b;
  }

  Future forecastupdate(String city) {
    print("fore update çalıştı");
    forecastvalue = forecasti(city);
    print("fore update alındı");

    return forecastvalue;
  }

  Future currentupdate(String city) {
    print("curre update çalıştı");

    currentvalue = currenti(city);
    print("cure update alındı");

    return currentvalue;
  }

  @override
  late Future<OpenWeatherForecast> forecastvalue;
  late Future<OpenWeather> currentvalue;
  var c = Get.put(getconfig());

  @override
  void initState() {
    forecastvalue = forecasti(getconfig.sehir);
    currentvalue = currenti(getconfig.sehir);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 80) / 2.2;
    final double itemWidth = size.width / 2;
    var veri;
    return Scaffold(
        key: _scaffoldKey,
        body: Obx(() => Stack(children: [
              Text(c.konumdegisti.value.toString()),
              FutureBuilder(
                  future: Future.wait([forecastvalue, currentvalue]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snaphost) {
                    if (snaphost.hasData) {
                      OpenWeatherForecast forecast = snaphost.data?[0];
                      OpenWeather current = snaphost.data?[1];
                      String current_date =
                          (DateTime.fromMillisecondsSinceEpoch(
                                  current.dt! * 1000))
                              .toString();
                      String fixedcurrentdate = current_date.substring(0, 10);
                      final String assetName = 'assets/weather.svg';
                      return CustomScrollView(slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          pinned: true,
                          expandedHeight: 100.0,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(
                              'Weathergoo',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            background: SvgPicture.asset(assetName,
                                semanticsLabel: 'Acme Logo',
                                fit: BoxFit.scaleDown),
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: Visibility(
                                visible: (1 > 0) ? true : false,
                                child: SizedBox(
                                    height: 100,
                                    child: Container(
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 15.0),
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                                flex: 8,
                                                child: Form(
                                                    key: _formKey,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 5, 1, 5),
                                                        child: SizedBox(
                                                            height: 40,
                                                            child: Stack(
                                                                children: [
                                                                  TextField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      hintText:
                                                                          "City",
                                                                      // prefixIcon: inputIcon,
                                                                      contentPadding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              14.0,
                                                                          bottom:
                                                                              8.0,
                                                                          top:
                                                                              8.0),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                Colors.white,
                                                                            width: 1.0),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                Colors.white,
                                                                            width: 1.0),
                                                                      ),
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    onChanged:
                                                                        (name) {
                                                                      setState(
                                                                          () {
                                                                        aranansehir =
                                                                            name;
                                                                      });
                                                                    },
                                                                  ),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child: Padding(
                                                                          padding: EdgeInsets.all(5),
                                                                          child: IconButton(
                                                                            icon: SizedBox(
                                                                                height: 30,
                                                                                width: 30,
                                                                                child: SvgPicture.asset("assets/search_in_cloud.svg", semanticsLabel: 'Acme Logo', fit: BoxFit.scaleDown)),
                                                                            onPressed:
                                                                                () {
                                                                              print("tuşa basildi");
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                        content: SizedBox(
                                                                                      height: 100,
                                                                                      child: const Center(
                                                                                        child: SizedBox(
                                                                                          child: CircularProgressIndicator(),
                                                                                          width: 32,
                                                                                          height: 32,
                                                                                        ),
                                                                                      ),
                                                                                    ));
                                                                                  });
                                                                              getconfig.sehir = aranansehir;
                                                                              forecastvalue = forecasti(getconfig.sehir);
                                                                              currentvalue = currenti(getconfig.sehir);

                                                                              print(c.konumdegisti.value.toString());
                                                                              print("${getconfig.sehir} şehir bu");

                                                                              c.konumla();
                                                                              Future.delayed(Duration(seconds: 1), () {
                                                                                Navigator.of(context, rootNavigator: true).pop();
                                                                              });
                                                                            },
                                                                          ))),
                                                                ]))))),
                                            Expanded(
                                                flex: 2,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),
                                                    child: Container(
                                                        child: MaterialButton(
                                                      minWidth: 15,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      color: Colors.white,
                                                      child:
                                                          Icon(Icons.gps_fixed),
                                                      onPressed: () {
                                                        print("tuşa basildi");

                                                        Config.getadres();
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  content:
                                                                      SizedBox(
                                                                height: 100,
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      SizedBox(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                    width: 32,
                                                                    height: 32,
                                                                  ),
                                                                ),
                                                              ));
                                                            });

                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 5),
                                                            () {});
                                                        forecastvalue =
                                                            forecasti(getconfig
                                                                .sehir);
                                                        currentvalue = currenti(
                                                            getconfig.sehir);

                                                        print(c
                                                            .konumdegisti.value
                                                            .toString());
                                                        print(
                                                            "${getconfig.sehir} şehir bu");

                                                        c.konumla();
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 1),
                                                            () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        });
                                                      },
                                                    ))))
                                          ],
                                        ))))),
                        SliverToBoxAdapter(
                            child: Visibility(
                                visible: (1 > 0) ? true : false,
                                child: Container(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  height: 100,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                                child: MaterialButton(
                                                    minWidth: 15,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    color: Colors.white,
                                                    onPressed: () {},
                                                    child: Row(children: [
                                                      SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: SvgPicture.asset(
                                                              "assets/address.svg",
                                                              semanticsLabel:
                                                                  'Acme Logo',
                                                              fit: BoxFit
                                                                  .scaleDown)),
                                                      Text(current.name!.substring(
                                                          0,
                                                          (current.name!
                                                                      .length >
                                                                  10
                                                              ? (current.name!
                                                                      .length -
                                                                  3)
                                                              : current.name!
                                                                      .length -
                                                                  0)))
                                                    ]))),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: MaterialButton(
                                                    minWidth: 15,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    color: Colors.white,
                                                    onPressed: () {},
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: SvgPicture.asset(
                                                                "assets/Tear-Off Calendar.svg",
                                                                semanticsLabel:
                                                                    'Acme Logo',
                                                                fit: BoxFit
                                                                    .scaleDown)),
                                                        Text(fixedcurrentdate
                                                            .toString())
                                                      ],
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: MaterialButton(
                                                      minWidth: 15,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      color: Colors.white,
                                                      onPressed: () {},
                                                      child: Row(children: [
                                                        SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: SvgPicture.asset(
                                                                "assets/thermometer.svg",
                                                                semanticsLabel:
                                                                    'Acme Logo',
                                                                fit: BoxFit
                                                                    .scaleDown)),
                                                        Text(
                                                            "${current.main!.temp.toString()} °C")
                                                      ]))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: MaterialButton(
                                                      minWidth: 15,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      color: Colors.white,
                                                      onPressed: () {},
                                                      child: Row(children: [
                                                        SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: SvgPicture.asset(
                                                                "assets/about.svg",
                                                                semanticsLabel:
                                                                    'Acme Logo',
                                                                fit: BoxFit
                                                                    .scaleDown)),
                                                        Text(current.weather![0]
                                                            .description!
                                                            .substring(0, 6))
                                                      ])))
                                            ]),
                                      ]),
                                ))),
                        SliverToBoxAdapter(
                            child: Visibility(
                                visible: (1 > 0) ? true : false,
                                child: SizedBox(
                                    height: 70,
                                    child: Container(
                                        margin: new EdgeInsets.fromLTRB(
                                            20.0, 20, 20.0, 5.0),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MaterialButton(
                                                minWidth: 15,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                color: Colors.white,
                                                onPressed: () {},
                                                child: Text("Days")),
                                            MaterialButton(
                                              minWidth: 15,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              color: Colors.white,
                                              onPressed: () {},
                                              child: Text("State"),
                                            ),
                                            MaterialButton(
                                                minWidth: 15,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                color: Colors.white,
                                                onPressed: () {},
                                                child: Text("Max")),
                                            MaterialButton(
                                                minWidth: 15,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                color: Colors.white,
                                                onPressed: () {},
                                                child: Text("Min"))
                                          ],
                                        ))))),
                        SliverToBoxAdapter(
                            child: Visibility(
                                visible: (1 > 0) ? true : false,
                                child: SizedBox(
                                    height: 400,
                                    child: Container(
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 0),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return daystile(
                                              day: forecast.list[index].dt,
                                              id: forecast.list[index].main.temp
                                                  .toString(),
                                              weather: forecast.list[index]
                                                  .weather[0].description
                                                  .toString(),
                                              max: forecast
                                                  .list[index].main.tempMax
                                                  .toString(),
                                              min: forecast
                                                  .list[index].main.tempMin
                                                  .toString(),
                                            );
                                          },
                                          itemCount: forecast.list.length,
                                        ))))),
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
                  })
            ])));
  }
}
