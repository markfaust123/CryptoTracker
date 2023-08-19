import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedFiat = 'AUD';
  String selectedCoin = 'BTC';
  dynamic selectedCoinPrice = '?';

  @override
  void initState() {
    super.initState();
    getCoinPriceData();
  }

  void getCoinPriceData() async {
    var coinData = await CoinData().getCoinData(selectedCoin, selectedFiat);
    setState(() {
      selectedCoinPrice = coinData['rate'].toStringAsFixed(0);
      selectedFiat = coinData['asset_id_quote'];
      selectedCoin = coinData['asset_id_base'];
    });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerList = [];
    for (String currency in currenciesList) {
      pickerList.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(
          () {
            selectedFiat = currenciesList[selectedIndex];
            getCoinPriceData();
          },
        );
      },
      children: pickerList,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> itemList = [];
    for (String currency in currenciesList) {
      itemList.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedFiat,
      items: itemList,
      onChanged: (value) {
        setState(
          () {
            selectedFiat = value!;
            getCoinPriceData();
          },
        );
      },
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    // getCoinPriceData('BTC', selectedFiat);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $selectedCoin = $selectedCoinPrice $selectedFiat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
