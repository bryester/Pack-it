//
//  AccountHolder.m
//  Bcc_iOS
//
//  Created by jy.zhu on 1/12/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXAccountHolder.h"

#define KEY_USERNAME @"kUsername"
#define KEY_PASSWORD @"kPassword"

@implementation PXAccountHolder

@synthesize username = _username;
@synthesize password = _password;

+(instancetype)sharedInstance{
    static PXAccountHolder *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [PXAccountHolder new];
    });
    return shared;
}

- (void)setUsername:(NSString *)username password:(NSString *)pswd{
    if (username && pswd) {
        _username = username;
        _password = pswd;
        [self saveData];
    }
}

- (void)logout {
    //_username = nil;
    _password = nil;
    [self saveData];
}

- (void)saveData{
    //NSLog(@"saveData");
    [[NSUserDefaults standardUserDefaults]
     setObject:_username forKey:KEY_USERNAME];
    
    [[NSUserDefaults standardUserDefaults]
     setObject:_password forKey:KEY_PASSWORD];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadData{
    //NSLog(@"loadData");
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME])
    {
        _username = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    }
}

- (void)removeData {
    NSLog(@"removeData");
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_USERNAME];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASSWORD];
    }
}

- (BOOL)isLogined {
    if (_username && _password) {
        return YES;
    }
    return NO;
}

@end
