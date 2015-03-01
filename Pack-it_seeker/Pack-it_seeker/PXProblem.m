//
//  Problem.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXProblem.h"

@implementation PXProblem

- (instancetype)initWithString:(NSString *)string error:(JSONModelError *__autoreleasing *)err {
    self = [self initWithString:string error:err];
    
    
    return self;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"problemID",
                                                       @"picture.url":@"pictureURL",
                                                       @"solved_solutions":@"solutions"
                                                       }];
}

//- (void)setPictureURL:(NSString *)pictureURL {
//    NSLog(@"setPic");
//    self.pictureURL = [NSString stringWithFormat:@"%@%@", BASE_URL, pictureURL];
//}

@end
