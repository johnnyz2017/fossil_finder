import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class QrCodeGeneratePage extends StatefulWidget {
  final String qrString;

  const QrCodeGeneratePage({Key key, this.qrString}) : super(key: key);
  @override
  _QrCodeGeneratePageState createState() => _QrCodeGeneratePageState();
}

class _QrCodeGeneratePageState extends State<QrCodeGeneratePage> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;

  @override
  void initState() {
    _dataString = widget.qrString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('记录二维码展示'),
        backgroundColor: Colors.blue,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.share),
        //     onPressed: _captureAndSharePng,
        //   )
        // ],
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      print('qr image file path ${file.path}');

      Share.shareFiles([file.path],subject: '分享记录链接: ${_dataString}', text: 'share with you');
      // final channel = const MethodChannel('channel:me.camellabs.share/share');
      // channel.invokeMethod('shareFile', 'image.png');

    } catch(e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      padding: EdgeInsets.all(20),
      child:  Column(
        children: <Widget>[
          // SizedBox(height: 100,),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                  
                ),
              ),
            ),
          ),
          // SizedBox(height: 100,),
        ],
      ),
    );
  }
}