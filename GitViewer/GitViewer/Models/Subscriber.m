//
//  Subscriber.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "Subscriber.h"

@interface Subscriber ()
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *ownerAvatarPath;
@end

@implementation Subscriber
+ (NSArray <Subscriber *> *)fetchSubscribersArrayFromJSON:(id)json
{
    NSMutableArray *subscribers = @[].mutableCopy;
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *jsonArray = (NSArray *)json;
        [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [subscribers insertObject:[Subscriber initSubscribersFromDictionary:obj] atIndex:idx];
        }];
    }
    return subscribers;
}


+ (instancetype)initSubscribersFromDictionary:(NSDictionary *)dictionary
{
    Subscriber *subscriber = [[Subscriber alloc] init];
    if (subscriber && dictionary) {
        subscriber.name = dictionary[@"login"];
        subscriber.ownerAvatarPath = dictionary[@"avatar_url"];
        return subscriber;
    }
    return nil;
}

@end
