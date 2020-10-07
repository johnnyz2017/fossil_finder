import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:decorated_flutter/decorated_flutter.dart';

final _assetsIcon = Uri.parse('images/icons/fossil_icon_512.png');

class MapListScreen extends StatefulWidget {
  @override
  _MapListScreenState createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
  AmapController _controller;

  @override
  Widget build(BuildContext context) {
    return AmapView(
            mapType: MapType.Satellite,
            showZoomControl: false,
            maskDelay: Duration(milliseconds: 500),
            onMapCreated: (controller) async {
              _controller = controller;

              await _controller?.showMyLocation(MyLocationOption(
                myLocationType: MyLocationType.Locate,
              ));
              _controller?.setMapType(MapType.Standard);
            }
    );

    // return DecoratedColumn(
    //       children: <Widget>[
    //         Flexible(
    //           flex: 1,
    //           child: AmapView(
    //             mapType: MapType.Satellite,
    //             showZoomControl: false,
    //             maskDelay: Duration(milliseconds: 500),
    //             onMapCreated: (controller) async {
    //               _controller = controller;                                    
                  
    //               await _controller?.showMyLocation(MyLocationOption(
    //                 myLocationType: MyLocationType.Locate,
    //               ));

    //               _controller?.setMapType(MapType.Standard);
    //             },
    //           ),
    //         ),
    //       ],
    // );
  }
}