//
//  CS_AnswerLikeRating_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerLikeRating_TVC.h"

@interface CS_AnswerLikeRating_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
//
@property(nonatomic, strong) UIImage *likeImage;
@property(nonatomic, strong) UIImage *unlikeImage;

@end

@implementation CS_AnswerLikeRating_TVC

@synthesize vcDelegate, btnLeft, btnRight;
@synthesize cellRow, cellSection, likeImage, unlikeImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    likeImage = [[UIImage imageNamed:@"CustomSurveyIconRatingLikeON"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    unlikeImage = [[UIImage imageNamed:@"CustomSurveyIconRatingLikeOFF"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //left
    btnLeft.backgroundColor = [UIColor clearColor];
    btnLeft.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnLeft setTitle:@"" forState:UIControlStateNormal];
    [btnLeft setExclusiveTouch:YES];
    [btnLeft setBackgroundImage:[self backgroundImage:btnLeft.frame.size corners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadius:CGSizeZero fillColor:[UIColor whiteColor] borderColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[self backgroundImage:btnLeft.frame.size corners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadius:CGSizeZero fillColor:[UIColor darkGrayColor] borderColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
    [btnLeft setImage:likeImage forState:UIControlStateNormal];
    [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 10.0)];
    [btnLeft.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnLeft setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnLeft setTintColor:[UIColor darkGrayColor]];
    [btnLeft setSelected:NO];
    btnLeft.tag = 0;
    
    //right
    btnRight.backgroundColor = [UIColor clearColor];
    btnRight.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnRight setTitle:@"" forState:UIControlStateNormal];
    [btnRight setExclusiveTouch:YES];
    [btnRight setBackgroundImage:[self backgroundImage:btnRight.frame.size corners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadius:CGSizeZero fillColor:[UIColor whiteColor] borderColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[self backgroundImage:btnRight.frame.size corners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadius:CGSizeZero fillColor:[UIColor darkGrayColor] borderColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
    [btnRight setImage:unlikeImage forState:UIControlStateNormal];
    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 10.0)];
    [btnRight.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnRight setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnRight setTintColor:[UIColor darkGrayColor]];
    [btnRight setSelected:NO];
    btnRight.tag = 1;
    
    cellRow = 0;
    cellSection = 0;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    
    if (element.question.type == SurveyQuestionTypeLikeRating){
        CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
        if (ua){
            int value = [ua.text intValue];
            
            if (value == 0){
                //left
                [btnLeft setSelected:YES];
                [btnLeft setTintColor:[UIColor whiteColor]];
                //
                [btnRight setSelected:NO];
                [btnRight setTintColor:[UIColor darkGrayColor]];
            }else{
                //right
                [btnRight setSelected:YES];
                [btnRight setTintColor:[UIColor whiteColor]];
                //
                [btnLeft setSelected:NO];
                [btnLeft setTintColor:[UIColor darkGrayColor]];
            }
            
        }
        
        [btnLeft setTitle:element.question.minBarRatingMessage forState:UIControlStateNormal];
        [btnRight setTitle:element.question.maxBarRatingMessage forState:UIControlStateNormal];
        
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 60.0;
}

#pragma mark -

- (IBAction)actionSelection:(UIButton*)sender
{
    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
        NSString *value = [NSString stringWithFormat:@"%li", (long)sender.tag];
        [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:value];
    }
}

- (UIImage*) backgroundImage:(CGSize)size corners:(UIRectCorner)corners cornerRadius:(CGSize)radius fillColor:(UIColor*)fillColor borderColor:(UIColor*)borderColor
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corners cornerRadii:radius];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [fillColor setFill];
    [rounded fill]; //or [path stroke]
    [borderColor setStroke];
    rounded.lineWidth = 2.0;
    //rounded.lineCapStyle = kCGLineCapButt;
    //rounded.lineJoinStyle = kCGLineJoinRound;
    [rounded stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
