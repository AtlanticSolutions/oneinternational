//
//  TVC_SponsorsCollection.m
//  AHK-100anos
//
//  Created by Erico GT on 11/3/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_SponsorsCollection.h"

@interface TVC_SponsorsCollection()

@property (nonatomic, strong) NSArray<NSString*>* itensArray;
@property (nonatomic, strong) NSMutableDictionary* itensData;

@end


@implementation TVC_SponsorsCollection

@synthesize collectionViewMenu, imvLine, lblTitulo, itensArray, itensData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void) updateLayoutForItens:(NSArray<NSString*>*)itens;
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    collectionViewMenu.backgroundColor = [UIColor clearColor];
    
    [lblTitulo setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
    [lblTitulo setTextColor:AppD.styleManager.colorCalendarAvailable];
    lblTitulo.backgroundColor = [UIColor clearColor];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    
    if (itens.count > 0){
        itensArray = [[NSArray alloc]initWithArray:itens];
    }else{
        itensArray = [NSArray new];
    }
    
    itensData = [NSMutableDictionary new];
    
    [collectionViewMenu reloadData];
}

#pragma mark - CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return itensArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CustomCellSponsor";
    
    CVC_SponsorLogo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[CVC_SponsorLogo alloc] init];
    }
    
    NSString *url = [itensArray objectAtIndex:indexPath.row];
    UIImage *img = [itensData valueForKey:url];
    if (img == nil){
        [cell updateLayoutStartingDownloading];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[ToolBox converterHelper_NormalizedURLForString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                CVC_SponsorLogo *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *urlImage = [itensArray objectAtIndex:indexPath.row];
                        [itensData setValue:[UIImage imageWithCGImage:image.CGImage] forKey:urlImage];
                        if (updateCell){
                            [updateCell updateLayoutFinishDownloadingWithImage:image];
                        }
                    });
                }
                else{
                    if (updateCell){
                        [updateCell updateLayoutFinishDownloadingWithImage:nil];
                    }
                }
            }
        }];
        [task resume];
    }else{
        [cell updateLayoutFinishDownloadingWithImage:img];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat largura = (self.frame.size.width - 20 - 20 - 20 - 20 )/ 3;
    return CGSizeMake(largura, (largura * 0.75));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

@end
