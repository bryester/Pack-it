//
//  PXTag.h
//  Pack-it_seeker
//
//  Created by Jiyang on 2/19/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "PXCategory.h"

@interface PXTag : JSONModel

@property (strong, nonatomic) NSString *tagID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PXCategory<Optional> *category;

@end
