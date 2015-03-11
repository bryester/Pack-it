//
//  PXCategory.h
//  Pack-it_seeker
//
//  Created by Jiyang on 3/2/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface PXCategory : JSONModel

@property (strong, nonatomic) NSString<Optional> *categoryID;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *icon;

@end
