//
//  PXSolutionTableViewCell.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXSolutionTableViewCell.h"

@implementation PXSolutionTableViewCell

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

- (void)setShop:(NSString *)shop {
    _labelShop.text = shop;
}

- (void)setAddress:(NSString *)address {
    _labelAddress.text = address;
}

- (void)setPrice:(NSNumber *)price {
    _labelPrice.text = [NSString stringWithFormat:@"%@", price];
}

@end
