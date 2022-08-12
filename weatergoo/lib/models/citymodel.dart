import 'dart:convert';

import 'package:weatergoo/config/config.dart';

import 'dart:io';
import 'dart:convert';
// To parse this JSON data, do
//
//     final citymodel = citymodelFromJson(jsonString);

import 'dart:convert';

List<Citymodel> citymodelFromJson(String str) =>
    List<Citymodel>.from(json.decode(str).map((x) => Citymodel.fromJson(x)));

class Citymodel {
  Citymodel({
    required this.plaka,
    required this.ilAdi,
    required this.lat,
    required this.lon,
    required this.northeastLat,
    required this.northeastLon,
    required this.southwestLat,
    required this.southwestLon,
  });

  final int plaka;
  final String ilAdi;
  final double lat;
  final double lon;
  final double northeastLat;
  final double northeastLon;
  final double southwestLat;
  final double southwestLon;

  factory Citymodel.fromJson(Map<String, dynamic> json) => Citymodel(
        plaka: json["plaka"],
        ilAdi: json["il_adi"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        northeastLat: json["northeast_lat"].toDouble(),
        northeastLon: json["northeast_lon"].toDouble(),
        southwestLat: json["southwest_lat"].toDouble(),
        southwestLon: json["southwest_lon"].toDouble(),
      );
}
