//
//  SetPasswordViewController.h
//  Bcc_iOS
//
//  Created by HDD-Dev1 on 15/1/8.
//  Copyright (c) 2015年 HDD-Dev1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXNetworkManager.h"
#import "PXAccountHolder.h"

@interface SetPasswordViewController : UIViewController<PXNetworkProtocol, UIAlertViewDelegate>{
    
    __weak IBOutlet UILabel *_labelUsername;
    
    __weak IBOutlet UITextField *_textFirstPass;
    __weak IBOutlet UITextField *_textSecondPass;
    
    __weak IBOutlet UIButton *_submitBtn;
    UIAlertView *_alertView;
}

@property (strong, nonatomic) NSString *registerUsername;

@end
