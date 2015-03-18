//
//  AppDelegate.m
//  Pack-it_solver
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[PXAccountHolder sharedInstance] loadData];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 推送相关
    // Let the device know we want to receive push notifications
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        //iOS > 8.0
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
        
    } else {
        // iOS < 8.0
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    }
    
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
    
    [self checkUpdate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My device token is: %@", newToken);
    //[[AuthenticationManager sharedStore] uploadTokenForNotification:newToken];
    [PXAccountHolder sharedInstance].token = newToken;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get device token, error: %@", error);
    
}

#pragma mark - Firim Update

- (void)checkUpdate {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fir.im/api/v2/app/version/55029e3ddce07c680b000162"]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            @try {
                NSDictionary *result= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                //对比版本
                NSString * version=result[@"version"]; //对应 CFBundleVersion, 对应Xcode项目配置"General"中的 Build
                NSString * versionShort=result[@"versionShort"]; //对应 CFBundleShortVersionString, 对应Xcode项目配置"General"中的 Version
                NSLog(@"version:%@", version);
                NSLog(@"versionBuild:%@", versionShort);
                NSString * localVersion=[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
                NSString * localVersionShort=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
                
                NSLog(@"localVersion:%@", localVersion);
                NSLog(@"localVersionBuild:%@", localVersionShort);
                
                NSString * url=result[@"update_url"]; //如果有更新 需要用Safari打开的地址
                NSString * changelog=result[@"changelog"];
                
                if ([version isEqualToString:localVersion] && [versionShort isEqualToString:localVersionShort]) {
                    NSLog(@"No new version");
                } else {
                    NSLog(@"new version");
                    
                    NSString *confirmTitle = @"取消";
                    NSString *title = [NSString stringWithFormat:@"New Version:%@(%@)", versionShort, version];
                    NSString *message = changelog;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:confirmTitle
                                                              otherButtonTitles:@"更新",nil];
                    alertView.tag = 100;
                    [alertView show];
                }
                
                
                //这里放对比版本的逻辑  每个 app 对版本更新的理解都不同
                //有的对比 version, 有的对比 build
                
            }
            @catch (NSException *exception) {
                //返回格式错误 忽略掉
            }
        }
        
    }];
}

/**
 * Confirm to update.
 *
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/aaw6"]];
        }
    }
}

@end
