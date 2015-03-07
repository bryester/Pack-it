//
//  PXCategory.m
//  Pack-it_seeker
//
//  Created by Jiyang on 3/2/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXCategory.h"

@implementation PXCategory

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"categoryID"
                                                       }];
}

@end
