//////////////////////////////////////////////////////////
// GENERATED BY FLUTTIFY. DO NOT EDIT IT.
//////////////////////////////////////////////////////////

#import "AmapMapFluttifyPlugin.h"
#import <objc/runtime.h>
#import "SubHandler/SubHandler0.h"
#import "SubHandler/SubHandler1.h"
#import "SubHandler/SubHandler2.h"
#import "SubHandler/SubHandler3.h"
#import "SubHandler/SubHandler4.h"
#import "SubHandler/SubHandler5.h"
#import "SubHandler/SubHandler6.h"
#import "SubHandler/SubHandler7.h"
#import "SubHandler/Custom/SubHandlerCustom.h"

// Dart端一次方法调用所存在的栈, 只有当MethodChannel传递参数受限时, 再启用这个容器
extern NSMutableDictionary<NSString*, NSObject*>* STACK;
// Dart端随机存取对象的容器
extern NSMutableDictionary<NSNumber*, NSObject*>* HEAP;
// 日志打印开关
extern BOOL enableLog;

@implementation AmapMapFluttifyPlugin {
  NSMutableDictionary<NSString*, Handler>* _handlerMap;
}

- (instancetype) initWithFlutterPluginRegistrar: (NSObject <FlutterPluginRegistrar> *) registrar {
  self = [super init];
  if (self) {
    _registrar = registrar;
    // 处理方法们
    _handlerMap = @{}.mutableCopy;

    [_handlerMap addEntriesFromDictionary: [self getSubHandler0]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler1]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler2]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler3]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler4]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler5]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler6]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandler7]];
    [_handlerMap addEntriesFromDictionary: [self getSubHandlerCustom]];
  }

  return self;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"me.yohom/amap_map_fluttify"
            binaryMessenger:[registrar messenger]];

  [registrar addMethodCallDelegate:[[AmapMapFluttifyPlugin alloc] initWithFlutterPluginRegistrar:registrar]
                           channel:channel];

  // 注册View
  [registrar registerViewFactory: [[MAPinAnnotationViewFactory alloc] initWithRegistrar:registrar] withId: @"me.yohom/MAPinAnnotationView"];
  [registrar registerViewFactory: [[MAAnnotationViewFactory alloc] initWithRegistrar:registrar] withId: @"me.yohom/MAAnnotationView"];
  [registrar registerViewFactory: [[MACustomCalloutViewFactory alloc] initWithRegistrar:registrar] withId: @"me.yohom/MACustomCalloutView"];
  [registrar registerViewFactory: [[MAMapViewFactory alloc] initWithRegistrar:registrar] withId: @"me.yohom/MAMapView"];
}

// Method Handlers
- (void)handleMethodCall:(FlutterMethodCall *)methodCall result:(FlutterResult)methodResult {
  if (_handlerMap[methodCall.method] != nil) {
    _handlerMap[methodCall.method](_registrar, [methodCall arguments], methodResult);
  } else {
    methodResult(FlutterMethodNotImplemented);
  }
}

// 委托方法们
- (void)traceManager : (MATraceManager*)manager didTrace: (NSArray<CLLocation*>*)locations correct: (NSArray<MATracePoint*>*)tracePoints distance: (double)distance withError: (NSError*)error
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MATraceDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MATraceDelegate::traceManager_didTrace_correct_distance_withError");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmanager = [NSNull null];
  if (manager != nil) {
      argmanager = @(manager.hash);
      HEAP[argmanager] = manager;
  }
  
  // list callback arg
  NSMutableArray<NSNumber*>* arglocations = [NSMutableArray arrayWithCapacity:locations.count];
  for (int __i__ = 0; __i__ < locations.count; __i__++) {
      NSObject* item = ((NSObject*) [locations objectAtIndex:__i__]);
      // return to dart side data
      arglocations[__i__] = @(item.hash);
      // add to HEAP
      HEAP[@(item.hash)] = item;
  }
  // list callback arg
  NSMutableArray<NSNumber*>* argtracePoints = [NSMutableArray arrayWithCapacity:tracePoints.count];
  for (int __i__ = 0; __i__ < tracePoints.count; __i__++) {
      NSObject* item = ((NSObject*) [tracePoints objectAtIndex:__i__]);
      // return to dart side data
      argtracePoints[__i__] = @(item.hash);
      // add to HEAP
      HEAP[@(item.hash)] = item;
  }
  // primitive callback arg
  NSNumber* argdistance = @(distance);
  // ref callback arg
  NSNumber* argerror = [NSNull null];
  if (error != nil) {
      argerror = @(error.hash);
      HEAP[argerror] = error;
  }
  

  [channel invokeMethod:@"Callback::MATraceDelegate::traceManager_didTrace_correct_distance_withError" arguments:@{@"manager": argmanager, @"locations": arglocations, @"tracePoints": argtracePoints, @"distance": argdistance, @"error": argerror}];
  
}

