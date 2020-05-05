import 'dart:convert';

import 'package:http/http.dart' as http;

const apiURl = 'https://rest.coinapi.io/v1';
const apiKey = '?apikey=2C25AFEA-5572-478D-822A-88C0FBF0E485';
class NetworkHelper{
  String url;

  NetworkHelper(this.url);

  Future<dynamic> getData() async{
    try {
      print('requesting -> $apiURl$url$apiKey');
      http.Response response = await http.get('$apiURl$url$apiKey');
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print(response.body);
        double rate = decodedData['rate'];
        print('rate return $rate');
        return jsonDecode(response.body);
      } else {
        print('Response error status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  }

