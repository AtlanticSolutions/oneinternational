//
//  CustomPickerView.h
//  AHK-100anos
//
//  Created by Erico GT on 10/20/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol CustomPickerViewDelegate <NSObject>

@required
-(void)didConfirmItem:(nullable NSString*)selectedItem forSender:(nullable id)sender;
-(void)didClearSelectionForSender:(nullable id)sender;
-(nonnull NSArray<NSString*>*)loadDataForSender:(nullable id)sender;
@end

@interface CustomPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

+(nonnull CustomPickerView*)createComponent;
-(void)initPickerViewWithDelegate:(nonnull UIViewController<CustomPickerViewDelegate>*)delegate confirmButtonTitle:(nullable NSString*)titleConfirm clearButtonTitle:(nullable NSString*)titleClear;
-(void)showPickerViewWithSender:(nullable id)sender rowSelected:(int)rowIndex animated:(bool)animated;
-(void)hidePickerViewAnimated:(bool)animated;
//
-(void)setAccessoryBackgroundColor:(nonnull UIColor*)color;
-(void)configRightButton:(nullable NSString*)bTitle font:(nullable UIFont*)bFont textColor:(nullable UIColor*)bColor enabled:(BOOL)bEnabled;
-(void)configLeftButton:(nullable NSString*)bTitle font:(nullable UIFont*)bFont textColor:(nullable UIColor*)bColor enabled:(BOOL)bEnabled;

@end
