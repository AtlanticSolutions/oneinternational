//
//  CS_GroupImage_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_GroupImage_TVC.h"
#import "VIPhotoView.h"

@interface CS_GroupImage_TVC()<VIPhotoViewDelegate>

@end

@implementation CS_GroupImage_TVC

@synthesize imvImage, indicatorView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    imvImage.backgroundColor = [UIColor clearColor];
    [imvImage setContentMode:UIViewContentModeScaleAspectFit];
    imvImage.image = nil;
    [imvImage cancelImageRequestOperation];
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
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    if (element.group.image != nil){
        
        self.imvImage.image = element.group.image;
        
    }else{

        if ([ToolBox textHelper_CheckRelevantContentInString:element.group.imageURL]){
            
            //busca no cache:
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:element.group.imageURL]];
            UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
            
            if (cachedImage){
                element.group.image = cachedImage;
                //
                self.imvImage.image = element.group.image;
                [tableView beginUpdates];
                [tableView endUpdates];
            }else{
                
                //busca imagem:
                [self.indicatorView startAnimating];
                [[[AsyncImageDownloader alloc] initWithFileURL:element.group.imageURL successBlock:^(NSData *data) {
                    [self.indicatorView stopAnimating];
                    
                    if (data != nil){
                        
                        //validando o conteúdo recebido:
                        if([UIImage imageWithData:data] != nil){
                            if ([element.group.imageURL hasSuffix:@"GIF"] || [element.group.imageURL hasSuffix:@"gif"]) {
                                element.group.image = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                            }else{
                                element.group.image = [UIImage imageWithData:data];
                            }
                            //guardando o imagem no cache
                            [[UIImageView sharedImageCache] cacheImage:element.group.image forRequest:request];
                            //
                            self.imvImage.image = element.group.image;
                            [tableView beginUpdates];
                            [tableView endUpdates];
                        }else{
                            [self.indicatorView stopAnimating];
                            element.group.image = [UIImage imageNamed:@"CustomSurveyIconNoImageLoaded"];
                            //
                            self.imvImage.image = element.group.image;
                            [tableView beginUpdates];
                            [tableView endUpdates];
                        }
                        
                    }else{
                        [self.indicatorView stopAnimating];
                        element.group.image = [UIImage imageNamed:@"CustomSurveyIconNoImageLoaded"];
                        //
                        self.imvImage.image = element.group.image;
                        [tableView beginUpdates];
                        [tableView endUpdates];
                    }
                    
                } failBlock:^(NSError *error) {
                    [self.indicatorView stopAnimating];
                    element.group.image = [UIImage imageNamed:@"CustomSurveyIconNoImageLoaded"];
                    //
                    self.imvImage.image = element.group.image;
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
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        
        if (element.group.image != nil){
            
            CGFloat imageRatio = element.group.image.size.width / element.group.image.size.height;
            if (imageRatio < 1.0){
                //image portrait:
                return containerWidth + 10.0;
            }else{
                //image landscape:
                return (containerWidth / imageRatio) + 10.0;
            }
            
        }else{
            
            return 40.0;
        }
        
    }else{
        
        return UITableViewAutomaticDimension;
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
