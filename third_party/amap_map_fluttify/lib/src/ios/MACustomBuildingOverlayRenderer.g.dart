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

class MACustomBuildingOverlayRenderer extends MAOverlayRenderer  {
  //region constants
  static const String name__ = 'MACustomBuildingOverlayRenderer';

  
  //endregion

  //region creators
  static Future<MACustomBuildingOverlayRenderer> create__() async {
    final int refId = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('ObjectFactory::createMACustomBuildingOverlayRenderer');
    final object = MACustomBuildingOverlayRenderer()..refId = refId..tag__ = 'amap_map_fluttify';
  
    kNativeObjectPool.add(object);
    return object;
  }
  
  static Future<List<MACustomBuildingOverlayRenderer>> create_batch__(int length) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
    final List resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('ObjectFactory::create_batchMACustomBuildingOverlayRenderer', {'length': length});
  
    final List<MACustomBuildingOverlayRenderer> typedResult = resultBatch.map((result) => MACustomBuildingOverlayRenderer()..refId = result..tag__ = 'amap_map_fluttify').toList();
    kNativeObjectPool.addAll(typedResult);
    return typedResult;
  }
  
  //endregion

  //region getters
  Future<MACustomBuildingOverlay> get_customBuildingOverlay() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MACustomBuildingOverlayRenderer::get_customBuildingOverlay", {'refId': refId});
    kNativeObjectPool.add(MACustomBuildingOverlay()..refId = __result__..tag__ = 'amap_map_fluttify');
    return MACustomBuildingOverlay()..refId = __result__..tag__ = 'amap_map_fluttify';
  }
  
  //endregion

  //region setters
  
  //endregion

  //region methods
  
  Future<MACustomBuildingOverlayRenderer> initWithCustomBuildingOverlay(MACustomBuildingOverlay customBuildingOverlay) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MACustomBuildingOverlayRenderer@$refId::initWithCustomBuildingOverlay([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MACustomBuildingOverlayRenderer::initWithCustomBuildingOverlay', {"customBuildingOverlay": customBuildingOverlay?.refId, "refId": refId});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = MACustomBuildingOverlayRenderer()..refId = __result__..tag__ = 'amap_map_fluttify';
      if (__return__ is Ref) kNativeObjectPool.add(__return__);
      return __return__;
    }
  }
  
  //endregion
}

extension MACustomBuildingOverlayRenderer_Batch on List<MACustomBuildingOverlayRenderer> {
  //region getters
  Future<List<MACustomBuildingOverlay>> get_customBuildingOverlay_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod("MACustomBuildingOverlayRenderer::get_customBuildingOverlay_batch", [for (final __item__ in this) {'refId': __item__.refId}]);
    final typedResult = (resultBatch as List).cast<int>().map((__result__) => MACustomBuildingOverlay()..refId = __result__..tag__ = 'amap_map_fluttify').toList();
    kNativeObjectPool.addAll(typedResult);
    return typedResult;
  }
  
  //endregion

  //region setters
  
  //endregion

  //region methods
  
  Future<List<MACustomBuildingOverlayRenderer>> initWithCustomBuildingOverlay_batch(List<MACustomBuildingOverlay> customBuildingOverlay) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MACustomBuildingOverlayRenderer::initWithCustomBuildingOverlay_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {"customBuildingOverlay": customBuildingOverlay[__i__].refId, "refId": this[__i__].refId}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<int>().map((__result__) => MACustomBuildingOverlayRenderer()..refId = __result__..tag__ = 'amap_map_fluttify').toList();
      kNativeObjectPool.addAll(typedResult);
      return typedResult;
    }
  }
  
  //endregion
}