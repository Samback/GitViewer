//
//  Repository.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "Repository.h"

@interface Repository ()

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *repositoryDescription;
@property (nonatomic, readwrite, copy) NSString *ownerAvatarPath;
@property (nonatomic, readwrite, copy) NSString *forksCount;
@property (nonatomic, readwrite, copy) NSString *subscribersURL;

@end

@implementation Repository

+ (instancetype)initRepositoryFromDictionary:(NSDictionary *)dictionary
{
    Repository *repository = [[Repository alloc] init];
    if (repository && dictionary) {
        repository.name = dictionary[@"name"];
        repository.repositoryDescription = dictionary[@"description"];
        repository.ownerAvatarPath = dictionary[@"owner"][@"avatar_url"];
        repository.forksCount = dictionary[@"forks_count"];
        repository.subscribersURL = dictionary[@"subscribers_url"];
        return repository;
    }
    return nil;
}
@end
