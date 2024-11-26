import 'package:flutter/material.dart';
import 'sessions/login_screen.dart'; 
import 'util/admin.dart';
import 'sessions/choice_screen.dart'; 
import 'util/db.dart';
import 'mapapi/mapa.dart';
import 'juego/kids_quiz.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PennyPal',
      theme: ThemeData(
        primarySwatch: Colors.red, 
      ),
      home: LoginScreenView(),
      // home: AdminView(),
    );
  }
}
