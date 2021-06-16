import 'package:flutter/material.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:fossils_finder/widgets/clipper_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class MapShowPage extends StatefulWidget {
  final bool selectable;
  final LatLng coord;

  const MapShowPage({Key key, this.coord, this.selectable = false}) : super(key: key);

  @override
  _MapShowPageState createState() => _MapShowPageState();
}

class _MapShowPageState extends State<MapShowPage> {
  double markerSize = 30.0;
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
        title: widget.selectable ? Text('${selectedPos.latitude.toStringAsFixed(4)}, ${selectedPos.longitude.toStringAsFixed(4)}') : Text('地图'),
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
          zoomLevel: 12,
          // maskDelay: Duration(milliseconds: 100),
          onMapClicked: (value) async{
            print('amap clicked with ${value.latitude} - ${value.longitude}');
            setState(() {
              selectedPos = value;
            });
            // _controller.getLocation();
            
            if(widget.selectable){
              await _marker?.remove();
              print('after makrer remove, create a marker @ ${selectedPos.latitude} - ${selectedPos.longitude}');
              _marker = await _controller?.addMarker(
                MarkerOption(
                  latLng: selectedPos,
                  widget: Container(
                    child: Image.asset('images/icons/marker-red.png'),
                    width: markerSize, height : markerSize
                  ),
                  // iconUri: Uri(path: 'images/icons/marker-blue.png'),
                  infoWindowEnabled: true,
                  // iconProvider: NetworkImage(
                  //   "https://cdn.clipartsfree.net/vector/medium/77913-map-marker-red-images.png",
                  //   scale: 0.01
                  // ),
                  // iconProvider: AssetImage('images/icons/marker-red.png', package: 'fossils_finder'),
                  width: markerSize,
                  height: markerSize, 
                  anchorV: 0.5,
                  anchorU: 0.5
                ),
              );

              _marker?.setCoordinate(selectedPos);
            }
          },
          onMapCreated: (controller) async {
            _controller = controller;
            // await _controller?.getLocation(); //TOO LONG

            bool status = await Permission.locationAlways.isGranted;
            if(!status){
              print("need to get locationAlways permission first");
              status = await Permission.locationAlways.request().isGranted;
              if(status){
                print('status == true');
                await _controller?.showMyLocation(MyLocationOption(
                  myLocationType: MyLocationType.Locate,
                ));

                _controller?.showScaleControl(true); //OK          
                _controller.setCenterCoordinate(selectedPos); //OK
                // _controller.addCircle(CircleOption(center: selectedPos, radius: 20, fillColor: Colors.green));

                _marker = await _controller?.addMarker(
                  MarkerOption(
                    latLng: selectedPos,
                    widget: Container(
                      child: Image.asset('images/icons/marker-red.png'),
                      width: markerSize, height : markerSize
                    ),
                    // iconUri: Uri(path: 'images/icons/marker-red.png'),
                    infoWindowEnabled: true,
                    // iconProvider: NetworkImage(
                    //   "https://cdn.clipartsfree.net/vector/medium/77913-map-marker-red-images.png",
                    //   scale: 0.01,
                    // ),
                    // iconProvider: AssetImage('images/icons/marker-red.png'),
                    width: markerSize,
                    height: markerSize, 
                    anchorV: 0.5,
                    anchorU: 0.5
                  ),
                );

                _marker.setCoordinate(selectedPos);
              }else{
                print("need to grant the location permission first");
              }
            }else{
              print('permission isGranted');
              // await _controller?.showMyLocation(MyLocationOption(
              //   myLocationType: MyLocationType.Locate,
              // ));
              await _controller?.setCenterCoordinate(selectedPos);

              await _controller?.showScaleControl(true); //OK          
              // _controller.setCenterCoordinate(selectedPos);
              // _controller.addCircle(CircleOption(center: selectedPos, radius: 20, fillColor: Colors.green));

              _marker = await _controller?.addMarker(
                MarkerOption(
                  latLng: selectedPos,
                  widget: Container(
                    child: Image.asset('images/icons/marker-red.png'),
                    width: markerSize, height : markerSize
                  ),
                  // iconUri: Uri(path: 'images/icons/marker-blue.png'),
                  infoWindowEnabled: true,
                  // iconProvider: NetworkImage(
                  //   "https://cdn.clipartsfree.net/vector/medium/77913-map-marker-red-images.png",
                  //   scale: 0.01
                  // ),
                  // iconProvider: AssetImage('images/icons/marker-red.png'),
                  width: markerSize,
                  height: markerSize, 
                  anchorV: 0.5,
                  anchorU: 0.5
                ),
              );

              _marker?.setCoordinate(selectedPos);
            }

            // _controller?.showZoomControl(true); //OK
            // _controller?.showCompass(true); //NO
            // _controller?.showLocateControl(true); //NO
            // _controller?.showScaleControl(true); //OK
            // _controller.setCenterCoordinate(selectedPos);
            // _controller.addCircle(CircleOption(center: selectedPos, radius: 20, fillColor: Colors.green));
        },
      ),
    );
  }
}