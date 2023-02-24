import 'package:flutter/material.dart';

import 'models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  // SharedPreferences section//
  Result _location = Result.fromJson(jsonDecode(
      '{"country": "Egypt", "name": "Cairo", "longitude" : 31.24967 , "latitude" : 30.06263}'));

  Result get location => _location;

  HomeProvider() {
    loadChange();
  }

  changeLocation(Result location) {
    _location = location;
    _future =
        requestWeatherDetails(lon: location.longitude, lat: location.latitude);
    saveChange();
    notifyListeners();
  }

  saveChange() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('location', jsonEncode(_location));
    notifyListeners();
  }

  loadChange() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var location = pref.getString('location') ??
        '{"country": "Egypt", "name": "Cairo", "longitude" : 31.24967 , "latitude" : 30.06263}';
    _location = Result.fromJson(jsonDecode(location));
    notifyListeners();
  }
  //End of SharedPreferences section//

  // API Section //
  late Future<ApiHit?> _future = requestWeatherDetails();
  Future<ApiHit?> get future => _future;

  Future<ApiHit?> requestWeatherDetails({double? lon, double? lat}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var location = pref.getString('location') ??
        '{"country": "Egypt", "name": "Cairo", "longitude" : 31.24967 , "latitude" : 30.06263}';
    var locationObject = Result.fromJson(jsonDecode(location));

    var longitide = lon ?? locationObject.longitude;
    var latitude = lat ?? locationObject.latitude;

    var client = http.Client();
    var uri = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitide&daily=apparent_temperature_max,apparent_temperature_min,weathercode&timezone=auto&hourly=apparent_temperature,weathercode");
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = response.body;
        return apiHitFromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  // End of API Section //

  void reload() {
    _future = requestWeatherDetails();
    notifyListeners();
  }
}
