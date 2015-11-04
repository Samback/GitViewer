//
//  NSArray+IndexPathsArray.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/4/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IndexPathsArray)
+ (NSArray *)arryOfIndexesStartedAtRow:(NSUInteger)startRow withCount:(NSInteger)count;
@end
