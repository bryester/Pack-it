//
//  PXNetworkManager.m
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXNetworkManager.h"

@implementation PXNetworkManager

#pragma mark - Init Methods

+ (instancetype)sharedStore{
    static PXNetworkManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [PXNetworkManager new];
        
    });
    return shared;
}

#pragma mark - User Methods

- (void)loginByUsername:(NSString *)username password:(NSString *)pswd {
    
}

#pragma mark - Functional Methods
- (void)getAllProblems {
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:22.0 longitude:22.0];
    PXProblem *problem = [PXProblem new];
    
    problem.pictureURL = @"xxx";
    
    problem.location = nil;
    problem.status = @"yStatus";
    problem.duration = 1;
    problem.pictureURL = @"http://image.baidu.com/channel?c=%E6%B1%BD%E8%BD%A6&t=%E5%85%A8%E9%83%A8&s=0";
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:problem];
    
    if ([self.delegate respondsToSelector:@selector(onGetAllProblemsResult:error:)]) {
        [self.delegate onGetAllProblemsResult:array error:nil];
    }
}

- (void)postNewProblem {
    
}

- (void)deleteProblem:(PXProblem *)problem {
    
}

@end
