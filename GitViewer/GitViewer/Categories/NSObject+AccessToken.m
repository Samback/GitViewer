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

- (NSError *)fetchErrorFromDictionary
{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)self;
        if (dictionary[@"error"]) {
            return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                 code:401
                                             userInfo:@{NSLocalizedDescriptionKey : dictionary[@"error_description"]}];
            
        }
    }
    return nil;
}

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
