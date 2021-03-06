// ignore_for_file: non_constant_identifier_names, camel_case_types, missing_return, unused_import, unused_local_variable, dead_code, unnecessary_cast
//////////////////////////////////////////////////////////
// GENERATED BY FLUTTIFY. DO NOT EDIT IT.
//////////////////////////////////////////////////////////

import 'dart:typed_data';

import 'package:amap_map_fluttify/src/ios/ios.export.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:foundation_fluttify/foundation_fluttify.dart';
import 'package:core_location_fluttify/core_location_fluttify.dart';

class MAPointAnnotation extends MAShape with MAAnnotation {
  //region constants
  static const String name__ = 'MAPointAnnotation';

  
  //endregion

  //region creators
  static Future<MAPointAnnotation> create__() async {
    final int refId = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('ObjectFactory::createMAPointAnnotation');
    final object = MAPointAnnotation()..refId = refId..tag__ = 'amap_map_fluttify';
  
    kNativeObjectPool.add(object);
    return object;
  }
  
  static Future<List<MAPointAnnotation>> create_batch__(int length) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
    final List resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('ObjectFactory::create_batchMAPointAnnotation', {'length': length});
  
    final List<MAPointAnnotation> typedResult = resultBatch.map((result) => MAPointAnnotation()..refId = result..tag__ = 'amap_map_fluttify').toList();
    kNativeObjectPool.addAll(typedResult);
    return typedResult;
  }
  
  //endregion

  //region getters
  Future<CLLocationCoordinate2D> get_coordinate() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MAPointAnnotation::get_coordinate", {'refId': refId});
    kNativeObjectPool.add(CLLocationCoordinate2D()..refId = __result__..tag__ = 'amap_map_fluttify');
    return CLLocationCoordinate2D()..refId = __result__..tag__ = 'amap_map_fluttify';
  }
  
  Future<bool> get_lockedToScreen() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MAPointAnnotation::get_isLockedToScreen", {'refId': refId});
  
    return __result__;
  }
  
  Future<CGPoint> get_lockedScreenPoint() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MAPointAnnotation::get_lockedScreenPoint", {'refId': refId});
    kNativeObjectPool.add(CGPoint()..refId = __result__..tag__ = 'amap_map_fluttify');
    return CGPoint()..refId = __result__..tag__ = 'amap_map_fluttify';
  }
  
  //endregion

  //region setters
  Future<void> set_coordinate(CLLocationCoordinate2D coordinate) async {
    await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAPointAnnotation::set_coordinate', {'refId': refId, "coordinate": coordinate.refId});
  
  
  }
  
  Future<void> set_lockedToScreen(bool lockedToScreen) async {
    await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAPointAnnotation::set_lockedToScreen', {'refId': refId, "lockedToScreen": lockedToScreen});
  
  
  }
  
  Future<void> set_lockedScreenPoint(CGPoint lockedScreenPoint) async {
    await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAPointAnnotation::set_lockedScreenPoint', {'refId': refId, "lockedScreenPoint": lockedScreenPoint.refId});
  
  
  }
  
  //endregion

  //region methods
  
  //endregion
}

extension MAPointAnnotation_Batch on List<MAPointAnnotation> {
  //region getters
  Future<List<CLLocationCoordinate2D>> get_coordinate_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MAPointAnnotation::get_coordinate_batch", [for (final __item__ in this) {'refId': __item__.refId}]);
    final typedResult = (resultBatch as List).cast<int>().map((__result__) => CLLocationCoordinate2D()..refId = __result__..tag__ = 'amap_map_fluttify').toList();
    kNativeObjectPool.addAll(typedResult);
    return typedResult;
  }
  
  Future<List<bool>> get_lockedToScreen_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MAPointAnnotation::get_isLockedToScreen_batch", [for (final __item__ in this) {'refId': __item__.refId}]);
    final typedResult = (resultBatch as List).cast<bool>().map((__result__) => __result__).toList();
  
    return typedResult;
  }
  
  Future<List<CGPoint>> get_lockedScreenPoint_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MAPointAnnotation::get_lockedScreenPoint_batch", [for (final __item__ in this) {'refId': __item__.refId}]);
    final typedResult = (resultBatch as List).cast<int>().map((__result__) => CGPoint()..refId = __result__..tag__ = 'amap_map_fluttify').toList();
    kNativeObjectPool.addAll(typedResult);
    return typedResult;
  }
  
  //endregion

  //region setters
  Future<void> set_coordinate_batch(List<CLLocationCoordinate2D> coordinate) async {
    await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAPointAnnotation::set_coordinate_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {'refId': this[__i__].refId, "coordinate": coordinate[__i__].refId}]);
  
  
  }
  
  Future<void> set_lockedToScreen_batch(List<bool> lockedToScreen) async {
    await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAPointAnnotation::set_lockedToScreen_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {'refId': this[__i__].refId, "lockedToScreen": lockedToScreen[__i__]}]);
  
  
  }
  
  Future<void> set_lockedScreenPoint_batch(List<CGPoint> lockedScreenPoint) async {
    await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAPointAnnotation::set_lockedScreenPoint_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {'refId': this[__i__].refId, "lockedScreenPoint": lockedScreenPoint[__i__].refId}]);
  
  
  }
  
  //endregion

  //region methods
  
  //endregion
}