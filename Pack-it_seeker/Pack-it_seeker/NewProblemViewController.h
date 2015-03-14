//
//  NewProblemViewController.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/20/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PXNetworkManager.h"
#import "LoginViewController.h"

@interface NewProblemViewController : UIViewController <PXNetworkProtocol, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    
    __weak IBOutlet UIButton *_imageButton;
    
    NSData *_imgData;
    
    MBProgressHUD *_hud;
    
    UIAlertView *_alertView;
}

@end
