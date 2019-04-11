//
//  PanoramaGalleryVC.m
//  aw_experience
//
//  Created by Erico GT on 12/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <AVFoundation/AVFoundation.h>
//
#import "PanoramaGalleryVC.h"
#import "AppDelegate.h"
#import "PanoramaGalleryItem.h"
#import "AsyncImageDownloader.h"
#import "PanoramaViewerVC.h"
#import "PanoramaViewItemCell.h"
#import "PanoramaGallery.h"
#import "ViewersDataSource.h"
#import "AdAliveImageCacheManager.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface PanoramaGalleryVC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate>
//Data:
@property(nonatomic, strong) PanoramaGallery *panoramaGallery;
@property(nonatomic, assign) BOOL isLoad;
//
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;

//Layout:
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UICollectionView *galleryCollection;
@property(nonatomic, weak) IBOutlet UILabel *lblEmptyGallery;
@property(nonatomic, strong) UIButton *muteSoundControlButton;

@end

#pragma mark - • IMPLEMENTATION
@implementation PanoramaGalleryVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize panoramaGallery, isLoad, targetName, audioPlayer;
@synthesize lblTitle, galleryCollection, lblEmptyGallery, muteSoundControlButton;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    isLoad = NO;
    
    if (AppD.adAliveImageCacheManager == nil){
        AppD.adAliveImageCacheManager = [AdAliveImageCacheManager newImageCache];
    }

    //Para URLs externas é preciso antes fazer o download do arquivo. Para URLs locais basta linkar o arquivo:
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"background_music_panorama_gallery" withExtension:@"mp3"];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    
    if (error){
        NSLog(@"PanoramaGalleryVC >> viewDidLoad >> audioPlayer >> Error >> %@", [error localizedDescription]);
    }
    
    //notifications:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAmbientMusic) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAmbientMusic) name:UIApplicationDidBecomeActiveNotification object:nil];
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
        [self setupLayout:@"Galeria"];
        //
        [self showActivityIndicatorView];
        [self getGalleryForTargetName];
    }
    
    if (audioPlayer){
        [audioPlayer setVolume:0.3 fadeDuration:0.5];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        if (audioPlayer){
            [audioPlayer setVolume:0.0 fadeDuration:0.25];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToPanoramaViewer"]){
        PanoramaGalleryItem *item = (PanoramaGalleryItem*)sender;
        //
        PanoramaViewerVC *view = (PanoramaViewerVC*)segue.destinationViewController;
        view.panoramaItem = item;
    }
    
    [self.galleryCollection setUserInteractionEnabled:YES];
    
    if (audioPlayer){
        [audioPlayer setVolume:1.0 fadeDuration:0.5];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionChangeMuteStateMethod:(UIButton*)sender
{
    if (audioPlayer){
        if (sender.tag == 0){
            sender.tag = 1;
            UIImage *image = [[UIImage imageNamed:@"icon-videoplayer-muteon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [muteSoundControlButton setImage:image forState:UIControlStateNormal];
            [muteSoundControlButton setImage:image forState:UIControlStateHighlighted];
            //
            [audioPlayer play];
        }else{
            sender.tag = 0;
            UIImage *image = [[UIImage imageNamed:@"icon-videoplayer-muteoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [muteSoundControlButton setImage:image forState:UIControlStateNormal];
            [muteSoundControlButton setImage:image forState:UIControlStateHighlighted];
            //
            [audioPlayer pause];
        }
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player setCurrentTime:0.0];
    [player play];
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
    return panoramaGallery.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PanoramaGalleryItemCellIdentifier";
    __block PanoramaViewItemCell *cell = (PanoramaViewItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupLayout];
    
    __block PanoramaGalleryItem *item = [panoramaGallery.photos objectAtIndex:indexPath.row];
    
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
    
    //início do download da imagem original
    if (item.originalImage == nil){
        //cache image original:
        NSString *imageID = [item createImageIdentifierForOriginal];
        [AppD.adAliveImageCacheManager saveImageWithID:imageID andRemoteURL:item.originalURL withCompletionHandler:^(BOOL success, NSString *localVideoURL, NSError *error) {
            if (success){
                item.originalImage = [UIImage imageWithContentsOfFile:localVideoURL];
            }
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView setUserInteractionEnabled:NO];
    
    __block PanoramaGalleryItem *selectedItem = [panoramaGallery.photos objectAtIndex:indexPath.row];
    
    if (selectedItem.originalImage == nil){
        
        NSString *imageID = [selectedItem createImageIdentifierForOriginal];
        [self showActivityIndicatorView];
        [AppD.adAliveImageCacheManager saveImageWithID:imageID andRemoteURL:selectedItem.originalURL withCompletionHandler:^(BOOL success, NSString *localImageURL, NSError *error) {
            if (success){
                selectedItem.originalImage = [UIImage imageWithContentsOfFile:localImageURL];
                [self performSegueWithIdentifier:@"SegueToPanoramaViewer" sender:selectedItem];
            }else{
                [collectionView setUserInteractionEnabled:YES];
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:@"Erro" subTitle:@"Não é possível transferir a imagem no momento. Por favor, tente mais tarde." closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            [self hideActivityIndicatorView];
        }];
        
    }else{
        [self performSegueWithIdentifier:@"SegueToPanoramaViewer" sender:selectedItem];
    }
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (collectionView.frame.size.width - (5.0 * 10.0)) / 4;
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
    lblTitle.text = @"Escolha uma imagem para visualizar em 360º";
    
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

- (void)getGalleryForTargetName
{
    //to mock:
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mockGallery];
        //
        [self startAmbientMusic];
    });
    
//    ViewersDataSource *viewersDS = [ViewersDataSource new];
//
//    [viewersDS getPanoramaGalleryForTargetName:targetName withCompletionHandler:^(PanoramaGallery * _Nullable gallery, DataSourceResponse * _Nonnull response) {
//
//        if (response.status == DataSourceResponseStatusSuccess) {
//            self.panoramaGallery = [gallery copyObject];
//            //carregando as imagens do cache
//            for (PanoramaGalleryItem *item in self.panoramaGallery.photos){
//                NSString *iCode = [item createImageIdentifierForOriginal];
//                NSString *localURL = [AppD.adAliveImageCacheManager loadImageURLforID:iCode andRemotelURL:item.originalURL];
//                if (localURL){
//                    item.originalImage = [UIImage imageWithContentsOfFile:localURL];
//                }
//            }
//            //
//            [galleryCollection reloadData];
//            self.navigationItem.title = self.panoramaGallery.galleryName;
//            [lblTitle setHidden:NO];
//            [galleryCollection setHidden:NO];
//            //
//            isLoad = YES;
//            [self hideActivityIndicatorView];
//        }else{
//            lblEmptyGallery.text = response.message;
//            [lblEmptyGallery setHidden:NO];
//            [self hideActivityIndicatorView];
//        }
//
//    }];
}

#pragma mark - Audio Control

- (void)startAmbientMusic
{
    NSError *error;
    //Usar 'AVAudioSessionCategorySoloAmbient'  para parar outros audios.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error){
        audioPlayer = nil;
        NSLog(@"Panorama Gallery >> startAmbientMusic >> AVAudioPlayerCategory >> Error: %@", [error localizedDescription]);
    }else{
        [audioPlayer play];
        //
        [self createMuteSoundButton];
    }
}

- (void)stopAmbientMusic
{
    if (audioPlayer){
        [audioPlayer stop];
        audioPlayer = nil;
    }
}

- (void)pauseAmbientMusic
{
    if (audioPlayer){
        [audioPlayer pause];
    }
}

-(void)resumeAmbientMusic
{
    if (audioPlayer && (muteSoundControlButton.tag == 1)){
        [audioPlayer play];
    }
}

#pragma mark - UTILS (General Use)

- (void)mockGallery
{
    //Gallery:
    panoramaGallery = [PanoramaGallery new];
    panoramaGallery.galleryID = 1;
    panoramaGallery.galleryName = @"Galeria AW|E";
    panoramaGallery.photos = [NSMutableArray new];
    
    //Items:
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Ambiente 1";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/1-thumb.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/1-original.jpg";
        //
        [panoramaGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Ambiente 2";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/2-thumb.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/2-original.jpg";
        //
        [panoramaGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Ambiente 3";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/3-thumb.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/3-original.jpg";
        //
        [panoramaGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Ambiente 4";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/4-thumb.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/4-original.jpg";
        //
        [panoramaGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Ambiente 5";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/5-thumb.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/5-original.jpg";
        //
        [panoramaGallery.photos addObject:item];
    }
    {
        PanoramaGalleryItem *item = [PanoramaGalleryItem new];
        item.itemName = @"Ambiente 6";
        item.thumbURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/6-thumb.jpg";
        item.originalURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/panoramicas/6-original.jpg";
        //
        [panoramaGallery.photos addObject:item];
    }
    
    //carregando as imagens do cache, se disponíveis:
    for (PanoramaGalleryItem *item in self.panoramaGallery.photos){
        NSString *iCode = [item createImageIdentifierForOriginal];
        NSString *localURL = [AppD.adAliveImageCacheManager loadImageURLforID:iCode andRemotelURL:item.originalURL];
        if (localURL){
            item.originalImage = [UIImage imageWithContentsOfFile:localURL];
        }
    }
    
    [galleryCollection reloadData];
    self.navigationItem.title = self.panoramaGallery.galleryName;
    [lblTitle setHidden:NO];
    [galleryCollection setHidden:NO];
    //
    isLoad = YES;
    [self hideActivityIndicatorView];
}

- (void)createMuteSoundButton;
{
    UIImage *image = [[UIImage imageNamed:@"icon-videoplayer-muteon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //
    muteSoundControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    muteSoundControlButton.tag = 1;
    muteSoundControlButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    [muteSoundControlButton setImage:image forState:UIControlStateNormal];
    [muteSoundControlButton setImage:image forState:UIControlStateHighlighted];
    [muteSoundControlButton setFrame:CGRectMake(0, 0, 32, 32)];
    [muteSoundControlButton setClipsToBounds:YES];
    [muteSoundControlButton setExclusiveTouch:YES];
    [muteSoundControlButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [muteSoundControlButton addTarget:self action:@selector(actionChangeMuteStateMethod:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[muteSoundControlButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[muteSoundControlButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:muteSoundControlButton];
    self.navigationItem.rightBarButtonItem = b;
}

@end
