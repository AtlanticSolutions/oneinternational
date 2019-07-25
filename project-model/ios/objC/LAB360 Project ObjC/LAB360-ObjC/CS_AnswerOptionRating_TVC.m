//
//  CS_AnswerOptionRating_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerOptionRating_TVC.h"
#import "CarouselViewItem.h"
#import "VIPhotoView.h"

@interface CS_AnswerOptionRating_TVC()<VIPhotoViewDelegate>

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
//
@property(nonatomic, strong) NSMutableArray<CustomSurveyAnswer*> *itemsList;
@property(nonatomic, strong) UIImage *placeholderImage;
//
@property(nonatomic, strong) CAShapeLayer *borderLayer;
//
@property(nonatomic, assign) BOOL needReportDelegate;

@end

@implementation CS_AnswerOptionRating_TVC

@synthesize vcDelegate;
@synthesize optCarousel, lblNote, imvArrow, imvNoteBackground;
@synthesize cellRow, cellSection, itemsList, placeholderImage, borderLayer, needReportDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    imvNoteBackground.backgroundColor = [UIColor clearColor];
    
    if (borderLayer == nil){
        CGSize iSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20.0, 60.0f);
        //
        borderLayer = [CAShapeLayer layer];
        borderLayer.lineWidth = 1.5;
        borderLayer.lineCap = kCALineCapSquare;
        borderLayer.lineJoin = kCALineJoinRound;
        borderLayer.lineDashPhase = 0.0;
        borderLayer.lineDashPattern = @[@(6.0), @(3.0)];
        borderLayer.strokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
        borderLayer.fillColor = [UIColor whiteColor].CGColor;
        borderLayer.frame = CGRectMake(0.0, 0.0, iSize.width, iSize.height);
        borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.frame].CGPath;
        //
        [imvNoteBackground.layer addSublayer:borderLayer];
        //
        [self animateBorder];
    }
    
    lblNote.backgroundColor = [UIColor clearColor];
    lblNote.textColor = COLOR_MA_BLUE;
    [lblNote setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM]];
    lblNote.text = @"";
    
    cellRow = 0;
    cellSection = 0;
    itemsList = [NSMutableArray new];
    
    //[imvArrow setHidden:NO];
    [imvNoteBackground setHidden:NO];
    [lblNote setHidden:NO];
    
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    
    long selectedIndex = -1;
    BOOL hasNote = NO;
    
    if (element.question.type == SurveyQuestionTypeOptionRating){
        
        //Quantidade de items:
        for (int aIndex = 0; aIndex < element.question.answers.count; aIndex++){
            
            CustomSurveyAnswer *copyItem = [[element.question.answers objectAtIndex:aIndex] copyObject];
            copyItem.referenceIndex = 0;
            
            //Verificando existência de notas:
            if ([ToolBox textHelper_CheckRelevantContentInString:copyItem.note]){
                hasNote = YES;
            }
            
            //Assinalando os items selecionados pelo usuário
            for (CustomSurveyAnswer *ua in element.question.userAnswers){
                if (ua.answerID == copyItem.answerID){
                    copyItem.referenceIndex = 1;
                    //
                    lblNote.text = copyItem.text;
                    //
                    selectedIndex = aIndex;
                }
            }
            [itemsList addObject:copyItem];
            
        }
        
    }
    
    if (!hasNote){
        //[imvArrow setHidden:YES];
        [imvNoteBackground setHidden:YES];
        [lblNote setHidden:YES];
    }
    
    optCarousel.type = iCarouselTypeLinear; // iCarouselTypeRotary;
    optCarousel.backgroundColor = [UIColor whiteColor];
    [optCarousel setClipsToBounds:YES];
    optCarousel.bounceDistance = 0.5;
    optCarousel.decelerationRate = 0.5;
    
    [optCarousel reloadData];
    
    if (selectedIndex != -1){
        [optCarousel scrollToItemAtIndex:selectedIndex animated:NO];
    }else{
        [optCarousel setCurrentItemIndex:0];
        [self carouselCurrentItemIndexDidChange:optCarousel];
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    
    BOOL hasNote = NO;
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        if (element.question.type == SurveyQuestionTypeOptionRating){
            
            for (CustomSurveyAnswer *answer in element.question.answers){
                if ([ToolBox textHelper_CheckRelevantContentInString:answer.note]){
                    hasNote = YES;
                    break;
                }
            }
            
        }
    }
    
    if (hasNote){
        return 180.0f;
    }else{
        return 130.0f;
    }
    
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return itemsList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling

    CustomSurveyAnswer *answer = [itemsList objectAtIndex:index];
    
    __block CarouselViewItem *carouselView = nil;
    
    if (view == nil){
        carouselView = [CarouselViewItem createNewComponentWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)];
    }else{
        carouselView = (CarouselViewItem*)view;
    }
    
    carouselView.lblNote.text = answer.text;
    
    if (answer.referenceIndex == 1){
        carouselView.lblNote.textColor = COLOR_MA_BLUE;
        self.lblNote.text = answer.note;
    }
    
    if (answer.image != nil){
        
        carouselView.imvItem.image = answer.image;
        
    }else{
        
        if ([ToolBox textHelper_CheckRelevantContentInString:answer.imageURL]){
            
            //busca no cache:
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:answer.imageURL]];
            UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
            
            if (cachedImage){
                answer.image = cachedImage;
                //
                carouselView.imvItem.image = answer.image;
            }else{
                
                //busca imagem:
                [carouselView.indicatorView startAnimating];
                [[[AsyncImageDownloader alloc] initWithFileURL:answer.imageURL successBlock:^(NSData *data) {
                    [carouselView.indicatorView stopAnimating];
                    
                    if (data != nil){
                        
                        //validando o conteúdo recebido:
                        if([UIImage imageWithData:data] != nil){
                            if ([answer.imageURL hasSuffix:@"GIF"] || [answer.imageURL hasSuffix:@"gif"]) {
                                answer.image = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                            }else{
                                answer.image = [UIImage imageWithData:data];
                            }
                            //guardando o imagem no cache
                            [[UIImageView sharedImageCache] cacheImage:answer.image forRequest:request];
                            //
                            carouselView.imvItem.image = answer.image;
                        }else{
                            answer.image = placeholderImage;
                            carouselView.imvItem.image = answer.image;
                        }
                        
                    }else{
                        answer.image = placeholderImage;
                        carouselView.imvItem.image = answer.image;
                    }
                    
                } failBlock:^(NSError *error) {
                    [carouselView.indicatorView stopAnimating];
                    carouselView.imvItem.image = placeholderImage;
                }] startDownload];
            }
            
        }else{
            answer.image = nil; //placeholderImage;
            carouselView.imvItem.image = nil; //answer.image;
        }
        
    }
    
    carouselView.tag = index;
    
    return carouselView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:{return 0.0;}break;
            //
        case iCarouselOptionVisibleItems:{return 5;}break;
            //
        case iCarouselOptionFadeMin:{return -0.5;}break;
            //
        case iCarouselOptionFadeMax:{return 0.5;}break;
            //
        case iCarouselOptionFadeRange:{return value;}break;
            //
        case iCarouselOptionFadeMinAlpha:{return 0.5;}break;
            //
        default:{return -1;}break;
    }
    
