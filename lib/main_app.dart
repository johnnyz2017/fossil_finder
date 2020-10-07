import 'package:flutter/material.dart';
import 'package:fossils_finder/pages/home/home_page.dart';
import 'package:fossils_finder/pages/login/login_page.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return 
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text("Fossil Finder"),
    //   ),
    //   body: LoginScreen(),
    // );
    return MaterialApp(
      title: "Fossil Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.blue),
      home: LoginScreen(),
    );
  }
}