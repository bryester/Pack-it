//
//  LoginViewController.h
//  Bcc_iOS
//
//  Created by HDD-Dev1 on 15/1/8.
//  Copyright (c) 2015年 HDD-Dev1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "PXNetworkManager.h"
#import "PXAccountHolder.h"

@interface LoginViewController : UIViewController<PXNetworkProtocol, UIAlertViewDelegate>{
    __weak IBOutlet UITextField *userName;
    
    __weak IBOutlet UITextField *userPass;
    __weak IBOutlet UIButton *login;

    __weak IBOutlet UIButton *forgivebutton;
    
    RegisterViewController *regis;
}

@property (strong,nonatomic) PXAccountHolder *account;

@end
