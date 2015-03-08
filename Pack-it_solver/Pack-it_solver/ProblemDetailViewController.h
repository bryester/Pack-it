//
//  ProblemDetailViewController.h
//  Pack-it_solver
//
//  Created by Jiyang on 3/8/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXSolution.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Config.h"
#import "SolutionDetailViewController.h"

@interface ProblemDetailViewController : UIViewController {
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_labelDesc;
    
    __weak IBOutlet UIButton *_btnToSolution;
}

@property (strong, nonatomic) PXSolution *solution;

@end
