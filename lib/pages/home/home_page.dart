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

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search Example' );

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildBar(context),
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
                      builder: (context) => LoginScreen(),
                    ));
                  },
                ),
              )
            )
          ],
        )
      ),
      body: Stack(
              children: <Widget>[
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
              ] 
              
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async{
          print("floating action button clicked");

          // bool status = await Permission.locationAlways.isGranted;
          // if(!status){
          //   print("need to get locationAlways permission first");
          //   status = await Permission.locationAlways.request().isGranted;
          //   if(status){
          //     await _controller?.showMyLocation(MyLocationOption(
          //       myLocationType: MyLocationType.Locate,
          //     ));
          //   }else{
          //     print("need to grant the location permission first");
          //   }
          // }else{
          //   await _controller?.showMyLocation(MyLocationOption(
          //     myLocationType: MyLocationType.Locate,
          //   ));
          // }

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
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      // centerTitle: true,
      backgroundColor: Color(0xff885566),
      // title: new TextFormField(
      //   decoration: new InputDecoration(
      //     labelText: "Enter Email",
      //     fillColor: Colors.white,
      //     border: new OutlineInputBorder(
      //       borderRadius: new BorderRadius.circular(25.0),
      //       borderSide: new BorderSide(
      //       ),
      //     ),
      //     //fillColor: Colors.green
      //   ),
      //   validator: (val) {
      //     if(val.length==0) {
      //       return "Email cannot be empty";
      //     }else{
      //       return null;
      //     }
      //   },
      //   keyboardType: TextInputType.emailAddress,
      //   style: new TextStyle(
      //     fontFamily: "Poppins",
      //   ),
      // ),
      title: new TextFormField(
        controller: _filter,
        decoration: InputDecoration(
          // icon: Icon(Icons.search),
          
          fillColor: Colors.white,      
          border: new OutlineInputBorder(
            // borderRadius: new BorderRadius.circular(5.0),
            borderSide: new BorderSide(),
            gapPadding: 10.0
          )    
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            print('search icon clicked');
          },
        ),
        IconButton(
          icon: Icon(Icons.scanner),
          onPressed: (){
            print('scan icon clicked');
          },
        )
      ],
    );
    // return new AppBar(
    //   centerTitle: true,
    //   title: _appBarTitle,
    //   leading: new IconButton(
    //     icon: _searchIcon,
    //     onPressed: _searchPressed,
    //   ),
    // );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search Example' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}