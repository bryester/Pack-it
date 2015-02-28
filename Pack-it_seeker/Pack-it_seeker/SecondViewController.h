//
//  SecondViewController.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXNetworkManager.h"
#import "PXAccountHolder.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UIViewController+Alert.h"

@interface SecondViewController : UIViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, PXNetworkProtocol> {
    
    BOOL _isLogin;
    
    UIAlertView *_alertView;
    
    __weak IBOutlet UILabel *_userLabel;
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIImageView *_userAvatar;
    
    LoginViewController *_loginViewController;
    RegisterViewController *_registerViewController;
    
}


@end

