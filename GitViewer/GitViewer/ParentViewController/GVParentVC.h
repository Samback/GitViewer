//
//  GVParentVC.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/4/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVParentVC : UIViewController
@property (nonatomic, readonly, weak) UITableView *tableView;

- (void)startSpinnerAnimation;
- (void)stopSpinnerAnimation;

@end
