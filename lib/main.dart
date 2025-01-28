
import 'package:flutter/material.dart';

import 'login_page.dart';

void main() => runApp(MyApp());
//This is main class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      theme: ThemeData(
        //changed color from blue to yellow
        primarySwatch: Colors.yellow,
      ),
      home: LoginPage(),
    );
  }
}