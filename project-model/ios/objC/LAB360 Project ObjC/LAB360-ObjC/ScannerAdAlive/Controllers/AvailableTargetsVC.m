//
//  AvailableTargetsVC.m
//  ARC360
//
//  Created by Erico GT on 25/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AvailableTargetsVC.h"
#import "AppDelegate.h"
#import "ImageTargetItem.h"
#import "PanoramaViewItemCell.h"
#import "VIPhotoView.h"
#import "ViewersDataSource.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AvailableTargetsVC()<UICollectionViewDelegate, UICollectionViewDataSource, VIPhotoViewDelegate>

//Data:
@property (nonatomic, strong) NSMutableArray<ImageTargetItem*> *targetsList;

//Layout:
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UICollectionView *cvTargets;

@end

#pragma mark - • IMPLEMENTATION
@implementation AvailableTargetsVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize targetsList;
@synthesize headerView, lblTitle, cvTargets;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    targetsList = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Targets"];
    
    [self loadTargetsFromServer];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Targets" subTitle:@"'Targets' são imagens reconhecidas pela câmera utilizadas para iniciar conteúdos de Realidade Aumentada.\nAo identificar uma imagem na cena será exibida uma interação relacionada, podendo ser uma vídeo, uma animação, um objeto 3D, etc.\n No menu 'Realidade Aumentada', aponte o dispositivo para uma das imagens desta lista para ver conferir!\n Você pode imprimir as imagens ou vê-las de um outro dispositivo, tablet ou computador." closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

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
    return targetsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PanoramaGalleryItemCellIdentifier";
    __block PanoramaViewItemCell *cell = (PanoramaViewItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupLayout];
    cell.imvItem.contentMode = UIViewContentModeScaleAspectFit;
    
    __block ImageTargetItem *item = [targetsList objectAtIndex:indexPath.row];
    
    if (item.image){
        cell.imvItem.image = item.image;
    }else{
        [cell.activityIndicator startAnimating];
        [cell.imvItem setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.imageURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            item.image = image;
            //
            [cell.activityIndicator stopAnimating];
            cell.imvItem.image = item.image;
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
    if (collectionView.tag == 0)
    {
        collectionView.tag = 1;
        PanoramaViewItemCell *cell = (PanoramaViewItemCell*)[collectionView cellForItemAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            [self resolveSelectionForRow:indexPath.row];
            collectionView.tag = 0;
        }];
    }
    
}

- (void)resolveSelectionForRow:(NSInteger)row
{
    __block ImageTargetItem *selectedItem = [targetsList objectAtIndex:row];
    
    if (selectedItem.image != nil){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        
        [alert addButton:@"Ampliar" withType:SCLAlertButtonType_Normal actionBlock:^{
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:selectedItem.image backgroundImage:nil andDelegate:self];
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
        }];
        
        [alert addButton:@"Imprimir" withType:SCLAlertButtonType_Normal actionBlock:^{
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[selectedItem.image] applicationActivities:nil];
            if (IDIOM == IPAD){
                activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
            }
            [self presentViewController:activityController animated:YES completion:^{
                NSLog(@"activityController presented");
            }];
            [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
            }];
        }];
        
        [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
        
        [alert showInfo:@"Targets" subTitle:selectedItem.name closeButtonTitle:nil duration:0.0];
    }
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (collectionView.frame.size.width - (3.0 * 10.0)) / 2;
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

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkGrayColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_ITALIC size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblTitle.text = @"Buscando targets disponíveis...";
    
    cvTargets.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [self createHelpButton];
}

#pragma mark - Connections

- (void)loadTargetsFromServer
{
    ViewersDataSource *dataSource = [ViewersDataSource new];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [dataSource getTargetsFromServerWithCompletionHandler:^(NSMutableArray<ImageTargetItem *> * _Nullable targets, DataSourceResponse * _Nonnull response) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (response.status == DataSourceResponseStatusSuccess){
                
                self.targetsList = [[NSMutableArray alloc] initWithArray:targets];
                
                if (self.targetsList.count == 0){
                    lblTitle.text = @"Nenhum 'Target' para exibição no momento.";
                }else{
                    if (self.targetsList.count == 1){
                        lblTitle.text = @"1 Target encontrado";
                    }else{
                        lblTitle.text = [NSString stringWithFormat:@"%lu Targets encontrados", (unsigned long)self.targetsList.count];
                    }
                }
                
            }else{
                
                lblTitle.text = @"Nenhum 'Target' para exibição no momento.";
                
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:@"Atenção" subTitle:response.message closeButtonTitle:@"OK" duration:0.0];
                
            }
            
            [cvTargets reloadData];
            
        }];
        
    });
}

#pragma mark - UTILS (General Use)

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

@end
