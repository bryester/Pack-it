//
//  FirstViewController.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "ProblemsViewController.h"

@interface ProblemsViewController ()

@end

@implementation ProblemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    [self getProblems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_problems) {
        return _problems.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PXProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProblemCell"];
    
    if (!cell) {
        cell = [[PXProblemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProblemCell"];
    }
    
    if (_problems.count > 0) {
        PXProblem *problem = [_problems objectAtIndex:indexPath.row];
        
        [cell.status setText: problem.status];
        [cell.duration setText:[NSString stringWithFormat:@"%d", problem.duration]];
        
    } else {
        [cell.status setText: @"yyy"];
        [cell.duration setText:@"2"];
        [cell.textLabel setText:@"gg"];
    }
    
    return cell;
}
#pragma mark - Network Methods

- (void)getProblems {
    //[[PXNetworkManager sharedStore] getAllProblems];
}

#pragma mark - PXNetworkProtocol Delegate

- (void)onGetAllProblemsResult:(NSArray *)problems error:(NSError *)error {
    if (!error) {
        _problems = problems;
        [self getProblems];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showSolutions"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        _solutionsTableViewController = [segue destinationViewController];
        _solutionsTableViewController.solutions = [[_problems objectAtIndex:indexPath.row] solutions];
        
    }
}

@end