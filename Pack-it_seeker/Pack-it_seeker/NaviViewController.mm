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

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配iOS8
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8 && _locationManager == nil) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        _locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        //NSLog(@"iOS8");
    }
    
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
    }
    
    
    _destShop = [PXNetworkManager sharedStore].currentSolution.shop_profile;
    
    
    _routeSearch = [[BMKRouteSearch alloc] init];
    
    [self initTypeSwitcher];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routeSearch.delegate = self;
    
    //[self addDestShopAnnotation];
    [self showDrivingRoute];
    [self initMap];
}

- (void)viewDidAppear:(BOOL)animated {
    [self startPositioning];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routeSearch.delegate = nil; // 不用时，置nil
}

- (void)initMap {
    
    _mapView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - self.navigationController.navigationBar.frame.size.height);
    
    [_mapView setUserInteractionEnabled:YES];
    
    [_mapView setZoomEnabled:YES];
    
    //显示比例尺
    _mapView.showMapScaleBar = true;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Positioning

- (void)startPositioning {
    
    //启动LocationService
    [_locService startUserLocationService];
    
    NSLog(@"进入普通定位态");
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation != nil) {
        NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    }
    
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:true];
    
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
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
            //[self showWalkingRoute];
            break;
        //drive
        case 1:
            [self showDrivingRoute];
            break;
        //bus
        case 2:
            //[self showBusRoute];
            break;
        default:
            break;
    }
}

//在目标shop位置添加annotation
- (void)addDestShopAnnotation {
    if (!_destShop) {
        return;
    }
    _destAnnotation = [[BMKPointAnnotation alloc]init];
    _destAnnotation.coordinate = CLLocationCoordinate2DMake([[_destShop.location objectAtIndex:1] floatValue], [[_destShop.location objectAtIndex:0] floatValue]);
    ;
    _destAnnotation.title = _destShop.name;
    _destAnnotation.subtitle = _destShop.address;
    
    
//    CLLocationDegrees latDelta = 0.01;
//    CLLocationDegrees lonDelta = 0.01;
//    BMKCoordinateSpan theSpan = BMKCoordinateSpanMake(latDelta, lonDelta);
//    BMKCoordinateRegion theRegion = BMKCoordinateRegionMake(CLLocationCoordinate2DMake(_destAnnotation.coordinate.latitude, _destAnnotation.coordinate.longitude), theSpan);
//    [_mapView setRegion:theRegion animated:true];
//    
    [_mapView setCenterCoordinate:_destAnnotation.coordinate animated:true];
    
    [_mapView addAnnotation:_destAnnotation];
    

}

- (void)showFakeDrivingRoute {
    BMKPlanNode* start = [BMKPlanNode new];
    //start.pt = [PXNetworkManager sharedStore].currentLocation.coordinate;
    //start.pt = CLLocationCoordinate2DMake(40.002538, 116.32838);
    //start.pt = startL.coordinate;
    start.name = @"百度大厦";
    start.cityName = @"北京市";
    
    BMKPlanNode* end = [BMKPlanNode new];
    //end.pt = CLLocationCoordinate2DMake([[_destShop.location objectAtIndex:1] floatValue], [[_destShop.location objectAtIndex:0] floatValue]);
    
    //end.pt = CLLocationCoordinate2DMake(39.797798, 116.404161);
    //end.pt = destL.coordinate;
    end.name = @"清华大学";
    end.cityName = @"北京市";
    
    //NSLog(@"drive route start %f - %f", start.pt.latitude, start.pt.longitude);
    
    //NSLog(@"drive route end %f - %f", end.pt.latitude, end.pt.longitude);
    
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }

}

- (void)showDrivingRoute {
    
//    CLLocation *startL = [[CLLocation alloc] initWithLatitude:40.002538 longitude:116.32838];
//    
//    CLLocation *destL;
//    
//    if (_destShop && _destShop.location) {
//        destL = [[CLLocation alloc] initWithLatitude:[[_destShop.location objectAtIndex:1] floatValue] longitude:[[_destShop.location objectAtIndex:0] floatValue]];
//    } else {
//        destL = [[CLLocation alloc] initWithLatitude:39.797798 longitude:116.404161];
//    }
//    
    [_mapView showAnnotations:@[[[CLLocation alloc] initWithLatitude:40.002538 longitude:116.32838], [[CLLocation alloc] initWithLatitude:39.797798 longitude:116.404161]] animated:YES];
    
    BMKPlanNode* start = [BMKPlanNode new];
    //start.pt = [PXNetworkManager sharedStore].currentLocation.coordinate;
    start.pt = CLLocationCoordinate2DMake(40.002538, 116.32838);
    //start.pt = startL.coordinate;
    //start.name = @"百度大厦";
    //start.cityName = @"北京市";
    
    BMKPlanNode* end = [BMKPlanNode new];
    //end.pt = CLLocationCoordinate2DMake([[_destShop.location objectAtIndex:1] floatValue], [[_destShop.location objectAtIndex:0] floatValue]);
    
    end.pt = CLLocationCoordinate2DMake(39.797798, 116.404161);
    //end.pt = destL.coordinate;
    //end.name = @"清华大学";
    //end.cityName = @"北京市";
    
    NSLog(@"drive route start %f - %f", start.pt.latitude, start.pt.longitude);
    
    NSLog(@"drive route end %f - %f", end.pt.latitude, end.pt.longitude);
    
    //[_mapView showAnnotations:[start, end] animated:YES];
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }

//    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
//    //walkingRouteSearchOption.city= @"深圳市";
//    walkingRouteSearchOption.from = start;
//    walkingRouteSearchOption.to = end;
//    BOOL flag2 = [_routeSearch walkingSearch:walkingRouteSearchOption];
//    if(flag2)
//    {
//        NSLog(@"Route检索发送成功");
//    }
//    else
//    {
//        NSLog(@"Route检索发送失败");
//    }
    
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    //Remove current annotations and overlays
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    NSLog(@"error:%u", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
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
        
        
    } else {
        [self showFakeDrivingRoute];
    }
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
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
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.canShowCallout = YES;
        return newAnnotationView;
    }
    return nil;

}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
