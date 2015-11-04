//
//  GVParentVC.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/4/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "GVParentVC.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import "UIColor+AppColorLegend.h"

@interface GVParentVC ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DGActivityIndicatorView *spinnerView;
@end

@implementation GVParentVC

#pragma mark - Lazy instantiation
- (DGActivityIndicatorView *)spinnerView
{
    if (!_spinnerView) {
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple
                                                                                             tintColor:[UIColor appMainColor]];
        CGFloat length = 50;
        
        activityIndicatorView.frame = CGRectMake((self.view.bounds.size.width - length)/2 , (self.view.bounds.size.height - length)/2, length, length);
        _spinnerView = activityIndicatorView;
        _spinnerView.hidden = YES;
        [self.view addSubview:_spinnerView];
    }
    return _spinnerView;
}

- (void)startSpinnerAnimation
{
    self.spinnerView.hidden = NO;
    [self.spinnerView startAnimating];
}
- (void)stopSpinnerAnimation
{
    self.spinnerView.hidden = YES;
    [self.spinnerView stopAnimating];
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
