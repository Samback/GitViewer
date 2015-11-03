//
//  GVHelper.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const nRecivedCodeAfterLoginNotification;

@interface GVHelper : NSObject
+ (void)callForInitialAuthorizeAtGitHub;
@end
