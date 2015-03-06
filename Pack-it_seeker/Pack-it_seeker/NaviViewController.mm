//
//  NaviViewController.m
//  Pack-it_seeker
//
//  Created by Jiyang on 3/6/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "NaviViewController.h"


@interface NaviViewController ()

@end

@implementation NaviViewController
@synthesize locationManager = _locationManager;
@synthesize destShop = _destShop;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //适配iOS8
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8 && self.locationManager == nil) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        self.locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        //NSLog(@"iOS8");
    }
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [self initMap];
    [self initSearch];
    [self initTypeSwitcher];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    
    _locService.delegate = self;
    _poiSearcher.delegate = self;
    _geoCodeSearcher.delegate = self;
    _routeSearcher.delegate = self;
    
    NSLog(@"viewWillAppear");
    [self initDestShop];
}

- (void)viewDidAppear:(BOOL)animated {
    [self showLocation];
    [self showCurrentLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navi Type Switch

- (void)initTypeSwitcher {
    [_typeSwitcher addTarget:self action:@selector(switchType:) forControlEvents:UIControlEventValueChanged];
    
    _typeSwitcher.selectedSegmentIndex = 0;
    
}

- (void)switchType:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    
    //NSLog(@"Index %li", (long)index);
    switch (index) {
        //walk
        case 0:
            [self showWalkingRoute];
            break;
        //drive
        case 1:
            [self showDrivingRoute];
            break;
        //bus
        case 2:
            [self showBusRoute];
            break;
        default:
            break;
    }
}

#pragma mark - Init
- (void) initMap {
    
    [_mapView setUserInteractionEnabled:YES];
    
    [_mapView setZoomEnabled:YES];
    
    //显示比例尺
    _mapView.showMapScaleBar = true;
    
    
}

- (void)initDestShop {
    if (!_destShop) {
        return;
    }
    _destAnnotation = [[BMKPointAnnotation alloc]init];
    _destAnnotation.coordinate = CLLocationCoordinate2DMake(114.271499, 22.326487);
    
    _destAnnotation.title = _destShop.name;
    _destAnnotation.subtitle = _destShop.address;
    
    
    CLLocationDegrees latDelta = 0.01;
    CLLocationDegrees lonDelta = 0.01;
    BMKCoordinateSpan theSpan = BMKCoordinateSpanMake(latDelta, lonDelta);
    BMKCoordinateRegion theRegion = BMKCoordinateRegionMake(CLLocationCoordinate2DMake(_destAnnotation.coordinate.latitude, _destAnnotation.coordinate.longitude), theSpan);
    [_mapView setRegion:theRegion animated:true];
    
    [_mapView setCenterCoordinate:_destAnnotation.coordinate animated:true];
    
    //[self poiToAnnotation:_destAnnotation];
}

- (void) initSearch{
    _poiSearcher = [[BMKPoiSearch alloc] init];
    _geoCodeSearcher =[[BMKGeoCodeSearch alloc] init];
    _routeSearcher = [[BMKRouteSearch alloc] init];
}

#pragma mark - Buttons Action
- (void)showCurrentLocation {
    NSLog(@"进入普通定位态");
    if (_locService) {
        //显示当前位置页面
        NSLog(@"my location: longitude: %f, latitude: %f", _locService.userLocation.location.coordinate.longitude, _locService.userLocation.location.coordinate.latitude);
        [_mapView setCenterCoordinate:_locService.userLocation.location.coordinate animated:true];
    }
}


- (void)showDrivingRoute {
    if (_destAnnotation == nil || _locService.userLocation == nil) {
        return;
    }
    [_mapView showAnnotations:@[_destAnnotation, _locService.userLocation.location] animated:true];
    [self searchDriveRoute];
}

- (void)showBusRoute {
    if (_destAnnotation == nil || _locService.userLocation == nil) {
        return;
    }
    [_mapView showAnnotations:@[_destAnnotation, _locService.userLocation.location] animated:true];
    [self searchTransitRoute];
}

- (void)showWalkingRoute {
    if (_destAnnotation == nil || _locService.userLocation == nil) {
        return;
    }
    [_mapView showAnnotations:@[_destAnnotation, _locService.userLocation.location] animated:true];
    [self searchWalkingRoute];
}
- (void)cancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Action
- (void)showLocation{
    if(_locService == nil || _mapView == nil){
        NSLog(@"initLocate Error");
        return;
    }
    
    //启动LocationService
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}

//通过关键词搜索Poi
- (void)searchPoiByKeyword: (NSString *)keyword{
    if(_locService == nil || _mapView == nil || _poiSearcher == nil){
        NSLog(@"initLocate Error");
        return;
    }
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"深圳";
    citySearchOption.keyword = keyword;
    BOOL flag = [_poiSearcher poiSearchInCity:citySearchOption];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
    
}

//通过UID搜索Poi
- (void)searchPoiByUID: (NSString *)uid{
    if(_locService == nil || _mapView == nil || _poiSearcher == nil){
        NSLog(@"initLocate Error");
        return;
    }
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = uid;
    BOOL flag = [_poiSearcher poiDetailSearch:option];
    if(flag)
    {
        NSLog(@"UID检索发送成功");
    }
    else
    {
        NSLog(@"UID检索发送失败");
    }
    
    
}

//步行
- (void)searchWalkingRoute{
    if(_locService == nil || _mapView == nil || _routeSearcher == nil){
        NSLog(@"revokeWalkingRouteSearch Error");
        return;
    }
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //start.name = @"海龙大厦";
    start.pt = _locService.userLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //end.name = MALL_NAME;
    end.pt = _destAnnotation.coordinate;
    
    NSLog(@"route start %f - %f", start.pt.latitude, start.pt.longitude);
    
    NSLog(@"route end %f - %f", _destAnnotation.coordinate.latitude, _destAnnotation.coordinate.longitude);
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    //walkingRouteSearchOption.city= @"深圳市";
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routeSearcher walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"Route检索发送成功");
    }
    else
    {
        NSLog(@"Route检索发送失败");
    }
    
}

