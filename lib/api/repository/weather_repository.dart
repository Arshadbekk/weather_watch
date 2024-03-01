import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/api/api_page.dart';
import 'package:weather/model/weather_model.dart';
import 'package:http/http.dart' as http;

WeatherModel? weatherData;
final weatherDataProvider = Provider((ref) {
  return WeatherRepository();
});

class WeatherRepository {
  WeatherModel? _weather;
  WeatherModel? get Weather => _weather;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  Future<WeatherModel?> fetchWeatherDataByCity(String city) async {
    _isLoading = true;
    _error = "";

    try {
      final apiUrl =
          "${ApiEndPoints().cityUrl}$city&appid=${ApiEndPoints().apiKey}${ApiEndPoints().unit}";

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        _weather = WeatherModel.fromJson(data);
      } else {
        _error = "Failed to load data";
        print("error $_error");
        return null;
      }
      return (_weather);
    } catch (e) {
      _error = "Failed to load data $e";
      print("error $_error");
      return null;
    }
  }
}
