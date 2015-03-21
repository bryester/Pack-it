//
//  SolutionDetailViewController.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXSolution.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Config.h"
#import "PXNetworkManager.h"

@interface SolutionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_labelPrice;
    __weak IBOutlet UILabel *_labelDesc;
    __weak IBOutlet UILabel *_labelYuan;
    __weak IBOutlet UILabel *_labelShop;
    __weak IBOutlet UILabel *_labelAddress;
}

@property (strong,nonatomic) PXSolution *solution;

@end
