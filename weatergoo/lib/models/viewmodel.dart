import 'package:weatergoo/models/apimodel.dart';

class OpenWeatherView {
  OpenWeatherView(OpenWeather openWeather) {
    temperature = openWeather?.main?.temp;
    celcius = '${openWeather?.main?.temp}°C';
    farenheit =
        '${((openWeather?.main?.temp ?? 0) * 9 / 5 + 32).toStringAsPrecision(4)}°F';
  }

  double? temperature;
  String? celcius;
  String? farenheit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenWeatherView &&
          runtimeType == other.runtimeType &&
          temperature == other.temperature;

  @override
  int get hashCode => temperature.hashCode;
}
