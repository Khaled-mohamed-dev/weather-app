import 'dart:convert';

ApiHit apiHitFromJson(String str) => ApiHit.fromJson(json.decode(str));

String apiHitToJson(ApiHit data) => json.encode(data.toJson());

class ApiHit {
  ApiHit({
    this.latitude,
    this.longitude,
    this.hourly,
    this.daily,
  });

  double? latitude;
  double? longitude;
  Hourly? hourly;
  Daily? daily;

  factory ApiHit.fromJson(Map<String, dynamic> json) => ApiHit(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
        daily: json["daily"] == null ? null : Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "hourly": hourly == null ? null : hourly!.toJson(),
        "daily": daily == null ? null : daily!.toJson(),
      };
}

class Daily {
  // this has the weather data for seven days
  Daily({
    this.time,
    this.apparentTemperatureMax,
    this.apparentTemperatureMin,
    this.weathercode,
  });

  List<DateTime>? time;
  List<double>? apparentTemperatureMax;
  List<double>? apparentTemperatureMin;
  List<int>? weathercode;

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        time: json["time"] == null
            ? null
            : List<DateTime>.from(json["time"].map((x) => DateTime.parse(x))),
        apparentTemperatureMax: json["apparent_temperature_max"] == null
            ? null
            : List<double>.from(
                json["apparent_temperature_max"].map((x) => x.toDouble())),
        apparentTemperatureMin: json["apparent_temperature_min"] == null
            ? null
            : List<double>.from(
                json["apparent_temperature_min"].map((x) => x.toDouble())),
        weathercode: json["weathercode"] == null
            ? null
            : List<int>.from(json["weathercode"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null
            ? null
            : List<dynamic>.from(time!.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "apparent_temperature_max": apparentTemperatureMax == null
            ? null
            : List<dynamic>.from(apparentTemperatureMax!.map((x) => x)),
        "apparent_temperature_min": apparentTemperatureMin == null
            ? null
            : List<dynamic>.from(apparentTemperatureMin!.map((x) => x)),
        "weathercode": weathercode == null
            ? null
            : List<dynamic>.from(weathercode!.map((x) => x)),
      };
}

class Hourly {
  Hourly({
    this.time,
    this.apparentTemperature,
    this.weathercode,
  });

  List<String>? time;
  List<double>? apparentTemperature;
  List<int>? weathercode;

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: json["time"] == null
            ? null
            : List<String>.from(json["time"].map((x) => x)),
        apparentTemperature: json["apparent_temperature"] == null
            ? null
            : List<double>.from(
                json["apparent_temperature"].map((x) => x.toDouble())),
        weathercode: json["weathercode"] == null
            ? null
            : List<int>.from(json["weathercode"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "time": time == null ? null : List<dynamic>.from(time!.map((x) => x)),
        "apparent_temperature": apparentTemperature == null
            ? null
            : List<dynamic>.from(apparentTemperature!.map((x) => x)),
        "weathercode": weathercode == null
            ? null
            : List<dynamic>.from(weathercode!.map((x) => x)),
      };
}

Countries countriesFromJson(String str) => Countries.fromJson(json.decode(str));

String countriesToJson(Countries data) => json.encode(data.toJson());

class Countries {
  Countries({
    this.results,
  });

  List<Result>? results;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.name,
    this.latitude,
    this.longitude,
    this.country,
  });

  String? name;
  double? latitude;
  double? longitude;
  String? country;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
      };
}
