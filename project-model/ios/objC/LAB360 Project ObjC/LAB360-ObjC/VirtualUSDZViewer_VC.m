//
//  VirtualUSDZViewer_VC.m
//  LAB360-Dev
//
//  Created by lucas on 19/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <AVFoundation/AVFoundation.h>
#import <QuickLook/QuickLook.h>
//
#import "VirtualUSDZViewer_VC.h"
#import "AppDelegate.h"
#import "PanoramaGalleryItem.h"
#import "AsyncImageDownloader.h"
#import "PanoramaViewerVC.h"
#import "PanoramaViewItemCell.h"
#import "PanoramaGallery.h"
#import "ViewersDataSource.h"
#import "AdAliveImageCacheManager.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VirtualUSDZViewer_VC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate, QLPreviewControllerDataSource>
//Data:
@property(nonatomic, strong) PanoramaGallery *itemsGallery;
@property(nonatomic, strong) PanoramaGalleryItem *selectedItem;
@property(nonatomic, assign) BOOL isLoad;

//Layout:
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UICollectionView *galleryCollection;
@property(nonatomic, weak) IBOutlet UILabel *lblEmptyGallery;
@property(nonatomic, strong) UIButton *muteSoundControlButton;

@end

#pragma mark - • IMPLEMENTATION
@implementation VirtualUSDZViewer_VC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize itemsGallery, selectedItem, isLoad;
@synthesize lblTitle, galleryCollection, lblEmptyGallery, muteSoundControlButton;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoad = NO;
    selectedItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    if (!isLoad){
        [self setupLayout:@"Apple USDZ"];
        //
        [self showActivityIndicatorView];
        [self getGalleryItems];
        //
        self.navigationItem.rightBarButtonItem = [self createHelpButton];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        return;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
//    if ([segue.identifier isEqualToString:@"SegueToPanoramaViewer"]){
//        //
//    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"AR Quick Look" subTitle:@"Com o iOS 12, você pode colocar objetos 3D no mundo real usando o AR Quick Look, atrvés da biblioteca ARKit 2. Toque em qualquer um dos modelos 3D abaixo em um dispositivo executando o iOS 12 para visualizar o objeto e colocá-lo em AR." closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - PreviewController

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return selectedItem.localPackageURL;
}

#pragma mark - CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0,0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return itemsGallery.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PanoramaGalleryItemCellIdentifier";
    __block PanoramaViewItemCell *cell = (PanoramaViewItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupLayout];
    
    __block PanoramaGalleryItem *item = [itemsGallery.photos objectAtIndex:indexPath.row];
    
    if (item.thumbImage){
        cell.imvItem.image = item.thumbImage;
    }else{
        [cell.activityIndicator startAnimating];
        [cell.imvItem setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.thumbURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            item.thumbImage = image;
            //
            [cell.activityIndicator stopAnimating];
            cell.imvItem.image = item.thumbImage;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            cell.imvItem.image = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
            //
            [cell.activityIndicator stopAnimating];
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItem = [itemsGallery.photos objectAtIndex:indexPath.row];
    
    //Open with external browser:
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:selectedItem.originalURL]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedItem.originalURL] options:@{} completionHandler:nil];
//    }
    
    //Open with QLPreviewController:
    [self downloadUSDZFile];
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (collectionView.frame.size.width - (5.0 * 10.0)) / 3;
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    lblTitle.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lblTitle.textColor = [UIColor darkTextColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL]];
    lblTitle.text = @"Selecione o objeto para ver em 3D";
    
    galleryCollection.backgroundColor = [UIColor clearColor];
    [ToolBox graphicHelper_ApplyShadowToView:galleryCollection withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.5];
    
    lblEmptyGallery.backgroundColor = [UIColor clearColor];
    lblEmptyGallery.textColor = [UIColor grayColor];
    [lblEmptyGallery setFont:[UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_TITLE_NAVBAR]];
    lblEmptyGallery.text = @"";
    
    [lblTitle setHidden:YES];
    [galleryCollection setHidden:YES];
    [lblEmptyGallery setHidden:YES];
}

