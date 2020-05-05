import 'networking.dart';

class ExchangeModel{

  Future<dynamic> getExchangeData(String assetID, String currency) async{
     String url = '/exchangerate/$assetID/$currency';
     var networkHelper = NetworkHelper(url);
     var exchangeData = await networkHelper.getData();
     return exchangeData;
  }

}