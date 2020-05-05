import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/exchange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  ExchangeModel exchangeModel = ExchangeModel();
  String currentCurrency = currenciesList[0];
  List<Widget> criptoCards = [];

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getExchanges();
  }

  void getExchanges() async{
    for(String cryptCurrency in cryptoList){
      var exchangeData = await exchangeModel.getExchangeData(cryptCurrency,currentCurrency);
      updateExchanges(exchangeData);
    }

  }

  void updateExchanges(dynamic exchangedata){
    setState(() {
      print('Exchange data $exchangedata');
      double rate = exchangedata['rate'];
      criptoCards.add(CryptoCard(crypto: exchangedata['asset_id_base'],currency: currentCurrency,currencyRate: rate.toStringAsFixed(2),));
    });
  }

  bool isLoading(){
   return criptoCards.length == 0;
  }

  List<DropdownMenuItem<String>> dropItems() {
    List<DropdownMenuItem<String>> dropItems = [];
    for (String currency in currenciesList) {
      dropItems.add(DropdownMenuItem(
        child: Text(currency,style: TextStyle(decorationColor: Colors.transparent),),
        value: currency,
      ));
    }
    return dropItems;
  }
  void updateCurrency(String newcurrency){
    setState(() {
      print('Updating currency $currentCurrency to $newcurrency');
      currentCurrency = newcurrency;
      getExchanges();
    });
  }
  List<Text> cuppertinoItems() {
    List<Text> cuppertinoItems = [];

    for (String currency in currenciesList) {
      cuppertinoItems.add(Text(currency,style: TextStyle(color: Colors.white),));
    }
    return cuppertinoItems;
  }

  Widget wichPicker() {
    if (Platform.isIOS) {
      return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          updateCurrency(currenciesList[selectedIndex]);
        }, children: cuppertinoItems(),
      );
    } else {
      return DropdownButton<String>(
          underline: SizedBox(),
          value: currentCurrency,
          items: dropItems(),
          onChanged: (value) {
            criptoCards.clear();
            updateCurrency(value);
          });
    }
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
          Visibility(
              visible: isLoading(),
              child: SpinKitPouringHourglass(size: 100,color: Colors.lightBlue,)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: criptoCards,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: wichPicker(),
          ),
        ],
      ),
    );
  }

  }

  class CryptoCard extends StatelessWidget {
  final String crypto,currency,currencyRate;

  CryptoCard({this.crypto, this.currency,this.currencyRate});

  @override
    Widget build(BuildContext context) {
      return Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $currencyRate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }




