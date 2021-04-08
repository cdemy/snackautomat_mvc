import 'package:flutter/material.dart';
import 'package:snackautomat/gui/automat_screen.dart';

void main() {
  runApp(MyApp());
}

/// Main Widget of the App
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snackautomat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AutomatScreen(),
    );
  }
}
