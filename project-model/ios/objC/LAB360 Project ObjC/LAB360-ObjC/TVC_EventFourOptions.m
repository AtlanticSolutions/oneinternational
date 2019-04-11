//
//  TVC_EventFourOptions.m
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import "TVC_EventFourOptions.h"

@implementation TVC_EventFourOptions

@synthesize  btnChat, btnCancel, btnDownload, btnResearch, lblChat, lblCancel, lblDownload, lblResearch,imgChat, imgCancel, imgDownload, imgResearch, viewChat, viewResearch, viewCancel, viewDownload, imgBackChat, imgBackCancel, imgBackDownload, imgBackResearch, imvLine;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateLayout
{
    UIImage *tempImage = [[ToolBox graphicHelper_CreateFlatImageWithSize:btnChat.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[UIColor blackColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //
    self.backgroundColor = [UIColor clearColor];
    //
    btnChat.backgroundColor = [UIColor clearColor];
    viewChat.backgroundColor = [UIColor clearColor];
    lblChat.numberOfLines = 0;
    [lblChat setText:NSLocalizedString(@"LABEL_TITLE_EVENT_CHAT", @"")];
    [lblChat setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblChat setTextColor:AppD.styleManager.colorPalette.textNormal];
    lblChat.backgroundColor = [UIColor clearColor];
    imgChat.backgroundColor = [UIColor clearColor];
    imgBackChat.image =tempImage;
    imgBackChat.tintColor = AppD.styleManager.colorPalette.primaryButtonNormal;
    imgChat.image = [UIImage imageNamed:@"icon-button-chat"];
    
    
    //
    //
    btnDownload.backgroundColor = [UIColor clearColor];
    viewDownload.backgroundColor = [UIColor clearColor];
    lblDownload.numberOfLines = 1;
    [lblDownload setText:NSLocalizedString(@"LABEL_TITLE_EVENT_DOWNLOAD", @"")];
    [lblDownload setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_BOTTOM]];
    [lblDownload setTextColor:AppD.styleManager.colorPalette.textNormal];
    lblDownload.backgroundColor = [UIColor clearColor];
    imgDownload.backgroundColor = [UIColor clearColor];
    imgBackDownload.image =tempImage;
    imgBackDownload.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    imgDownload.image = [UIImage imageNamed:@"icon-button-download"];
    
    //
    //
    btnCancel.backgroundColor = [UIColor clearColor];
    viewCancel.backgroundColor = [UIColor clearColor];
    lblCancel.numberOfLines = 0;
    [lblCancel setText:NSLocalizedString(@"LABEL_TITLE_EVENT_CANCEL", @"")];
    [lblCancel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_BOTTOM]];
    [lblCancel setTextColor:AppD.styleManager.colorPalette.textNormal];
    lblCancel.backgroundColor = [UIColor clearColor];
    imgCancel.backgroundColor = [UIColor clearColor];
    imgBackCancel.image =tempImage;
    imgBackCancel.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    imgCancel.image = [UIImage imageNamed:@"icon-button-cancel"];
    
    //
    btnResearch.backgroundColor = [UIColor clearColor];
    viewResearch.backgroundColor = [UIColor clearColor];
    lblResearch.numberOfLines = 2;
    [lblResearch setText:NSLocalizedString(@"LABEL_TITLE_EVENT_RESEARCH", @"")];
    [lblResearch setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
    [lblResearch setTextColor:AppD.styleManager.colorPalette.textNormal];
    lblResearch.backgroundColor = [UIColor clearColor];
    imgResearch.backgroundColor = [UIColor clearColor];
    imgBackResearch.image =tempImage;
    imgBackResearch.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    imgResearch.image = [UIImage imageNamed:@"icon-button-research"];
    
    
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor grayColor]];
    
}

-(UIButton *) customButton:(UIButton *)button withIcon:(UIImage *)icon andLabel:(NSString *)msg
{
    //Customização para o botão
    float fixedWidth = button.frame.size.width;
    float fixedHeight = button.frame.size.height;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.height, button.frame.size.width)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 100;
    //
    UILabel *label = [[UILabel alloc]init];
    label.tag = 101;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = AppD.styleManager.colorPalette.textNormal;//[UIColor whiteColor];
    label.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 2;
    label.text = NSLocalizedString(@"MENU_BUTTON_SCAN_QRCODE", @"");
    [label sizeToFit];
    //
    CGRect rect = label.frame;
    float width = rect.size.width;
    float height = rect.size.height;
    label.frame = CGRectMake((fixedWidth - height - 4 - width)/2, (fixedHeight - height)/2, width, height);
    //
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 4, (fixedHeight - height)/2, height, height)];
    imageView.tag = 102;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = icon;
    imageView.tintColor = AppD.styleManager.colorPalette.textNormal;
    //
    [view addSubview:imageView];
    [view addSubview:label];
    //
    [button addSubview:view];
    
    
    return button;
}

@end
