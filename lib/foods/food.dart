import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Food {
  String foodName, pictureUrl, image64;
  double price;
  int quantity, foodId;

  Food({this.foodId, this.foodName, this.price, this.quantity});

  Food.fromJson(json) {
    foodId = json['foodtId'];
    foodName = json['foodName'];
    price = json['price'].toDouble();
    quantity = json['quantity'];
    pictureUrl = json['picture'];
  }
}

class FoodProvider with ChangeNotifier {
  List<Food> foodList = [];
  getFood() async {
    var url =
        Uri.parse('https://slumberjer.com/263592/foodgood/php/loadfood.php');
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      data = data['data']['foods'];
      print(data);
      foodList = data.map<Food>((item) => Food.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<bool> addFood(Food food, File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    var url =
        Uri.parse('https://slumberjer.com/263592/foodgood/php/newfood.php');
    var response = await http.post(url, body: {
      'foodName': food.foodName,
      'price': food.price.toString(),
      'quantity': food.quantity.toString(),
      'encoded_base64string': base64Image,
    });
    if (response.body == 'success') {
      getFood();
      return true;
    }
    return false;
  }
}
//   Future<bool> deleteFood(int foodtId) async {
//     var url = Uri.parse('https://slumberjer.com/263592/foodgood/php/deletefood.php');
//     var response = await http.post(url, body: {
//       'FoodID': foodId,
//     });
//     if (response.body == 'success') {
//       getFood();
//       return true;
//     }
//     return false;
//   }
// }
