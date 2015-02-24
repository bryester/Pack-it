//
//  SetPasswordViewController.m
//  Bcc_iOS
//
//  Created by HDD-Dev1 on 15/1/8.
//  Copyright (c) 2015年 HDD-Dev1. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController

@synthesize registerUsername = _registerUsername;



- (void)viewDidLoad {
    [super viewDidLoad];
    [_submitBtn.layer setCornerRadius:10.0];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [PXNetworkManager sharedStore].delegate = self;
    if (_registerUsername) {
        [_labelUsername setText:_registerUsername];
    }
    
    
    _alertView = [UIAlertView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    //[PXNetworkManager sharedStore].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Methods

//返回
- (IBAction)returnClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

//提交
- (IBAction)submitClick:(id)sender {
    if (!_textFirstPass || [_textFirstPass.text isEqualToString:@""] || !_textSecondPass || [_textSecondPass.text isEqualToString:@""]) {
        [self showAlertViewForMessage:@"请输入新密码"];
    } else if (![_textSecondPass.text isEqualToString:_textFirstPass.text]) {
        [self showAlertViewForMessage:@"请输入相同密码"];
    } else if ([_textFirstPass.text length] < 8){
        [self showAlertViewForMessage:@"密码长度不可小于8"];
    } else {
        NSLog(@"firstPass:%@", _textFirstPass.text);
        NSLog(@"secondPass:%@", _textSecondPass.text);
        [[PXNetworkManager sharedStore] setNewPassword:_textFirstPass.text];
    }
}

#pragma mark UI
- (void)showAlertViewForMessage:(NSString *)msg {
    if (!_alertView) {
        _alertView = [UIAlertView new];
    }
    if(_alertView && !_alertView.isVisible){
        _alertView.delegate = self;
        [_alertView setMessage:msg];
        [_alertView addButtonWithTitle:@"确定"];
        [_alertView show];
    }
}

- (IBAction)touchDownBackground:(id)sender {
    //收回键盘
    [_textFirstPass resignFirstResponder];
    [_textSecondPass resignFirstResponder];
}

- (IBAction)textEndOnEditing:(id)sender {
    [sender resignFirstResponder];
}


- (void)dismissCurrentAndParentViewController {
    UIViewController *parentView = [self presentingViewController];
    UIViewController *grandView = [parentView presentingViewController];
    [grandView dismissViewControllerAnimated:NO completion:nil];
    [parentView dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"dismiss register view controller");
    
}

#pragma mark - PXNetworkProtocol Delegate

/**
 *异步回调，返回设置新密码的结果
 *@param error  nil表示成功
 */
- (void)onSetNewPasswordResult:(NSError *)error{
    if (error) {
        [self showAlertViewForMessage:[NSString stringWithFormat:@"error:%ld", error.code]];
    } else {
        [self showAlertViewForMessage:@"新密码设置成功"];
        [[PXAccountHolder sharedInstance] setUsername:self.registerUsername password:_textSecondPass.text];
        [[PXNetworkManager sharedStore] loginAutomatically];
        [self dismissCurrentAndParentViewController];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
