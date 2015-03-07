//
//  PXTag.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXTag.h"

@implementation PXTag


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"tagID"
                                                       }];
}

@end
