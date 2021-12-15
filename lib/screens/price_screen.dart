import 'package:bitcoin_ticker/components/coin_card.dart';
import 'package:bitcoin_ticker/services/coin_data.dart';
import 'package:bitcoin_ticker/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  final Map<String, String> cryptoMap = {};

  // Initialize the crypto map to store all the available cryptocurrencies to be displayed
  // Currently initialized once in initState
  void _initAvailableCryptoCurrencies() {
    cryptoList.forEach((element) {
      cryptoMap[element] = 'N/A';
    });
  }

  // Refresh the crypto map with latest market price
  void _refreshAllCurrencyRates() {
    // Should not depend on cryptoList if possible, use the initialized crypto map instead for displayed crypto values
    cryptoList.forEach((element) {
      _refreshCurrentRate(element);
    });
  }

  // Refresh a single entry inside crypto map. Function is invoked for every available cryptocurrencies being displayed
  Future<void> _refreshCurrentRate(String cryptoCurrency) async {
    CoinData coinData =
        CoinData(currency: selectedCurrency, crypto: cryptoCurrency);
    Map<String, dynamic> currentCoinData = await coinData.getCurrentRate();
    setState(() {
      double rateInDouble = currentCoinData['rate'];
      cryptoMap[cryptoCurrency] = rateInDouble.toStringAsFixed(0);
    });
  }

  Widget getSelectorByPlatform() {
    return Platform.isIOS ? getIOSPicker() : getAndroidDropdown();
  }

  DropdownButton getAndroidDropdown() {
    return DropdownButton(
      value: selectedCurrency,
      onChanged: (newValue) {
        setState(() {
          selectedCurrency = newValue!;
          _refreshAllCurrencyRates();
        });
      },
      items: List.generate(
        currenciesList.length,
        (index) => DropdownMenuItem(
          child: Text(currenciesList[index]),
          value: currenciesList[index],
        ),
      ),
    );
  }

  CupertinoPicker getIOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (int newIndex) {
        setState(() {
          selectedCurrency = currenciesList[newIndex];
          _refreshAllCurrencyRates();
        });
        print(selectedCurrency);
      },
      children: List.generate(
        currenciesList.length,
        (index) => Text(
          currenciesList[index],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initAvailableCryptoCurrencies();
    _refreshAllCurrencyRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                cryptoList.length,
                (int index) => CoinCard(
                  currencyRate: cryptoMap[cryptoList[index]],
                  selectedCurrency: selectedCurrency,
                  selectedCrypto: cryptoList[index],
                ),
              )),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getSelectorByPlatform(),
          ),
        ],
      ),
    );
  }
}

// TODO: Revamp the UI using Dribbble as source of inspiration
// TODO: Implement error handling by HTTP codes
