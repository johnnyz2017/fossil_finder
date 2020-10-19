import 'package:flutter/material.dart';
import 'package:fossils_finder/main_app.dart';
import 'package:fossils_finder/pages/home/home_page.dart';
import 'package:fossils_finder/pages/index_page.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

void MapInit() async{
  localStorage = await SharedPreferences.getInstance();
  String _token = localStorage.get('token');
  print('token is ${_token}');

  await enableFluttifyLog(false);
  await AmapService.init(
    iosKey: '442bcb9df9178d4e0e1d30370c485907',
    androidKey: 'cf2c5badb6669ff95b26030d9e77f490',
  );
}

void main() => runApp(new MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }
return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        home: new Material(
            child: new Container (
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                    child: new Column(
                     children : [
                       new Padding(padding: EdgeInsets.only(top: 140.0)),
                       new Text('Beautiful Flutter TextBox',
                       style: new TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0),),
                       new Padding(padding: EdgeInsets.only(top: 50.0)),
                       new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Enter Email",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Email cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                     ]
                    )
                 ),
)
            )
        )
    );
}
}

// void main(){
  
  
//   runApp(
//     FossilApp()
//     // MainApp()
//     // MaterialApp(
//     //   home: MainApp(),
//     //   // home: IndexPage(),
//     // )
//   );

//   MapInit();
  
// }

class FossilApp extends StatefulWidget {

  @override
  _FossilAppState createState() => _FossilAppState();
}

class _FossilAppState extends State<FossilApp> {

  bool isLoggedIn = false;

  init() async{
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');
    print('token is ${_token}');
    if(_token != null && !(_token.isEmpty)){
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fossil Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.blue),
      home: isLoggedIn ? IndexPage() : LoginScreen(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fossil Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.blue),
      home: LoginScreen(),
    );
  }
}