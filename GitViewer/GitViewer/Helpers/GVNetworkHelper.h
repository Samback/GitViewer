//
//  GVNetworkHelper.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  Repository;


typedef void (^CompletionBlock)(NSError *error);
typedef void (^CompletionRepositoriesBlock)(NSArray <Repository *> * repositories, NSError *error);

@interface GVNetworkHelper : NSObject
@property (nonatomic, readonly) NSString *accessToken;

+ (instancetype)sharedManager;
- (void)fetchOAuthTokenForCode:(NSString *)code withCompletionBlock:(CompletionBlock)completionBlock;
- (void)fetchRepositories;
@end
