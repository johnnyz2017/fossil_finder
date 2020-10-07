import 'package:flutter/material.dart';
import 'package:fossils_finder/main_app.dart';
import 'package:fossils_finder/pages/home/home.dart';

import 'package:fossils_finder/pages/login/login_page.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:fossils_finder/pages/main_page.dart';
import 'map/map_demo.dart';

Future<void> main() async {
  runApp(
      // MainApp()
      // LoginScreen()
        MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: new LoginScreen(),
          // home: PickImageWidget(),
          home: HomePage()
        )
  );

  await enableFluttifyLog(false);
  await AmapService.init(
    iosKey: '442bcb9df9178d4e0e1d30370c485907',
    androidKey: 'cf2c5badb6669ff95b26030d9e77f490',
  );
}
