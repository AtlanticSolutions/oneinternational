//
//  LightControlView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 02/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "LightControlView.h"
#import "AppDelegate.h"
#import "ToolBox.h"

@interface LightControlView()

//Data:
@property(nonatomic, strong) LightControlParameter *parameter;

//Layout:
@property(nonatomic, weak) IBOutlet UIView* contentView;
@property(nonatomic, weak) IBOutlet UILabel* lblName;
@property(nonatomic, weak) IBOutlet UILabel* lblValue;
@property(nonatomic, weak) IBOutlet UISlider* slider;

@end

@implementation LightControlView

@synthesize viewDelegate, parameter;
@synthesize contentView, lblName, lblValue, slider;

#pragma mark - INITIALIZERS

+ (LightControlView*)newLightControlViewWithFrame:(CGRect)frame parameter:(LightControlParameter*)lightParameter andDelegate:(id<LightControlViewDelegate>)delegate
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"LightControlView" owner:self options:nil];
    LightControlView *view = (LightControlView *)[nibArray objectAtIndex:0];
    [view awakeFromNib];
    [view setFrame:frame];
    [view layoutIfNeeded];
    //
    view.viewDelegate = delegate;
    view.parameter = lightParameter;
    //
    [view setupLayout];
    
    if (!view){
        NSAssert(false, @"Erro ao criar componente.");
    }
    
    return view;
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    contentView.layer.cornerRadius = 5.0;
    
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = [UIColor whiteColor];
    lblName.text = parameter.name;
    [lblName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    
    lblValue.backgroundColor = [UIColor clearColor];
    lblValue.textColor = [UIColor whiteColor];
    [lblValue setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    slider.backgroundColor = [UIColor clearColor];
    slider.minimumTrackTintColor = AppD.styleManager.colorPalette.primaryButtonNormal; //COLOR_MA_BLUE;
    
    if (parameter.type == LightControlParameterTypeColor){
        slider.minimumValueImage = nil;
        slider.maximumValueImage = nil;
    }else{
        slider.minimumValueImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor darkGrayColor] andImageTemplate:[UIImage imageNamed:@"VirtualSceneSliderMinus"]];
        slider.maximumValueImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor darkGrayColor] andImageTemplate:[UIImage imageNamed:@"VirtualSceneSliderPlus"]];
    }
    
    [self updateWithParameter:parameter];
}

- (NSString*)stringValueForCurrentParameter
{
    NSString *text = @"";
    if (viewDelegate){
        text = [viewDelegate lightControlView:self textForUpdatedParameterValue:[parameter copyObject]];
    }else{
        text = [NSString stringWithFormat:@"%.0f", parameter.currentValue];
    }
    return text;
}

- (void)updateWithParameter:(LightControlParameter*)newParameter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Values
        slider.minimumValue = parameter.minValue;
        slider.maximumValue = parameter.maxValue;
        slider.value = parameter.currentValue;
        
        //Value Text
        lblValue.text = [self stringValueForCurrentParameter];
    });
}

- (LightControlParameterType)currentParameterType
{
    return parameter.type;
}

- (IBAction)actionSliderChangeValue:(UISlider*)sender
{
    self.parameter.currentValue = sender.value;
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        lblValue.text = [self stringValueForCurrentParameter];
    });
}

@end
