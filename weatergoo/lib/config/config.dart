import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatergoo/config/response.dart';
import 'package:weatergoo/models/apimodel.dart';
import 'package:weatergoo/models/apimodel2.dart';
import 'package:weatergoo/models/citymodel.dart';
import 'package:weatergoo/page/ilget.dart';

class getconfig extends GetxController {
  static final active = false.obs;
  final konumdegisti = false.obs;
  Position _currentPosition = Position(
      latitude: 0,
      longitude: 0,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      timestamp: DateTime.now(),
      speedAccuracy: 0);
  String _currentAddress = "";
  static String sehir = "Konya";

//internetkontrol();

  konumla() {
    konumdegisti(!konumdegisti.value);
  }

  test() {
    active(!active.value);
  }
}

class Config extends ChangeNotifier {
  static String url = "https://api.openweathermap.org/data/2.5/weather?";
  static final apiKey = "b679fb2adbbc2e862ac532f640945493";

  static var weatherData;

  static Future<OpenWeatherForecast?> fetchWeatherFromCityforecast(
      String city) async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&APPID=$apiKey"),
        headers: {"Accept": "application/json"},
      );

      print("forecast isteği");

      print(response.body);

      if (response.statusCode == 200) {
        // Map<String, dynamic> weatherJson2 = json.decode(response.body);
        var weather2 = OpenWeatherForecast.fromRawJson(response.body);
        return weather2;
      } else {
        throw ValidateResponse.generateException(response);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<OpenWeather?> fetchWeatherFromCitynow(String city) async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&APPID=$apiKey"),
        headers: {"Accept": "application/json"},
      );

      print("api isteği");

      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> weatherJson = json.decode(response.body);
        var weather = OpenWeather.fromJson(weatherJson);
        return weather;
      } else {
        throw ValidateResponse.generateException(response);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static getapibylocation(lat, lon) async {
    try {
      await http.get(Uri.parse(url + "lat=$lat&lon=$lon&appid=$apiKey")).then(
            (res) => weatherData = jsonDecode(res.body),
          );
      if (weatherData['cod'] == 200) {
        print(weatherData['weather'][0]['main']); //weather[0].main
      }
    } catch (e) {
      print(e);
    }
  }

  static List<Citymodel> illiste = [];
  static bool konumsecildi = false;

  static Future<bool> checkInternet() async {
    try {
      print("internet kontrol ediliyor");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected internet');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected internet');

      return false;
    }
    print("internet kontrol edildi başarısız");
    return false;
  }

  static var c = Get.put(getconfig());

  static String konum = "";

  static int selectedIndex = 0;

  static String? il = "İl Seçin";

  static Future readJson() async {
    final String response = await rootBundle.loadString('assets/city.json');
    final data = await citymodelFromJson(response);
    print(data.length);
    Config.illiste = data;
    print(data[1].ilAdi);
    print("şehirler jsondan çekildi");

    // ...
  }

  static displayDialog(BuildContext context) async {
    _getAddressFromLatLng() async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            c._currentPosition.latitude, c._currentPosition.longitude);

        Placemark place = placemarks[0];
        print(c._currentAddress);
        getconfig.sehir = "${place.administrativeArea}";
        print("konuöda bulununan şehir : ${getconfig.sehir}");

        c.konumla();
      } catch (e) {
        print("hata var latling");
        print(e);
      }
    }

    _getCurrentLocation() async {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              forceAndroidLocationManager: true)
          .then((Position position) {
        //setState(() {
        c._currentPosition = position;
        //print(" pozsiyon ${c._currentPosition}");
        _getAddressFromLatLng();
        c.konumla();
        // });
      }).catchError((e) {
        print("hata var get location");
        print(e);
      });
    }

    LocationPermission permission2 = await Geolocator.checkPermission();
    print(permission2.toString());
    print("izin");
    LocationPermission permission = await Geolocator.requestPermission();
    print("konum");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konum Seçin"),
          content: SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextButton(
                        onPressed: () async {
                          var sonuc = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Ilgetir(),
                            ),
                          );
                          Config.il =
                              (sonuc != null) ? sonuc["title"] : Config.il;

                          Navigator.pop(context, true);
                          displayDialog(context);
                        },
                        child: Obx(() => Column(children: [
                              Text(Config.il!),
                              Text(c.konumdegisti.value.toString(),
                                  style: TextStyle(fontSize: 0))
                            ])))),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple)),
                      child: Text(
                        "Konum",
                        style: TextStyle(color: Colors.white),
                      ),
                      //future delayed alert diolog with a timer
                      onPressed: () {
                        Config.il = "bekleyiniz";

                        _getCurrentLocation();
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
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.pop(context);
                        });

                        c.konumla();
                        getconfig.sehir = getconfig.sehir.toUpperCase();
                        print("konuımdan bulununan şehir ${getconfig.sehir}");

                        c.konumla();
                        Config.il = getconfig.sehir;

                        c.konumla();

                        Config.konumsecildi = true;
                        c.konumla();
                        c.test();
                        //   Navigator.pop(context);
                      },
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Config.konumsecildi = true;
                          c.test();
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        child: const Text(
                          "Git",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
/*   
                                      */
