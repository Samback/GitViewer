//
//  GVNetworkHelper.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Repository;
@class Subscriber;


typedef void (^CompletionBlock)(NSError *error);
typedef void (^CompletionRepositoriesBlock)(NSArray <Repository *> * repositories, NSError *error);
typedef void (^CompletionSubscribersBlock)(NSArray <Subscriber *> * subscribers, NSError *error);

@interface GVNetworkHelper : NSObject
@property (nonatomic, readonly) NSString *accessToken;

+ (instancetype)sharedManager;

- (void)updateAuthorizationHeader;
- (void)fetchOAuthTokenWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)fetchRepositoriesAtPage:(NSInteger)page withCompletionRepositoriesBlock:(CompletionRepositoriesBlock)completionRepositoriesBlock;
- (void)fetchSubscribersAtPath:(NSString *) path withCompletionSubscribersBlock:(CompletionSubscribersBlock)completionSubscribersBlock;

@end
