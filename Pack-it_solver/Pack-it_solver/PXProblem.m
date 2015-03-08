//
//  Problem.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXProblem.h"

@implementation PXProblem

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"problemID",
                                                       @"picture.url":@"pictureURL",
                                                       @"description":@"desc"
                                                       }];
}

//- (void)setPictureURL:(NSString *)pictureURL {
//    NSLog(@"setPic");
//    self.pictureURL = [NSString stringWithFormat:@"%@%@", BASE_URL, pictureURL];
//}

@end
