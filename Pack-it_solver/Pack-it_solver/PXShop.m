//
//  PXShop.m
//  Pack-it_seeker
//
//  Created by Jiyang on 3/2/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXShop.h"

@implementation PXShop

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"_id": @"shopID",
                                                       @"picture.url":@"pictureURL",
                                                       @"description":@"desc"
                                                       }];
}

@end
