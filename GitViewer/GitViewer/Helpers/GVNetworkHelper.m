//
//  GVNetworkHelper.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//



#import "GVNetworkHelper.h"

#import "Repository.h"
#import "Subscriber.h"

#import "GVHelper.h"
#import "GVKeyChain.h"

#import "NSObject+AccessToken.h"


#import <AFNetworking/AFNetworking.h>

static NSString *const kTokenPath = @"https://github.com/login/oauth/access_token";
static NSString *const kUserReposPath = @"https://api.github.com/user/repos";

@interface GVNetworkHelper ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation GVNetworkHelper

+ (instancetype)sharedManager
{
    static GVNetworkHelper *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager configurateManager];
    });
    return sharedManager;
}

//https://developer.github.com/v3/#current-version
- (void)configurateManager
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

//https://developer.github.com/v3/oauth/#github-redirects-back-to-your-site
- (void)fetchOAuthTokenWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *code = [GVKeyChain sharedManager].code;
    if (code) {
        NSDictionary *parameters = @{@"client_id" : [GVKeyChain sharedManager].clientID,
                                     @"client_secret" : [GVKeyChain sharedManager].clientSecretID,
                                     @"code" : code};
        
        [self.manager POST:kTokenPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [GVKeyChain sharedManager].accessToken = [responseObject fetchAuthTokenFromDictionary];
            completionBlock(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [GVKeyChain sharedManager].accessToken = nil;
            completionBlock(error);
        }];
    }
}

- (void)updateAuthorizationHeader
{
    NSString *accessToken = [GVKeyChain sharedManager].accessToken;
    if (accessToken) {
        NSString *tokenValue = [@"token " stringByAppendingString:accessToken];
        [self.manager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    } else {
        [self.manager.requestSerializer clearAuthorizationHeader];
    }
}

//https://developer.github.com/v3/oauth/#scopes
- (void)fetchRepositoriesWithCompletionRepositoriesBlock:(CompletionRepositoriesBlock)completionRepositoriesBlock
{
    [self updateAuthorizationHeader];
    [self.manager GET:kUserReposPath
           parameters:nil
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  completionRepositoriesBlock([Repository fetchRepositoriesArrayFromJSON:responseObject], nil);
              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  completionRepositoriesBlock(nil, error);
              }];
}


- (void)fetchSubscribersAtPath:(NSString *)path withCompletionSubscribersBlock:(CompletionSubscribersBlock)completionSubscribersBlock
{
    [self.manager GET:path
           parameters:nil
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  completionSubscribersBlock([Subscriber fetchSubscribersArrayFromJSON:responseObject], nil);
              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  completionSubscribersBlock(nil, error);
              }];
}

@end
