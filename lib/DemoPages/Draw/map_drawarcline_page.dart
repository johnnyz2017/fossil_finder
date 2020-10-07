import 'package:flutter/material.dart';
import 'package:fossils_finder/CustomWidgets/map_appbar.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:fossils_finder/CustomWidgets/map_base_page_state.dart';
import 'package:fossils_finder/constants.dart';

/// arcline弧线绘制示例
class DrawArclinePage extends StatefulWidget {
  DrawArclinePage({Key key}) : super(key: key);

  @override
  _DrawArclinePageState createState() => _DrawArclinePageState();
}

class _DrawArclinePageState extends BMFBaseMapState<DrawArclinePage> {
  BMFArcline _arcline0;
  BMFArcline _arcline1;
  BMFArcline _arcline2;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addArcline();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: 'arcline示例',
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(children: <Widget>[generateMap(), generateControlBar()]),
      ),
    );
  }

  @override
  Widget generateControlBar() {
    return Container(
      width: screenSize.width,
      height: 60,
      color: Color(int.parse(Constants.controlBarColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Color(int.parse(Constants.btnColor)),
              textColor: Colors.white,
              child: Text(
                _btnText,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _onBtnPress();
              }),
        ],
      ),
    );
  }

  void _onBtnPress() {
    if (_addState) {
      addArcline();
    } else {
      removeArcline();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addArcline() {
    //addArline0();
    addArcline1();
    addArcline2();
  }

  void addArline0() {
    List<BMFCoordinate> coordinates0 = List(3);
    coordinates0[0] = BMFCoordinate(40.065, 116.224);
    coordinates0[1] = BMFCoordinate(40.125, 116.404);
    coordinates0[2] = BMFCoordinate(40.065, 116.504);
    _arcline0 = BMFArcline(
        coordinates: coordinates0,
        lineDashType: BMFLineDashType.LineDashTypeNone,
        width: 6,
        color: Colors.blue);
    myMapController?.addArcline(_arcline0);
  }

  void addArcline1() {
    List<BMFCoordinate> coordinates1 = List(3);
    coordinates1[0] = BMFCoordinate(39.965, 116.324);
    coordinates1[1] = BMFCoordinate(39.825, 116.374);
    coordinates1[2] = BMFCoordinate(39.865, 116.304);
    _arcline1 = BMFArcline(
        coordinates: coordinates1,
        lineDashType: BMFLineDashType.LineDashTypeDot,
        width: 4,
        color: Colors.green);
    myMapController?.addArcline(_arcline1);
  }

  void addArcline2() {
    List<BMFCoordinate> coordinates2 = List(3);
    coordinates2[0] = BMFCoordinate(39.975, 116.224);
    coordinates2[1] = BMFCoordinate(39.935, 116.404);
    coordinates2[2] = BMFCoordinate(39.975, 116.584);
    _arcline2 = BMFArcline(
        coordinates: coordinates2,
        lineDashType: BMFLineDashType.LineDashTypeDot,
        width: 10,
        color: Colors.red);
    myMapController?.addArcline(_arcline2);
  }

  void removeArcline() {
    myMapController?.removeOverlay(_arcline0?.getId());
    myMapController?.removeOverlay(_arcline1?.getId());
    myMapController?.removeOverlay(_arcline2?.getId());
  }
}
