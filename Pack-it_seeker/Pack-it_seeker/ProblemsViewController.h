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

@interface ProblemsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, PXNetworkProtocol> {
    
    NSArray *_problems;
    
    SolutionsTableViewController *_solutionsTableViewController;
}


@end

