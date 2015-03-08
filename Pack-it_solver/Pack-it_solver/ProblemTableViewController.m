//
//  ProblemTableViewController.m
//  Pack-it_solver
//
//  Created by Jiyang on 3/7/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "ProblemTableViewController.h"

@interface ProblemTableViewController ()

@end

@implementation ProblemTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    if (!(_solutions && _solutions.count > 0)) {
        //[self getProblems];
        [_refreshControl beginRefreshing];
        [self getSolutions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActivityIndicatorView

- (void)startIndicator {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [_activityIndicator startAnimating];
}

- (void)stopIndicator {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [_activityIndicator stopAnimating];
}

#pragma mark - TableView Refresh
- (void)initRefreshControl {
    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
}

- (void)refreshTableView:(UIRefreshControl *)refreshControl {
    //NSLog(@"refreshTableView");
    //[AuthenticationManager sharedStore].delegate = self;
    //refreshFlag = 0;
    [self getSolutions];
}



- (void)stopRefreshing {
    [_refreshControl endRefreshing];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_solutions) {
        return _solutions.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PXProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PXProblemTableViewCell"];
    
    if (!cell) {
        cell = [[PXProblemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PXProblemTableViewCell"];
    }
    
    if (_solutions.count > 0) {
        PXSolution *solution = [_solutions objectAtIndex:indexPath.row];
        
        cell.status = solution.status;
        cell.duration = solution.problem.duration;
        cell.imageURL = solution.problem.pictureURL;
        cell.desc = solution.problem.desc;
        if (solution.pictureURL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, solution.problem.pictureURL];
            [cell.imageView_customed setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"defult_portraiture.png"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - Network Methods

- (void)getSolutions {
    if ([PXNetworkManager sharedStore].credential) {
        //[self startIndicator];
        [[PXNetworkManager sharedStore] getAllSolutions];
    } else {
        [self stopRefreshing];
    }
    
}

#pragma mark - PXNetworkProtocol Delegate

- (void)onGetAllSolutionsResult:(NSArray *)solutions error:(NSError *)error {
    [self stopRefreshing];
    if (!error) {
        _solutions = solutions;
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProblemDetailViewController *problemDetailViewController = [segue destinationViewController];
        problemDetailViewController.solution = [_solutions objectAtIndex:indexPath.row];
    }
}
@end
