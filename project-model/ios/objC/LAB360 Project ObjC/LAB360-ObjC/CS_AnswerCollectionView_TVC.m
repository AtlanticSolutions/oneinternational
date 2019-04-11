//
//  CS_AnswerCollectionView_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerCollectionView_TVC.h"
#import "CS_AnswerCollectionImageItem_CVC.h"

@interface CS_AnswerCollectionView_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) NSInteger selectableItems;
@property(nonatomic, assign) NSInteger displayColumns;
@property(nonatomic, strong) NSMutableArray *imagesList;
@property(nonatomic, strong) UIImage *placeholderImage;
@property(nonatomic, strong) CustomSurveyAnswer *currentAnswer;

@end

@implementation CS_AnswerCollectionView_TVC

@synthesize cvImages, cellRow, cellSection, imagesList, selectableItems, placeholderImage, currentAnswer, vcDelegate, displayColumns;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    cvImages.delegate = self;
    cvImages.dataSource = self;
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerCollectionImageItem_CVC" bundle:nil];
        [cvImages registerNib:nib forCellWithReuseIdentifier:@"CS_AnswerCollectionImageItem_CVC_Identifier"];
    }
    
    placeholderImage = [UIImage imageNamed:@"CustomSurveyIconPhotoSlot"];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cvImages.backgroundColor = [UIColor clearColor];
    
    cellRow = 0;
    cellSection = 0;
    selectableItems = 0;
    imagesList = [NSMutableArray new];
    currentAnswer = nil;
    
    [self layoutIfNeeded];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    selectableItems = element.question.selectableItems;
    displayColumns = element.question.displayColumns;
    
    //Quantidade de items:
    for (CustomSurveyAnswer *a in element.question.answers){
        CustomSurveyAnswer *copyItem = [a copyObject];
        copyItem.referenceIndex = 0;
        
        //Assinalando os items selecionados pelo usuário
        for (CustomSurveyAnswer *ua in element.question.userAnswers){
            if (ua.answerID == a.answerID){
                copyItem.referenceIndex = 1;
            }
        }
        [imagesList addObject:copyItem];
    }
    
    cellRow = indexPath.row;
    cellSection = indexPath.section;

    [cvImages reloadData];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        
        CGFloat lines = ceil((float)(element.question.answers.count) / (float)(element.question.displayColumns));
        CGFloat height = containerWidth / (float)(element.question.displayColumns);
        return (height * lines) + 20.0;
        
    }else{
        
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - CollectionView Delegates...

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CS_AnswerCollectionImageItem_CVC_Identifier";
    
    CS_AnswerCollectionImageItem_CVC *cell = (CS_AnswerCollectionImageItem_CVC*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell layoutIfNeeded];
    
    CustomSurveyAnswer *answer = [imagesList objectAtIndex:indexPath.row];
    
    if (answer.referenceIndex == 0){
        [cell setupLayoutSelected:NO];
    }else{
        [cell setupLayoutSelected:YES];
    }
    
    if (answer.image != nil){
        
        cell.imvPicture.image = answer.image;
        
    }else{
        
        if ([ToolBox textHelper_CheckRelevantContentInString:answer.imageURL]){
            
            //busca no cache:
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:answer.imageURL]];
            UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
            
            if (cachedImage){
                answer.image = cachedImage;
                //
                cell.imvPicture.image = answer.image;
            }else{
                
                //busca imagem:
                [cell.indicatorView startAnimating];
                [[[AsyncImageDownloader alloc] initWithFileURL:answer.imageURL successBlock:^(NSData *data) {
                    [cell.indicatorView stopAnimating];
                    
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
                            cell.imvPicture.image = answer.image;
                        }else{
                            answer.image = placeholderImage;
                            cell.imvPicture.image = answer.image;
                        }
                        
                    }else{
                        answer.image = placeholderImage;
                        cell.imvPicture.image = answer.image;
                    }
                    
                } failBlock:^(NSError *error) {
                    [cell.indicatorView stopAnimating];
                    //answer.image = placeholderImage;
                    cell.imvPicture.image = placeholderImage;
                }] startDownload];
            }
            
        }else{
            answer.image = placeholderImage;
            cell.imvPicture.image = answer.image;
        }
        
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0 && vcDelegate)
    {
        collectionView.tag = 1;
        CS_AnswerCollectionImageItem_CVC *cell = (CS_AnswerCollectionImageItem_CVC*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.imvPicture.alpha = 0.0;
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            cell.imvPicture.alpha = 1.0;
        } completion: ^(BOOL finished) {
            [self resolveSelectionForElementAtIndex:indexPath.row];
            collectionView.tag = 0;
        }];
    }
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = collectionView.frame.size.height;
    
    if (imagesList.count <= displayColumns){
        lado = collectionView.frame.size.width / (float)(imagesList.count);
    }else{
        lado = collectionView.frame.size.width / (float)(displayColumns);
    }
    
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - Private Methods

- (void)resolveSelectionForElementAtIndex:(NSInteger)index
{
    if (vcDelegate){
        [vcDelegate didEndSelectingComponentAtSection:cellSection row:cellRow collectionIndex:index withImage:nil];
    }
}

@end
