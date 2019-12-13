import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  CoinData coinData = CoinData();

  String btcValue = '?';
  String ethValue = '?';
  String ltcValue = '?';

  void getValue() async {
    Map<String, String> returnedValue =
        await coinData.getCoinData(selectedCurrency);
    setState(() {
      btcValue = returnedValue['BTC'];
      ethValue = returnedValue['ETH'];
      ltcValue = returnedValue['LTC'];
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency, //valor inicial
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getValue();
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0, //o height de cada item
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = pickerItems[selectedIndex].data;
          getValue();
        });
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          coinData.currencyWidget(
            crypto: 'BTC',
            currency: selectedCurrency,
            currencyValue: btcValue,
          ),
          coinData.currencyWidget(
            crypto: 'ETH',
            currency: selectedCurrency,
            currencyValue: ethValue,
          ),
          coinData.currencyWidget(
            crypto: 'LTC',
            currency: selectedCurrency,
            currencyValue: ltcValue,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
