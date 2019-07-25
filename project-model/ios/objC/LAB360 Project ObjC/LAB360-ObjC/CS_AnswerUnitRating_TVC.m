//
//  CS_AnswerUnitRating_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerUnitRating_TVC.h"

@interface CS_AnswerUnitRating_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
//
@property(nonatomic, strong) UIImage *minusImage;
@property(nonatomic, strong) UIImage *plusImage;
//
@property(nonatomic, strong) NSString *unitIdentifier;

@end

@implementation CS_AnswerUnitRating_TVC

@synthesize vcDelegate;
@synthesize cellRow, cellSection, minusImage, plusImage;
@synthesize lblTitle, btnMinus, btnPlus, sdValue, unitIdentifier;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    minusImage = [[UIImage imageNamed:@"CustomSurveyIconRatingUnitMinus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    plusImage = [[UIImage imageNamed:@"CustomSurveyIconRatingUnitPlus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor grayColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:22.0]];
    lblTitle.text = @"";
    
    [btnMinus setBackgroundColor:[UIColor clearColor]];
    [btnMinus setTitle:@"" forState:UIControlStateNormal];
    [btnMinus setExclusiveTouch:YES];
    [btnMinus.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnMinus setImage:minusImage forState:UIControlStateNormal];
    [btnMinus setTintColor:AppD.styleManager.colorPalette.primaryButtonSelected];
    
    [btnPlus setBackgroundColor:[UIColor clearColor]];
    [btnPlus setTitle:@"" forState:UIControlStateNormal];
    [btnPlus setExclusiveTouch:YES];
    [btnPlus.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnPlus setImage:plusImage forState:UIControlStateNormal];
    [btnPlus setTintColor:AppD.styleManager.colorPalette.primaryButtonSelected];
    
    sdValue.backgroundColor = [UIColor clearColor];
    sdValue.minimumTrackTintColor = AppD.styleManager.colorPalette.primaryButtonNormal;
    //
    //slider.minimumValueImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor darkGrayColor] andImageTemplate:[UIImage imageNamed:@"VirtualSceneSliderMinus"]];
    //slider.maximumValueImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor darkGrayColor] andImageTemplate:[UIImage imageNamed:@"VirtualSceneSliderPlus"]];
    //
    sdValue.minimumValue = 1.0;
    sdValue.maximumValue = 1.0;
    sdValue.value = 1.0;
        
    cellRow = 0;
    cellSection = 0;
    
    unitIdentifier = @"";
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    
    if (element.question.type == SurveyQuestionTypeUnitRating){
        
        CustomSurveyAnswer *answer = [element.question.answers firstObject];
        
        if (answer){
            
            float minV = [answer.minValue floatValue];
            float maxV = [answer.maxValue floatValue];
            
            [sdValue setMinimumValue:minV];
            [sdValue setMaximumValue:maxV];
            
            //verificando valor atual:
            CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
            if (ua){
                float value = [ua.text floatValue];
                if (value < sdValue.minimumValue){
                    value = sdValue.minimumValue;
                }else if (value > sdValue.maximumValue){
                    value = sdValue.maximumValue;
                }
                
                [sdValue setValue:value];
            }else{
                
                //não existe valor setado pelo usuário ou enviado pelo servidor para ser o default (será utilizado o valor mínimo)
                [sdValue setValue:minV];

            }
        }
        
        if ([ToolBox textHelper_CheckRelevantContentInString:element.question.unitIdentifier]){
            unitIdentifier = [NSString stringWithFormat:@" %@", element.question.unitIdentifier];
        }
        
        lblTitle.text = [NSString stringWithFormat:@"%i%@", (int)sdValue.value, unitIdentifier];
        
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 89.0;
}

#pragma mark -

- (IBAction)actionSliderChangeValue:(UISlider*)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        lblTitle.text = [NSString stringWithFormat:@"%li%@", (long)sender.value, unitIdentifier];
    });
}

- (IBAction)actionSliderDidSetFinalValue:(UISlider*)sender
{
    NSString *value = [NSString stringWithFormat:@"%li%@", (long)sender.value, unitIdentifier];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        lblTitle.text = value;
    });
    
    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
        [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:[NSString stringWithFormat:@"%li", (long)sender.value]];
    }
}

- (IBAction)actionMinus:(UIButton*)sender
{
    float value = sdValue.value - 1.0;
    
    if (value < sdValue.minimumValue){
        value = sdValue.minimumValue;
    }
    
    sdValue.value = value;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        lblTitle.text = [NSString stringWithFormat:@"%li%@", (long)value, unitIdentifier];
    });
    
    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
        [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:[NSString stringWithFormat:@"%li", (long)sdValue.value]];
    }
}

- (IBAction)actionPlus:(UIButton*)sender
{
    float value = sdValue.value + 1.0;
    
    if (value > sdValue.maximumValue){
        value = sdValue.maximumValue;
    }
    
    sdValue.value = value;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        lblTitle.text = [NSString stringWithFormat:@"%li%@", (long)value, unitIdentifier];
    });
    
    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
        [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:[NSString stringWithFormat:@"%li", (long)sdValue.value]];
    }
}

@end
