import 'package:flutter/material.dart';
import '../service/service_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = "USD";
  String _toCurrency = "EUR";
  String _result = "";

  final ApiService _apiService = ApiService();

  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _result = "⚠️ Montant invalide";
      });
      return;
    }

    final rate = await _apiService.getExchangeRate(_fromCurrency, _toCurrency);
    if (rate != null) {
      final converted = amount * rate;
      setState(() {
        _result = "$amount $_fromCurrency = ${converted.toStringAsFixed(2)} $_toCurrency";
      });
    } else {
      setState(() {
        _result = "⚠️ Impossible de récupérer le taux";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Currency Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Montant"),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _fromCurrency,
              items: ["USD", "EUR", "MAD", "GBP"]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _fromCurrency = value!),
            ),
            DropdownButton<String>(
              value: _toCurrency,
              items: ["USD", "EUR", "MAD", "GBP"]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _toCurrency = value!),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text("Convertir"),
            ),
            const SizedBox(height: 16),
            Text(_result, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
