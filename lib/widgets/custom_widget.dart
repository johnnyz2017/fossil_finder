import 'package:flutter/material.dart';

Widget FListTile(String leadingImage, String title, Function onTapCallback, {double height = 100, double iconSize=50}){
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: new Image.asset(
          leadingImage,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.fill
        ),
        title: Text(title,
          style: TextStyle(
            fontSize: 18
          ),
        ),
        // trailing: Icon(Icons.arrow_right),
        onTap: onTapCallback,
      ),
    );
  }