import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/utilities/constants.dart';

class NetworkHelper {
  final String url;
  Map<String, String>? headers;

  NetworkHelper({
    required this.url,
    this.headers,
  });

  Future getData() async {
    http.Response response = await http.get(
      Uri.parse(
        url,
      ),
      headers: headers ?? {},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // TODO Handle connectivity error using dartz
      // This API tend to return 429 Too Many Request often
      print(response.statusCode);
    }
  }
}
