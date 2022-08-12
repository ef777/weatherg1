import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:weatergoo/comp/Input.dart';
import 'package:weatergoo/config/config.dart';

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
  Future<void> api() async {
    Config.weatherSaved = await Config.fetchWeatherFromCity(getconfig.sehir);
    Config.weatherFuture = Config.fetchWeatherFromCity(getconfig.sehir);
  }

  @override
  void initState() {
    api();

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
              api();
            },
            child: FutureBuilder(
                future: Future.wait([Config.weatherFuture]),
                builder: (context, AsyncSnapshot<List<dynamic>> snaphost) {
                  print("builder başladı");

                  if (snaphost.hasData) {
                    print("data geldi");

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
                                  height: 200,
                                  child: Container(
                                    child: Form(
                                        key: _formKey,
                                        child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Input(
                                              label: "City name",
                                              inputype:
                                                  TextInputType.emailAddress,
                                              borderColors: Colors.grey,
                                              textval: (text) => {email = text},
                                              errorText:
                                                  "Please enter a valid city name",
                                            ))),
                                  ))))
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
