//
//  SecondViewController.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    
    if ([[PXAccountHolder sharedInstance] isLogined] && [[PXNetworkManager sharedStore] credential]) {
        _isLogin = YES;
        
    } else {
        _isLogin = NO;
    }
    [_tableView reloadData];
    [self showUser];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)showUser {
    if (_isLogin) {
        _userLabel.text =[PXAccountHolder sharedInstance].username;

    } else {
        _userLabel.text = @"未登录";
    }
}

#pragma mark UIAlertView

- (void)showLogoutAlertView {
    
    //[self showAlertViewWithTitle:@"注销当前用户" message:@"" confirmButtonTitle:@"确定" confirmButtonMethod:@selector(confirmLogout) cancelButtonTitle:@"取消" cancelButtonMethod:nil];
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"注销当前用户" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_alertView show];
}

- (void)confirmLogout {
    NSLog(@"注销当前用户");
    [[PXAccountHolder sharedInstance] logout];
    [PXNetworkManager sharedStore].account = nil;
    [self viewWillAppear:NO];
    [_tableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self confirmLogout];
    }else{
        NSLog(@"取消注销用户");
    }
}



#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isLogin) {
        return 4;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"iden"];
        
    }
    switch (indexPath.section) {
            //        case 0:
            //            if (_isLogin) {
            //                cell.textLabel.text = [AccountHolder sharedInstance].username;
            //                cell.detailTextLabel.text = @"";
            //                cell.accessoryType = UITableViewCellAccessoryNone;
            //            } else {
            //                cell.textLabel.text = @"用户未登录";
            //                cell.detailTextLabel.text = @"登录";
            //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //            }
            //            break;
            //        case 1:
            //            cell.textLabel.text = @"我的积分";
            //            if (_credit) {
            //                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _credit];
            //            }
            //            break;
        case 0:
            if (_isLogin) {
                cell.textLabel.text = @"修改密码";
                cell.detailTextLabel.text = @"";
            } else {
                cell.textLabel.text = @"用户未登录";
                cell.detailTextLabel.text = @"登录";
            }
            break;
        case 1:
            cell.textLabel.text = @"注销";
            break;
        default:
            break;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            //        case 0:
            //            if (!_isLogin) {
            //                _loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            //                [self presentViewController:_loginViewController animated:YES completion:nil];
            //                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            //            }
            //            break;
            //        case 1:
            //            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            //            NSLog(@"我的积分");
            //            break;
        case 0:
            if (!_isLogin) {
                _loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                [self presentViewController:_loginViewController animated:YES completion:nil];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            } else {
                NSLog(@"修改密码");
                _registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
                _registerViewController.registerType = NO;
                [self presentViewController:_registerViewController animated:YES completion:nil];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
            break;
        case 1:
            NSLog(@"注销");
            [self showLogoutAlertView];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            break;
        default:
            break;
    }
}






@end