- (void)mapViewRequireLocationAuth : (CLLocationManager*)locationManager
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MATraceDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MATraceDelegate::mapViewRequireLocationAuth");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* arglocationManager = [NSNull null];
  if (locationManager != nil) {
      arglocationManager = @(locationManager.hash);
      HEAP[arglocationManager] = locationManager;
  }
  

  [channel invokeMethod:@"Callback::MATraceDelegate::mapViewRequireLocationAuth" arguments:@{@"locationManager": arglocationManager}];
  
}

- (void)multiPointOverlayRenderer : (MAMultiPointOverlayRenderer*)renderer didItemTapped: (MAMultiPointItem*)item
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMultiPointOverlayRendererDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMultiPointOverlayRendererDelegate::multiPointOverlayRenderer_didItemTapped");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argrenderer = [NSNull null];
  if (renderer != nil) {
      argrenderer = @(renderer.hash);
      HEAP[argrenderer] = renderer;
  }
  
  // ref callback arg
  NSNumber* argitem = [NSNull null];
  if (item != nil) {
      argitem = @(item.hash);
      HEAP[argitem] = item;
  }
  

  [channel invokeMethod:@"Callback::MAMultiPointOverlayRendererDelegate::multiPointOverlayRenderer_didItemTapped" arguments:@{@"renderer": argrenderer, @"item": argitem}];
  
}

- (void)mapViewRegionChanged : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapViewRegionChanged");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapViewRegionChanged" arguments:@{@"mapView": argmapView}];
  
}

- (void)mapView : (MAMapView*)mapView regionWillChangeAnimated: (BOOL)animated
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_regionWillChangeAnimated");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* arganimated = @(animated);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_regionWillChangeAnimated" arguments:@{@"mapView": argmapView, @"animated": arganimated}];
  
}

- (void)mapView : (MAMapView*)mapView regionDidChangeAnimated: (BOOL)animated
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_regionDidChangeAnimated");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* arganimated = @(animated);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_regionDidChangeAnimated" arguments:@{@"mapView": argmapView, @"animated": arganimated}];
  
}

- (void)mapView : (MAMapView*)mapView mapWillMoveByUser: (BOOL)wasUserAction
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_mapWillMoveByUser");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* argwasUserAction = @(wasUserAction);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_mapWillMoveByUser" arguments:@{@"mapView": argmapView, @"wasUserAction": argwasUserAction}];
  
}

- (void)mapView : (MAMapView*)mapView mapDidMoveByUser: (BOOL)wasUserAction
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_mapDidMoveByUser");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* argwasUserAction = @(wasUserAction);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_mapDidMoveByUser" arguments:@{@"mapView": argmapView, @"wasUserAction": argwasUserAction}];
  
}

- (void)mapView : (MAMapView*)mapView mapWillZoomByUser: (BOOL)wasUserAction
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_mapWillZoomByUser");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* argwasUserAction = @(wasUserAction);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_mapWillZoomByUser" arguments:@{@"mapView": argmapView, @"wasUserAction": argwasUserAction}];
  
}

- (void)mapView : (MAMapView*)mapView mapDidZoomByUser: (BOOL)wasUserAction
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_mapDidZoomByUser");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* argwasUserAction = @(wasUserAction);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_mapDidZoomByUser" arguments:@{@"mapView": argmapView, @"wasUserAction": argwasUserAction}];
  
}

- (void)mapViewWillStartLoadingMap : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapViewWillStartLoadingMap");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapViewWillStartLoadingMap" arguments:@{@"mapView": argmapView}];
  
}

- (void)mapViewDidFinishLoadingMap : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapViewDidFinishLoadingMap");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapViewDidFinishLoadingMap" arguments:@{@"mapView": argmapView}];
  
}

