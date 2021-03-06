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
#import "PXNetworkManager.h"
#import "PXProblem.h"

@interface SolutionsTableViewController : UITableViewController <UIActionSheetDelegate, PXNetworkProtocol> {
    SolutionDetailViewController *_solutionDetailViewController;
    
    NSMutableArray *_tagsName;
    
    
    __weak IBOutlet UINavigationItem *_naviItem;
    
    UILabel *_noDataLabel;
    
    //下拉刷新
    UIRefreshControl *_refreshControl;
    
    __weak IBOutlet UIBarButtonItem *_changeTagBtn;
    
}

//@property (strong, nonatomic) NSArray *solutions;
@property (strong, nonatomic) PXProblem *problem;

@end
