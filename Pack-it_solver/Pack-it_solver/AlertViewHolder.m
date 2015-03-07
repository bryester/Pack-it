//
//  AlertViewHolder.m
//  Bcc_iOS
//
//  Created by 梁友 on 15/1/26.
//  Copyright (c) 2015年 PX. All rights reserved.
//

#import "AlertViewHolder.h"

@implementation AlertViewHolder

@synthesize alertView = _alertView;

+(instancetype)sharedInstance {
    static AlertViewHolder *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [AlertViewHolder new];
        [shared initAlertView];
    });
    return shared;
}

- (void)initAlertView {
    _alertView = [UIAlertView new];
}

@end
