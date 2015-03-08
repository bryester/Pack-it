//
//  ProblemDetailViewController.m
//  Pack-it_solver
//
//  Created by Jiyang on 3/8/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "ProblemDetailViewController.h"

@interface ProblemDetailViewController ()

@end

@implementation ProblemDetailViewController
@synthesize solution = _solution;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showContent];
    [self showButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showContent {
    if (_solution && _solution.problem) {
        if (_solution.problem.pictureURL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, _solution.problem.pictureURL];
            [_imageView setImageWithURL:[NSURL URLWithString: url]];
        }
        
        if (_solution.problem.desc) {
            [_labelDesc setText:_solution.problem.desc];
        }
    }
}

- (void)showButton {
    if (!_solution || !_solution.status) {
        return;
    }
    
    if ([_solution.status isEqualToString:@"waiting"]) {
        [_btnToSolution setTitle:@"Solve" forState:UIControlStateNormal];
        [_btnToSolution setBackgroundColor:[UIColor greenColor]];
    } else if ([_solution.status isEqualToString:@"solved"]) {
        [_btnToSolution setTitle:@"Check my solution" forState:UIControlStateNormal];
        [_btnToSolution setBackgroundColor:[UIColor greenColor]];
    } else if ([_solution.status isEqualToString:@"failed"]) {
        [_btnToSolution setTitle:@"Failed" forState:UIControlStateNormal];
        [_btnToSolution setBackgroundColor:[UIColor grayColor]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSolution"]) {
        SolutionDetailViewController *solutionDetailViewController = [segue destinationViewController];
        solutionDetailViewController.solution = _solution;
    }
}

@end
