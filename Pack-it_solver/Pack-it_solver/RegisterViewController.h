//
//  RegisterViewController.h
//  Bcc_iOS
//
//  Created by HDD-Dev1 on 15/1/8.
//  Copyright (c) 2015年 HDD-Dev1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXNetworkManager.h"
#import "SetPasswordViewController.h"

@interface RegisterViewController : UIViewController <PXNetworkProtocol, UIAlertViewDelegate>{
    __weak IBOutlet UITextField *_textPhoneNo;
    __weak IBOutlet UITextField *_textEmail;
    UITextField *_textUserName;
    
    __weak IBOutlet UILabel *_labelPhone;
    __weak IBOutlet UILabel *_labelEmail;
    
    __weak IBOutlet UITextField *_textVerifyCode;
    
    __weak IBOutlet UIButton *_registerBtn;
    SetPasswordViewController *setPasswordViewController;
    
    UIAlertView *_alertView;
    
    NSString *_registerUsername;
}

//Yes 邮箱 No 手机号码
@property (nonatomic) BOOL registerType;

- (void)dismissCurrentView;

@end
