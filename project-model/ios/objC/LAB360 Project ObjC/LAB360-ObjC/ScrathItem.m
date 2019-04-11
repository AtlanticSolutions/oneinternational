//
//  ScrathItem.m
//  Raspadinha
//
//  Created by Erico GT on 11/01/18.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import "ScrathItem.h"

@implementation ScrathItem

@synthesize isPremium, scrathView, order, itemImage;

- (ScrathItem*)init
{
    self = [super init];
    if (self) {
        isPremium = false;
        scrathView = nil;
        order = 0;
        itemImage = nil;
    }
    return self;
}

+ (ScrathItem*) newItemWithRect:(CGRect)viewRect imageItem:(UIImage*)iImage imageTexture:(UIImage*)tImage lineThickness:(CGFloat)lineT premium:(bool)premium delegate:(id<MDScratchImageViewDelegate>)scratchImageViewDelegate order:(NSInteger)iOrder
{
    ScrathItem *newItem = [ScrathItem new];
    //
    newItem.isPremium = premium;
    newItem.itemImage = iImage;
    newItem.scrathView = [[MDScratchImageView alloc] initWithFrame:viewRect];
    newItem.backImageView = [[UIImageView alloc] initWithFrame:viewRect];
    newItem.backImageView.contentMode = UIViewContentModeScaleAspectFit;
    newItem.scrathView.delegate = scratchImageViewDelegate;
    [newItem.scrathView setImage:tImage radius:lineT / 2.0];
    [newItem.backImageView setImage:iImage];
    newItem.scrathView.tag = iOrder;
    //
    [newItem.backImageView setClipsToBounds:NO];
    [newItem.backImageView.layer setMasksToBounds:NO];
    [newItem.scrathView setClipsToBounds:NO];
    [newItem.scrathView.layer setMasksToBounds:NO];
    //
    return newItem;
}

@end
