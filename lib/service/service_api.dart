import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<double?> getExchangeRate(String base, String target) async {
    try {
      final url = Uri.parse(
          'https://api.exchangerate.host/latest?base=$base&symbols=$target');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if the response was successful
        if (data['success'] == false) {
          print("Error: ${data['error']?['info'] ?? 'Unknown error'}");
          return null;
        }

        // Check that "rates" exists and contains the target currency
        final rates = data['rates'] as Map<String, dynamic>?;
        if (rates != null && rates.containsKey(target)) {
          final rate = rates[target];
          if (rate != null) {
            return (rate as num).toDouble();
          }
        }
        
        print("Currency $target not found in API response");
        return null;
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching exchange rate: $e");
      return null;
    }
  }
}
