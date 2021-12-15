import 'package:bitcoin_ticker/services/networking.dart';
import 'package:bitcoin_ticker/utilities/constants.dart';
import 'package:flutter/material.dart';

class CoinData {
  final String currency;
  final String crypto;

  CoinData({
    required this.currency,
    required this.crypto,
  });

  Future<Map<String, dynamic>> getCurrentRate() async {
    Map<String, dynamic>? fetchedData;
    try {
      fetchedData = await NetworkHelper(
        url: '$kCoinAPIURL/exchangerate/$crypto/$currency',
        headers: {
          'X-CoinAPI-Key': kCoinAPIKey,
        },
      ).getData();
    } catch (e) {}
    // Return error object if network fetch fails
    return fetchedData ??
        {
          'error':
              FlutterError('Unspecified, handle this better through dartz'),
          'rate': 0.0,
        };
  }
}
