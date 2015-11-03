//
//  Repository.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *repositoryDescription;
@property (nonatomic, readonly, copy) NSString *ownerAvatarPath;
@property (nonatomic, readonly, copy) NSString *forksCount;
@property (nonatomic, readonly, copy) NSString *subscribersURL;

+ (NSArray <Repository *> *)fetchRepositoriesArrayFromJSON:(id)json;

@end
