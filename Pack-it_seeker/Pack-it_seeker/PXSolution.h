//
//  Solution.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import "PXShop.h"

@protocol PXSolution
@end

@interface PXSolution : JSONModel

@property (strong, nonatomic) NSString *solutionID;

@property (strong, nonatomic) UIImage<Ignore> *picture;
@property (strong, nonatomic) NSString<Optional> *pictureURL;
@property (strong, nonatomic) NSString<Optional> *status;
@property (strong, nonatomic) NSString<Ignore> *status_CHN;
@property (strong, nonatomic) NSString<Optional> *desc;
@property (strong, nonatomic) NSNumber<Optional> *price;
@property (strong, nonatomic) PXShop<Optional> *shop_profile;


@end