- (void)mapViewDidFailLoadingMap : (MAMapView*)mapView withError: (NSError*)error
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapViewDidFailLoadingMap_withError");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argerror = [NSNull null];
  if (error != nil) {
      argerror = @(error.hash);
      HEAP[argerror] = error;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapViewDidFailLoadingMap_withError" arguments:@{@"mapView": argmapView, @"error": argerror}];
  
}

- (MAAnnotationView*)mapView : (MAMapView*)mapView viewForAnnotation: (id<MAAnnotation>)annotation
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_viewForAnnotation");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argannotation = [NSNull null];
  if (annotation != nil) {
      argannotation = @(annotation.hash);
      HEAP[argannotation] = annotation;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_viewForAnnotation"
              arguments:@{}
                 result:^(id result) {}]; // 由于结果是异步返回, 这里用不上, 所以就不生成代码了
  
  // 由于flutter无法同步调用method channel, 所以暂不支持有返回值的回调方法
  // 相关issue https://github.com/flutter/flutter/issues/28310
  NSLog(@"暂不支持有返回值的回调方法");
  
  ////////////////////////////如果需要手写代码, 请写在这里/////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////
  
  return nil;
}

- (void)mapView : (MAMapView*)mapView didAddAnnotationViews: (NSArray*)views
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didAddAnnotationViews");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // list callback arg
  NSMutableArray<NSNumber*>* argviews = [NSMutableArray arrayWithCapacity:views.count];
  for (int __i__ = 0; __i__ < views.count; __i__++) {
      NSObject* item = ((NSObject*) [views objectAtIndex:__i__]);
      // return to dart side data
      argviews[__i__] = @(item.hash);
      // add to HEAP
      HEAP[@(item.hash)] = item;
  }

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didAddAnnotationViews" arguments:@{@"mapView": argmapView, @"views": argviews}];
  
}

- (void)mapView : (MAMapView*)mapView didSelectAnnotationView: (MAAnnotationView*)view
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didSelectAnnotationView");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argview = [NSNull null];
  if (view != nil) {
      argview = @(view.hash);
      HEAP[argview] = view;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didSelectAnnotationView" arguments:@{@"mapView": argmapView, @"view": argview}];
  
}

- (void)mapView : (MAMapView*)mapView didDeselectAnnotationView: (MAAnnotationView*)view
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didDeselectAnnotationView");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argview = [NSNull null];
  if (view != nil) {
      argview = @(view.hash);
      HEAP[argview] = view;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didDeselectAnnotationView" arguments:@{@"mapView": argmapView, @"view": argview}];
  
}

- (void)mapViewWillStartLocatingUser : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapViewWillStartLocatingUser");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapViewWillStartLocatingUser" arguments:@{@"mapView": argmapView}];
  
}

- (void)mapViewDidStopLocatingUser : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapViewDidStopLocatingUser");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapViewDidStopLocatingUser" arguments:@{@"mapView": argmapView}];
  
}

- (void)mapView : (MAMapView*)mapView didUpdateUserLocation: (MAUserLocation*)userLocation updatingLocation: (BOOL)updatingLocation
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didUpdateUserLocation_updatingLocation");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* arguserLocation = [NSNull null];
  if (userLocation != nil) {
      arguserLocation = @(userLocation.hash);
      HEAP[arguserLocation] = userLocation;
  }
  
  // primitive callback arg
  NSNumber* argupdatingLocation = @(updatingLocation);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didUpdateUserLocation_updatingLocation" arguments:@{@"mapView": argmapView, @"userLocation": arguserLocation, @"updatingLocation": argupdatingLocation}];
  
}

- (void)mapView : (MAMapView*)mapView didFailToLocateUserWithError: (NSError*)error
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didFailToLocateUserWithError");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argerror = [NSNull null];
  if (error != nil) {
      argerror = @(error.hash);
      HEAP[argerror] = error;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didFailToLocateUserWithError" arguments:@{@"mapView": argmapView, @"error": argerror}];
  
}