//驾车
- (void)searchDriveRoute{
    if(_locService == nil || _mapView == nil || _routeSearcher == nil){
        NSLog(@"revokeDriveRouteSearch Error");
        return;
    }
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //start.name = @"海龙大厦";
    start.pt = _locService.userLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //end.name = MALL_NAME;
    end.pt = _destAnnotation.coordinate;
    
    NSLog(@"drive route start %f - %f", start.pt.latitude, start.pt.longitude);
    
    NSLog(@"drive route end %f - %f", _destAnnotation.coordinate.latitude, _destAnnotation.coordinate.longitude);
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearcher drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"Route检索发送成功");
    }
    else
    {
        NSLog(@"Route检索发送失败");
    }
    
}

//公交
- (void)searchTransitRoute{
    if(_locService == nil || _mapView == nil || _routeSearcher == nil){
        NSLog(@"revokeTransitRouteSearch Error");
        return;
    }
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //start.name = @"海龙大厦";
    start.pt = _locService.userLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //end.name = MALL_NAME;
    end.pt = _destAnnotation.coordinate;
    
    //NSLog(@"route start %f - %f", start.pt.latitude, start.pt.longitude);
    
    //NSLog(@"route end %f - %f", _destAnnotation.coordinate.latitude, _destAnnotation.coordinate.longitude);
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city = @"香港";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routeSearcher transitSearch:transitRouteSearchOption];
    if(flag)
    {
        NSLog(@"Route检索发送成功");
    }
    else
    {
        NSLog(@"Route检索发送失败");
    }
    
}

//
- (void) poiToAnnotation:(BMKPointAnnotation *)pointAnnotation{
    if (pointAnnotation == nil) {
        return;
    }
    
    [_mapView addAnnotation:pointAnnotation];
}

//发起反向地理编码检索
- (void) searchReverseGeoCode:(CLLocationCoordinate2D) coordinate{
    if (_geoCodeSearcher == nil) {
        NSLog(@"_geoCodeSearcher == nil");
        return;
    }
    if (coordinate.latitude) {
        NSLog(@"_geoCodeSearcher location != nil");
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
        BOOL flag = [_geoCodeSearcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    }
    
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}


#pragma mark - Baidu Map Delegate Methods
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    //NSLog(@"willStartLocatingUser");
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //NSLog(@"regionDidChangeAnimated");
}

#pragma mark Search delegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"SearchPoi result: %@", poiResult.poiInfoList);
        BMKPoiInfo *poiInfo;
        
        for (NSUInteger i = 0; i < poiResult.poiInfoList.count; ++i) {
            poiInfo = [poiResult.poiInfoList objectAtIndex:i];
            NSLog(@"SearchPoi result name: %@ uid: %@", poiInfo.name, poiInfo.uid);
        }
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    NSLog(@"poidetail search error:  %u", errorCode);
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"SearchPoi result: %@, address: %@", poiDetailResult.name, poiDetailResult.address);
        //NSLog(@"SearchPoi result name: %@ uid: %@", [[poiResult.poiInfoList objectAtIndex:0] name], [[poiResult.poiInfoList objectAtIndex:0] uid]);
        
        _destAnnotation = [[BMKPointAnnotation alloc]init];
        _destAnnotation.coordinate = poiDetailResult.pt;
        _destAnnotation.title = poiDetailResult.name;
        _destAnnotation.subtitle = poiDetailResult.address;
        
        [_mapView setCenterCoordinate:_destAnnotation.coordinate animated:true];
        
        [self poiToAnnotation:_destAnnotation];
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark Map delegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    //annotation in the route
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        NSLog(@"-------Click RouteAnnotation");
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    //
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        //NSLog(@"-------Click BMKPointAnnotation");
        static NSString *reuseID = @"annotationReuseIdentifier";
        //NSLog(@"reuseID: %@", reuseID);
        
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
        if(newAnnotationView == nil){
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
            
        }
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.canShowCallout = YES;
        return newAnnotationView;
    }
    return nil;
}

/**
 *根据route anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //选中annotation为当前用户location时
    if ([view .annotation isKindOfClass:[BMKUserLocation class]]) {
        [self searchReverseGeoCode:_locService.userLocation.location.coordinate];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    //NSLog(@"GetReverseGeoCodeResultError %u", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        if (result != nil) {
            
            NSString *title = [[result addressDetail] city];
            if(title.length == 0){
                title = [[result addressDetail] province];
            }
            NSLog(@"reverseGeoResult:city: %@", title);
            
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = result.location;
            item.title = title;
            item.subtitle = result.address;
            [_mapView addAnnotation:item];
            _mapView.centerCoordinate = result.location;
            
            //_locService.userLocation.title = title;
            //_locService.userLocation.subtitle = [result address];
            
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

/**
 *返回步行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKWalkingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    NSLog(@"onGetWalkingRouteResult Error %u", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
    
}


/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    NSLog(@"onGetTransitRouteResult Error %u", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"onGetTransitRouteResult");
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        NSLog(@"onGetTransitRouteResult %lu", size);
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                //NSLog(@"轨迹点：x %f y %f", temppoints[i].x,temppoints[i].y);
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        
        //[_mapView showAnnotations:@[_destAnnotation, _locService.userLocation] animated:YES];
        //delete []temppoints;
    }
    
}

/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
