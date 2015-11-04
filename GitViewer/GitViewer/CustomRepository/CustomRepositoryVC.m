//
//  CustomRepositoryVC.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "CustomRepositoryVC.h"
#import "Subscriber.h"
#import <AFNetworking/AFNetworking.h>
#import "UITableView+ConfigurateSeparator.h"


static NSString * const  kSubscriberCellIdentifier = @"SubscriberCell";
@interface CustomRepositoryVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSString *repositoryName;
@property (nonatomic, copy) NSString *subscribersPath;
@property (nonatomic, strong) AFHTTPRequestOperation *fetchOperation;
@property (nonatomic, strong) NSArray <Subscriber *> *subscribers;
@end

@implementation CustomRepositoryVC


- (void)setSubscribers:(NSArray <Subscriber *> *)subscribers
{
    _subscribers = subscribers;
    self.tableView.hidden = NO;
    [self.tableView reloadData];

}

- (void)configurateVCWithName:(NSString *)name
         usingSubscribersPath:(NSString *)path
{
    self.repositoryName = name;
    self.subscribersPath = path;
    CustomRepositoryVC *__weak weakSelf = self;
    self.title = name;
    self.tableView.hidden = YES;
    self.fetchOperation =
    [[AFHTTPRequestOperationManager manager]
     GET:path
     parameters:nil
     success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         weakSelf.subscribers = [Subscriber fetchSubscribersArrayFromJSON:responseObject];
         dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.navigationItem.prompt = [NSString stringWithFormat:@"Subscribers [%lu]", (unsigned long)weakSelf.subscribers.count];
         });
        
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"Error %@", error);
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.fetchOperation cancel];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subscribers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubscriberCellIdentifier
                                                            forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView configurateSeparatorForCell:cell];
    cell.textLabel.text = (self.subscribers[indexPath.row]).name;
}


@end
