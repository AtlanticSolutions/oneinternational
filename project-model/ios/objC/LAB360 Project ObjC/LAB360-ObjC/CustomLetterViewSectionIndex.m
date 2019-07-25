//
//  CustomLetterViewSectionIndex.m
//  AHK-100anos
//
//  Created by Erico GT on 10/26/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "CustomLetterViewSectionIndex.h"

@interface CustomLetterViewSectionIndex()

@property(nonatomic, weak) IBOutlet UIImageView* imvArrow;
@property(nonatomic, weak) IBOutlet UILabel* lblLetter;
//
@property(nonatomic, strong) UITableView *tableViewDelegate;

@end

@implementation CustomLetterViewSectionIndex

@synthesize imvArrow, lblLetter;
@synthesize tableViewDelegate;

+(nonnull CustomLetterViewSectionIndex*)createComponent
{
    NSArray* arrayNibCustomPickerView = [[NSBundle mainBundle] loadNibNamed:@"CustomLetterViewSectionIndex" owner:nil options:nil];
    CustomLetterViewSectionIndex *letterView = (CustomLetterViewSectionIndex*)[arrayNibCustomPickerView objectAtIndex:0];
    return letterView;
}

//- (CustomLetterViewSectionIndex*)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        //
//    }
//    return self;
//}
//
//- (CustomLetterViewSectionIndex*)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //
//    }
//    return self;
//}

- (void)bindWithTableView:(UITableView*)tableView
{
    self.frame = CGRectMake(0, 0, 45, 30);
    //
    self.backgroundColor = [UIColor clearColor];
    self.imvArrow.backgroundColor = [UIColor clearColor];
    self.imvArrow.image = [[UIImage imageNamed:@"icon-letter-index-right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imvArrow.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    self.lblLetter.backgroundColor = [UIColor clearColor];
    self.lblLetter.textColor = [UIColor whiteColor];
    self.tableViewDelegate = tableView;
    [ToolBox graphicHelper_ApplyShadowToView:self withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:2.0 opacity:0.75];
    //
    [self.tableViewDelegate.superview addSubview:self];
    [self layoutIfNeeded];
    self.alpha = 0.0;
}

- (void)showWithLetter:(NSString*)letterText position:(CGFloat)yPosition
{
    self.frame = CGRectMake(tableViewDelegate.frame.size.width - 80, yPosition, 45, 30);
    [tableViewDelegate.superview bringSubviewToFront:self];
    lblLetter.text = letterText;
    self.alpha = 1.0;
    
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        //
    }];
}

@end
