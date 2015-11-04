//
//  GVKeyChain.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVKeyChain : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) NSString *clientID;
@property (nonatomic, readonly) NSString *clientSecretID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *code;

@end
