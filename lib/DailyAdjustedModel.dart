
import 'dart:convert';

DailyAdjusted dailyAdjustedFromMap(String str) => DailyAdjusted.fromMap(json.decode(str));

String dailyAdjustedToMap(DailyAdjusted data) => json.encode(data.toMap());

class DailyAdjusted {
  MetaData metaData;
  Map<String, TimeSeriesDaily> timeSeriesDaily;

  DailyAdjusted({
    required this.metaData,
    required this.timeSeriesDaily,
  });

  factory DailyAdjusted.fromMap(Map<String, dynamic> json) => DailyAdjusted(
    metaData: MetaData.fromMap(json["Meta Data"]),
    timeSeriesDaily: Map.from(json["Time Series (Daily)"]).map((k, v) => MapEntry<String, TimeSeriesDaily>(k, TimeSeriesDaily.fromMap(v))),
  );

  Map<String, dynamic> toMap() => {
    "Meta Data": metaData.toMap(),
    "Time Series (Daily)": Map.from(timeSeriesDaily).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
  };
}

class MetaData {
  String the1Information;
  String the2Symbol;
  DateTime the3LastRefreshed;
  String the4OutputSize;
  String the5TimeZone;

  MetaData({
    required this.the1Information,
    required this.the2Symbol,
    required this.the3LastRefreshed,
    required this.the4OutputSize,
    required this.the5TimeZone,
  });

  factory MetaData.fromMap(Map<String, dynamic> json) => MetaData(
    the1Information: json["1. Information"],
    the2Symbol: json["2. Symbol"],
    the3LastRefreshed: DateTime.parse(json["3. Last Refreshed"]),
    the4OutputSize: json["4. Output Size"],
    the5TimeZone: json["5. Time Zone"],
  );

  Map<String, dynamic> toMap() => {
    "1. Information": the1Information,
    "2. Symbol": the2Symbol,
    "3. Last Refreshed": "${the3LastRefreshed.year.toString().padLeft(4, '0')}-${the3LastRefreshed.month.toString().padLeft(2, '0')}-${the3LastRefreshed.day.toString().padLeft(2, '0')}",
    "4. Output Size": the4OutputSize,
    "5. Time Zone": the5TimeZone,
  };
}

class TimeSeriesDaily {
  String the1Open;
  String the2High;
  String the3Low;
  String the4Close;
  String the5Volume;

  TimeSeriesDaily({
    required this.the1Open,
    required this.the2High,
    required this.the3Low,
    required this.the4Close,
    required this.the5Volume,
  });

  factory TimeSeriesDaily.fromMap(Map<String, dynamic> json) => TimeSeriesDaily(
    the1Open: json["1. open"],
    the2High: json["2. high"],
    the3Low: json["3. low"],
    the4Close: json["4. close"],
    the5Volume: json["5. volume"],
  );

  Map<String, dynamic> toMap() => {
    "1. open": the1Open,
    "2. high": the2High,
    "3. low": the3Low,
    "4. close": the4Close,
    "5. volume": the5Volume,
  };
}
