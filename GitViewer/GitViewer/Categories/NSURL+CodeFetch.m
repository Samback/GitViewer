//
//  NSURL+CodeFetch.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "NSURL+CodeFetch.h"

@implementation NSURL (CodeFetch)

- (NSString *)fetchCodeFromURL
{
    NSString *code = nil;
    NSURLComponents *components = [NSURLComponents componentsWithURL:self
                                             resolvingAgainstBaseURL:NO];
    
    for (NSURLQueryItem *queryItem in components.queryItems) {
        if ([[queryItem.name lowercaseString] isEqualToString:@"code"]) {
            return code = queryItem.value;
        }
    }
    return nil;
}

@end
