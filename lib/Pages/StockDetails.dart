import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/Models/daily_adjusted_model.dart';
import 'package:stock_app/Pages/CompanyNews.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Stockdetails extends StatefulWidget {
  final String symbol;
  const Stockdetails({super.key, required this.symbol});

  @override
  State<Stockdetails> createState() => _StockdetailsState();
}

class _StockdetailsState extends State<Stockdetails> {
  late Future<List<DailyAdjusted>> _futureStockData;

  @override
  void initState() {
    super.initState();
    _futureStockData = getHttpRequest(widget.symbol);
  }

  Future<List<DailyAdjusted>> getHttpRequest(String symbol) async {
    String url =
        "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=${dotenv.env['stockkey']}";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final timeSeries = data['Time Series (Daily)'] as Map<String, dynamic>;

      return timeSeries.entries.map((entry) {
        DailyAdjusted l = DailyAdjusted.fromJson(entry.key, entry.value);
        return l;
      }).toList();
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 50, 90, 1),
        title: const Text(
          'Stock Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(30, 40, 80, 1),
              Color.fromRGBO(70, 100, 160, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<DailyAdjusted>>(
                  future: _futureStockData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Center(child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 50,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error occurred', style: TextStyle(color: Colors.red)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No stock data available.', style: TextStyle(color: Colors.white)));
                    } else {
                      final stocks = snapshot.data!;
                      return Column(
                        children: [
                          _buildStockOverviewCard(stocks.first),
                          const SizedBox(height: 10),
                          _buildStockList(stocks),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockOverviewCard(DailyAdjusted stock) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stock: ${widget.symbol}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(40, 50, 90, 1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Date: ${stock.date}",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 7),
            Text(
              "Open: \$${stock.open.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              "Close: \$${stock.close.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              "High: \$${stock.high.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            Text(
              "Low: \$${stock.low.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(50, 70, 110, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => News(
                      date: stock.date,
                    ),
                  ),
                );
              },
              child: const Text('Current News', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockList(List<DailyAdjusted> stocks) {
    return Expanded(
      child: ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white.withOpacity(0.9),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              title: Text(
                stock.date,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(40, 50, 90, 1)),
              ),
              subtitle: Text(
                'Open: \$${stock.open.toStringAsFixed(2)}, Close: \$${stock.close.toStringAsFixed(2)}',
                style: const TextStyle(color: Color.fromRGBO(30, 40, 80, 1),),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('High: \$${stock.high.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                  Text('Low: \$${stock.low.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
