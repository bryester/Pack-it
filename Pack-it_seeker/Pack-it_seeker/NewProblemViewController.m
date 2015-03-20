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
        
        pickerImage.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerImage.cameraDevice= UIImagePickerControllerCameraDeviceRear;
        //pickerImage.showsCameraControls = YES;
        //pickerImage.navigationBarHidden = NO;
        pickerImage.showsCameraControls = YES;
        pickerImage.navigationBarHidden = YES;
        
        // overlay on top of camera lens view
        UIImageView *cameraOverlayView = [[UIImageView alloc]
                                          initWithImage:[UIImage imageNamed:@"camera_overlay.png"]];
        cameraOverlayView.frame = [self getCameraOverlayFrameByControllerFrame:pickerImage.view.bounds];
        //cameraOverlayView.alpha = 0.0f;
        pickerImage.cameraOverlayView = cameraOverlayView;


    }
    
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];

    //UIImage *chosedImage = nil;
    //[_imageButton setImage:chosedImage forState:UIControlStateNormal];
}

- (CGRect)getCameraOverlayFrameByControllerFrame:(CGRect)controllerFrame{
    
    CGFloat overLay_width = controllerFrame.size.width*0.8;
    
    return CGRectMake((controllerFrame.size.width - overLay_width)/2, (controllerFrame.size.height - overLay_width)/2, overLay_width, overLay_width);
}

- (CGRect)getClipRectByOriginalPhotoSize:(CGSize)photoSize{
    NSLog(@"clip_width rogitnl %f", photoSize.width);
    CGFloat clip_width = photoSize.width * 0.8;
    NSLog(@"clip_width%f", clip_width);
    return CGRectMake((photoSize.width - clip_width)/2, (photoSize.height - clip_width)/2, clip_width, clip_width);
}

- (IBAction)addImageFromLibrary:(id)sender {
    //拍照或者选择的图片
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController
                                  availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];
    
}


- (IBAction)confirm:(id)sender {
    if (_imgData) {
        [self showHub];
        
//        NSArray *coordinateArray = nil;
        
//        if ([PXNetworkManager sharedStore].currentLocation) {
//             coordinateArray = [NSArray arrayWithObjects:[@([PXNetworkManager sharedStore].currentLocation.coordinate.longitude) stringValue], [@([PXNetworkManager sharedStore].currentLocation.coordinate.latitude) stringValue], nil];
//            
//        }
        
        [[PXNetworkManager sharedStore] postNewProblemByImage:_imgData desc:@"" duration:@(10) tag:nil location:[PXNetworkManager sharedStore].currentLocation];
        
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
    CGSize newSize = CGSizeMake(1000, image.size.height/image.size.width *1000);
    UIGraphicsBeginImageContext(newSize);

    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    
    CGRect cropRect = [self getClipRectByOriginalPhotoSize:newImage.size];
    UIImage *croppedImg = [self croppIngimageByImageName:newImage toRect:cropRect];
    
    _imgData = UIImageJPEGRepresentation(croppedImg,0.1);
    
    image = [UIImage imageWithData: _imgData];
    
    
    [_imageButton setImage:image forState:UIControlStateNormal];
    
//
    
//    NSInteger fileSize = _imgData.length;
//    NSLog(@"image size1:%ld", (long)fileSize);
    CGSize size = [image size];
}

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    //UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    NSLog(@"scaleAndRotateImage");
    static int kMaxResolution = 640; // this is the maximum resolution that you want to set for an image.
    
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, width, height), imgRef);
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
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
