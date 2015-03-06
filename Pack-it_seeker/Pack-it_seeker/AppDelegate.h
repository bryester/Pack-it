//
//  AppDelegate.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXNetworkManager.h"
#import "BMapKit.h"
#import "Config.h"
#import "PXNetworkManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate, BMKLocationServiceDelegate> {
    
    
    //Outdoor
    BMKMapManager *_mapManager;
    BMKLocationService* _locService;
    
    //Upload Location
    //NSTimer *_uploadTimer;
    
}

@property (strong, nonatomic) UIWindow *window;


@end

