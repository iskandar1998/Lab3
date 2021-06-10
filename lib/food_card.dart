import 'package:flutter/material.dart';
import 'package:lab2/foods/food.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  FoodCard({this.food});

  BuildContext get context => null;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => {},
      child: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://slumberjer.com/" + food.pictureUrl,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              food.foodName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('RM ${food.price.toString()}'),
            Text(
              'qty: ${food.quantity.toString()}',
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

//   _deleteFood() {
//     print(food.FoodName);
//     Provider.of<FoodProvider>(context, listen: false)
//         .deleteFood(food.foodId);
//   }
}
