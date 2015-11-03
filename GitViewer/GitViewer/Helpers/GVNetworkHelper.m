//
//  GVNetworkHelper.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "GVNetworkHelper.h"
#import "GVHelper.h"
#import  "NSObject+AccessToken.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kTokenPath = @"https://github.com/login/oauth/access_token";
static NSString *const kUserReposPath = @"https://api.github.com/user/repos";

@interface GVNetworkHelper ()
@property (nonatomic, readwrite) NSString *accessToken;
@property (nonatomic, strong)  AFHTTPRequestOperationManager *manager;
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
- (void)fetchOAuthTokenForCode:(NSString *)code withCompletionBlock:(CompletionBlock)completionBlock
{
    if (code) {
        NSDictionary *parameters = @{@"client_id" : kClientID,
                                     @"client_secret" : kClientSecretID,
                                     @"code" : code};
        
        [self.manager POST:kTokenPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            self.accessToken = [responseObject fetchAuthTokenFromDictionary];
            completionBlock(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            completionBlock(error);
        }];
    }
}


//https://developer.github.com/v3/oauth/#scopes
- (void)fetchRepositories
{   
    NSString *tokenValue = [@"token " stringByAppendingString:self.accessToken];
    [self.manager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    
    [self.manager GET:kUserReposPath
           parameters:nil
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  NSLog(@"Repos %@", responseObject);
              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                  NSLog(@"Error %@", error);
              }];
    
}


//https://developer.github.com/v3/#current-version



@end
