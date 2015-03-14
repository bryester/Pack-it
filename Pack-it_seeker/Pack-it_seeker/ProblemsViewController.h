//
//  FirstViewController.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/18/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXNetworkManager.h"
#import "SolutionsTableViewController.h"
#import "PXProblemTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Config.h"

@interface ProblemsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, PXNetworkProtocol, SDWebImageManagerDelegate> {
    
    NSArray *_problems;
    
    __weak IBOutlet UIActivityIndicatorView *_activityIndicator;
    
    
    SolutionsTableViewController *_solutionsTableViewController;
    
    //下拉刷新
    UIRefreshControl *_refreshControl;
}


@end

