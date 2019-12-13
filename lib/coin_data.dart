import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> valores = {};

    for (int i = 0; i < (cryptoList.length); i++) {
      String crypto = cryptoList[i];
      http.Response response = await http.get(
          'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$selectedCurrency');

      if (response.statusCode == 200) {
        String data = response.body;
        double val = jsonDecode(data)['last'];
        int intValue = val.toInt();
        String value = intValue.toString();

        valores[crypto] = value;
      } else {
        print(response.statusCode);
        valores[crypto] = '?';
      }
    }
    print(valores);
    return valores;
  }

  Padding currencyWidget(
      {String crypto, String currency, String currencyValue}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $currencyValue $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
