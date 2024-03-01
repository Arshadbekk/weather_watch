import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/constants/image_constants.dart';
import 'package:weather/main.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

void getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  String placeName = placemarks[0].locality.toString();
  currentLocation = placeName;
}

// void getWeather() async {
//   var data = await http.get(Uri.tryParse(
//       "https://api.openweathermap.org/data/2.5/weather?q=${currentLocation}&appid=2f95eef8224acbbf823445855b62b07d")!);
//   print(data.body);
//   print(data.body);
//   var datas = json.decode(data.body);
//   print(datas[0]);
// }
List imageList = [
  ImageConstants.clearBackground,
  ImageConstants.drizzleBackground,
  ImageConstants.homeBackground,
  ImageConstants.thunderStormBackground
];
