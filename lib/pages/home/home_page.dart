import 'dart:convert';
import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
// import 'package:geolocation/geolocation.dart';

// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/form/post_upload.dart';
import 'package:fossils_finder/pages/list/category_posts.dart';
import 'package:fossils_finder/pages/list/category_select.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:fossils_finder/utils/permission.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


SharedPreferences localStorage;

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // FocusNode _inputFocus = FocusNode();
  List<Post> posts = new List<Post>();

  bool _used = false;
  bool _show = true;

  Future loadPostListViaCategoryFromServer(int cid) async{
    var _content = await request(servicePath['categories'] + '/${cid}/posts');
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
    var _listJson;
    if(_jsonData['paginated']){
      _listJson = _jsonData['data']['data'];
    }
    else{
      _listJson = _jsonData['data'];
    }

    List _jsonList = _listJson as List;
    List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });

    await Future.forEach(posts, (post) async { 
      print('post ${post.id} ${post.author}');
      
      final marker1 = await _controller?.addMarker(
        MarkerOption(
          latLng: LatLng(
            post.coordinateLatitude,
            post.coordinateLongitude,
          ),
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Text('${post.title}'),
              Container(
                width: 80,
                height: 50,
                child: ClipOval(
                  clipper: _MyClipper(),
                  child: post.images.length > 0 ? 
                      (post.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  post.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), fit: BoxFit.fill, height: 50, width: 80) : Image.asset(post.images[0].url, fit: BoxFit.fill, height: 50, width: 80))
                      : Image.asset('images/icons/marker.png', fit: BoxFit.fill)
                ),
              )
              // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
              // ClipOval(
              //   child: post.images.length > 0 ? 
              //       (post.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  post.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), height: 50, width: 50) : Image.asset(post.images[0].url, height: 50, width: 50))
              //       : Image.asset('images/icons/marker.png', height: 50,)
              // )
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

  Future loadPostListFromServer() async{
    var _content = await request(servicePath['posts']);
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
    var _listJson;
    if(_jsonData['paginated']){
      _listJson = _jsonData['data']['data'];
    }
    else{
      _listJson = _jsonData['data'];
    }

    List _jsonList = _listJson as List;
    List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });

    await Future.forEach(posts, (post) async { 
      print('post ${post.id} ${post.author}');
      
      final marker1 = await _controller?.addMarker(
        MarkerOption(
          latLng: LatLng(
            post.coordinateLatitude,
            post.coordinateLongitude,
          ),
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Text('${post.title}'),
              // ClipOval(child: Image.asset('images/icons/marker.png', height: 50,),)
              // ClipOval(
              //   child: post.images.length > 0 ? 
              //       (post.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  post.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), height: 50, width: 50) : Image.asset(post.images[0].url, height: 50, width: 50))
              //       : Image.asset('images/icons/marker.png', height: 50,)
              // )
              Container(
                width: 80,
                height: 50,
                child: ClipOval(
                  clipper: _MyClipper(),
                  child: post.images.length > 0 ? 
                      (post.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  post.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), fit: BoxFit.fill,) : Image.asset(post.images[0].url, fit: BoxFit.fill))
                      : Image.asset('images/icons/marker.png', height: 50,)
                ),
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
  // bool _locationStatus = false;

  final TextEditingController _filter = new TextEditingController();
  
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  // Widget _appBarTitle = new Text( 'Search Example' );

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  init() async{
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');
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
        // setState(() {
        //   _locationStatus = true;
        // });

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
      key: _drawerKey,
      // appBar: _buildBar(context),
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
                    Text("高德地图")
                  ],),),
                  Expanded(child: Column(children: <Widget>[
                    IconButton(
                      iconSize: 50,
                      icon: ClipOval(child: Image.asset('images/icons/map-google.png', width: 50,),),
                      focusColor: Colors.blue,
                      onPressed: null,
                    ),
                    Text("谷歌地图")
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
                  title: Text("退出登陆"),
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
              // onMapClicked: (value) async{
              //   // _inputFocus.unfocus();
              //   print('ampa clicked with ${value.latitude - value.longitude}');
              // },
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

                // _controller?.showZoomControl(true); //OK
                _controller?.showCompass(false); //NO
                // _controller?.showLocateControl(true); //NO
                _controller?.showScaleControl(false); //OK
                
                loadPostListFromServer(); //load posts after amap init
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () async{
                // _inputFocus.unfocus();
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
        ],
        
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            top: 100.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'layer',
              onPressed: () async{
                _drawerKey.currentState.openDrawer();
              },
              child: new Image.asset(
                'images/icons/layer_gray.png',
                width: 21,
                height: 21,
                fit: BoxFit.fill
              ),
              shape: CircleBorder(
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0.0,
          //   right: MediaQuery.of(context).size.width * 0.5,
          //   child: FloatingActionButton(
          //     heroTag: 'add',
          //     onPressed: () async{
          //       // _inputFocus.unfocus();
          //       final center = await _controller?.getCenterCoordinate();

          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (BuildContext context) {
          //           return PostUploadPage(center: center,);
          //         }) 
          //       );
          //     },
          //     child: Icon(Icons.add),
          //     shape: CircleBorder(
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 290.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'category',
              onPressed: () async{
                // _inputFocus.unfocus();
                print('markers size: ${_markers.length}');

                CategoryNode selectedCategory = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CategorySelector(treeJson: "", editable: false);
                  }) 
                );

                print('parent as: ${selectedCategory}');

                if(selectedCategory != null){
                  print('result: ${selectedCategory.key} - ${selectedCategory.label}');
                  
                  if(_markers.isNotEmpty){
                    for(var marker in _markers){
                      print('marker ${marker.toString()}');                    
                      marker.remove();
                    }
                  }
                  if(selectedCategory.id == 0){
                    loadPostListFromServer();
                  }else{
                    String _key = selectedCategory.key;
                    String _type = _key.split('_')[0];
                    if(_type.isNotEmpty || _type == "c"){
                      var _categoryId = int.parse(_key.split('_')[1]);
                      print('got category id ${_categoryId}');
                      loadPostListViaCategoryFromServer(_categoryId);
                    }
                  }
                }
              },
              child: new Image.asset(
                'images/icons/category_gray.png',
                width: 21,
                height: 21,
                fit: BoxFit.fill
              ),
              shape: CircleBorder(
              ),
            ),
          ),
          Positioned(
            bottom: 220.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'show',
              onPressed: () async{
                print('markers size: ${_markers.length}');
                setState(() {
                  _show = !_show;
                });

                bool _needReload = false;

                if(_markers.isNotEmpty){
                  for(var marker in _markers){
                    // marker.showInfoWindow();
                    print('marker ${marker.toString()}'); //null
                    if(marker != null)
                      marker.setVisible(_show);
                    else
                      _needReload = true;
                  }
                }else{
                  _needReload = true;
                }

                if(_needReload){
                  print('need reload ...........');
                  setState(() {
                    _show = true;
                  });
                  loadPostListFromServer();
                }

                if(_used) return;
                _used = true;
              },
              child: _show? new Image.asset(
                'images/icons/map_show_gray.png',
                width: 21,
                height: 21,
                fit: BoxFit.fill
              ) : new Image.asset(
                'images/icons/map_hide_gray.png',
                width: 21,
                height: 21,
                fit: BoxFit.fill
              ),
              shape: CircleBorder(
              ),
            ),
          ),
          Positioned(
            bottom: 150.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'scan',
              onPressed: () async{
                print('scan icon clicked');
                _scan();
              },
              child: new Image.asset(
                'images/icons/scan_gray.png',
                width: 21,
                height: 21,
                fit: BoxFit.fill
              ),
              shape: CircleBorder(
              ),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'search',
              onPressed: () async{
                var ret = showSearch(context: context, delegate: DataSearch(), query: _filter.text);
                ret.then((searchedPost) async{
                  if(searchedPost == null) return;

                  var existed = false;
                  posts.forEach((post) { 
                    if(post.id == searchedPost.id){
                      existed = true;
                      _controller?.setCenterCoordinate(
                        LatLng(searchedPost.coordinateLatitude, searchedPost.coordinateLongitude),
                        zoomLevel: 19,
                        animated: true,
                      );
                    }
                  });

                  if(!existed){
                    final marker1 = await _controller?.addMarker(
                      MarkerOption(
                        latLng: LatLng(
                          searchedPost.coordinateLatitude,
                          searchedPost.coordinateLongitude,
                        ),
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('${searchedPost.title}'),
                            // ClipOval(
                            //   child: Image.asset('images/icons/marker.png', height: 50)
                            // ),
                            // ClipOval(
                            //   child: searchedPost.images.length > 0 ? 
                            //       (searchedPost.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  searchedPost.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), height: 50, width: 50) : Image.asset(searchedPost.images[0].url, height: 50, width: 50))
                            //       : Image.asset('images/icons/marker.png', height: 50,)
                            // )
                            Container(
                              width: 80,
                              height: 50,
                              child: ClipOval(
                                clipper: _MyClipper(),
                                child: searchedPost.images.length > 0 ? 
                                    (searchedPost.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  searchedPost.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), fit: BoxFit.fill, height: 50, width: 80) : Image.asset(searchedPost.images[0].url, fit: BoxFit.fill, height: 50, width: 80))
                                    : Image.asset('images/icons/marker.png', height: 50,)
                              ),
                            )
                          ],
                        ),
                        imageConfig: createLocalImageConfiguration(context),
                        title: '${searchedPost.title}',
                        snippet: '${searchedPost.content}',
                        width: 100,
                        height: 100,
                        object: '${searchedPost.id}'
                      ),
                    );
                    _markers.add(marker1);
                    posts.add(searchedPost);

                    _controller?.setCenterCoordinate(
                      LatLng(searchedPost.coordinateLatitude, searchedPost.coordinateLongitude),
                      zoomLevel: 19,
                      animated: true,
                    );
                  }
                });
              },
              child: Icon(Icons.search),
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
                // _inputFocus.unfocus();
                await _controller?.showMyLocation(MyLocationOption(
                  myLocationType: MyLocationType.Locate,
                ));
              },
              child: new Image.asset(
                'images/icons/target_gray.png',
                width: 21,
                height: 21,
                fit: BoxFit.fill
              ),
              shape: CircleBorder(
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      // centerTitle: true,
      // title: Container(
      //   height: 50,
      //   // color: Colors.blueAccent,
      //   padding: EdgeInsets.only(top: 10.0),
      //   child: new TextFormField(
      //     focusNode: _inputFocus,
      //     autofocus: false,
      //     controller: _filter,
      //     decoration: InputDecoration(
      //       fillColor: Colors.white,      
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(5.0),
      //         borderSide: BorderSide(
      //           color: Colors.white,
      //           width: 1.5,
      //         ),
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(5.0),
      //         borderSide: BorderSide(
      //           color: Colors.green,
      //           width: 1.5
      //         ),
      //       ),
      //     ),
      //     style: TextStyle(
      //       color: Colors.white,
      //       decorationColor: Color(0XFFFFCC11),//Font color change
      //     ),
      //     // onTap: (){
      //     //   showSearch(context: context, delegate: DataSearch());
      //     // },
      //   ),
      // ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            // _inputFocus.unfocus();
            var ret = showSearch(context: context, delegate: DataSearch(), query: _filter.text);
            ret.then((searchedPost) async{
              if(searchedPost == null) return;

              var existed = false;
              posts.forEach((post) { 
                if(post.id == searchedPost.id){
                  existed = true;
                  _controller?.setCenterCoordinate(
                    LatLng(searchedPost.coordinateLatitude, searchedPost.coordinateLongitude),
                    zoomLevel: 19,
                    animated: true,
                  );
                }
              });

              if(!existed){
                final marker1 = await _controller?.addMarker(
                  MarkerOption(
                    latLng: LatLng(
                      searchedPost.coordinateLatitude,
                      searchedPost.coordinateLongitude,
                    ),
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('${searchedPost.title}'),
                        // ClipOval(
                        //   child: Image.asset('images/icons/marker.png', height: 50,)
                        // )
                        // ClipOval(
                        //   child: searchedPost.images.length > 0 ? 
                        //       (searchedPost.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  searchedPost.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), height: 50, width: 50) : Image.asset(searchedPost.images[0].url, height: 50, width: 50))
                        //       : Image.asset('images/icons/marker.png', height: 50,)
                        // )
                        ClipOval(
                          clipper: _MyClipper(),
                          child: searchedPost.images.length > 0 ? 
                              (searchedPost.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  searchedPost.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), fit: BoxFit.fill, height: 50, width: 80) : Image.asset(searchedPost.images[0].url, fit: BoxFit.fill, height: 50, width: 80))
                              : Image.asset('images/icons/marker.png', height: 50,)
                        )
                      ],
                    ),
                    imageConfig: createLocalImageConfiguration(context),
                    title: '${searchedPost.title}',
                    snippet: '${searchedPost.content}',
                    width: 100,
                    height: 100,
                    object: '${searchedPost.id}'
                  ),
                );
                _markers.add(marker1);
                posts.add(searchedPost);

                _controller?.setCenterCoordinate(
                  LatLng(searchedPost.coordinateLatitude, searchedPost.coordinateLongitude),
                  zoomLevel: 19,
                  animated: true,
                );
              }
            });
          },
        ),
        IconButton(
          icon: new Image.asset(
            'images/icons/scan_gray.png',
            width: 21,
            height: 21,
            fit: BoxFit.fill
          ),
          onPressed: (){
            print('scan icon clicked');
            // _inputFocus.unfocus();
            // _scanCode();
            _scan();
          },
        )
      ],
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        // this._appBarTitle = new TextField(
        //   controller: _filter,
        //   decoration: new InputDecoration(
        //     prefixIcon: new Icon(Icons.search),
        //     hintText: 'Search...'
        //   ),
        // );
      } else {
        this._searchIcon = new Icon(Icons.search);
        // this._appBarTitle = new Text( 'Search Example' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  Future _scan() async {
    var status = await PermissionUtils.requestCemera();
    if (status == PermissionStatus.granted) {
      print('permission granted');
      
      try {
        String barcode = await BarcodeScanner.scan();
        print('got string : ${barcode}');
        if(barcode.contains('${serviceUrl}/posts')){
          print('found post link, try to convert to post detail page');
          List<String> _splitRet = barcode.split('/');
          int _pid = int.parse(_splitRet[_splitRet.length - 1]);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return PostDetailPage(pid: _pid,);
            }) 
          );
        }else{
          Fluttertoast.showToast(
            msg: "解析失败，请确认扫描的是否为记录相关的二维码，扫描结果为： ${barcode}",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG
            );
        }
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          print('The user did not grant the camera permission!');
        } else {
          print('Unknown error: $e');
        }
      } on FormatException{
        print('null (User returned using the "back"-button before scanning anything. Result)');
      } catch (e) {
        print('Unknown error: $e');
      }
      
      // final String qrCode = await FlutterBarcodeScanner.scanBarcode(
      //   '#ff6666', 
      //   '取消', 
      //   true, 
      //   ScanMode.QR);
      
      // final String qrCode = await scanner.scan();
      // print('qr code result : ${qrCode}');
      // if(qrCode.contains('${serviceUrl}/posts')){
      //   print('found post link, try to convert to post detail page');
      //   List<String> _splitRet = qrCode.split('/');
      //   int _pid = int.parse(_splitRet[_splitRet.length - 1]);

      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (BuildContext context) {
      //       return PostDetailPage(pid: _pid,);
      //     }) 
      //   );
      // }
    } else {
      PermissionUtils.showPermissionDialog(context);
    }

    
  }

  Future _scanCode() async {
    var status = await PermissionUtils.requestCemera();
    if (status == PermissionStatus.granted) {
      print('permission granted');
      
      // final String qrCode = await FlutterBarcodeScanner.scanBarcode(
      //   '#ff6666', 
      //   '取消', 
      //   true, 
      //   ScanMode.QR);
      
      // final String qrCode = await scanner.scan();
      // print('qr code result : ${qrCode}');
      // if(qrCode.contains('${serviceUrl}/posts')){
      //   print('found post link, try to convert to post detail page');
      //   List<String> _splitRet = qrCode.split('/');
      //   int _pid = int.parse(_splitRet[_splitRet.length - 1]);

      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (BuildContext context) {
      //       return PostDetailPage(pid: _pid,);
      //     }) 
      //   );
      // }
    } else {
      PermissionUtils.showPermissionDialog(context);
    }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

Future<List<Post>> searchFromServer(String query) async{
  SharedPreferences localStorage;
  localStorage = await SharedPreferences.getInstance();
  String _token = localStorage.get('token');

  BaseOptions options = BaseOptions(
    baseUrl: apiUrl,
    responseType: ResponseType.json,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    validateStatus: (code) {
      if (code >= 200) {
        return true;
      }
    },
    headers: {
      HttpHeaders.authorizationHeader : 'Bearer $_token',
      HttpHeaders.acceptHeader : 'application/json'
    }
  );
  Response response;
  Dio dio = new Dio(options);
  Options ops = Options(
    contentType: 'application/json',
  );
  String url = apiUrl + '/search?search_key=${query}&type=all';
  print('search url is $url');
  response = await dio.get(url, options: ops);

  if(response.statusCode != 200){
    if(response.statusCode == 401){
      print('#### unauthenticated, need back to login page ${response.statusCode}');
    }
    print('#### Network Connection Failed: ${response.statusCode}');
  }

  var _jsonData = jsonDecode(response.toString());
  var _listJson;
  if(_jsonData['paginated']){
    _listJson = _jsonData['data']['data'];
  }
  else{
    _listJson = _jsonData['data'];
  }
  
  List _jsonList = _listJson as List;
  List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
  return postList;
}

class DataSearch extends SearchDelegate<Post>{
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      // IconButton(
      //   icon: Icon(Icons.title),
      //   onPressed: (){
      //     // type = 'title';
      //     print('clicked title type');
      //   },
      // ),
      // IconButton(
      //   icon: Icon(Icons.category),
      //   onPressed: (){
      //     // type = 'title';
      //     print('clicked category type');
      //   },
      // ),
      // IconButton(
      //   icon: Icon(Icons.people),
      //   onPressed: (){
      //     // type = 'title';
      //     print('clicked author type');
      //   },
      // ),
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = '';
      },)
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
        ),
      onPressed: (){
        close(context, null);
      },);
  }
  
  @override
  Widget buildResults (BuildContext context) {
    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: searchFromServer(query),
      builder: (context, snapshot){
        switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    '搜索失败!',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                );
              } else {
                return buildResultSuccess(snapshot.data);
              }
          }
      }
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }


  Widget buildResultSuccess(List<Post> posts) => ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: posts.length,
    itemBuilder: (context, index){
      final post = posts[index];
      return ListTile(
        // leading: Text(post.author),
        title: Text(post.title),
        subtitle: Text(post.author),
        onTap: (){
          print('tile been clicked ${post.categoryId}');
          Navigator.pop(context, post);

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (BuildContext context) {
          //     return PostDetailPage(pid: post.id,);
          //   }) 
          // );
        },
      );
    },
  );

}




class _MyClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(10.0, 10.0, size.width - 10.0,  size.height- 10.0);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}