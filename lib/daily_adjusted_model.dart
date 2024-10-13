class DailyAdjusted {
  final String date;
  final double open;
  final double high;
  final double low;
  final double close;

  DailyAdjusted({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory DailyAdjusted.fromJson(String date, Map<String, dynamic> json) {
    return DailyAdjusted(
      date: date,
      open: double.parse(json['1. open']),
      high: double.parse(json['2. high']),
      low: double.parse(json['3. low']),
      close: double.parse(json['4. close']),
    );
  }
}