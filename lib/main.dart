
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'daily_adjusted_model.dart'; // Import the model

void main() {
  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apikey = "KVGTWNS5U9H7E4YC";
  late Future<List<DailyAdjusted>> _futureStockData;
  final TextEditingController _controller = TextEditingController();
  String symbol = "AAPL";  // Default stock symbol

  @override
  void initState() { // function excuted one time when widget is build
    super.initState(); //for parent
    _futureStockData = getHttpRequest(symbol);
  }

  Future<List<DailyAdjusted>> getHttpRequest(String symbol) async {
    String url =
        "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$apikey";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final timeSeries = data['Time Series (Daily)'] as Map<String, dynamic>;

      return timeSeries.entries.map((entry) {
        return DailyAdjusted.fromJson(entry.key, entry.value);
      }).toList();
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  void _searchStock() {
    setState(() {
      String inputSymbol = _controller.text.trim();
      if (inputSymbol.isNotEmpty) {
        symbol = inputSymbol; // Update the symbol with user input
        _futureStockData = getHttpRequest(symbol); // Fetch new stock data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a stock symbol.')),
        );
      }
    });
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter Stock Symbol',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchStock,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<DailyAdjusted>>(
                future: _futureStockData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {  // if Api taking time to fetch data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
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
              "Stock: $symbol",
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