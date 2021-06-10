import 'package:flutter/material.dart';
import 'package:lab2/mainscreen.dart';

import 'newfood.dart';
// import 'package:lab2/newfood.dart';

// import 'package:lab2/splashscreen.dart';
// import 'splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FoodGood',
        // home: SplashScreen(),
        home: NewFood());
  }
}
