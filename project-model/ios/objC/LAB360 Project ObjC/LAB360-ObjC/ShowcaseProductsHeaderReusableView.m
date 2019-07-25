//
//  ShowcaseProductsHeaderReusableView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ShowcaseProductsHeaderReusableView.h"

@implementation ShowcaseProductsHeaderReusableView

@synthesize imvBanner, activityIndicator;

+ (CGFloat)heightForImage:(UIImage*_Nullable)refImage containedInWidth:(CGFloat)widthContainer
{
    if (refImage){
        CGFloat height = refImage.size.height;
        CGFloat width = refImage.size.width;
        
        if ((width / height) < (16.0 / 9.0)){
            //A imagem é alta demais, retorna padrão 16:9
            return (widthContainer / (16.0 / 9.0));
        }else{
            //A imagem possui padrão compatível
            CGFloat newHeight = (widthContainer / (width / height));
            if (newHeight < 41.0){
                return 41.0; //tamanho do indicatorViewLarge + 4 de bonus
            }else{
                return newHeight;
            }
        }
    }else{
        return 41.0;
    }
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor whiteColor];
    
    imvBanner.backgroundColor = [UIColor darkTextColor];
    imvBanner.contentMode = UIViewContentModeScaleAspectFit;
    imvBanner.image = nil;
    [imvBanner cancelImageRequestOperation];
    
    activityIndicator.backgroundColor = nil;
    activityIndicator.color =[UIColor whiteColor];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
}

@end
