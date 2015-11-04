//
//  GVParentVC.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/4/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "GVParentVC.h"

@interface GVParentVC ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GVParentVC


- (void)startAnimation
{
    
}
- (void)stopAnimation
{
    
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
