//
//  CS_AnswerSingleSelection_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerSingleSelection_TVC.h"
#import "VIPhotoView.h"

@interface CS_AnswerSingleSelection_TVC()<VIPhotoViewDelegate>

@end

@implementation CS_AnswerSingleSelection_TVC

@synthesize lblText, imvRadioButton, imvImage, indicatorView, labelHeightConstraint, imageViewHeightConstraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblText.backgroundColor = [UIColor clearColor];
    lblText.textColor = [UIColor grayColor];
    lblText.text = @"";
    
    imvRadioButton.backgroundColor = [UIColor clearColor];
    imvRadioButton.image = nil;
    
    imvImage.backgroundColor = [UIColor clearColor];
    [imvImage setContentMode:UIViewContentModeScaleAspectFit];
    imvImage.image = nil;
    [imvImage cancelImageRequestOperation];
    [imvImage setHidden:YES];
    //
    [imvImage setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [longPressGesture setNumberOfTouchesRequired:1];
    [longPressGesture setMinimumPressDuration:0.75];
    longPressGesture.allowableMovement = 20.0;
    longPressGesture.delaysTouchesBegan = NO;
    [imvImage addGestureRecognizer:longPressGesture];
    
    indicatorView.color = [UIColor grayColor];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    
    labelHeightConstraint.constant = 1.0;
    imageViewHeightConstraint.constant = 1.0;
    
    [self.contentView layoutIfNeeded];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    BOOL selected = NO;
    
    //NOTE: se a resposta atual estiver na lista de respostas do usuário o elemento está respondido:
    for (CustomSurveyAnswer *ua in element.question.userAnswers)
    {
        if (element.answer.answerID == ua.answerID){
            selected = YES;
            break;
        }
    }
    
    if (selected){
        [lblText setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
        imvRadioButton.image = [UIImage imageNamed:@"CustomSurveyIconRadioButtonSelected"];
    }else{
        [lblText setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
        imvRadioButton.image = [UIImage imageNamed:@"CustomSurveyIconRadioButtonNormal"];
    }
    
    BOOL hasImage = NO;
    if ([ToolBox textHelper_CheckRelevantContentInString:element.answer.imageURL]){
        hasImage = YES;
    }
    
    if ([ToolBox textHelper_CheckRelevantContentInString:element.answer.text]){
        self.lblText.text = element.answer.text;
        [self.lblText setHidden:NO];
        //
        labelHeightConstraint.constant = [self heightForText:element.answer.text selected:selected withImage:hasImage];
        [self layoutIfNeeded];
    }
    
    if (element.answer.image != nil){
        
        self.imvImage.image = element.answer.image;
        [self.imvImage setHidden:NO];
        //
        imageViewHeightConstraint.constant = [self heightForImage:element.answer.image];
        [self layoutIfNeeded];
        
    }else{
        
        if ([ToolBox textHelper_CheckRelevantContentInString:element.answer.imageURL]){
            
            //busca no cache:
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:element.answer.imageURL]];
            UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
            
            if (cachedImage){
                element.answer.image = cachedImage;
                //
                self.imvImage.image = element.answer.image;
                [self.imvImage setHidden:NO];
                //
                imageViewHeightConstraint.constant = [self heightForImage:element.answer.image];
                [self layoutIfNeeded];
                //
                [tableView beginUpdates];
                [tableView endUpdates];
            }else{
                
                //busca imagem:
                [self.indicatorView startAnimating];
                [[[AsyncImageDownloader alloc] initWithFileURL:element.answer.imageURL successBlock:^(NSData *data) {
                    [self.indicatorView stopAnimating];
                    [self.imvImage setHidden:NO];
                    
                    if (data != nil){
                        
                        //validando o conteúdo recebido:
                        if([UIImage imageWithData:data] != nil){
                            if ([element.answer.imageURL hasSuffix:@"GIF"] || [element.answer.imageURL hasSuffix:@"gif"]) {
                                element.answer.image = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                            }else{
                                element.answer.image = [UIImage imageWithData:data];
                            }
                            //guardando o imagem no cache
                            [[UIImageView sharedImageCache] cacheImage:element.answer.image forRequest:request];
                            //
                            self.imvImage.image = element.answer.image;
                            //
                            imageViewHeightConstraint.constant = [self heightForImage:element.answer.image];
                            [self layoutIfNeeded];
                            //
                            [tableView beginUpdates];
                            [tableView endUpdates];
                        }else{
                            [self.indicatorView stopAnimating];
                            element.question.image = [UIImage imageNamed:@"CustomSurveyIconNoImageLoaded"];
                            //
                            self.imvImage.image = element.answer.image;
                            //
                            imageViewHeightConstraint.constant = [self heightForImage:element.answer.image];
                            [self layoutIfNeeded];
                            //
                            [tableView beginUpdates];
                            [tableView endUpdates];
                        }
                        
                    }else{
                        [self.indicatorView stopAnimating];
                        element.question.image = [UIImage imageNamed:@"CustomSurveyIconNoImageLoaded"];
                        //
                        self.imvImage.image = element.answer.image;
                        //
                        imageViewHeightConstraint.constant = [self heightForImage:element.answer.image];
                        [self layoutIfNeeded];
                        //
                        [tableView beginUpdates];
                        [tableView endUpdates];
                    }
                    
                } failBlock:^(NSError *error) {
                    [self.indicatorView stopAnimating];
                    [self.imvImage setHidden:NO];
                    element.question.image = [UIImage imageNamed:@"CustomSurveyIconNoImageLoaded"];
                    //
                    self.imvImage.image = element.answer.image;
                    //
                    imageViewHeightConstraint.constant = [self heightForImage:element.answer.image];
                    [self layoutIfNeeded];
                    //
                    [tableView beginUpdates];
                    [tableView endUpdates];
                }] startDownload];
            }
            
        }else{
            self.imvImage.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    
    BOOL hasText = NO;
    BOOL hasImage = NO;
    CGFloat finalCellHeight = 10.0; //margem superior
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        
        if ([ToolBox textHelper_CheckRelevantContentInString:element.answer.text]){
            hasText = YES;
        }
        
        if ([ToolBox textHelper_CheckRelevantContentInString:element.answer.imageURL]){
            hasImage = YES;
        }
        
        if (hasText) {
            
            BOOL selected = NO;
            
            //NOTE: se a resposta atual estiver na lista de respostas do usuário o elemento está respondido:
            for (CustomSurveyAnswer *ua in element.question.userAnswers)
            {
                if (element.answer.answerID == ua.answerID){
                    selected = YES;
                    break;
                }
            }
            
            UIFont *font =  [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
            
            if (selected){
                font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
            }
            
            CGRect textRect = [element.answer.text boundingRectWithSize:CGSizeMake(containerWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
            
            if (hasImage){
                finalCellHeight += textRect.size.height;
            }else{
                finalCellHeight += (textRect.size.height >= 40.0 ? textRect.size.height : 40.0);
            }
            
        }
        
        if (hasImage){
            
            if (hasText){
                finalCellHeight += 10.0;
            }
            
            if (element.answer.image != nil){
                
                //caso a imagem já exista utiliza-se ela para determinação
                CGFloat imageRatio = element.answer.image.size.width / element.answer.image.size.height;
                if (imageRatio < 1.0){
                    //image portrait:
                    finalCellHeight += containerWidth;
                }else{
                    //image landscape:
                    CGFloat h = (containerWidth / imageRatio);
                    finalCellHeight += (h >= 40.0 ? h : 40.0);
                }
                
            }else{
                
                //caso a imagem ainda não tenha sido baixada deixa-se o espaço
                finalCellHeight += 40.0;
            }
            
        }
        
        if (hasText || hasImage){
            finalCellHeight += 10.0; //margem inferior
        }
        
        return finalCellHeight;
        
    }else{
        
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)heightForText:(NSString*)text selected:(BOOL)selected withImage:(BOOL)hasImage
{
    UIFont *font =  [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    if (selected){
        font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    }
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.lblText.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    if (hasImage){
        return textRect.size.height;
    }else{
        return (textRect.size.height >= 40.0 ? textRect.size.height : 40.0);
    }
    
}

- (CGFloat)heightForImage:(UIImage*)image
{
    if (image == nil){
        return 40.0;
    }else{
        CGFloat imageRatio = image.size.width / image.size.height;
        if (imageRatio < 1.0){
            //image portrait:
            return self.imvImage.frame.size.width;
        }else{
            //image landscape:
            CGFloat h = (self.imvImage.frame.size.width / imageRatio);
            return (h >= 40.0 ? h : 40.0);
        }
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        UIImageView *imv = (UIImageView*)recognizer.view;
        
        if (imv.image != nil){
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:imv.image backgroundImage:nil andDelegate:self];
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
