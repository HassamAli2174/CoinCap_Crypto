import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;
  const DetailsPage({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange Rates'),
        backgroundColor:
            const Color.fromRGBO(70, 40, 150, 1), // More vibrant color
        elevation: 0, // Removes the shadow for a flat design
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(123, 67, 151, 1),
              Color.fromRGBO(70, 40, 150, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (_context, index) {
              String _currency = _currencies[index].toString().toUpperCase();
              String _exchange = _exchangeRates[index].toStringAsFixed(2);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: const Color.fromRGBO(70, 40, 150, 0.8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.monetization_on, color: Colors.white),
                  ),
                  title: Text(
                    _currency,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    "\$$_exchange",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
