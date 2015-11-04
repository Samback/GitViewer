//
//  RepositoryCell.m
//  GitViewer
//
//  Created by Max Tymchiy on 11/3/15.
//  Copyright © 2015 Max Tymchiy. All rights reserved.
//

#import "RepositoryCell.h"
#import "Repository.h"
#import <UIImageView+AFNetworking.h>
@interface RepositoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ownerView;
@property (weak, nonatomic) IBOutlet UILabel *nameAndForksTitle;
@property (weak, nonatomic) IBOutlet UILabel *repositoryDescription;
@end

@implementation RepositoryCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self roundAvatars];
}

- (void)roundAvatars
{
    CAShapeLayer *shape = [CAShapeLayer layer];
    CGPoint point = CGPointMake(self.ownerView.center.x - 5, self.ownerView.center.y - 6);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:(self.ownerView.bounds.size.width / 2) startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
    shape.path = path.CGPath;
    self.ownerView.layer.mask = shape;
}

- (void)fillCellWithInfo:(Repository *)repository
{
    self.nameAndForksTitle.text = [NSString stringWithFormat:@" %@ forks[%@]", repository.name, repository.forksCount];
    self.repositoryDescription.text = repository.repositoryDescription;
    [self updateImageOfAvatarWithPath:repository.ownerAvatarPath];
    
    
}
- (void)updateImageOfAvatarWithPath:(NSString *)path
{
    NSString *pathForMediumSize = [NSString stringWithFormat:@"%@&s=100", path];
    NSURL *url = [NSURL URLWithString:pathForMediumSize];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:30.0];
    UIImage *image = [[UIImageView sharedImageCache] cachedImageForRequest:request];
    if (image) {
        self.ownerView.image = image;
    } else {
        RepositoryCell *__weak weakCell = self;
        [self.ownerView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             weakCell.ownerView.image = image;
             [weakCell setNeedsLayout];
         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             
         }];
    }
}

@end
