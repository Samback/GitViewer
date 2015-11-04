//
//  NSObject+UNNIL.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/4/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "NSObject+UNNIL.h"

@implementation NSObject (UNNIL)
- (instancetype)unnilObject
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return self;
}
@end
