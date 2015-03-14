//
//  SolutionsTableViewController.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXSolutionTableViewCell.h"
#import "PXSolution.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Config.h"
#import "SolutionDetailViewController.h"
#import "PXTagHolder.h"

@interface SolutionsTableViewController : UITableViewController {
    SolutionDetailViewController *_solutionDetailViewController;
}

@property (strong, nonatomic) NSArray *solutions;

@end
