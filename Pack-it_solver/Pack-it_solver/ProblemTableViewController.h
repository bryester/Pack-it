//
//  ProblemTableViewController.h
//  Pack-it_solver
//
//  Created by Jiyang on 3/7/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXNetworkManager.h"
#import "PXProblemTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Config.h"

@interface ProblemTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, PXNetworkProtocol> {
    
    NSArray *_problems;
    
    __weak IBOutlet UIActivityIndicatorView *_activityIndicator;
    
    //下拉刷新
    UIRefreshControl *_refreshControl;
}

@end
