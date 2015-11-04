//
//  NSArray+IndexPathsArray.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/4/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "NSArray+IndexPathsArray.h"
#import <UIKit/UIKit.h>

@implementation NSArray (IndexPathsArray)

+ (NSArray *)arryOfIndexesStartedAtRow:(NSUInteger)startRow withCount:(NSInteger)count
{
    NSMutableArray *indexes = @[].mutableCopy;
    for (NSUInteger row = startRow; row < startRow + count; row++) {
        [indexes addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }
    return indexes.copy;
}

@end
