import 'package:flutter/material.dart';
import 'package:texttospeachapp/home.dart';
import 'package:texttospeachapp/ml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Text To Speach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Imagetotext(),
      
    );
    
  }
}