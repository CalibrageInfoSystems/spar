import 'dart:convert';
import 'dart:core';

import 'package:alsadhan/localdb/LocalDb.dart';

import 'PlaceOrdermodelLocalModel.dart';

class CartItemHelper {
  void additemtocart(
      LocalData localData, List<PlaceOrdermodelLocalModel> productslist) {
  getproductfromCart(localData);

      localData.addStringToSF(
        LocalData.CARTINFO, placeOrdermodelToJson(productslist));
  }

  List<PlaceOrdermodelLocalModel> getproductfromCart(LocalData localData) {
    List<PlaceOrdermodelLocalModel> items =
        new List<PlaceOrdermodelLocalModel>();
    localData.getStringValueSF(LocalData.CARTINFO).then((cartdata) {
      if (cartdata.isEmpty) {
      } else {
        items = placeOrdermodelFromJson(cartdata);
      }
    });

    return items;
  }

  List<PlaceOrdermodelLocalModel> placeOrdermodelFromJson(String str) =>
      List<PlaceOrdermodelLocalModel>.from(
          json.decode(str).map((x) => PlaceOrdermodelLocalModel.fromJson(x)));

  String placeOrdermodelToJson(List<PlaceOrdermodelLocalModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
