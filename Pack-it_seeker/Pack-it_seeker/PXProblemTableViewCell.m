//
//  PXProblemTableViewCell.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXProblemTableViewCell.h"

@implementation PXProblemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    
    //Download image from _imageURL
    _imageView = nil;
}

- (void)setDuration:(int)duration {
    _labelDuration.text = [NSString stringWithFormat:@"有效时间：%d", duration];
}

- (void)setDesc:(NSString *)desc {
    _labelDesc.text = desc;
}

- (void)setLocation:(NSString *)location {
    _labelLocation.text = location;
}

- (void)setStatus:(NSString *)status {
    _labelStatus.text = status;
}
@end
