//
//  Solution.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXSolution.h"

@implementation PXSolution

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"solutionID",
                                                       @"picture.url":@"pictureURL",
                                                       @"description":@"desc"
                                                       }];
}

@end
