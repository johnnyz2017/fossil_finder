import 'dart:convert';
import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
// import 'package:geolocation/geolocation.dart';

// import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
                      // _controller?.showCompass(true); //NO
                      // _controller?.showLocateControl(true); //NO
                      _controller?.showScaleControl(true); //OK
                      
                      loadPostListFromServer(); //load posts after amap init
                  },
                ),
              ]
      ),
      floatingActionButton: Stack(
        children: <Widget>[
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
                  });
                  loadPostListFromServer();
                }

                if(_used) return;
                _used = true;
              },
              child: _show? Icon(Icons.highlight) : Icon(Icons.highlight_off),
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
              },
              child: Icon(FontAwesome.map_marker),
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
          ),
          // onTap: (){
          //   showSearch(context: context, delegate: DataSearch());
          // },
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
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
                        ClipOval(
                          child: searchedPost.images.length > 0 ? 
                              (searchedPost.images[0].url.startsWith('http') ? CachedNetworkImage(imageUrl:  searchedPost.images[0].url, placeholder: (context, url) => Center(child: CircularProgressIndicator()), height: 50,) : Image.asset(searchedPost.images[0].url, height: 50,))
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
          icon: new Image.asset('images/icons/scanning.png'),
          onPressed: (){
            print('scan icon clicked');
            _scanCode();
          },
        )
      ],
    );
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
      final String qrCode = await scanner.scan();
      // final String qrCode = await FlutterBarcodeScanner.scanBarcode(
      //   '#ff6666', 
      //   '取消', 
      //   true, 
      //   ScanMode.QR);
      print('qr code result : ${qrCode}');
      if(qrCode.contains('${serviceUrl}/posts')){
        print('found post link, try to convert to post detail page');
        List<String> _splitRet = qrCode.split('/');
        int _pid = int.parse(_splitRet[_splitRet.length - 1]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return PostDetailPage(pid: _pid,);
          }) 
        );
      }
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