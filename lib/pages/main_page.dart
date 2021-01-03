import 'package:flutter/material.dart';
import 'package:fossils_finder/pages/login/login_page.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Fossil Finder',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.indigo, 
      //   accentColor: Colors.blue
      // ),
      home: LoginScreen(),
    );
  }

}