import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/api/repository/weather_repository.dart';

import '../../model/weather_model.dart';

final weatherControllerProvider = NotifierProvider<WeatherController, bool>(
  () {
    return WeatherController();
  },
);

final fetchDataProvider = FutureProvider.family.autoDispose((ref, String city) {
  return ref
      .watch(weatherControllerProvider.notifier)
      .fetchWeatherDataByCity(city);
});

class WeatherController extends Notifier<bool> {
  WeatherRepository get _weatherReposiotry => ref.read(weatherDataProvider);

  Future<WeatherModel?> fetchWeatherDataByCity(String city) async {
    return _weatherReposiotry.fetchWeatherDataByCity(city);
  }

  @override
  build() {
    return false;
  }
}
