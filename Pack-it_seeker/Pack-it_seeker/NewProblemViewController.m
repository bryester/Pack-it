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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [[PXNetworkManager sharedStore] postNewProblemByImage:_imgData desc:@"haha" duration:@(10) tag:nil location:nil];
    }
    
    //[self dismissViewControllerAnimated:NO completion:nil];
}


//点击添加图片按钮调用相机
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _imgData = UIImageJPEGRepresentation(image,0.01);
    image = [UIImage imageWithData: _imgData];
    
    [_imageButton setImage:image forState:UIControlStateNormal ];
    [self dismissViewControllerAnimated:picker completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
