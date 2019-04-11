//
//  TVC_SubmitOrderDetail.m
//  GS&MD
//
//  Created by Erico GT on 18/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SubmitOrderDetail.h"

@implementation TVC_SubmitOrderDetail

@synthesize viewPoints, lblTitlePoints, lblTotalPoints;
@synthesize lblTitleCoupon, txtCoupon;
@synthesize lblTitleReferenceProduct, txtReferenceProduct;
@synthesize viewFooter, btnSubmitOrder;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) updateLayout
{
    [self layoutIfNeeded];
    
    //Background:
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //---------------------------------------------------------------------------
    viewPoints.backgroundColor = [UIColor whiteColor];
    lblTitlePoints.backgroundColor = nil;
    lblTotalPoints.backgroundColor = nil;
    //
    lblTitlePoints.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS];
    lblTitlePoints.textColor = [UIColor darkTextColor];
    lblTotalPoints.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS];
    lblTotalPoints.textColor = [UIColor darkTextColor];
    //
    viewPoints.layer.cornerRadius = 5.0;
    viewPoints.layer.borderColor = COLOR_MA_GRAY.CGColor;
    viewPoints.layer.borderWidth = 1.5;
    
    
    //---------------------------------------------------------------------------
    lblTitleCoupon.backgroundColor = nil;
    //
    txtCoupon.backgroundColor = [UIColor whiteColor];
    [txtCoupon setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    txtCoupon.placeholder = @"Digite seu cupom";
    txtCoupon.textColor = [UIColor darkTextColor];
    txtCoupon.layer.cornerRadius = 5.0;
    txtCoupon.layer.borderColor = COLOR_MA_GREEN.CGColor;
    txtCoupon.layer.borderWidth = 1.5;
    [txtCoupon setLeftViewMode:UITextFieldViewModeAlways];
    txtCoupon.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, txtCoupon.frame.size.height)];

    
    //---------------------------------------------------------------------------
    lblTitleReferenceProduct.backgroundColor = nil;
    //
    txtReferenceProduct.backgroundColor = [UIColor whiteColor];
    [txtReferenceProduct setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    txtReferenceProduct.placeholder = @"Digite o código de referência";
    txtReferenceProduct.textColor = [UIColor darkTextColor];
    txtReferenceProduct.layer.cornerRadius = 5.0;
    txtReferenceProduct.layer.borderColor = COLOR_MA_GREEN.CGColor;
    txtReferenceProduct.layer.borderWidth = 1.5;
    [txtReferenceProduct setLeftViewMode:UITextFieldViewModeAlways];
    txtReferenceProduct.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, txtReferenceProduct.frame.size.height)];
    
    
    //---------------------------------------------------------------------------
    viewFooter.backgroundColor = [UIColor whiteColor];
    [ToolBox graphicHelper_ApplyShadowToView:viewFooter withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, -1.0) radius:2.0 opacity:0.50];
    //
    btnSubmitOrder.backgroundColor = nil;
    [btnSubmitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmitOrder.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnSubmitOrder setTitle:@"REALIZAR PAGAMENTO" forState:UIControlStateNormal];
    [btnSubmitOrder setExclusiveTouch:YES];
    [btnSubmitOrder setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSubmitOrder.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:COLOR_MA_GREEN] forState:UIControlStateNormal];
    
    //Texts:
    lblTitlePoints.text = @"Total de pontos disponíveis:";
    lblTotalPoints.text = @"";
    //
    lblTitleCoupon.text = @"Código do cupom:";
    txtCoupon.text = @"";
    //
    lblTitleReferenceProduct.text = @"Informe o código de referência do produto que deseja trocar pelos seus pontos:";
    txtReferenceProduct.text = @"";
    
}

@end
