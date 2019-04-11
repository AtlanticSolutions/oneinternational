//
//  VirtualShowcaseMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VirtualShowcaseMainVC.h"
#import "VirtualShowcaseGallery.h"
#import "ShowcaseProductsHeaderReusableView.h"
#import "ShowcaseProductCollectionViewCell.h"
#import "VirtualShowcaseTakePhotoVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VirtualShowcaseMainVC()

//Interface
@property (nonatomic, weak) IBOutlet UICollectionView *cvProducts;

//Data
@property (nonatomic, strong) VirtualShowcaseGallery *showcase;
@property (nonatomic, assign) BOOL isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VirtualShowcaseMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize cvProducts;
@synthesize showcase, isLoaded;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self createUserCollectionButton];
    
    //DZNEmptyDataSetDelegate
    self.cvProducts.emptyDataSetSource = self;
    self.cvProducts.emptyDataSetDelegate = self;

    isLoaded = NO;

    showcase = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    if (showcase == nil){
        [self setupLayout:@"Vitrine Virtual"];
        [self getVirtualShowcaseFromServer];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToTakePhoto"]){
        VirtualShowcaseTakePhotoVC *vcPhoto = segue.destinationViewController;
        vcPhoto.category = [(VirtualShowcaseCategory*)sender copyObject];
        
        //AdAliveLog:
        [AppD logAdAliveEventWithName:@"VitrineVirtualCategorySelected" data:[vcPhoto.category dictionaryJSON]];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

//Manual Actions:
- (void)showUserCollection:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToUserCollection" sender:self];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        ShowcaseProductsHeaderReusableView *header = (ShowcaseProductsHeaderReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShowcaseProductsHeader" forIndexPath:indexPath];
        [header setupLayout];
        //
        if (showcase.bannerImage){
            [header.activityIndicator stopAnimating];
            header.imvBanner.image = showcase.bannerImage;
        }else{
            [header.activityIndicator startAnimating];
            [header.imvBanner setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:showcase.bannerURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                [header.activityIndicator stopAnimating];
                header.imvBanner.image = image;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [header.activityIndicator stopAnimating];
                header.imvBanner.image = [UIImage new];
            }];
        }
        
        reusableview = header;
    }
    
    return reusableview;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (showcase.bannerImage) {
        CGFloat height = [ShowcaseProductsHeaderReusableView heightForImage:showcase.bannerImage containedInWidth:collectionView.frame.size.width];
        return CGSizeMake(collectionView.frame.size.width, height);
    }else{
        return CGSizeMake(0,0);
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return showcase.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ShowcaseProductCustomCell";
    
    __block ShowcaseProductCollectionViewCell *cell = (ShowcaseProductCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupLayout];
    
    __block VirtualShowcaseCategory *category = [showcase.categories objectAtIndex:indexPath.row];
    
    if (category.picture){
        cell.imvProduct.image = category.picture;
    }else{
        [cell.activityIndicator startAnimating];
        [cell.imvProduct setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:category.pictureURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            category.picture = image;
            //
            [cell.activityIndicator stopAnimating];
            cell.imvProduct.image = category.picture;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            category.picture = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
            //
            [cell.activityIndicator stopAnimating];
            cell.imvProduct.image = category.picture;
        }];
    }
    
    cell.lblProduct.text = category.name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VirtualShowcaseCategory *selectedCategory = [showcase.categories objectAtIndex:indexPath.row];
    
    if (selectedCategory.products.count > 0){
        if (selectedCategory.maskModel != nil){
            [self performSegueWithIdentifier:@"SegueToTakePhoto" sender:selectedCategory];
        }else{
            [self loadMaskImagesForCategory:selectedCategory];
        }
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showInfo:@"Atenção" subTitle:@"A categoria selecionada ainda não possui nenhum produto cadastrado." closeButtonTitle:@"OK" duration:0.0];
    }
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (collectionView.frame.size.width - 20 - 20 - 20)/ 2;
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - DZNEmptyDataSetSource Methods
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"Please Allow Photo Access";
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"LABEL_SHOWCASE_NO_ITEMS_AVAILABLES", @"");

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Italic" size:17], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {

    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];

    //Self
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]]; //[UIColor groupTableViewBackgroundColor];

    cvProducts.backgroundColor = nil;
    UICollectionViewFlowLayout *vcProductsFL = (UICollectionViewFlowLayout*)cvProducts.collectionViewLayout;
    vcProductsFL.sectionHeadersPinToVisibleBounds = YES;
    vcProductsFL.sectionFootersPinToVisibleBounds = YES;
    [ToolBox graphicHelper_ApplyShadowToView:cvProducts withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.50];
    //[cvProducts setHidden:YES];
}