#pragma mark - Connection

- (void)getGalleryItems
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mockGallery];
    });
}

#pragma mark - UTILS (General Use)

- (void)mockGallery
{
    //Gallery:
    itemsGallery = [PanoramaGallery new];
    itemsGallery.galleryID = 1;
    itemsGallery.galleryName = @"Galeria USDZ";
    itemsGallery.photos = [NSMutableArray new];
    
    //Items:
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Stratocaster";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_1.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_1.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"RetroTV";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_2.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_2.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Gramophone";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_3.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_3.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Trowel";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_4.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_4.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Wateringcan";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_5.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_5.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Wheelbarrow";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_6.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_6.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"RedChair";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_7.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_7.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Tulip";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_8.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_8.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"PlantPot";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_9.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_9.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"TeaPot";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_10.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_10.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"CupAndSaucer";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_11.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_11.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    //
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"PokemonIvysaur";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_12.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_12.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Island";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_13.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_13.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Dish";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_14.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_14.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"DamagedHelmet";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/thumbs/image_file_15.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/usdz_files/file_15.usdz";
        //
        [itemsGallery.photos addObject:item];
    }
    
    [galleryCollection reloadData];
    [lblTitle setHidden:NO];
    [galleryCollection setHidden:NO];
    
    //Verificando existência dos arquivos:
    
//    for (PanoramaGalleryItem *item in itemsGallery.photos){
//        NSString *urlString = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.usdz", item.itemName]];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if ([fileManager fileExistsAtPath:urlString]){
//            NSURL *fileURL = [NSURL fileURLWithPath:urlString];
//            item.localPackageURL = fileURL;
//        }
//    }
    
    isLoad = YES;
    [self hideActivityIndicatorView];
}

- (UIBarButtonItem*)createHelpButton
{
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.backgroundColor = nil;
    collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *img = [[UIImage imageNamed:@"NavControllerHelpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [collectionButton setImage:img forState:UIControlStateNormal];
    //
    [collectionButton setFrame:CGRectMake(0, 0, 32, 32)];
    [collectionButton setClipsToBounds:YES];
    [collectionButton setExclusiveTouch:YES];
    [collectionButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [collectionButton addTarget:self action:@selector(actionHelp:) forControlEvents:UIControlEventTouchUpInside];
    //
    [collectionButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    //
    [[collectionButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[collectionButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:collectionButton];
}

- (void)downloadUSDZFile
{
    if (selectedItem.localPackageURL == nil){
        
        [self showActivityIndicatorView];
        
        [[[AsyncImageDownloader alloc] initWithFileURL:selectedItem.originalURL successBlock:^(NSData *data) {
            
            [self hideActivityIndicatorView];
            
            if (data != nil){
                //URL local para guardar o documento temporariamente:
                NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.usdz", selectedItem.itemName]]];
                
                if ([data writeToURL:fileURL atomically:NO]){
                    
                    selectedItem.localPackageURL = fileURL;
                    [self openPreviewController];
                    
                }else{
                    
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:@"Erro" subTitle:@"Não foi possível baixar o modelo 3D. Por favor, tente mais tarde." closeButtonTitle:@"OK" duration:0.0];
                    
                }
                
            }else{
                
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:@"Erro" subTitle:@"Não foi possível baixar o modelo 3D. Por favor, tente mais tarde." closeButtonTitle:@"OK" duration:0.0];
                
            }
            
        } failBlock:^(NSError *error) {
            
            [self hideActivityIndicatorView];
            //
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Erro" subTitle:[error localizedDescription] closeButtonTitle:@"OK" duration:0.0];
            
        }] startDownload];
        
    }else{
        
        [self openPreviewController];
        
    }
}

- (void)openPreviewController
{
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.currentPreviewItemIndex = 0;
    [previewController.view setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [previewController.navigationController setHidesBarsOnTap:YES];
    previewController.navigationItem.rightBarButtonItems = nil;

    [previewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [previewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [previewController setModalPresentationCapturesStatusBarAppearance:YES];

    [self presentViewController:previewController animated:YES completion:nil];
}


@end
