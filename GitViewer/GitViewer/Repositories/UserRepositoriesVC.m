//
//  UserRepositoriesVC.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/2/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "UserRepositoriesVC.h"
#import "CustomRepositoryVC.h"
#import "RepositoryCell.h"
#import "Repository.h"

#import "GVHelper.h"
#import "GVNetworkHelper.h"
#import "GVKeyChain.h"

#import "NSURL+CodeFetch.h"
#import "UITableView+ConfigurateSeparator.h"

static  NSString *repositoryCellIdentifier = @"RepositoryCell";
static  NSString *sCustomRepositoryVCSegue = @"CustomRepositoryVCSegue";
static  CGFloat repositoryCellHeight = 58.0;

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
    
    if (![GVKeyChain sharedManager].accessToken) {
        [GVHelper callForInitialAuthorizeAtGitHub];
    } else {
        [self fetchRepositories];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recivedNotificationWithCode:)
                                                 name:nRecivedCodeAfterLoginNotification
                                               object:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    // Do any additional setup after loading the view.
}

- (void)recivedNotificationWithCode:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSURL class]]) {
        NSURL * url = (NSURL *)notification.object;
        [GVKeyChain sharedManager].code = [url fetchCodeFromURL];
    } else if (![GVKeyChain sharedManager].code )
    {
        [GVHelper callForInitialAuthorizeAtGitHub];
        return;
    }
    UserRepositoriesVC *__weak weakSelf = self;
    [[GVNetworkHelper sharedManager] fetchOAuthTokenWithCompletionBlock:^(NSError *error) {
        if (!error) {
            [weakSelf fetchRepositories];
        }
    }];
}

- (void)fetchRepositories
{
    UserRepositoriesVC *__weak weakSelf = self;
    [[GVNetworkHelper sharedManager] fetchRepositoriesWithCompletionRepositoriesBlock:^(NSArray<Repository *> *repositories, NSError *error) {
        if (!error) {
            [weakSelf addObjectsAtRepositoriesFromArray:repositories];
        } else if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Warning"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] show];
            });           
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return repositoryCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView configurateSeparatorForCell:cell];
    if ([cell isKindOfClass:[RepositoryCell class]]) {
        [(RepositoryCell *)cell fillCellWithInfo:[self.repositories objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoryCell *cell =  (RepositoryCell *)[tableView dequeueReusableCellWithIdentifier:repositoryCellIdentifier];
    return cell;
}

#pragma mark - Segue connection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:sCustomRepositoryVCSegue] && [sender isKindOfClass:[UITableViewCell class]]) {
        CustomRepositoryVC *customRepositoryVC = (CustomRepositoryVC *)segue.destinationViewController;
        NSInteger rowID = [self.tableView indexPathForCell:(UITableViewCell *)sender].row;
        Repository *repository =  self.repositories[rowID];
        [customRepositoryVC configurateVCWithName:repository.name
                             usingSubscribersPath:repository.subscribersURL];
    }
    
}

#pragma mark - Memory Part

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nRecivedCodeAfterLoginNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
