//
//  CarouselViewItem.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselViewItem : UIView

@property (nonatomic, strong) UILabel *lblNote;
@property (nonatomic, strong) UIImageView *imvItem;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
//
+ (CarouselViewItem*)createNewComponentWithFrame:(CGRect)frame;

@end
