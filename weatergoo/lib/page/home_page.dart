import 'package:flutter/material.dart';
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
        appBar: AppBar(),
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

                  print("builder başladı");

                  if (snaphost.hasData) {
                    print("data geldi");
                    print(snaphost.data);
                    print(" işte liste ${forecast.list.length.toString()}");

                    return CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child: SizedBox(
                                  height: 250,
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
                                              Text(fixedcurrentdate.toString())
                                            ],
                                          )),
                                        ],
                                      ),
                                      Row(children: [
                                        Expanded(
                                            child: Row(children: [
                                          Icon(Icons.temple_buddhist_rounded),
                                          Text(
                                              "${current.main!.temp.toString()} °C")
                                        ])),
                                        Expanded(
                                            child: Row(children: [
                                          Icon(Icons.calendar_month),
                                          Text(current.weather![0].description
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
                                                                      () {},
                                                                ))),
                                                      ]))))),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              child: Container(
                                                  child: IconButton(
                                                icon: Icon(Icons.gps_fixed),
                                                onPressed: () {
                                                  Config.displayDialog(context);
                                                },
                                              ))))
                                    ],
                                  ))))),
                      SliverToBoxAdapter(
                          child: Visibility(
                              visible: (1 > 0) ? true : false,
                              child: SizedBox(
                                  height: 200,
                                  child: Container(
                                      child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return daystile(
                                        day: forecast.list[index].dt,
                                        id: forecast.list[index].main.temp
                                            .toString(),
                                        weather: forecast
                                            .list[index].weather[0].description
                                            .toString(),
                                        max: forecast.list[index].main.tempMax
                                            .toString(),
                                        min: forecast.list[index].main.tempMin
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