- (void)mapView : (MAMapView*)mapView annotationView: (MAAnnotationView*)view didChangeDragState: (MAAnnotationViewDragState)newState fromOldState: (MAAnnotationViewDragState)oldState
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_annotationView_didChangeDragState_fromOldState");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argview = [NSNull null];
  if (view != nil) {
      argview = @(view.hash);
      HEAP[argview] = view;
  }
  
  // enum callback arg
  NSNumber* argnewState = @((NSInteger) newState);
  // enum callback arg
  NSNumber* argoldState = @((NSInteger) oldState);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_annotationView_didChangeDragState_fromOldState" arguments:@{@"mapView": argmapView, @"view": argview, @"newState": argnewState, @"oldState": argoldState}];
  
}

- (MAOverlayRenderer*)mapView : (MAMapView*)mapView rendererForOverlay: (id<MAOverlay>)overlay
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_rendererForOverlay");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argoverlay = [NSNull null];
  if (overlay != nil) {
      argoverlay = @(overlay.hash);
      HEAP[argoverlay] = overlay;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_rendererForOverlay"
              arguments:@{}
                 result:^(id result) {}]; // 由于结果是异步返回, 这里用不上, 所以就不生成代码了
  
  // 由于flutter无法同步调用method channel, 所以暂不支持有返回值的回调方法
  // 相关issue https://github.com/flutter/flutter/issues/28310
  NSLog(@"暂不支持有返回值的回调方法");
  
  ////////////////////////////如果需要手写代码, 请写在这里/////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////
  
  return nil;
}

- (void)mapView : (MAMapView*)mapView didAddOverlayRenderers: (NSArray*)overlayRenderers
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didAddOverlayRenderers");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // list callback arg
  NSMutableArray<NSNumber*>* argoverlayRenderers = [NSMutableArray arrayWithCapacity:overlayRenderers.count];
  for (int __i__ = 0; __i__ < overlayRenderers.count; __i__++) {
      NSObject* item = ((NSObject*) [overlayRenderers objectAtIndex:__i__]);
      // return to dart side data
      argoverlayRenderers[__i__] = @(item.hash);
      // add to HEAP
      HEAP[@(item.hash)] = item;
  }

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didAddOverlayRenderers" arguments:@{@"mapView": argmapView, @"overlayRenderers": argoverlayRenderers}];
  
}

- (void)mapView : (MAMapView*)mapView annotationView: (MAAnnotationView*)view calloutAccessoryControlTapped: (UIControl*)control
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_annotationView_calloutAccessoryControlTapped");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argview = [NSNull null];
  if (view != nil) {
      argview = @(view.hash);
      HEAP[argview] = view;
  }
  
  // ref callback arg
  NSNumber* argcontrol = [NSNull null];
  if (control != nil) {
      argcontrol = @(control.hash);
      HEAP[argcontrol] = control;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_annotationView_calloutAccessoryControlTapped" arguments:@{@"mapView": argmapView, @"view": argview, @"control": argcontrol}];
  
}

- (void)mapView : (MAMapView*)mapView didAnnotationViewCalloutTapped: (MAAnnotationView*)view
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didAnnotationViewCalloutTapped");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argview = [NSNull null];
  if (view != nil) {
      argview = @(view.hash);
      HEAP[argview] = view;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didAnnotationViewCalloutTapped" arguments:@{@"mapView": argmapView, @"view": argview}];
  
}

- (void)mapView : (MAMapView*)mapView didAnnotationViewTapped: (MAAnnotationView*)view
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didAnnotationViewTapped");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argview = [NSNull null];
  if (view != nil) {
      argview = @(view.hash);
      HEAP[argview] = view;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didAnnotationViewTapped" arguments:@{@"mapView": argmapView, @"view": argview}];
  
}

- (void)mapView : (MAMapView*)mapView didChangeUserTrackingMode: (MAUserTrackingMode)mode animated: (BOOL)animated
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didChangeUserTrackingMode_animated");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // enum callback arg
  NSNumber* argmode = @((NSInteger) mode);
  // primitive callback arg
  NSNumber* arganimated = @(animated);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didChangeUserTrackingMode_animated" arguments:@{@"mapView": argmapView, @"mode": argmode, @"animated": arganimated}];
  
}

- (void)mapView : (MAMapView*)mapView didChangeOpenGLESDisabled: (BOOL)openGLESDisabled
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didChangeOpenGLESDisabled");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // primitive callback arg
  NSNumber* argopenGLESDisabled = @(openGLESDisabled);

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didChangeOpenGLESDisabled" arguments:@{@"mapView": argmapView, @"openGLESDisabled": argopenGLESDisabled}];
  
}

