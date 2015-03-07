//
//  PXProblemTableViewCell.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXProblemTableViewCell : UITableViewCell {
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_labelDuration;
    __weak IBOutlet UILabel *_labelStatus;
    __weak IBOutlet UILabel *_labelDesc;
    __weak IBOutlet UILabel *_labelLocation;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView_customed;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *image;
@property (assign, nonatomic) int duration;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *location;

@end
