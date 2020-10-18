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

class _MAAnimatableAnnotation_SUB extends NSObject with MAAnimatableAnnotation {}

mixin MAAnimatableAnnotation on NSObject {
  

  static MAAnimatableAnnotation subInstance() => _MAAnimatableAnnotation_SUB();

  

  

  
  Future<void> step(double timeDelta) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAAnimatableAnnotation@$refId::step([\'timeDelta\':$timeDelta])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::step', {"timeDelta": timeDelta, "refId": refId});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
    
      return __return__;
    }
  }
  
  
  Future<bool> isAnimationFinished() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAAnimatableAnnotation@$refId::isAnimationFinished([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::isAnimationFinished', {"refId": refId});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
    
      return __return__;
    }
  }
  
  
  Future<bool> shouldAnimationStart() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAAnimatableAnnotation@$refId::shouldAnimationStart([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::shouldAnimationStart', {"refId": refId});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
    
      return __return__;
    }
  }
  
  
  Future<double> rotateDegree() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAAnimatableAnnotation@$refId::rotateDegree([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::rotateDegree', {"refId": refId});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
    
      return __return__;
    }
  }
  
}

extension MAAnimatableAnnotation_Batch on List<MAAnimatableAnnotation> {
  //region methods
  
  Future<List<void>> step_batch(List<double> timeDelta) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::step_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {"timeDelta": timeDelta[__i__], "refId": this[__i__].refId}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => __result__).toList();
    
      return typedResult;
    }
  }
  
  
  Future<List<bool>> isAnimationFinished_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::isAnimationFinished_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {"refId": this[__i__].refId}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<bool>().map((__result__) => __result__).toList();
    
      return typedResult;
    }
  }
  
  
  Future<List<bool>> shouldAnimationStart_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::shouldAnimationStart_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {"refId": this[__i__].refId}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<bool>().map((__result__) => __result__).toList();
    
      return typedResult;
    }
  }
  
  
  Future<List<double>> rotateDegree_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify').invokeMethod('MAAnimatableAnnotation::rotateDegree_batch', [for (int __i__ = 0; __i__ < this.length; __i__++) {"refId": this[__i__].refId}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<double>().map((__result__) => __result__).toList();
    
      return typedResult;
    }
  }
  
  //endregion
}