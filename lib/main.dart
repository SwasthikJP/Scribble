import 'package:flutter/material.dart';
import 'package:scribble/home.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'scribble',
      home: Home(),

      debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
 