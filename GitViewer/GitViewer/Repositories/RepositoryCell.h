//
//  RepositoryCell.h
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Repository;

@interface RepositoryCell : UITableViewCell

- (void)fillCellWithInfo:(Repository *)repository;

@end