- (void)mapView : (MAMapView*)mapView didTouchPois: (NSArray*)pois
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didTouchPois");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // list callback arg
  NSMutableArray<NSNumber*>* argpois = [NSMutableArray arrayWithCapacity:pois.count];
  for (int __i__ = 0; __i__ < pois.count; __i__++) {
      NSObject* item = ((NSObject*) [pois objectAtIndex:__i__]);
      // return to dart side data
      argpois[__i__] = @(item.hash);
      // add to HEAP
      HEAP[@(item.hash)] = item;
  }

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didTouchPois" arguments:@{@"mapView": argmapView, @"pois": argpois}];
  
}

- (void)mapView : (MAMapView*)mapView didSingleTappedAtCoordinate: (CLLocationCoordinate2D)coordinate
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didSingleTappedAtCoordinate");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // struct callback arg
  NSValue* coordinateValue = [NSValue value:&coordinate withObjCType:@encode(CLLocationCoordinate2D)];
  NSNumber* argcoordinate = @(coordinateValue.hash);
  HEAP[argcoordinate] = coordinateValue;
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didSingleTappedAtCoordinate" arguments:@{@"mapView": argmapView, @"coordinate": argcoordinate}];
  
}

- (void)mapView : (MAMapView*)mapView didLongPressedAtCoordinate: (CLLocationCoordinate2D)coordinate
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didLongPressedAtCoordinate");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // struct callback arg
  NSValue* coordinateValue = [NSValue value:&coordinate withObjCType:@encode(CLLocationCoordinate2D)];
  NSNumber* argcoordinate = @(coordinateValue.hash);
  HEAP[argcoordinate] = coordinateValue;
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didLongPressedAtCoordinate" arguments:@{@"mapView": argmapView, @"coordinate": argcoordinate}];
  
}

- (void)mapInitComplete : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapInitComplete");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapInitComplete" arguments:@{@"mapView": argmapView}];
  
}

- (void)mapView : (MAMapView*)mapView didIndoorMapShowed: (MAIndoorInfo*)indoorInfo
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didIndoorMapShowed");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argindoorInfo = [NSNull null];
  if (indoorInfo != nil) {
      argindoorInfo = @(indoorInfo.hash);
      HEAP[argindoorInfo] = indoorInfo;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didIndoorMapShowed" arguments:@{@"mapView": argmapView, @"indoorInfo": argindoorInfo}];
  
}

- (void)mapView : (MAMapView*)mapView didIndoorMapFloorIndexChanged: (MAIndoorInfo*)indoorInfo
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didIndoorMapFloorIndexChanged");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argindoorInfo = [NSNull null];
  if (indoorInfo != nil) {
      argindoorInfo = @(indoorInfo.hash);
      HEAP[argindoorInfo] = indoorInfo;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didIndoorMapFloorIndexChanged" arguments:@{@"mapView": argmapView, @"indoorInfo": argindoorInfo}];
  
}

- (void)mapView : (MAMapView*)mapView didIndoorMapHidden: (MAIndoorInfo*)indoorInfo
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::mapView_didIndoorMapHidden");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  
  // ref callback arg
  NSNumber* argindoorInfo = [NSNull null];
  if (indoorInfo != nil) {
      argindoorInfo = @(indoorInfo.hash);
      HEAP[argindoorInfo] = indoorInfo;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::mapView_didIndoorMapHidden" arguments:@{@"mapView": argmapView, @"indoorInfo": argindoorInfo}];
  
}

- (void)offlineDataWillReload : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::offlineDataWillReload");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::offlineDataWillReload" arguments:@{@"mapView": argmapView}];
  
}

- (void)offlineDataDidReload : (MAMapView*)mapView
{
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"MAMapViewDelegate::Callback"
            binaryMessenger:[_registrar messenger]];
  // print log
  if (enableLog) {
    NSLog(@"MAMapViewDelegate::offlineDataDidReload");
  }

  // convert to jsonable arg
  // ref callback arg
  NSNumber* argmapView = [NSNull null];
  if (mapView != nil) {
      argmapView = @(mapView.hash);
      HEAP[argmapView] = mapView;
  }
  

  [channel invokeMethod:@"Callback::MAMapViewDelegate::offlineDataDidReload" arguments:@{@"mapView": argmapView}];
  
}


@end