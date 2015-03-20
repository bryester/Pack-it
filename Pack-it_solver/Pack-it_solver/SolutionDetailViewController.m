//
//  SolutionDetailViewController.m
//  Pack-it_solver
//
//  Created by Jiyang on 3/8/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "SolutionDetailViewController.h"

@interface SolutionDetailViewController ()

@end

@implementation SolutionDetailViewController
@synthesize solution = _solution;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    [self initHud];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showContent {
    if (_solution && _solution.problem) {
        if ([_solution.status isEqualToString:@"waiting"]) {
            //待解决
            _textPrice.enabled = YES;
            
        } else if ([_solution.status isEqualToString:@"solved"]) {
            //已回答
            
            [_confirmButton setEnabled:NO];
            [_confirmButton setTintColor:[UIColor clearColor]];
            
            _textPrice.enabled = NO;
            [_textPrice setText:[_solution.price stringValue]];
            
            _imageButton.enabled = NO;
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL, _solution.pictureURL]]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     [_imageButton setImage:image forState:UIControlStateNormal];
                     
                 }
             }];
            
            
        } else if ([_solution.status isEqualToString:@"failed"]) {
            //未回答
            
        }
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

- (IBAction)confirm:(id)sender {
    if (_imgData && _textPrice.text && ![_textPrice.text  isEqual: @""] && _solution) {
        [self showHub];
        [[PXNetworkManager sharedStore] postNewSolutionByImage:_imgData desc:@"" price:@([_textPrice.text floatValue]) forSolution:_solution.solutionID];
    } else {
        [self showHubWithText:@"输入不可为空"];
    }
}

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
}

/**
 *拍照后的异步回调函数
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
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

#pragma mark - PXNetworkProtocol Delegate

- (void)onPostNewSolutionResult:(NSError *)error {
    if (error) {
        [self showHubWithText:error.description];
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
