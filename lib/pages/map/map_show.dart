import 'package:flutter/material.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';

class MapShowPage extends StatefulWidget {
  final bool selectable;
  final LatLng coord;

  const MapShowPage({Key key, this.coord, this.selectable = false}) : super(key: key);

  @override
  _MapShowPageState createState() => _MapShowPageState();
}

class _MapShowPageState extends State<MapShowPage> {
  AmapController _controller;
  List<Marker> _markers = [];
  bool _locationStatus = false;
  Marker _marker;

  LatLng selectedPos;

  @override
  void initState() {
    super.initState();
    selectedPos = widget.coord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.selectable ? Text('${selectedPos.latitude.toStringAsFixed(6)}, ${selectedPos.longitude.toStringAsFixed(6)}') : Text('地图'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              print('select to ${selectedPos.latitude.toStringAsFixed(6)}-${selectedPos.longitude.toStringAsFixed(6)}');
              Navigator.pop(context, selectedPos);
            },
          )
        ],
      ),
      body: AmapView(
          mapType: MapType.Standard,
          showZoomControl: false,
          zoomLevel: 10,
          maskDelay: Duration(milliseconds: 500),
          onMapClicked: (value) async{
            print('ampa clicked with ${value.latitude - value.longitude}');
            setState(() {
              selectedPos = value;
            });
          },
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
            _controller.setCenterCoordinate(selectedPos);
            _controller.addCircle(CircleOption(center: selectedPos, radius: 20, fillColor: Colors.green));
        },
      ),
    );
  }
}