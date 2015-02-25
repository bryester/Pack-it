//
//  PXSolutionTableViewCell.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXSolutionTableViewCell : UITableViewCell{
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_labelShop;
    __weak IBOutlet UILabel *_labelLocation;
    __weak IBOutlet UILabel *_labelPrice;
    
}

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *image;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSString *shop;
@property (strong, nonatomic) NSString *location;

@end
