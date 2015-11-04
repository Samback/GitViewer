//
//  CustomRepositoryVC.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVParentVC.h"

@interface CustomRepositoryVC : GVParentVC
- (void)configurateVCWithName:(NSString *)name
         usingSubscribersPath:(NSString *)path;


@end
