import 'dart:convert';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:qrscan/qrscan.dart' as scanner;

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/form/post_upload.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:fossils_finder/utils/permission.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';


final _assetsIcon = Uri.parse('images/icons/fossil_icon_512.png');

final _assetsIcon1 = AssetImage('images/icons/marker.png');

SharedPreferences localStorage;

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = new List<Post>();

  bool _used = false;
  bool _show = true;

  Future loadPostListFromServer() async{
    var _content = await request(servicePath['posts']);
    // print('get _content ${_content}');
    if(_content.statusCode != 200){
      if(_content.statusCode == 401){
        print('#### unauthenticated, need back to login page ${_content.statusCode}');

        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('token');

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      }
      print('#### Network Connection Failed: ${_content.statusCode}');

      return;
    }
    var _jsonData = jsonDecode(_content.toString());
    // print('get json data is  ${_jsonData}');
    // if(_jsonData['message'] && _jsonData['message'] == "Unauthenticated."){
    //   print('#### unauthenticated, need back to login page ${_jsonData}');
    // }
    var _listJson;
    if(_jsonData['paginated']){
      _listJson = _jsonData['data']['data'];
    }
    else{
      _listJson = _jsonData['data'];
    }

    List _jsonList = _listJson as List;
    print('get list item 0 ${_jsonList[0]}');
    List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });

    await Future.forEach(posts, (post) async { 
      print('post ${post.id} ${post.author}');
      
      final marker1 = await _controller?.addMarker(
        MarkerOption(
          latLng: LatLng(
            post.latitude,
            post.longitude,
          ),
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('${post.title}'),
              // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
              ClipOval(
                child: post.images.length > 0 ? 
                    (post.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  post.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), height: 50,) : Image.asset(post.images[0].url, height: 50,))
                    : Image.asset('images/icons/marker.png', height: 50,)
                // child: Image.asset('images/icons/marker.png', height: 50,)
              )
            ],
          ),
          imageConfig: createLocalImageConfiguration(context),
          title: '${post.title}',
          snippet: '${post.content}',
          width: 100,
          height: 100,
          object: '${post.id}'
        ),
      );
      _markers.add(marker1);
    }); //foreach

    _controller?.setMarkerClickedListener((marker) async {
      String id = await marker.object;
      int pid = int.parse(id);
      print('marker clicked ${pid}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return PostDetailPage(pid: pid,);
        }) 
      );
      return true;
    });
  }
  
  AmapController _controller;
  List<Marker> _markers = [];
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
    // print('token is ${_token}');
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
    // loadPostListFromServer();
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
            Padding(padding: EdgeInsets.only(top: 50)),
            Column(children: <Widget>[
              Text("地图类型"),
              Row(
                children: <Widget>[
                  Expanded(child: Column(children: <Widget>[
                    IconButton(
                      iconSize: 50,
                      icon: ClipRect(child: Image.asset('images/icons/map-amap.png', width: 50,)),
                      focusColor: Colors.blue,
                      onPressed: (){
                        print('amap mode');
                        // _controller?.setMapType(MapType.Night);
                        // _controller?.setMapType(MapType.Standard);
                      },
                    ),
                    Text("高德视图")
                  ],),),
                  Expanded(child: Column(children: <Widget>[
                    IconButton(
                      iconSize: 50,
                      icon: ClipOval(child: Image.asset('images/icons/map-google.png', width: 50,),),
                      focusColor: Colors.blue,
                      onPressed: (){
                        print('google mode');
                        // _controller?.setMapType(MapType.Satellite);
                      },
                    ),
                    Text("谷歌视图")
                  ],))
                ],
              ),
              Divider(height: 50,),
              Text("视图类型"),
              Row(
                children: <Widget>[
                  Expanded(child: Column(children: <Widget>[
                    IconButton(
                      iconSize: 50,
                      icon: ClipRect(child: Image.asset('images/icons/map-icon-standard.png', width: 50,)),
                      focusColor: Colors.blue,
                      onPressed: (){
                        print('standard mode');
                        // _controller?.setMapType(MapType.Night);
                        _controller?.setMapType(MapType.Standard);
                      },
                    ),
                    Text("标准视图")
                  ],),),
                  Expanded(child: Column(children: <Widget>[
                    IconButton(
                      iconSize: 50,
                      icon: ClipRect(child: Image.asset('images/icons/map-icon-satillite.png', width: 50,)),
                      focusColor: Colors.blue,
                      onPressed: (){
                        print('satellite mode');
                        _controller?.setMapType(MapType.Satellite);
                      },
                    ),
                    Text("卫星视图")
                  ],))
                ],
              )
            ],),
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
                    zoomLevel: 10,
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

                      //
                      // _controller?.showZoomControl(true); //OK
                      // _controller?.showCompass(true); //NO
                      // _controller?.showLocateControl(true); //NO
                      _controller?.showScaleControl(true); //OK
                      //

                      // await Future.forEach(posts, (post) async { 
                      //   print('post ${post.id} ${post.author}');
                        
                      //   final marker1 = await _controller?.addMarker(
                      //     MarkerOption(
                      //       latLng: LatLng(
                      //         post.latitude,
                      //         post.longitude,
                      //       ),
                      //       widget: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: <Widget>[
                      //           Text('${post.title}'),
                      //           // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
                      //           ClipOval(
                      //             child: post.images.length > 0 ? 
                      //                 (post.images[0].url.startsWith('http') ? Image.network(post.images[0].url, height: 50,) : Image.asset(post.images[0].url, height: 50,))
                      //                 : Image.asset('images/icons/marker.png', height: 50,)
                      //           )
                      //         ],
                      //       ),
                      //       imageConfig: createLocalImageConfiguration(context),
                      //       title: '${post.title}',
                      //       snippet: '${post.content}',
                      //       width: 100,
                      //       height: 100,
                      //       object: '${post.id}'
                      //     ),
                      //   );
                      //   _markers.add(marker1);
                      // }); //foreach

                      // _controller?.setMarkerClickedListener((marker) async {
                      //   String id = await marker.object;
                      //   int pid = int.parse(id);
                      //   print('marker clicked ${pid}');
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (BuildContext context) {
                      //       return PostDetailPage(pid: pid,);
                      //     }) 
                      //   );
                      //   return true;
                      // });

                      // await Future.forEach(posts, (post) async { 
                      //   print('post ${post.id} ${post.author}');
                        
                      //   final marker1 = await _controller?.addMarker(
                      //     MarkerOption(
                      //       latLng: LatLng(
                      //         post.latitude,
                      //         post.longitude,
                      //       ),
                      //       widget: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: <Widget>[
                      //           Text('${post.title}'),
                      //           // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
                      //           ClipOval(
                      //             child: post.images.length > 0 ? 
                      //                 (post.images[0].url.startsWith('http') ? Image.network(post.images[0].url, height: 50,) : Image.asset(post.images[0].url, height: 50,))
                      //                 : Image.asset('images/icons/marker.png', height: 50,)
                      //           )
                      //         ],
                      //       ),
                      //       imageConfig: createLocalImageConfiguration(context),
                      //       title: '${post.title}',
                      //       snippet: '${post.content}',
                      //       width: 100,
                      //       height: 100,
                      //     ),
                      //   );
                      //   _markers.add(marker1);
                      // }); //foreach

                      loadPostListFromServer(); //load posts after amap init
                  },
                ),
              ] 
              
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: <Widget>[
//           Positioned(
//             bottom: 220.0,
//             right: 10.0,
//             child: FloatingActionButton(
//               heroTag: 'hide',
//               onPressed: () async{
//                 if(_markers.isNotEmpty){
//                   for(var marker in _markers){
//                     // marker.hideInfoWindow();
//                     marker.setVisible(false);
//                   }
//                 }

//                 // print('get posts size: ${posts.length}');
//                 posts.forEach((post) { 
//                   print('post ${post.id} ${post.author}');
//                 });
                
//                 if(_used) return;
//                 _used = true;

// //                 _controller?.addMarkers(
// //                   [
// //                     for (int i = 0; i < 100; i++)
// //                       MarkerOption(
// //                         latLng: getNextLatLng(),
// // //                            title: '北京$i',
// // //                            snippet: '描述$i',
// //                         iconProvider:
// //                             i % 2 == 0 ? _assetsIcon1 : _assetsIcon2,
// //                         imageConfig: createLocalImageConfiguration(context),
// //                         width: 40,
// //                         infoWindowEnabled: false,
// // //                            rotateAngle: 90,
// //                         height: 40,
// //                         object: 'Marker_$i',
// //                       ),
// //                   ],
// //                 )?.then(_markers.addAll);
                
//                   await Future.forEach(posts, (post) async { 
//                         print('post ${post.id} ${post.author}');
                        
//                         final marker1 = await _controller?.addMarker(
//                           MarkerOption(
//                             latLng: LatLng(
//                               post.latitude,
//                               post.longitude,
//                             ),
//                             widget: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 Text('${post.title}'),
//                                 // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
//                                 ClipOval(
//                                   child: post.images.length > 0 ? 
//                                       (post.images[0].url.startsWith('http') ? Image.network(post.images[0].url, height: 50,) : Image.asset(post.images[0].url, height: 50,))
//                                       : Image.asset('images/icons/marker.png', height: 50,)
//                                 )
//                               ],
//                             ),
//                             imageConfig: createLocalImageConfiguration(context),
//                             title: '${post.title}',
//                             snippet: '${post.content}',
//                             width: 100,
//                             height: 100,
//                             object: '${post.id}'
//                           ),
//                         );
//                         _markers.add(marker1);
//                       }); //foreach

//                       _controller?.setMarkerClickedListener((marker) async {
//                         String id = await marker.object;
//                         int pid = int.parse(id);
//                         print('marker clicked ${pid}');
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (BuildContext context) {
//                             // return PostDetailPage(post: post,);
//                             return PostDetailPage(pid: pid,);
//                           }) 
//                         );
//                         return true;
//                       });

//                       // _controller?.setMarkerDragListener(
//                       //   onMarkerDragEnd: (marker) async {
//                       //     toast(
//                       //       '${await marker.title}, ${await marker.location}',
//                       //     );
//                       //   },
//                       // );
//               },
//               child: Icon(Icons.keyboard_hide),
//               shape: CircleBorder(
//               ),
//             ),
//           ),
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'show',
              onPressed: () async{

                print('markers size: ${_markers.length}');
                print('posts ${posts.length} - ${posts[0].images[0].url}');

                setState(() {
                  _show = !_show;
                });

                bool need_reload = false;

                if(_markers.isNotEmpty){
                  for(var marker in _markers){
                    // marker.showInfoWindow();
                    print('marker ${marker.toString()}'); //null
                    if(marker != null)
                      marker.setVisible(_show);
                    else
                      need_reload = true;
                  }
                }else{
                  need_reload = true;
                }

                if(need_reload){
                  print('need reload ...........');
                  setState(() {
                    _show = true;
                    loadPostListFromServer();
                  });
                }

                if(_used) return;
                _used = true;

//                 _controller?.addMarkers(
//                   [
//                     for (int i = 0; i < 100; i++)
//                       MarkerOption(
//                         latLng: getNextLatLng(),
// //                            title: '北京$i',
// //                            snippet: '描述$i',
//                         iconProvider:
//                             i % 2 == 0 ? _assetsIcon1 : _assetsIcon2,
//                         imageConfig: createLocalImageConfiguration(context),
//                         width: 40,
//                         infoWindowEnabled: false,
// //                            rotateAngle: 90,
//                         height: 40,
//                         object: 'Marker_$i',
//                       ),
//                   ],
//                 )?.then(_markers.addAll);
                
                  // await Future.forEach(posts, (post) async { 
                  //   print('post ${post.id} ${post.author}');
                    
                  //   final marker1 = await _controller?.addMarker(
                  //     MarkerOption(
                  //       latLng: LatLng(
                  //         post.latitude,
                  //         post.longitude,
                  //       ),
                  //       widget: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: <Widget>[
                  //           Text('${post.title}'),
                  //           // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
                  //           ClipOval(
                  //             child: post.images.length > 0 ? 
                  //                 (post.images[0].url.startsWith('http') ? Image.network(post.images[0].url, height: 50,) : Image.asset(post.images[0].url, height: 50,))
                  //                 : Image.asset('images/icons/marker.png', height: 50,)
                  //           )
                  //         ],
                  //       ),
                  //       imageConfig: createLocalImageConfiguration(context),
                  //       title: '${post.title}',
                  //       snippet: '${post.content}',
                  //       width: 100,
                  //       height: 100,
                  //       object: '${post.id}'
                  //     ),
                  //   );
                  //   _markers.add(marker1);
                  // }); //foreach

                  // _controller?.setMarkerClickedListener((marker) async {
                  //   String id = await marker.object;
                  //   int pid = int.parse(id);
                  //   print('marker clicked ${pid}');
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //       return PostDetailPage(pid: pid,);
                  //     }) 
                  //   );
                  //   return true;
                  // });
              },
              child: _show? Icon(Icons.brightness_5) : Icon(Icons.brightness_1),
              shape: CircleBorder(
              ),
            ),
          ),
          Positioned(
            bottom: 150.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () async{
                final center = await _controller?.getCenterCoordinate();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PostUploadPage(center: center,);
                  }) 
                );
              },
              child: Icon(Icons.add),
              shape: CircleBorder(
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'close',
              onPressed: () async {
                await _controller?.showMyLocation(MyLocationOption(
                  myLocationType: MyLocationType.Locate,
                ));
                // if(_markers.isNotEmpty){
                //   for(var marker in _markers){
                //     marker.setVisible(false);
                //   }
                // }

                // final center = await _controller?.getCenterCoordinate(); //OK
                // print('center get ${center?.latitude}, ${center?.longitude}'); 
                // final random = Random();
                // // LatLng center = LatLng(39.90960, 121.247228);
                // final marker = await _controller?.addMarker(
                //   MarkerOption(
                //     // latLng: LatLng(39.90960, 121.44147669684741),
                //     latLng: LatLng(
                //       center.latitude + random.nextDouble() * 0.1,
                //       center.longitude + random.nextDouble() * 0.1,
                //     ),
                //     title: 'Title 北',
                //     snippet: '描述 ${center?.latitude}, ${center?.longitude}',
                //     iconProvider:  _assetsIcon1,
                //     object: '自定义数据',
                //     width: 10,
                //     height: 10
                //   ),
                // );
                // _markers.add(marker);
                // // marker.showInfoWindow(); //OK

                // print('get marker ${marker?.title}');

                // final marker1 = await _controller?.addMarker(
                //   MarkerOption(
                //     latLng: LatLng(
                //       center.latitude + random.nextDouble(),
                //       center.longitude + random.nextDouble(),
                //     ),
                //     widget: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: <Widget>[
                //         Text('使用Widget作为Marker'),
                //         //FlutterLogo(size: 80),
                //         ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
                //       ],
                //     ),
                //     imageConfig: createLocalImageConfiguration(context),
                //     title: 'title .....',
                //     snippet: '描述',
                //     width: 100,
                //     height: 100,
                //   ),
                // );
                // _markers.add(marker1);
                // // marker1.showInfoWindow(); //OK
              },
              child: Icon(FontAwesome.map_marker),
              shape: CircleBorder(
              ),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async{
      //     print("floating action button clicked");

      //     // bool status = await Permission.locationAlways.isGranted;
      //     // if(!status){
      //     //   print("need to get locationAlways permission first");
      //     //   status = await Permission.locationAlways.request().isGranted;
      //     //   if(status){
      //     //     await _controller?.showMyLocation(MyLocationOption(
      //     //       myLocationType: MyLocationType.Locate,
      //     //     ));
      //     //   }else{
      //     //     print("need to grant the location permission first");
      //     //   }
      //     // }else{
      //     //   await _controller?.showMyLocation(MyLocationOption(
      //     //     myLocationType: MyLocationType.Locate,
      //     //   ));
      //     // }


      //     // await _controller?.showMyLocation(MyLocationOption(
      //     //   myLocationType: MyLocationType.Locate,
      //     // ));

      //     //获取当前经纬度
      //     // final latLng = await _controller?.getLocation(); //FAILED
      //     // toast('当前经纬度: ${latLng.toString()}');

      //     // _controller?.setMapType(MapType.Standard);  //OK
      //     // _controller?.setMapType(MapType.Satellite);

      //     // _controller?.setMapLanguage(Language.Chinese);
      //     // _controller?.setMapLanguage(Language.English); //OK

    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Container(
        height: 50,
        // color: Colors.blueAccent,
        padding: EdgeInsets.only(top: 10.0),
        child: new TextFormField(
          autofocus: false,
          controller: _filter,
          decoration: InputDecoration(
            // icon: Icon(Icons.search),
            labelText: "Input for Search",
            // focusColor: Colors.white,
            fillColor: Colors.white,      
            // border: new OutlineInputBorder(
            //   // borderRadius: new BorderRadius.circular(5.0),
            //   borderSide: new BorderSide(),
            //   gapPadding: 10.0,
            // ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.green,
                width: 1.5
              ),
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            decorationColor: Color(0XFFFFCC00),//Font color change
            // backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            print('search icon clicked ${_filter.text}');
            String txt = _filter.text;
            if(txt.isNotEmpty && posts.isNotEmpty){
              for(var i = 0; i < posts.length; i++){
                var post = posts[i];
                print('post : ${post.id} - ${post.author}');
                if(post.author == txt){
                  print('found author ${post.author} - ${post.id}');
                  // await _controller?.setCenterCoordinate(LatLng(post.latitude, post.longitude));
                  _controller?.setCenterCoordinate(
                    LatLng(post.latitude, post.longitude),
                    zoomLevel: 19,
                    animated: true,
                  );
                  return;
                }
              }
              // posts.forEach((post) { 
              //   // print('post : ${post.id} - ${post.author}');
              //   if(post.author == txt){
              //     print('found author ${post.author} - ${post.id}');

              //     await _controller?.showMyLocation(MyLocationOption(
              //           myLocationType: MyLocationType.Locate,
              //         ));
              //   }
              // });
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.scanner),
          onPressed: (){
            print('scan icon clicked');
            _scanCode();
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

  _scanCode() async {
    var status = await PermissionUtils.requestCemera();
    if (status == PermissionStatus.granted) {
      print('permission granted');
      // String cameraScanResult = await scanner.scan();
      // print('scan result is:::: ${cameraScanResult}');
      // _filter.text = cameraScanResult;


      // var result = await BarcodeScanner.scan();
      // print('result is ${result}');
      // if (result.type == ResultType.Barcode) {
      //   print('barcode scan result --> Barcode');
      // }
    } else {
      PermissionUtils.showPermissionDialog(context);
    }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

