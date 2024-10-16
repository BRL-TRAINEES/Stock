
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_app/Models/daily_adjusted_model.dart';
import 'package:stock_app/Pages/CompanyNews.dart';

class Stockdetails extends StatefulWidget {
  final String symbol;
  const Stockdetails({super.key , required this.symbol});

  @override
  State<Stockdetails> createState() => _HomePageState();
}

class _HomePageState extends State<Stockdetails> {

  late Future<List<DailyAdjusted>> _futureStockData;


  @override
  void initState() { // function excuted one time when widget is build
    super.initState(); //for parent
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
        DailyAdjusted l=DailyAdjusted.fromJson(entry.key, entry.value);
        return l;
      }).toList();
      // DailyAdjusted l=


    } else {
      throw Exception('Failed to load stock data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<DailyAdjusted>>(
                future: _futureStockData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {  // if Api taking time to fetch data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error occured'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No stock data available.'));
                  } else {
                    final stocks = snapshot.data!;
                    return Column(
                      children: [
                        _buildStockOverviewCard(stocks.first),
                        const SizedBox(height: 20),
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
    );
  }

  Widget _buildStockOverviewCard(DailyAdjusted stock) {
    return Card(
      elevation: 20, // shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 40,right: 40,top: 20,bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stock: ${widget.symbol}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Date: ${stock.date}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Open: \$${stock.open.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Close: \$${stock.close.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "High: \$${stock.high.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Low: \$${stock.low.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => News(
                        date: stock.date,
                      ),
                    ),
                  );
                },
                child: Text('current News'))
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
            child: ListTile(
              title: Text(stock.date),
              subtitle: Text('Open: \$${stock.open.toStringAsFixed(2)},' // upto 2 digits after decimal
                  'Close: \$${stock.close.toStringAsFixed(2)}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('High: \$${stock.high.toStringAsFixed(2)}'),
                  Text('Low: \$${stock.low.toStringAsFixed(2)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//sliver , sliverlist , sliverappbar