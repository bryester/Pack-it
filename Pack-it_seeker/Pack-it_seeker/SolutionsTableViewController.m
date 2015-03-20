//
//  SolutionsTableViewController.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "SolutionsTableViewController.h"

@interface SolutionsTableViewController ()

@end

@implementation SolutionsTableViewController

//@synthesize solutions = _solutions;
@synthesize problem = _problem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [PXNetworkManager sharedStore].delegate = self;
    [self prepareTags];
    [self showTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeContent {
    _problem.solutions = nil;
    [self.tableView reloadData];
}

- (void)refreshContent {
    [[PXNetworkManager sharedStore] getProblemByID:_problem.problemID];
}

- (void)showTitle {
    _naviItem.title = _problem.tag.name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_problem && _problem.solutions) {
        return _problem.solutions.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PXSolutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PXSolutionTableViewCell"];
    
    if (!cell) {
        cell = [[PXSolutionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PXSolutionTableViewCell"];
    }
    
    if (_problem.solutions.count > 0) {
        PXSolution *solution = [_problem.solutions objectAtIndex:indexPath.row];
        
        cell.shop = solution.shop_profile.name;
        if (solution.price && ![solution.price isKindOfClass:[NSNull class]]) {
            cell.price = [NSString stringWithFormat:@"%@", solution.price];
            cell.labelYuan.hidden = NO;
        } else {
            cell.price = @"－";
            cell.labelYuan.hidden = YES;
        }
        
        cell.imageURL = solution.pictureURL;
//        cell.address = [NSString stringWithFormat:@"%@ - %@",solution.shop_profile.name, solution.shop_profile.address] ;
        cell.address = solution.shop_profile.address;
        if (solution.pictureURL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, solution.pictureURL];
            [cell.imageView_customed setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"defult_portraiture.png"]];
        }
        
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Alternative Tags

- (void)prepareTags {
    
    NSArray *tags = [PXTagHolder sharedInstance].tags;
    
    if (tags) {
        _tagsName = [NSMutableArray new];
        for (PXTag *tag in tags) {
            [_tagsName addObject:tag.name];
        }
    } else {
        [[PXNetworkManager sharedStore] getAllTags];
    }
}

- (IBAction)showAlterTags:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Alter Tags", nil)
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (NSString *str in _tagsName) {
        [actionSheet addButtonWithTitle:str];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    
    actionSheet.cancelButtonIndex = [_tagsName count];
    
    //    [actionSheet showInView:self.view];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        // In this case the device is an iPad.
    //        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    //    }
    //    else{
    //        // In this case the device is an iPhone/iPod Touch.
    //        [actionSheet showInView:self.view];
    //    }
    //
    actionSheet.tag = 100;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100 && buttonIndex < [PXTagHolder sharedInstance].tags.count) {
        
        [self removeContent];
        
        PXTag *newTag = [[PXTagHolder sharedInstance].tags objectAtIndex:buttonIndex];
        
        [[PXNetworkManager sharedStore] putNewTag:newTag.tagID forProblem:_problem.problemID];
    }
}

#pragma mark - Network Protocol

- (void)onPutNewTagResult:(NSError *)error {
    if (!error) {
        [self refreshContent];
    } else {
        
    }
}

- (void)onGetProblemByIDResult:(PXProblem *)problem error:(NSError *)error {
    if (!error) {
        if ([_problem.problemID isEqualToString:problem.problemID]) {
            _problem.tag = problem.tag;
            _problem.solutions = problem.solutions;
            [self.tableView reloadData];
            [self showTitle];
        }
    } else {
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        _solutionDetailViewController = [segue destinationViewController];
        _solutionDetailViewController.solution = [_problem.solutions objectAtIndex:indexPath.row];
        
    }
}


@end
