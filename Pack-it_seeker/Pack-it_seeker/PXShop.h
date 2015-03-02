//
//  PXShop.h
//  Pack-it_seeker
//
//  Created by Jiyang on 3/2/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import <CoreLocation/CoreLocation.h>

@protocol PXShop
@end

@interface PXShop : JSONModel

@property (strong, nonatomic) NSString *shopID;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString<Optional> *pictureURL;
@property (strong, nonatomic) NSString<Optional> *tel;
@property (strong, nonatomic) NSString<Optional> *desc;
@property (strong, nonatomic) NSString<Optional> *address;
@property (strong, nonatomic) NSString<Optional> *tag_id;
@property (strong, nonatomic) NSString<Optional> *user_id;
@property (strong, nonatomic) NSArray<Optional> *location;


@end
