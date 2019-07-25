//
//  PanoramaViewItemCell.m
//  aw_experience
//
//  Created by Erico GT on 12/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "PanoramaViewItemCell.h"

@implementation PanoramaViewItemCell

@synthesize imvItem, activityIndicator;

- (void)setupLayout
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentView.backgroundColor = nil;
    //
    imvItem.backgroundColor = nil;
    imvItem.contentMode = UIViewContentModeScaleAspectFill;
    imvItem.image = nil;
    [imvItem cancelImageRequestOperation];
    //
    activityIndicator.backgroundColor = nil;
    activityIndicator.color = [UIColor darkGrayColor];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    
    self.layer.cornerRadius = 3.0;
    
    [self.imvItem cancelImageRequestOperation];
}

@end

