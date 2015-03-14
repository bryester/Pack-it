//
//  PXTagHolder.m
//  Pack-it_seeker
//
//  Created by Jiyang on 3/14/15.
//  Copyright (c) 2015 Jiyang. All rights reserved.
//

#import "PXTagHolder.h"

#define KEY_TAGS @"tags"

@implementation PXTagHolder
@synthesize tags = _tags;

+ (instancetype)sharedInstance {
    static PXTagHolder *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [PXTagHolder new];
        [shared loadTags];
    });
    return shared;
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    [self saveTags:tags];
}

- (void)saveTags:(NSArray *)tags {
    //NSLog(@"saveData");
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSKeyedArchiver archivedDataWithRootObject:tags] forKey:KEY_TAGS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadTags {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_TAGS])
    {
        NSData *tagsData = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TAGS];
        _tags = [NSKeyedUnarchiver unarchiveObjectWithData:tagsData];
    }
}

- (BOOL)hasTags {
    if (_tags && _tags.count > 0) {
        return YES;
    }
    return NO;
}

@end
