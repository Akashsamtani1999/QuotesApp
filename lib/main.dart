import 'package:flutter/material.dart';
import 'package:quotes/Views/home_screen.dart';

void main() {
  runApp(const MyApp());
}
var favouriteIds = [];
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:HomeScreen(),
    );
  }
}