//
//  AppDelegate.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[PXAccountHolder sharedInstance] loadData];
    if ([[PXAccountHolder sharedInstance] username] && [[PXAccountHolder sharedInstance] password]) {
        //Login automatically
        [[PXNetworkManager sharedStore] loginAutomatically];
    } else {
        //[[PXNetworkManager sharedStore] getTempAccount];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self startLocationService];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Location

- (void)startLocationService {
    NSLog(@"startLocationService");
    
    // 室外地图
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BaiduMap_Key generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [self initLocation];
    [self startLocation];
    
    //上传位置
    //[self initUploadTimer];
    
}

#pragma mark - Outdoor Positioning
- (void)initLocation {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
}

- (void)startLocation{
    if(_locService == nil){
        NSLog(@"initLocate Error");
        return;
    }
    
    //启动LocationService
    [_locService startUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [PXNetworkManager sharedStore].currentLocation = userLocation.location;
}


#pragma mark Baidu Map

//Baidu Map
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

//
//#pragma mark - Upload Location and Position
//
//- (void) initUploadTimer{
//    _uploadTimer = [NSTimer scheduledTimerWithTimeInterval:UPLOAD_INTERNAL target:self selector:@selector(uploadPositionAndLocation) userInfo:nil repeats:YES];
//}
//- (void)stopUpload {
//    if (_uploadTimer) {
//        //关闭定时器
//        NSLog(@"turn off timer");
//        [_uploadTimer invalidate];
//    }
//}
//
//
//- (void) uploadPositionAndLocation{
//    NSLog(@"upload position");
//    //NSLog(@"backgroundTimeRemaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
//    [[PXNetworkManager sharedStore] uploadCurrentLocation];
//}


@end
