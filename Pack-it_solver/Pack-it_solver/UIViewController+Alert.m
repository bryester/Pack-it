//
//  UIViewController+Alert.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/28/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (UIViewController_Alert)


- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message {
    [self showAlertViewWithTitle:title message:message confirmButtonTitle:nil confirmButtonMethod:nil cancelButtonTitle:@"确定" cancelButtonMethod:nil];
}

- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
            confirmButtonTitle:(NSString *)confirmButtonTitle
           confirmButtonMethod:(SEL)confirmButtonMethod
             cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonMethod:(SEL)cancelButtonMethod {
    
    
    UIAlertView *alert = [[AlertViewHolder sharedInstance] alertView];
    if ([alert isVisible]) {
        return;
    }
    
    alert.delegate = self;
    [alert setTitle:title];
    [alert setMessage:message];
    [alert addButtonWithTitle:cancelButtonTitle];
    [alert addButtonWithTitle:confirmButtonTitle];
    
//    if (confirmButtonMethod) {
//        self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
//    } else {
//        self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
//    }
    
    alert.delegate = self;
    [AlertViewHolder sharedInstance].confirmButtonMethod = confirmButtonMethod;
    [AlertViewHolder sharedInstance].cancelButtonMethod = cancelButtonMethod;
    [alert show];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) { //cancel
        if ([AlertViewHolder sharedInstance].cancelButtonMethod && [self respondsToSelector:[AlertViewHolder sharedInstance].cancelButtonMethod]) {
            [self performSelector:[AlertViewHolder sharedInstance].cancelButtonMethod];
        }
    } else {
        if ([AlertViewHolder sharedInstance].confirmButtonMethod && [self respondsToSelector:[AlertViewHolder sharedInstance].confirmButtonMethod]) {
            [self performSelector:[AlertViewHolder sharedInstance].confirmButtonMethod];
        }
    }
}


@end
