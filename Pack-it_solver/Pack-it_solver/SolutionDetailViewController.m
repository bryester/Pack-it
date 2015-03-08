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

- (IBAction)confirm:(id)sender {
    if (_imgData && _textPrice.text && ![_textPrice.text  isEqual: @""] && _solution) {
        [self showHub];
        [[PXNetworkManager sharedStore] postNewSolutionByImage:_imgData desc:@"" price:@([_textPrice.text floatValue]) forProblem:_solution.solutionID];
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
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _imgData = UIImageJPEGRepresentation(image,0.01);
    image = [UIImage imageWithData: _imgData];
    
    NSInteger fileSize = _imgData.length;
    
    [_imageButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:picker completion:nil];
    
}

#pragma mark - PXNetworkProtocol Delegate

- (void)onPostNewSolutionResult:(NSError *)error {
    if (error) {
        [self showHubWithText:@"Error"];
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
