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
    __weak IBOutlet UILabel *_labelAddress;
    __weak IBOutlet UILabel *_labelPrice;
    __weak IBOutlet UILabel *_labelYuan;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView_customed;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *image;
@property (assign, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *shop;
@property (strong, nonatomic) NSString *address;

@end
