//
//  GVKeyChain.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "GVKeyChain.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"
#import "GVNetworkHelper.h"

static NSString * const kAccessTokenKey = @"accessTokenKey";
static NSString * const kCodeTokenKey = @"codeTokenKey";

@interface GVKeyChain ()
@property (nonatomic, strong) UICKeyChainStore *keychain;
@end

@implementation GVKeyChain

+ (instancetype)sharedManager
{
    static GVKeyChain *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.keychain = [UICKeyChainStore keyChainStore];
        sharedManager.keychain[@"clientID"] = @"6ef19636b8f523ec532d";
        sharedManager.keychain[@"clientSecretID"] = @"e1ea12767019182c8db931a14e2ab9010f90aad8";
    });
    return sharedManager;
}

- (NSString *)clientID
{
    return self.keychain[@"clientID"];
}

- (NSString *)clientSecretID
{
     return self.keychain[@"clientSecretID"];
}

- (void)setAccessToken:(NSString *)accessToken
{
    if (accessToken) {
        self.keychain[kAccessTokenKey] = accessToken;
        [[GVNetworkHelper sharedManager] updateAuthorizationHeader];
    } else {
        self.keychain[kAccessTokenKey] = nil;
        [[GVNetworkHelper sharedManager] updateAuthorizationHeader];
    }
    
}

- (NSString *)accessToken
{
    if (self.keychain[kAccessTokenKey]) {
        return self.keychain[kAccessTokenKey];
    }
    return nil;
}

- (void)setCode:(NSString *)code
{
    self.keychain[kCodeTokenKey] = code;
}

- (NSString *)code
{
    return self.keychain[kCodeTokenKey];
}

@end
