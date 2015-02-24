//
//  RegisterViewController.m
//  Bcc_iOS
//
//  Created by HDD-Dev1 on 15/1/8.
//  Copyright (c) 2015年 HDD-Dev1. All rights reserved.
//

#import "RegisterViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize registerType = _registerType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [PXNetworkManager sharedStore].delegate = self;
    
    [self hideOrShowUIByRegisterType];
    
    _alertView = [UIAlertView new];
    [_registerBtn.layer setCornerRadius:10.0];
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

- (IBAction)sendCode:(UIButton *)sender {
    
    NSLog(@"获取验证码！！！");
    if (_textUserName.text && ![_textUserName.text isEqualToString:@""] ) {
        if (_registerType) {
            /**
             *用户通过邮箱注册，会收到验证码
             *异步函数，返回结果在PXNetworkProtocol的onRegisterByTelOrEmailResult通知
             *@param email  邮箱
             */
            [[PXNetworkManager sharedStore] registerByEmail:_textUserName.text];
        } else {
            /**
             *用户通过手机号码注册，会收到验证码
             *异步函数，返回结果在PXNetworkProtocol的onRegisterByTelResult通知
             *@param tel 手机号码
             */
            [[PXNetworkManager sharedStore] registerByTelephone:_textUserName.text];
        }
        
    } else {
        [self showAlertViewForMessage:@"用户名不可为空"];
    }
}
- (IBAction)returnClick:(id)sender {
    [self dismissCurrentView];
}

- (IBAction)submitClick:(UIButton *)sender {
    
    NSLog(@"%@",_textUserName.text);
    NSLog(@"%@",_textVerifyCode.text);
    
    if (!_textVerifyCode.text || [_textVerifyCode.text isEqualToString:@""]) {
        [self showAlertViewForMessage:@"验证码不可为空"];
    } else if (!_textUserName.text || [_textUserName.text isEqualToString:@""]){
        [self showAlertViewForMessage:@"用户名不可为空"];
    } else {
        _registerUsername = _textUserName.text;
        if (_registerType) {
            /**
             *验证用户邮箱收到的验证码
             *异步函数，返回结果在PXNetworkProtocol的onVerifyTelOrEmailCodeResult通知
             *@param code 验证码
             */
            [[PXNetworkManager sharedStore] verifyEmail:_textUserName.text andCode:_textVerifyCode.text];
        } else {
            /**
             *验证用户手机收到的验证码
             *异步函数，返回结果在PXNetworkProtocol的onVerifyTelCodeResult通知
             *@param code 验证码
             */
            [[PXNetworkManager sharedStore] verifyTel:_textUserName.text andCode:_textVerifyCode.text];

        }
    }
    
    
    
}

#pragma mark UI
- (void)showAlertViewForMessage:(NSString *)msg {
    if(_alertView && !_alertView.isVisible){
        _alertView.delegate = self;
        [_alertView setMessage:msg];
        [_alertView addButtonWithTitle:@"确定"];
        [_alertView show];
    }
}

/**
 * Yes for email, No for phone
 */
- (void)hideOrShowUIByRegisterType{
    if (_registerType) {
        //Yes 邮箱注册
        _textEmail.hidden = NO;
        _textPhoneNo.hidden = YES;
        _labelEmail.hidden = NO;
        _labelPhone.hidden = YES;
        _textUserName = _textEmail;
    } else {
        //No 手机注册
        _textEmail.hidden = YES;
        _textPhoneNo.hidden = NO;
        _labelEmail.hidden = YES;
        _labelPhone.hidden = NO;
        _textUserName = _textPhoneNo;
    }
}

- (IBAction)touchDownBackground:(id)sender {
    //收回键盘
    [_textEmail resignFirstResponder];
    [_textPhoneNo resignFirstResponder];
    [_textVerifyCode resignFirstResponder];
}

- (IBAction)textEndOnEditing:(id)sender {
    [sender resignFirstResponder];
}


#pragma mark - PXNetworkProtocol Delegate

/**
 *异步回调，返回通过手机号或邮箱注册申请验证码的结果
 *@param error  nil表示成功
 */
- (void)onRegisterByTelOrEmailResult:(NSError *)error{
    if (error) {
        [self showAlertViewForMessage:[NSString stringWithFormat:@"error:%ld", (long)error.code]];
        //[self showConfirmAlertViewWithMessage:[NSString stringWithFormat:@"输入手机号有误:%ld", (long)error.code]];
    } else {
        [self showAlertViewForMessage:@"验证码发送成功"];
    }
}

/**
 *异步回调，返回验证手机或邮箱验证码的结果
 *@param error  nil表示成功
 */
- (void)onVerifyTelOrEmailCodeResult:(NSError *)error{
    if (error) {
        [self showAlertViewForMessage:@"验证失败"];
    } else {
        [self showAlertViewForMessage:@"验证码发送成功！确定设置新密码"];
        
        
        setPasswordViewController = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
        setPasswordViewController.registerUsername = _registerUsername;
        [self presentViewController:setPasswordViewController animated:NO completion:nil];
    }
}

- (void)dismissCurrentView{
    [self dismissViewControllerAnimated:NO completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Network delegate

- (void)onToNextViewHelperResult:(id)object {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
