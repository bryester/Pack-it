//
//  LoginViewController.m
//  Bcc_iOS
//
//  Created by HDD-Dev1 on 15/1/8.
//  Copyright (c) 2015年 HDD-Dev1. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIAlertView *alert;
}
@synthesize account = _account;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [PXNetworkManager sharedStore].delegate = self;
    _account = [PXAccountHolder sharedInstance];
    [login.layer setCornerRadius:10.0];
}

- (void)viewWillAppear:(BOOL)animated{
    [PXNetworkManager sharedStore].delegate = self;
    NSLog(@"view will appear");
    if (_account && _account.password && _account.username) {
        //NSLog(@"willAppear email %@", _account.username);
        userName.text = _account.username;
        userPass.text = _account.password;
    } else if (_account && _account.username) {
        userName.text = _account.username;
    }
    
    [self initActivityIndicatorView];
}
- (IBAction)returnClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)loginClick:(UIButton *)sender {
    
    NSLog(@"%@",userName.text);
    NSLog(@"%@",userPass.text);
    
    if (userName.text && userPass.text && ![userName.text isEqualToString:@""] && ![userPass.text isEqualToString:@""]) {
        [[PXNetworkManager sharedStore] loginByUsername:userName.text password:userPass.text];
        [self startIndicator];
    } else {
        [self showAlertByMSG:@"输入不可为空"];
    }

    

}
- (IBAction)registerByEmailClick:(UIButton *)sender {
    
    NSLog(@"ASDF");
    
    regis = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    regis.registerType = YES;
    [self presentViewController:regis animated:NO completion:nil];

}
- (IBAction)registerByPhoneClick:(id)sender {
    regis = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    regis.registerType = NO;
    [self presentViewController:regis animated:NO completion:nil];
}




- (IBAction)forgiveClick:(UIButton *)sender {
    regis = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    regis.registerType = NO;
    [self presentViewController:regis animated:NO completion:nil];
    
}

- (void)showAlertview:(NSError *)error
{
    if(!alert.isVisible){
        alert = [UIAlertView new];
        alert.delegate = self;
        [alert setTitle:@"登录错误"];
        [alert setMessage:[NSString stringWithFormat:@"%@", error]];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }
    
}

- (void)showAlertByMSG:(NSString *)msg
{
    if(!alert.isVisible){
        alert = [UIAlertView new];
        alert.delegate = self;
        [alert setTitle:msg];
        //[alert setMessage:msg];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }
    
}

- (IBAction)touchDownBackground:(id)sender {
    //收回键盘
    [userPass resignFirstResponder];
    [userName resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIActivityIndicatorView
- (void)initActivityIndicatorView {
    //_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //_activityIndicatorView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    //_activityIndicatorView.center = self.view.center;
    //[self.view addSubview:_activityIndicatorView];
    //[self.view bringSubviewToFront:_activityIndicatorView];
    //[_activityIndicatorView bringSubviewToFront:self.view];
    //[_activityIndicatorView setHidden:NO];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    //[_activityIndicatorView setBounds:self.view.frame];
    //[_activityIndicatorView setCenter:self.view.center];
}

- (void)startIndicator {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [_activityIndicatorView startAnimating];
}

- (void)stopIndicator {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [_activityIndicatorView stopAnimating];
}


#pragma mark - PXNetworkProtocol Delegate
- (void)onLoginResult:(NSError *)error {
    [self stopIndicator];
    NSLog(@"onLoginResult");
    if (error) {
        [self showAlertByMSG:@"登录失败，请检查账号或网络"];
        //[self showConfirmAlertViewWithMessage:@"登录失败，请检查账号或网络"];
    } else {
        //[self showConfirmAlertViewWithMessage:@"登录成功"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
