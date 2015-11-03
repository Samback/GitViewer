//
//  UserRepositoriesVC.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "UserRepositoriesVC.h"
#import "RepositoryCell.h"
#import "GVHelper.h"
#import "GVNetworkHelper.h"
#import "NSURL+CodeFetch.h"

@interface UserRepositoriesVC ()
@property (nonatomic, strong) NSArray<Repository*> *repositories;
@end

@implementation UserRepositoriesVC

#pragma mark - Lazy instantiation

- (NSArray <Repository *> *)repositories
{
    if (!_repositories) {
        _repositories = @[];
    }
    return _repositories;
}

- (void)addObjectsAtRepositoriesFromArray:(NSArray <Repository *> *)repositories
{
    NSMutableArray *updatedRepositories = [NSMutableArray arrayWithArray:self.repositories];
    [updatedRepositories addObjectsFromArray:repositories];
    self.repositories = [updatedRepositories copy];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recivedNotificationWithCode:)
                                                 name:nRecivedCodeAfterLoginNotification
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *path = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=repo&state=TEST_STATE", kClientID];
    
    if (path) {
        NSURL *urlPath = [NSURL URLWithString:path];
        if ([[UIApplication sharedApplication] canOpenURL:urlPath]) {
            [[UIApplication sharedApplication] openURL:urlPath];
        }
    }
    
}

- (void)recivedNotificationWithCode:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSURL class]]) {
        NSURL * url = (NSURL *)notification.object;
        NSString *code = [url fetchCodeFromURL];
        UserRepositoriesVC *__weak weakSelf = self;
        [[GVNetworkHelper sharedManager] fetchOAuthTokenForCode:code withCompletionBlock:^(NSError *error) {
            if (!error) {
                [[GVNetworkHelper sharedManager] fetchRepositoriesWithCompletionRepositoriesBlock:^(NSArray<Repository *> *repositories, NSError *error) {
                    if (!error) {
                         [weakSelf addObjectsAtRepositoriesFromArray:repositories];
                    }                   
                }];
            }
        }];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