- (UIBarButtonItem*)createUserCollectionButton
{
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.backgroundColor = nil;
    collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *img = [[UIImage imageNamed:@"PhotoUserCollection"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [collectionButton setImage:img forState:UIControlStateNormal];
    //
    [collectionButton setFrame:CGRectMake(0, 0, 32, 32)];
    [collectionButton setClipsToBounds:YES];
    [collectionButton setExclusiveTouch:YES];
    [collectionButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [collectionButton addTarget:self action:@selector(showUserCollection:) forControlEvents:UIControlEventTouchUpInside];
    //
    [collectionButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    //
    [[collectionButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[collectionButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:collectionButton];
}

- (void)getVirtualShowcaseFromServer {
    ShowcaseDataSource *ds = [ShowcaseDataSource new];

    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });

    [ds getVirtualShowcaseFromServerWithCompletionHandler:^(VirtualShowcaseGallery * _Nullable data, DataSourceResponse * _Nonnull response) {
        
        if (response.status == DataSourceResponseStatusSuccess){
            if (data){
                showcase = data;
                self.navigationItem.title = showcase.title;
                [self loadBanner];
            }else{
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                [cvProducts reloadData];
            }
        }else{
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:response.message closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            //
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            [cvProducts reloadData];
        }
    }];
}

- (void)loadBanner
{
    [[[AsyncImageDownloader alloc] initWithFileURL:showcase.bannerURL successBlock:^(NSData *data) {
        
        if (data){
            showcase.bannerImage = [UIImage imageWithData:data];
        }else{
            showcase.bannerImage = nil;
        }
        
        [self.view layoutIfNeeded];
        [cvProducts reloadData];
        //[cvProducts setHidden:NO];
        isLoaded = true;
        //
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
    } failBlock:^(NSError *error) {
        NSLog(@"Erro ao buscar imagem: %@", error.domain);
        
        showcase.bannerImage = nil;
        [self.view layoutIfNeeded];
        [cvProducts reloadData];
        //[cvProducts setHidden:NO];
        //
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
    }] startDownload];
}

- (void)loadMaskImagesForCategory:(VirtualShowcaseCategory*)category
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    //Carrega máscara modelo
    [[[AsyncImageDownloader alloc] initWithFileURL:category.maskModelURL successBlock:^(NSData *data) {
        
        if (data){
            UIImage *img = [UIImage imageWithData:data];
            category.maskModel = img;
            //
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            //Abre tela de fotos:
            [self performSegueWithIdentifier:@"SegueToTakePhoto" sender:category];
            
        }else{
            //Error:
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            //
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:NSLocalizedString(@"ALERT_TITLE_SHOWCASE_LOAD_IMAGES_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SHOWCASE_LOAD_IMAGES_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
        
    } failBlock:^(NSError *error) {
        NSLog(@"Erro ao buscar imagem: %@", error.domain);
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:NSLocalizedString(@"ALERT_TITLE_SHOWCASE_LOAD_IMAGES_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SHOWCASE_LOAD_IMAGES_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        
    }] startDownload];
    
}

@end
