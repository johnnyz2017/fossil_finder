import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final url;
  const ImageDetailScreen({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: url.startsWith('http') ? Image.network(url) 
                                        : Image.asset(url)
        ),
      ),
    );
  }
}