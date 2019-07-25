//
//  ZoneActionInfoView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ZoneActionInfoView.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "UIImageView+AFNetworking.h"

@interface ZoneActionInfoView()

//Data:
@property(nonatomic, strong) ZoneAction* currentZoneAction;
@property(nonatomic, weak) id<ZoneActionInfoViewDelegate>viewDelegate;

//Layout:
@property(nonatomic, weak) IBOutlet UIView* contentView;
@property(nonatomic, weak) IBOutlet UIImageView* imvPhoto;
@property(nonatomic, weak) IBOutlet UILabel* lblTitle;
@property(nonatomic, weak) IBOutlet UITextView* txvMessage;
@property(nonatomic, weak) IBOutlet UIButton *btnClose;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation ZoneActionInfoView

@synthesize currentZoneAction, viewDelegate;
@synthesize contentView, imvPhoto, lblTitle, txvMessage, btnClose, indicator;

#pragma mark - INITIALIZERS

+ (ZoneActionInfoView*)newZoneActionInfoViewWithFrame:(CGRect)frame andDelegate:(id<ZoneActionInfoViewDelegate>)delegate
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ZoneActionInfoView" owner:self options:nil];
    ZoneActionInfoView *view = (ZoneActionInfoView *)[nibArray objectAtIndex:0];
    [view awakeFromNib];
    [view setFrame:frame];
    [view layoutIfNeeded];
    [view setupLayout];
    view.viewDelegate = delegate;
    
    if (!view){
        NSAssert(false, @"Erro ao criar componente.");
    }
    
    return view;
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = [UIColor whiteColor];
    
    imvPhoto.backgroundColor = [UIColor darkGrayColor];
    [imvPhoto setContentMode: UIViewContentModeScaleAspectFill];
    [imvPhoto setClipsToBounds:YES];
    [imvPhoto setImage:nil];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkTextColor];
    lblTitle.text = @"";
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    txvMessage.backgroundColor = [UIColor whiteColor];
    txvMessage.text = @"";
    
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_BOTTOM];
    [btnClose setTitle:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") forState:UIControlStateNormal];
    [btnClose setExclusiveTouch:YES];
    [btnClose setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnClose.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnClose setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnClose.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    indicator.color = [UIColor whiteColor];
    [indicator setHidesWhenStopped:YES];
    [indicator stopAnimating];
    
    [contentView.layer setCornerRadius:5.0];
    [ToolBox graphicHelper_ApplyShadowToView:self withColor:[UIColor blackColor] offSet:CGSizeMake(3.0, 3.0) radius:5.0 opacity:0.5];
    
    [ToolBox graphicHelper_ApplyParallaxEffectInView:self with:10.0];
}

- (void)updateContentToZoneAction:(ZoneAction*)zoneAction
{
    currentZoneAction = [zoneAction copyObject];
    //
    imvPhoto.image = nil;
    if (currentZoneAction.infoImage){
        imvPhoto.image = currentZoneAction.infoImage;
    }else{
        [indicator startAnimating];
        [imvPhoto setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentZoneAction.infoImageURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            currentZoneAction.infoImage = image;
            imvPhoto.image = image;
            //
            [indicator stopAnimating];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [indicator stopAnimating];
        }];
    }
    
    lblTitle.text = currentZoneAction.infoTitle;
    
    //NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:txvMessage.attributedText];
    //[mutableAttributedString.mutableString setString:currentZoneAction.infoMessage];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 22.0f;
    paragraphStyle.maximumLineHeight = 22.0f;
    paragraphStyle.minimumLineHeight = 22.0f;
    //
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:currentZoneAction.infoMessage];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION] range:NSMakeRange(0, currentZoneAction.infoMessage.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, currentZoneAction.infoMessage.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, currentZoneAction.infoMessage.length)];
    //
    txvMessage.attributedText = attributedString;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.txvMessage flashScrollIndicators];
    });
}

- (IBAction)actionClose:(UIButton*)sender
{
    if (viewDelegate){
        [viewDelegate zoneActionInfoViewExecuteCloseAction:self];
    }
}

@end
