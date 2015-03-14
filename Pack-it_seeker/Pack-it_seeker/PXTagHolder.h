//
//  PXTagHolder.h
//  Pack-it_seeker
//
//  Created by Jiyang on 3/14/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXTag.h"

@interface PXTagHolder : NSObject

@property (strong, nonatomic) NSArray *tags;

+ (instancetype)sharedInstance;

//- (void)saveTags:(NSArray *)tags;

//- (void)loadTags;

- (BOOL)hasTags;

@end
