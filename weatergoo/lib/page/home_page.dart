import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:weatergoo/comp/Input.dart';
import 'package:weatergoo/comp/daystile.dart';
import 'package:weatergoo/config/config.dart';
import 'package:weatergoo/models/apimodel.dart';
import 'package:weatergoo/models/apimodel2.dart';

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

  var a;
  var b;

  Future<OpenWeather> current(String city) async {
    print("api başladı");
    getconfig.sehir = city.toString();

    a = await Config.fetchWeatherFromCitynow(city);

    print("current: $a");

    return a;
  }

  Future<OpenWeatherForecast> forecast(String city) async {
    print("api2 başladı");
    getconfig.sehir = city.toString();
    b = await Config.fetchWeatherFromCityforecast(city);

    print("forecast: $b");

    return b;
  }

  late Future<OpenWeatherForecast> forecastvalue;
  late Future<OpenWeather> currentvalue;

  @override
  void initState() {
    // api();
    forecastvalue = forecast(getconfig.sehir);
    currentvalue = current(getconfig.sehir);

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
        body: RefreshIndicator(
            onRefresh: () async {
              //forecastvalue = forecast(getconfig.sehir);
              //currentvalue = current(getconfig.sehir);
            },
            child: FutureBuilder(
                future: Future.wait([forecastvalue, currentvalue]),
                builder: (context, AsyncSnapshot<List<dynamic>> snaphost) {
                  OpenWeatherForecast forecast = snaphost.data![0];
                  OpenWeather current = snaphost.data![1];
                  String current_date =
                      (DateTime.fromMillisecondsSinceEpoch(current.dt! * 1000))
                          .toString();
                  String fixedcurrentdate = current_date.substring(0, 10);

                  if (snaphost.hasData) {
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
                            style: TextStyle(color: Colors.black, fontSize: 14),
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
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 1, 5),
                                                      child: SizedBox(
                                                          height: 80,
                                                          child: Stack(
                                                              children: [
                                                                Input(
                                                                  label:
                                                                      getconfig
                                                                          .sehir,
                                                                  inputype:
                                                                      TextInputType
                                                                          .text,
                                                                  borderColors:
                                                                      Colors
                                                                          .grey,
                                                                  textval:
                                                                      (text) =>
                                                                          {
                                                                    getconfig
                                                                            .sehir =
                                                                        text
                                                                  },
                                                                  errorText:
                                                                      "Please enter a valid city name",
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
                                                                              () {},
                                                                        ))),
                                                              ]))))),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
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
                                                      Config.displayDialog(
                                                          context);
                                                    },
                                                  ))))
                                        ],
                                      ))))),
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child: Container(
                                margin:
                                    new EdgeInsets.symmetric(horizontal: 20.0),
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
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                    Text(getconfig.sehir)
                                                  ]))),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: MaterialButton(
                                                  minWidth: 15,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                          .description
                                                          .toString())
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
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                                      BorderRadius.circular(8)),
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
                                                      BorderRadius.circular(8)),
                                              color: Colors.white,
                                              onPressed: () {},
                                              child: Text("Max")),
                                          MaterialButton(
                                              minWidth: 15,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
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
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                })));
  }
}
