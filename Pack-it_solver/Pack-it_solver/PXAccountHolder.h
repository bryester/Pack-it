//
//  AccountHolder.h
//  Bcc_iOS
//
//  Created by jy.zhu on 1/12/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXAccountHolder : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *token;

- (void)setUsername:(NSString *)username password:(NSString *)pswd;

- (void)logout;

//Save account data to disk
- (void)saveData;
//Load account data from disk
- (void)loadData;

- (BOOL)isLogined;
@end
