//
//  SolutionDetailViewController.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
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
    if (_solution) {
        [self showSolution:_solution];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSolution:(PXSolution *)solution {
    if (solution) {
        if (solution.pictureURL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, solution.pictureURL];
            [_imageView setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"defult_portraiture.png"]];
        }
        _labelPrice.text = [NSString stringWithFormat:@"%@", solution.price];
        _labelDesc.text = solution.desc;
        
    }
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_solution && _solution.shop_profile && _solution.shop_profile.address) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SolutionDetailCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SolutionDetailCell"];
    }
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Location"];
            [cell.detailTextLabel setText:_solution.shop_profile.address];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:@"toMap"]) {
//        
//        NaviViewController *_naviViewController = [segue destinationViewController];
//        _naviViewController.destShop = _solution.shop_profile;
//        
//    }
}

@end
