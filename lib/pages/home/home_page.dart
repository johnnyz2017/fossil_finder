import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fossils_finder/map/map_demo.dart';
import 'package:fossils_finder/pages/form/post_upload.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:fossils_finder/pages/map/map_list.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';


final _assetsIcon = Uri.parse('images/icons/fossil_icon_512.png');

SharedPreferences localStorage;

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AmapController _controller;
  bool _locationStatus = false;

  init() async{
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');
    print('token is ${_token}');
  }

  logout() async{
    if(localStorage == null) localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }

  _checkPermission() async{
    // bool status = await Permission.storage.isGranted;
    // if(!status) {
    //   return await Permission.storage.request().isGranted;
    // }

    bool status = await Permission.locationAlways.isGranted;
    if(!status){
      print("need to get locationAlways permission first");
      status = await Permission.locationAlways.request().isGranted;
      if(status){
        setState(() {
          _locationStatus = true;
        });

        await _controller?.showMyLocation(MyLocationOption(
          myLocationType: MyLocationType.Locate,
        ));
      }
    }
  }

  @override
  void initState(){
    super.initState();
    // _checkPermission();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //   ),
    //   home: Scaffold(
    //     appBar: AppBar(title: const Text('Home Page')),
    //     body: MapListScreen(),
    //     bottomNavigationBar: BottomNavigationBar(
    //       items: <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.email),
    //           title: Text("Email")
    //           ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.home),
    //           title: Text("Home")
    //           ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.settings),
    //           title: Text("User")
    //           ),
    //       ] 
    //       ),
    //     // DecoratedColumn(
    //     //   children: <Widget>[
    //     //     Flexible(
    //     //       flex: 1,
    //     //       child: AmapView(
    //     //         mapType: MapType.Satellite,
    //     //         showZoomControl: false,
    //     //         maskDelay: Duration(milliseconds: 500),
    //     //         onMapCreated: (controller) async {
    //     //           _controller = controller;                                    
                  
    //     //           await _controller?.showMyLocation(MyLocationOption(
    //     //             myLocationType: MyLocationType.Locate,
    //     //           ));

    //     //           _controller?.setMapType(MapType.Standard);
    //     //         },
    //     //       ),
    //     //     ),
    //     //   ],
    //     // ),
    //   )
    // ); 
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('Home Page'),
        // extendBodyBehindAppBar: true,
        // backgroundColor: Colors.red,
        // toolbarOpacity: 0.1,
        // elevation: 0,
        // leading: CircleAvatar(child: Icon(Icons.search),),
        
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            Divider(),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Logout"),
                  onTap: (){
                    logout();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      // builder: (context) => HomePage(),
                      builder: (context) => LoginScreen(),
                    ));
                  },
                ),
                // child: RaisedButton(
                //   onPressed: () {
                //     //
                //     print("logout clicked");
                //   },
                //   child: Text("Logout"),
                // ),
              )
            )
          ],
        )
      ),
      body: Stack(
              children: <Widget>[
                  // Container(
                  //   decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //       begin: Alignment.centerLeft,
                  //       end: Alignment.bottomCenter,
                  //       colors: [Colors.red[900], Colors.blue[700]])),
                  //   height: MediaQuery.of(context).size.height * 0.3
                  // ),
                  AmapView(
                    mapType: MapType.Standard,
                    showZoomControl: false,
                    maskDelay: Duration(milliseconds: 500),
                    onMapCreated: (controller) async {
                      _controller = controller;

                      bool status = await Permission.locationAlways.isGranted;
                      if(!status){
                        print("need to get locationAlways permission first");
                        status = await Permission.locationAlways.request().isGranted;
                        if(status){
                          await _controller?.showMyLocation(MyLocationOption(
                            myLocationType: MyLocationType.Locate,
                          ));
                        }else{
                          print("need to grant the location permission first");
                        }
                      }else{
                        await _controller?.showMyLocation(MyLocationOption(
                          myLocationType: MyLocationType.Locate,
                        ));
                      }
                  },
                ),
                //AppBar move to here
                Positioned( 
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  // child: Container(
                  //   height: 100,
                  //   child: Row(
                      
                  //     children: <Widget>[
                  //       Container(
                  //         height: 100,
                  //         child: Text("Left"),
                  //         color: Colors.blue,
                  //       ),
                  //       RaisedButton(
                  //         onPressed: () {  },
                  //         child: Text("Test"),
                  //       ),
                  //       Text("Text Edit")
                  //     ],
                  //   ),
                  // ),
                  child: AppBar(        // Add AppBar here only
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text("Home Page"),
                    leading: CircleAvatar(child: Icon(Icons.search)),
                  ),
                ),
              ] 
              
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{
          print("floating action button clicked");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              // return PostDetailPage(post: post,);
              return PostUploadPage();
            }) 
          );

          // await _controller?.showMyLocation(MyLocationOption(
          //   myLocationType: MyLocationType.Locate,
          // ));

          // //获取当前经纬度
          // final latLng = await _controller?.getLocation(); //FAILED
          // toast('当前经纬度: ${latLng.toString()}');

          // _controller?.setMapType(MapType.Standard);  //OK
          //_controller?.setMapType(MapType.Satellite);

          //_controller?.setMapLanguage(Language.Chinese);
          // _controller?.setMapLanguage(Language.English); //OK

          //final center = await _controller?.getCenterCoordinate(); //NO
          //toast('center: lat: ${center.latitude}, lng: ${center.longitude}');


          //NO
          // final circle = await _controller?.addCircle(CircleOption(
          //   center: LatLng(121.74046,31.05408), //野生动物园附近
          //   radius: 100,
          //   width: 10,
          //   strokeColor: Colors.green,
          // ));
          // _circleList.add(circle);
        },
      ),
      // body: AmapView(
      //         mapType: MapType.Satellite,
      //         showZoomControl: false,
      //         maskDelay: Duration(milliseconds: 500),
      //         onMapCreated: (controller) async {
      //           _controller = controller;

      //           // await _controller?.showMyLocation(MyLocationOption(
      //           //   myLocationType: MyLocationType.Locate,
      //           // ));
      //         },
      //       ),
      // body: DecoratedColumn(
      //   children: <Widget>[
      //     Flexible(
      //       flex: 1,
      //       child: AmapView(
      //         mapType: MapType.Satellite,
      //         showZoomControl: false,
      //         maskDelay: Duration(milliseconds: 500),
      //         onMapCreated: (controller) async {
      //           _controller = controller;

      //           await _controller?.showMyLocation(MyLocationOption(
      //             myLocationType: MyLocationType.Locate,
      //           ));
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}