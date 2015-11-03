//
//  GVHelper.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "AppDelegate.h"
#import "GVHelper.h"
#import "GVKeyChain.h"


NSString *const kClientID = @"6ef19636b8f523ec532d";
NSString *const kClientSecretID = @"e1ea12767019182c8db931a14e2ab9010f90aad8";
NSString *const nRecivedCodeAfterLoginNotification = @"StartAuthentificationProcess";


@implementation GVHelper
+ (void)callForInitialAuthorizeAtGitHub
{
    [GVKeyChain sharedManager].code = nil;
    [GVKeyChain sharedManager].accessToken = nil;
    NSString *path = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=repo&state=development", kClientID];
    if (path) {
        NSURL *urlPath = [NSURL URLWithString:path];
        if ([[UIApplication sharedApplication] canOpenURL:urlPath]) {
            [[UIApplication sharedApplication] openURL:urlPath];
        }
    }
}


@end
