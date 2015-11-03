//
//  Subscriber.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscriber : NSObject
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *ownerAvatarPath;

+ (NSArray <Subscriber *> *)fetchSubscribersArrayFromJSON:(id)json;

@end
