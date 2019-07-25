//
//  ShowcaseUserCollection.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "ShowcaseUserCollectionViewController.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ShowcaseUserCollectionViewController()

//Interface
@property (nonatomic, weak) IBOutlet UICollectionView *cvPhotoCollection;
@property (nonatomic, weak) IBOutlet UILabel *lblEmptyCollection;
@property (nonatomic, weak) IBOutlet UIView *viewEditMode;
@property (nonatomic, weak) IBOutlet UIButton *btnShare;
@property (nonatomic, weak) IBOutlet UIButton *btnDelete;

//Data
@property (nonatomic, strong) NSMutableArray<VirtualShowcasePhoto*>* photosList;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isEditMode;

@end

#pragma mark - • IMPLEMENTATION
@implementation ShowcaseUserCollectionViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize cvPhotoCollection, lblEmptyCollection, viewEditMode, btnShare,  btnDelete;
@synthesize photosList, isLoaded, isEditMode;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    isLoaded = NO;
    isEditMode = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    if (!isLoaded){
        [self setupLayout];
        //
        [self loadData];
        //
        isLoaded = YES;
    }
    
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)showOrHideEditMode:(id)sender
{
    isEditMode = !isEditMode;
    
    if (isEditMode){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") style:UIBarButtonItemStylePlain target:self action:@selector(showOrHideEditMode:)];
        //
        [UIView animateWithDuration:0.2 animations:^{
            [cvPhotoCollection setContentInset:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];
            //
            viewEditMode.alpha = 1.0;
        }];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTON_TITLE_GALLERY_EDIT", @"") style:UIBarButtonItemStylePlain target:self action:@selector(showOrHideEditMode:)];
        //
        [UIView animateWithDuration:0.2 animations:^{
            [cvPhotoCollection setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            //
            viewEditMode.alpha = 0.0;
        }];
    }
    
    [cvPhotoCollection reloadData];
}

- (IBAction)actionSharePhotos:(id)sender
{
    NSMutableArray<UIImage*>* photos = [NSMutableArray new];
    
    for (VirtualShowcasePhoto *p in photosList){
        if (p.selected){
            [photos addObject:p.image];
        }
        p.selected = NO;
    }
    
    if (photos.count > 0){
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:photos applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.sourceView = sender;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
    }
    
    //[cvPhotoCollection reloadData];
    //[self showOrHideEditMode:nil];
}

- (IBAction)actionRemovePhotos:(id)sender
{
    __block NSMutableArray<VirtualShowcasePhoto*>* photos = [NSMutableArray new];
    
    for (VirtualShowcasePhoto *p in photosList){
        if (p.selected){
            [photos addObject:p];
        }
    }
    
    if (photos.count > 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_REMOVE_PHOTO_USER_COLLECTION", @"") message:NSLocalizedString(@"ALERT_MESSAGE_REMOVE_PHOTO_USER_COLLECTION", @"") preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_REMOVE", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            ShowcaseDataSource *SDS = [ShowcaseDataSource new];
            for (VirtualShowcasePhoto *p in photos){
                [SDS deletePhoto:p.name forUser:AppD.loggedUser.userID];
            }
            [self loadData];
            [self showOrHideEditMode:nil];
        }];
        [alertController addAction:actionDelete];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertController addAction:actionCancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

#pragma mark - CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photosList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ShowcaseProductCustomCell";
    
    ShowcaseProductCollectionViewCell *cell = (ShowcaseProductCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupLayout];
    
    cell.imvProduct.contentMode = UIViewContentModeScaleAspectFill;
    cell.imvProduct.clipsToBounds = YES;
    cell.layer.cornerRadius = 0;
    
    __block VirtualShowcasePhoto *photo = [photosList objectAtIndex:indexPath.row];
    
    if (photo.image){
        cell.imvProduct.image = photo.image;
    }else{
        [cell.activityIndicator startAnimating];
        [cell.imvProduct setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:photo.fileURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            photo.image = image;
            //
            ShowcaseProductCollectionViewCell *originalCell = (ShowcaseProductCollectionViewCell*)[cvPhotoCollection cellForItemAtIndexPath:indexPath];
            [originalCell.activityIndicator stopAnimating];
            originalCell.imvProduct.image = photo.image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            photo.image = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
            //
            ShowcaseProductCollectionViewCell *originalCell = (ShowcaseProductCollectionViewCell*)[cvPhotoCollection cellForItemAtIndexPath:indexPath];
            [originalCell.activityIndicator stopAnimating];
            originalCell.imvProduct.image = photo.image;
        }];
    }
    
    if (isEditMode){
        if (photo.selected){
            [cell.imvSelectionIndicator setImage:[UIImage imageNamed:@"ShowcaseItemChecked"]];
        }else{
            [cell.imvSelectionIndicator setImage:[UIImage imageNamed:@"ShowcaseItemUnchecked"]];
        }
        [cell.imvSelectionIndicator setHidden:NO];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VirtualShowcasePhoto *selectedPhoto = [photosList objectAtIndex:indexPath.row];
    
    if (isEditMode){
        selectedPhoto.selected = !selectedPhoto.selected;
        [cvPhotoCollection reloadItemsAtIndexPaths:@[indexPath]];
    }else{
        VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:selectedPhoto.image backgroundImage:nil andDelegate:self];
        photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
        photoView.autoresizingMask = (1 << 6) -1;
        photoView.alpha = 0.0;
        //
        [AppD.window addSubview:photoView];
        [AppD.window bringSubviewToFront:photoView];
        //
        [UIView animateWithDuration:0.3 animations:^{
            photoView.alpha = 1.0;
        }];
    }
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (collectionView.frame.size.width - 4 - 4 - 4)/ 3;
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
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

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_SHOWCASE_USER_COLLECTION", @"");
    
    lblEmptyCollection.backgroundColor = nil;
    lblEmptyCollection.textColor = [UIColor whiteColor];
    lblEmptyCollection.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_BUTTON_MENU_OPTION];
    lblEmptyCollection.text = NSLocalizedString(@"LABEL_SHOWCASE_EMPTY_COLLECTION", @"");
    
    viewEditMode.backgroundColor = [UIColor blackColor];
    
    btnShare.backgroundColor = nil;
    [btnShare setBackgroundImage: [ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:COLOR_MA_GREEN] forState:UIControlStateNormal];
    [btnShare setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
    [btnShare setImage:[[UIImage imageNamed:@"SharePhotoMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnShare setTintColor:[UIColor whiteColor]];
    [btnShare setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnShare.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS];
    [btnShare setTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_SHARE", @"") forState:UIControlStateNormal];
    [btnShare setExclusiveTouch:YES];
    [btnShare setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    
    btnDelete.backgroundColor = nil;
    [btnDelete setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:COLOR_MA_RED] forState:UIControlStateNormal];
    [btnDelete setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
    [btnDelete setImage:[[UIImage imageNamed:@"icon-order-trash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    [btnDelete setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    btnDelete.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnDelete.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS];
    [btnDelete setTitle:NSLocalizedString(@"ALERT_OPTION_REMOVE", @"") forState:UIControlStateNormal];
    [btnDelete setExclusiveTouch:YES];
    [btnDelete setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    
    cvPhotoCollection.backgroundColor = nil;
    cvPhotoCollection.alpha = 0.0;
    lblEmptyCollection.alpha = 0.0;
    viewEditMode.alpha = 0.0;
}

- (void)loadData
{
    photosList = [NSMutableArray new];
    self.navigationItem.rightBarButtonItem = nil;
    
//    dispatch_async(dispatch_get_main_queue(),^{
//        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
//    });
    
    ShowcaseDataSource *SDS = [ShowcaseDataSource new];
    
    [SDS loadSavedPhotosForUser:AppD.loggedUser.userID withCompletionHandler:^(NSArray<VirtualShowcasePhoto*> * _Nullable photos, NSError * _Nullable error) {
        if (error){
            NSLog(@"loadSavedPhotosForUserError: %@", [error localizedDescription]);
            //
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:NSLocalizedString(@"ALERT_TITLE_SAVE_TO_COLLECTION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SAVE_TO_COLLECTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }else{
            photosList = [[NSMutableArray alloc] initWithArray:photos];
            [cvPhotoCollection reloadData];
            if (photosList.count == 0){
                [UIView animateWithDuration:0.25 animations:^{
                    lblEmptyCollection.alpha = 1.0;
                }];
            }else{
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTON_TITLE_GALLERY_EDIT", @"") style:UIBarButtonItemStylePlain target:self action:@selector(showOrHideEditMode:)];
                [UIView animateWithDuration:0.25 animations:^{
                    cvPhotoCollection.alpha = 1.0;
                }];
            }
        }
        
//        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    }];
}

@end
