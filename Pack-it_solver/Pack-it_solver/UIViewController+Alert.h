//
//  UIViewController+Alert.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/28/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewHolder.h"

@interface UIViewController (UIViewController_Alert)<UIAlertViewDelegate>



- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message;

- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
            confirmButtonTitle:(NSString *)confirmButtonTitle
           confirmButtonMethod:(SEL)confirmButtonMethod
             cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonMethod:(SEL)cancelButtonMethod;

@end
