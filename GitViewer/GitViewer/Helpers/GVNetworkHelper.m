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

@interface GVNetworkHelper ()
@property (nonatomic, readwrite) NSString *accessToken;
@end

@implementation GVNetworkHelper

+ (instancetype)sharedManager
{
    static GVNetworkHelper *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}



//https://developer.github.com/v3/oauth/#github-redirects-back-to-your-site
- (void)fetchOAuthTokenForCode:(NSString *)code withCompletionBlock:(CompletionBlock)completionBlock
{
    if (code) {
        NSDictionary *parameters = @{@"client_id" : kClientID,
                                     @"client_secret" : kClientSecretID,
                                     @"code" : code};
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:kTokenPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {            
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *tokenValue = [@"token " stringByAppendingString:self.accessToken];
    [manager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    
    
    

}




@end
