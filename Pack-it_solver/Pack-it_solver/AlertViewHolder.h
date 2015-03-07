//
//  AlertViewHolder.h
//  Bcc_iOS
//
//  Created by 梁友 on 15/1/26.
//  Copyright (c) 2015年 PX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AlertViewHolder.h"

@interface AlertViewHolder : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertView *alertView;
@property (assign, nonatomic) SEL confirmButtonMethod;
@property (assign, nonatomic) SEL cancelButtonMethod;

+ (instancetype)sharedInstance;

@end
