//
//  Problem.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONModel.h"
#import "PXSolution.h"
#import "PXTag.h"
#import "Config.h"

@protocol PXProblem
@end

@interface PXProblem : JSONModel

@property (strong, nonatomic) NSString *problemID;

@property (strong, nonatomic) UIImage<Ignore> *picture;
@property (strong, nonatomic) NSString<Optional> *pictureURL;
@property (strong, nonatomic) NSString<Optional> *status;
@property (strong, nonatomic) NSString<Ignore> *status_CHN;
@property (strong, nonatomic) NSString<Optional> *desc;
@property (assign, nonatomic) int duration;
@property (strong, nonatomic) NSArray<Optional, PXSolution> *solutions;   //@PXSolution
@property (strong, nonatomic) PXTag<Optional> *tag;
@property (strong, nonatomic) CLLocation<Ignore> *location;

- (instancetype)initWithString:(NSString *)string error:(JSONModelError *__autoreleasing *)err;

@end
