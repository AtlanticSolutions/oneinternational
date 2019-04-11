//
//  VC_Sponsor.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 01/12/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Sponsor.h"
#import "TVC_SponsorHeader.h"
#import "Sponsor.h"
#import "CVC_CustomIconButton.h"
#import "CVC_SponsorLogo.h"
#import "WebItemToShow.h"
#import "VC_WebViewCustom.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Sponsor()

@property (nonatomic, strong) NSArray* plansList;
@property (nonatomic, strong) NSMutableArray *plansTitle;
@property (nonatomic, weak) IBOutlet UICollectionView* clvSponsor;
//
@property (nonatomic, assign) bool isLoaded;
@property (nonatomic, strong) UIImage *noImagePic;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Sponsor
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize clvSponsor, isLoaded, noImagePic, plansList, plansTitle;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
  
    isLoaded = false;
    
    noImagePic = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_SPONSORS", @"")];
        [self setupData];
        [clvSponsor reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([segue.identifier isEqualToString:@"SegueToWebBrowser"]){
        VC_WebViewCustom *destViewController = (VC_WebViewCustom*)segue.destinationViewController;
        destViewController.fileURL = ((WebItemToShow *)sender).urlString;
        destViewController.titleNav = ((WebItemToShow *)sender).titleMenu;
        destViewController.showShareButton = NO;
        destViewController.hideViewButtons = NO;
        destViewController.showAppMenu = NO;
        
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return plansList.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
	
	UICollectionReusableView *reusableview = nil;
	
	if (kind == UICollectionElementKindSectionHeader) {
		TVC_SponsorHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SponsorHeader" forIndexPath:indexPath];
		[headerView updateLayout];
		headerView.lblTitle.text = [plansTitle objectAtIndex:indexPath.section];
		
		reusableview = headerView;
	}
 
	return reusableview;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
	
	return CGSizeMake(clvSponsor.frame.size.width, 41);
	
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSDictionary *dicPlan = [plansList objectAtIndex:section];
	NSArray *arraySponsors = [dicPlan objectForKey:@"sponsors"];
    return arraySponsors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CustomCellSponsor";
    
    CVC_SponsorLogo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[CVC_SponsorLogo alloc] init];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.indicator.color = AppD.styleManager.colorPalette.backgroundNormal;
	
	NSDictionary *dicPlan = [plansList objectAtIndex:indexPath.section];
	NSArray *arraySponsors = [dicPlan objectForKey:@"sponsors"];
	NSDictionary *dicSponsor = [arraySponsors objectAtIndex:indexPath.row];
	
    Sponsor *spo = [Sponsor createObjectFromDictionary:dicSponsor];
    
    [cell updateLayoutStartingDownloading];
    
    if (spo.image == nil){
        
        [cell.indicator startAnimating];
        [cell.imvLogo setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:spo.imageUrl]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [cell.indicator stopAnimating];
            cell.imvLogo.image = image;
            spo.image = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [cell.indicator stopAnimating];
            cell.imvLogo.image = noImagePic;
            cell.imvLogo.alpha = 0.25;
            cell.lblName.text = spo.name;
            cell.lblName.alpha = 1.0;
        }];
    }else{
        [cell.indicator stopAnimating];
        cell.imvLogo.image = spo.image;
    }
    

    
//    [[[AsyncImageDownloader alloc] initWithFileURL:spo.imageUrl successBlock:^(NSData *data) {
//        
//        [cell.indicator startAnimating];
//        cell.indicator.hidden = false;
//        
//        Sponsor *spoFinal = [sponsorList objectAtIndex:indexPath.row];
//        
//        if (data != nil){
//            spoFinal.image = [UIImage imageWithData:data];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            CVC_SponsorLogo *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
//           if (updateCell){
//                updateCell.imvLogo.image = spoFinal.image;
//           }
//            
//            [cell.indicator stopAnimating];
//            cell.indicator.hidden = true;
//            
//        });
//        
//    } failBlock:^(NSError *error) {
//        NSLog(@"Erro ao buscar imagem: %@", error.domain);
//    }] startDownload];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dicPlan = [plansList objectAtIndex:indexPath.section];
	NSArray *arraySponsors = [dicPlan objectForKey:@"sponsors"];
	NSDictionary *dicSponsor = [arraySponsors objectAtIndex:indexPath.row];
	
    Sponsor *spo = [Sponsor createObjectFromDictionary:dicSponsor];
    
    if (spo.sponsorLink != nil && ![spo.sponsorLink isEqualToString:@""]){
        
        NSString *url = [NSString stringWithFormat:@"%@", spo.sponsorLink];
        
        if (![url containsString:@"http"])
        {
            url = [NSString stringWithFormat:@"http://%@", url];
        }
        
        WebItemToShow *webItem = [WebItemToShow new];
        webItem.urlString = url;
        webItem.titleMenu = spo.name;

        
        [self performSegueWithIdentifier:@"SegueToWebBrowser" sender:webItem];
    }
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (self.view.frame.size.width - 20 - 20 -20 )/ 2;
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 20, 0, 20);
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

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.clvSponsor.backgroundColor = [UIColor whiteColor];
}

- (void)setupData
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
		
        [connection getSponsorsPlansWithCompletionHandler:^(NSArray *response, NSError *error) {
            
            if (error){
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SPONSOR_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
				plansList = response;
				
				plansTitle= [NSMutableArray new];
				
				for(int i=0; i<plansList.count ; i++)
				{
					NSDictionary *dict = [plansList objectAtIndex:i];
					[plansTitle addObject:[dict objectForKey:@"name"]];
				}
				
                [clvSponsor reloadData];
                
                isLoaded = true;
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

@end

