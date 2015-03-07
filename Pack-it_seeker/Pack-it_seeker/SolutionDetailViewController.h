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
//#import "NaviViewController.h"

@interface SolutionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_labelPrice;
    __weak IBOutlet UILabel *_labelDesc;
}

@property (strong,nonatomic) PXSolution *solution;

@end
