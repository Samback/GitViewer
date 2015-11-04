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

NSString *const nRecivedCodeAfterLoginNotification = @"StartAuthentificationProcess";
NSInteger const kPageSize = 20;

@implementation GVHelper
+ (void)callForInitialAuthorizeAtGitHub
{
    [GVKeyChain sharedManager].code = nil;
    [GVKeyChain sharedManager].accessToken = nil;
    NSString *path = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=repo&state=development", [GVKeyChain sharedManager].clientID];
    if (path) {
        NSURL *urlPath = [NSURL URLWithString:path];
        if ([[UIApplication sharedApplication] canOpenURL:urlPath]) {
            [[UIApplication sharedApplication] openURL:urlPath];
        }
    }
}


+ (void)showAlertBasedOnError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Warning"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}
@end
