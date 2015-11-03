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
#import "RepositoryCell.h"

static  NSString *repositoryCellIdentifier = @"RepositoryCell";

@interface UserRepositoriesVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<Repository*> *repositories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recivedNotificationWithCode:)
                                                 name:nRecivedCodeAfterLoginNotification
                                               object:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
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

#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell isKindOfClass:[RepositoryCell class]]) {
        [(RepositoryCell *)cell fillCellWithInfo:[self.repositories objectAtIndex:indexPath.row]];
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoryCell *cell =  (RepositoryCell *)[tableView dequeueReusableCellWithIdentifier:repositoryCellIdentifier];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
