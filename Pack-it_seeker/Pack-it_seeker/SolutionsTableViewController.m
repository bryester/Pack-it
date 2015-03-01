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

@synthesize solutions = _solutions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
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
    
    PXSolutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PXSolutionTableViewCell"];
    
    if (!cell) {
        cell = [[PXSolutionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PXSolutionTableViewCell"];
    }
    
    if (_solutions.count > 0) {
        PXSolution *solution = [_solutions objectAtIndex:indexPath.row];
        
        //cell.shop = solution.shop;
        cell.price = solution.price;
        cell.imageURL = solution.pictureURL;
        //cell.location = solution.location;
        if (solution.pictureURL) {
            NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, solution.pictureURL];
            [cell.imageView_customed setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"defult_portraiture.png"]];
        }
        
    } else {
        cell.shop = @"优衣库（新都城店）";
        cell.price = 300;
        //cell.imageURL = solution.pictureURL;
        cell.location = @"新界將軍澳坑口東港城178-179 & 191-192店";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
