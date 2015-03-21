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
    [self initRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    if (!(_problems && _problems.count > 0)) {
        //[self getProblems];
        [_refreshControl beginRefreshing];
        [self getProblems];
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
    [self getProblems];
}



- (void)stopRefreshing {
    [_refreshControl endRefreshing];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_problems) {
        return _problems.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PXProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PXProblemTableViewCell"];
    
    if (!cell) {
        cell = [[PXProblemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PXProblemTableViewCell"];
    }
    
    if (_problems.count > 0) {
        PXProblem *problem = [_problems objectAtIndex:indexPath.row];
        
        if (problem.status_CHN) {
            cell.status = problem.status_CHN;
        }
        //cell.status = problem.status;
        cell.duration = problem.duration;
        cell.imageURL = problem.pictureURL;
        cell.desc = problem.desc;
        if (problem.pictureURL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, problem.pictureURL];
            
//            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//            [manager downloadWithURL:[NSURL URLWithString:url]
//                             options:SDWebImageProgressiveDownload
//                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                
//                            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                                
//                                if (finished ) {
//                                    
//                                }
//                                
//                            }];
//            [manager downloadWithURL:url delegate:self options:0 success:^(UIImage *image)
//            {
//                cell.profilePicture.image = [self imageByScalingAndCroppingForSize:CGSizeMake(cell.profilePicture.frame.size.width, cell.profilePicture.frame.size.height) image:image];
//            } failure:nil];
//            
            [cell.imageView_customed setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"defult_portraiture.png"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - Network Methods

- (void)getProblems {
    if ([PXNetworkManager sharedStore].credential) {
        //[self startIndicator];
        [[PXNetworkManager sharedStore] getAllProblems];
    } else {
        [self stopRefreshing];
    }
    
}

#pragma mark - PXNetworkProtocol Delegate

- (void)onGetAllProblemsResult:(NSArray *)problems error:(NSError *)error {
    [self stopRefreshing];
    if (!error) {
        _problems = problems;
        [self.tableView reloadData];
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
        //_solutionsTableViewController.solutions = [[_problems objectAtIndex:indexPath.row] solutions];
        _solutionsTableViewController.problem = [_problems objectAtIndex:indexPath.row];
        
    }
}

@end
