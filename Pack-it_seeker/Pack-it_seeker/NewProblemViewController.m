//
//  NewProblemViewController.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/20/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "NewProblemViewController.h"

@interface NewProblemViewController ()

@end

@implementation NewProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    [self initHud];
}

- (void)viewDidAppear:(BOOL)animated {
    [self verifyLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Verify Login

- (void)verifyLogin {
    if (![PXNetworkManager sharedStore].credential) {
        [self showUnlogginAlert];
    }
}

- (void)showUnlogginAlert {
    _alertView = [[UIAlertView alloc] initWithTitle:@"用户未登录，请先登录" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [_alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"跳转到登录界面");
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

#pragma mark - Progress Hub
- (void)initHud {
    
//    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    _hud.mode = MBProgressHUDModeAnnularDeterminate;
//    _hud.labelText = @"Uploading";
//    [_hud hide:YES];
}

- (void)showHub {
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Uploading";
}

- (void)hideHub {
    [_hud hide:YES];
}

- (void)showHubWithText:(NSString *)string {
    [_hud hide:YES];
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = string;
    
    [_hud hide:YES afterDelay:1];
}

#pragma mark - Button Methods

//点击添加图片按钮调用此方法
- (IBAction)addImage:(id)sender {
    
    //拍照或者选择的图片
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController
                                  availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];

    //UIImage *chosedImage = nil;
    //[_imageButton setImage:chosedImage forState:UIControlStateNormal];
}

- (IBAction)confirm:(id)sender {
    if (_imgData) {
        [self showHub];
        
//        NSArray *coordinateArray = nil;
        
//        if ([PXNetworkManager sharedStore].currentLocation) {
//             coordinateArray = [NSArray arrayWithObjects:[@([PXNetworkManager sharedStore].currentLocation.coordinate.longitude) stringValue], [@([PXNetworkManager sharedStore].currentLocation.coordinate.latitude) stringValue], nil];
//            
//        }
        
        [[PXNetworkManager sharedStore] postNewProblemByImage:_imgData desc:@"new problem. Can you help me?" duration:@(10) tag:nil location:[PXNetworkManager sharedStore].currentLocation];
        
    }
    
    //[self dismissViewControllerAnimated:NO completion:nil];
}


//点击添加图片按钮调用相机
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //Dismiss PickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [NSThread detachNewThreadSelector:@selector(resizeAndShowImage:) toTarget:self withObject:image];
}

- (void)resizeAndShowImage:(UIImage *)image {
    
    // Create a graphics image context
    CGSize newSize = CGSizeMake(320, 480);
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    
    _imgData = UIImageJPEGRepresentation(newImage,0.01);
    
    image = [UIImage imageWithData: _imgData];
    
    [_imageButton setImage:newImage forState:UIControlStateNormal];
    
//    
//    NSInteger fileSize = _imgData.length;
//    NSLog(@"image size1:%ld", (long)fileSize);
    //CGSize size = [newImage size];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewProblemCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewProblemCell"];
    }
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Tag"];
            break;
        case 1:
            [cell.textLabel setText:@"Location"];
            break;
        case 2:
            [cell.textLabel setText:@"Duration"];
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - PXNetworkProtocol Delegate

- (void)onPostNewProblemResult:(NSError *)error {
    if (error) {
        if (error.code) {
            [self showHubWithText:[NSString stringWithFormat:@"Error: %lu", error.code]];
        } else {
            [self showHubWithText:@"Error: no login"];
        }
        
    } else {
        [self showHubWithText:@"Success"];
        
        [self.navigationController popViewControllerAnimated:YES];
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