//    iCarouselOptionWrap = 0,
//    iCarouselOptionShowBackfaces,
//    iCarouselOptionOffsetMultiplier,
//    iCarouselOptionVisibleItems,
//    iCarouselOptionCount,
//    iCarouselOptionArc,
//    iCarouselOptionAngle,
//    iCarouselOptionRadius,
//    iCarouselOptionTilt,
//    iCarouselOptionSpacing,
//    iCarouselOptionFadeMin,
//    iCarouselOptionFadeMax,
//    iCarouselOptionFadeRange,
//    iCarouselOptionFadeMinAlpha
    
}

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return (itemsList.count > 5 ? 5 : itemsList.count);
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    //create new view if no view is available for recycling
    CarouselViewItem *carouselView = [CarouselViewItem createNewComponentWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)];
    return carouselView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index == carousel.currentItemIndex){
        CarouselViewItem *carouselView = (CarouselViewItem*)[carousel itemViewAtIndex:index];
        if (carouselView.imvItem.image != nil && carouselView.imvItem.image != placeholderImage){
            
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:carouselView.imvItem.image backgroundImage:nil andDelegate:self];
            photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
            photoView.autoresizingMask = (1 << 6) -1;
            photoView.alpha = 0.0;
            //
            [AppD.window addSubview:photoView];
            [AppD.window bringSubviewToFront:photoView];
            //
            [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
                photoView.alpha = 1.0;
            }];
            
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (carousel.currentItemIndex != -1){
        
        for (int i = 0; i < itemsList.count; i++){
            CustomSurveyAnswer *answer = [itemsList objectAtIndex:i];
            answer.referenceIndex = 0;
            //
            CarouselViewItem *carouselView = (CarouselViewItem*)[carousel itemViewAtIndex:i];
            //
            if (i == carousel.currentItemIndex){
                answer.referenceIndex = 1;
                //
                lblNote.text = answer.note;
                //
                [carouselView.lblNote setTextColor:COLOR_MA_BLUE];
                //
                if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                    [vcDelegate didEndSelectingComponentAtSection:cellSection row:cellRow collectionIndex:carousel.currentItemIndex withImage:answer.image];
                }
            }else{
                [carouselView.lblNote setTextColor:COLOR_MA_GRAY];
            }
        }
        
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    //animations:
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [imvArrow setAlpha:0.25];
    }];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    //animations:
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [imvArrow setAlpha:1.0];
    }];
}

#pragma mark - Utils

- (UIImage*)applyGrayscaleEffectInImage:(UIImage*)image
{
    if (image == nil){
        return image;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    if (filter){
        
        CIImage *ciImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
        [filter setValue:ciImage forKey:@"inputImage"];
        [filter setValue:@(0.0) forKey:@"inputSaturation"];
        //[filter setValue:@(1.0) forKey:@"inputBrightness"];
        //[filter setValue:@(1.0) forKey:@"inputContrast"];
        //
        UIImage *finalImage = [UIImage imageWithCIImage:filter.outputImage];
        //
        return (finalImage ? finalImage : image);
    }else{
        return image;
    }

}

- (void)animateBorder
{
    CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:(id)[NSNumber numberWithFloat:0.0f]];
    [dashAnimation setToValue:(id)[NSNumber numberWithFloat:-9.0f]]; //somatória do setLineDashPattern
    [dashAnimation setFillMode:kCAFillModeRemoved];
    [dashAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [dashAnimation setDuration:ANIMA_TIME_SLOOOW];
    [dashAnimation setRepeatCount:CGFLOAT_MAX];
    //
    [borderLayer addAnimation:dashAnimation forKey:@"linePhase"];
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    if (borderLayer){
        [self animateBorder];
    }
}

#pragma mark - VIPhotoViewDelegate

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

@end


