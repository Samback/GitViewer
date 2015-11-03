//
//  NSObject+AccessToken.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "NSObject+AccessToken.h"
static NSString *const kAccessToken = @"access_token";

@implementation NSObject (AccessToken)
- (NSString *)fetchAuthTokenFromDictionary
{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)self;
        if (dictionary[kAccessToken]) {
            return dictionary[kAccessToken];
        }
    }
    return nil;
}
@end
