//
//  CustomPickerView.m
//  AHK-100anos
//
//  Created by Erico GT on 10/20/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()<CustomPickerViewDelegate>

//Properties
@property(nonatomic, assign) bool initialized;
@property(nonatomic, assign) bool visible;
@property(nonatomic, strong) NSArray* arrayData;
@property(nonatomic, assign) int selectedIndex;
@property(nonatomic, weak) id senderForReference;

//View
@property(nonatomic, strong) UIViewController<CustomPickerViewDelegate> *delegateController;
@property(nonatomic, strong) IBOutlet UIView *acessoryView;
@property(nonatomic, strong) IBOutlet UIButton *btnConfirm;
@property(nonatomic, strong) IBOutlet UIButton *btnClear;
@property(nonatomic, strong) IBOutlet UIImageView *imvLine;
@property(nonatomic, strong) IBOutlet UIPickerView *pkrView;


@end

@implementation CustomPickerView

@synthesize initialized, delegateController, arrayData, selectedIndex, senderForReference, visible;
@synthesize acessoryView, btnConfirm, btnClear, pkrView, imvLine;

+(nonnull CustomPickerView*)createComponent
{
    NSArray* arrayNibCustomPickerView = [[NSBundle mainBundle] loadNibNamed:@"CustomPickerView" owner:nil options:nil];
    CustomPickerView *pickerView = (CustomPickerView*)[arrayNibCustomPickerView objectAtIndex:0];
    return pickerView;
}

- (CustomPickerView*)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

-(void)initPickerViewWithDelegate:(nonnull UIViewController<CustomPickerViewDelegate>*)delegate confirmButtonTitle:(nullable NSString*)titleConfirm clearButtonTitle:(nullable NSString*)titleClear;
{
    if (!initialized) {
        // Initialization code
        if (delegate == nil)
        {
            NSException* myException = [NSException exceptionWithName:@"InvalidParametersForInitialization" reason:@"All parameters are expected." userInfo:nil];
            @throw myException;
        }else{
            initialized = true;
            visible = false;
            selectedIndex = -1;
            delegateController = delegate;
            //
            self.frame = CGRectMake(0, 0, delegate.view.frame.size.width, 230);
            self.backgroundColor = [UIColor whiteColor];
            pkrView.backgroundColor = [UIColor clearColor];
            acessoryView.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
            //
            btnConfirm.backgroundColor = [UIColor clearColor];
            btnClear.backgroundColor = [UIColor clearColor];
            //
            btnConfirm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [btnConfirm setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            //
            [btnConfirm.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
            [btnConfirm setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
            if (titleConfirm == nil){
                [btnConfirm  setTitle:@"Select" forState:UIControlStateNormal];
            }else{
                [btnConfirm  setTitle:titleConfirm forState:UIControlStateNormal];
            }
            [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
            [btnClear setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
            if (titleClear == nil){
                [btnClear  setTitle:@"Clear" forState:UIControlStateNormal];
            }else{
                [btnClear  setTitle:titleClear forState:UIControlStateNormal];
            }
            //
            imvLine.backgroundColor = [UIColor clearColor];
            imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [imvLine setTintColor:[UIColor lightGrayColor]];
            //
            self.alpha = 0.0;
            [delegateController.view addSubview:self];
        }
    }
}

-(void)showPickerViewWithSender:(nullable id)sender rowSelected:(int)rowIndex animated:(bool)animated;
{
    if (initialized){
        
        //[self layoutIfNeeded];
        self.frame = CGRectMake(0, delegateController.view.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.alpha = 1.0;
        [delegateController.view bringSubviewToFront:self];
        
        senderForReference = sender;
        arrayData = [delegateController loadDataForSender:senderForReference];
        [self.pkrView reloadAllComponents];
        
        if (rowIndex < 0){
            selectedIndex = 0;
        }else if(rowIndex > (arrayData.count - 1)){
            selectedIndex = (arrayData.count - 1);
        }else{
            selectedIndex = rowIndex;
        }
        
        [pkrView selectRow:selectedIndex inComponent:0 animated:NO];
        
        if (!visible)
        {
            visible = true;
            if (animated){
                [UIView animateWithDuration:ANIMA_TIME_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.frame = CGRectMake(0, delegateController.view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    //
                }];
            }else{
                self.frame = CGRectMake(0, delegateController.view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            }
        }else{
            self.frame = CGRectMake(0, delegateController.view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }
    }else{
        NSException* myException = [NSException exceptionWithName:@"IncorrectInitializationMethod" reason:@"Initializate component using method 'initWithDelegate:confirmButtonTitle:clearButtonTitle'." userInfo:nil];
        @throw myException;
    }
}

-(void)hidePickerViewAnimated:(bool)animated
{
    if (initialized){
        
        if (selectedIndex == -1){
            [delegateController didClearSelectionForSender:senderForReference];
        }else{
            [delegateController didConfirmItem:[arrayData objectAtIndex:selectedIndex] forSender:senderForReference];
        }

        if (visible)
        {
            visible = false;
            if (animated){
                [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.frame = CGRectMake(0, delegateController.view.frame.size.height, self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    self.alpha = 0.0;
                }];
            }else{
                self.frame = CGRectMake(0, delegateController.view.frame.size.height, self.frame.size.width, self.frame.size.height);
                self.alpha = 0.0;
            }
        }
        
    }else{
        NSException* myException = [NSException exceptionWithName:@"IncorrectInitializationMethod" reason:@"Initializate component using method 'initWithDelegate:confirmButtonTitle:clearButtonTitle'." userInfo:nil];
        @throw myException;
    }
}

- (IBAction)hideAction:(id)sender
{
    if (sender == btnClear){
        selectedIndex = -1;
    }
    
    [self hidePickerViewAnimated:true];
}

#pragma mark - PickerView Delegate

//DELEGATE
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    if (view){
        ((UILabel*)view).text = [arrayData objectAtIndex:row];
        return view;
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR]];
        label.textColor = [UIColor blackColor];
        label.text = [arrayData objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
        //
        return label;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = (int)row;
}

//DATA SOURCE

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrayData.count;
}

#pragma mark - Layout Configuration

-(void)setAccessoryBackgroundColor:(nonnull UIColor*)color
{
    acessoryView.backgroundColor = color;
}

-(void)configRightButton:(nullable NSString*)bTitle font:(nullable UIFont*)bFont textColor:(nullable UIColor*)bColor enabled:(BOOL)bEnabled
{
    if (bTitle){
        [btnConfirm setTitle:bTitle forState:UIControlStateNormal];
    }
    //
    if (bFont){
        [btnConfirm.titleLabel setFont:bFont];
    }
    //
    if (bColor){
        [btnConfirm setTitleColor:bColor forState:UIControlStateNormal];
    }
    //
    [btnConfirm setEnabled:bEnabled];
}

-(void)configLeftButton:(nullable NSString*)bTitle font:(nullable UIFont*)bFont textColor:(nullable UIColor*)bColor enabled:(BOOL)bEnabled
{
    if (bTitle){
        [btnClear setTitle:bTitle forState:UIControlStateNormal];
    }
    //
    if (bFont){
        [btnClear.titleLabel setFont:bFont];
    }
    //
    if (bColor){
        [btnClear setTitleColor:bColor forState:UIControlStateNormal];
    }
    //
    [btnClear setEnabled:bEnabled];
}


@end
