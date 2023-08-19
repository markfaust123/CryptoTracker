import 'package:http/http.dart' as https;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String apiKey = '0BE6C1EA-EDB8-4733-AEB4-4F938CD6A807';
  String domain = 'rest.coinapi.io';

  Future getCoinData(String fiat) async {
    Map<String, String> cryptoPrices = {};

    for (String cryptoName in cryptoList) {
      String path = '/v1/exchangerate/$cryptoName/$fiat';
      var request = Uri.https(domain, path);

      https.Response response = await https.get(
        request,
        headers: {'X-CoinAPI-Key': apiKey},
      );

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        cryptoPrices[cryptoName] = decodedData['rate'].toStringAsFixed(0);
      } else {
        print(
            'ERROR: ' + response.statusCode.toString() + ' - ' + response.body);
      }
    }
    return cryptoPrices;
  }
}
