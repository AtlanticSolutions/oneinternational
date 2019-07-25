//
//  VC_Team.m
//  GS&MD
//
//  Created by Erico GT on 11/29/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Team.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Team()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionViewMenu;
//
@property (nonatomic, weak) IBOutlet UIView *viewCard;
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property (nonatomic, weak) IBOutlet UIImageView *imvMember;
@property (nonatomic, weak) IBOutlet UILabel *lblNameCard;
@property (nonatomic, weak) IBOutlet UILabel *lblCargoCard;
@property (nonatomic, weak) IBOutlet UILabel *lblNameMember;
@property (nonatomic, weak) IBOutlet UILabel *lblCargoMember;
@property (nonatomic, weak) IBOutlet UIImageView *imvLinkedimLogo;
@property (nonatomic, weak) IBOutlet UIButton *btnLinkedin;
@property (nonatomic, weak) IBOutlet UIButton *btnCloseCard;
//
@property (nonatomic, strong)  NSMutableArray *membersList;
@property (nonatomic, strong)  Contact *selectedContact;
@property (nonatomic, assign) bool isTouchResolved;
//
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraitCargo;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Team
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize collectionViewMenu, membersList, isTouchResolved, selectedContact;
@synthesize viewCard, imvBackground, imvMember, lblNameCard, lblCargoCard, lblNameMember, lblCargoMember, btnLinkedin, imvLinkedimLogo, btnCloseCard;
@synthesize constraitCargo;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
	[self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_TEAM", @"");
    
    isTouchResolved = true;
    viewCard.alpha = 0.0;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [viewCard addGestureRecognizer:swipe];
    
    constraitCargo.constant = 26.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    NSLog(@"%i", AppD.loggedUser.userID);
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        //Buscando contatos GS&MD
        [connectionManager getContactsListWithCompletionHandler:^(NSArray *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONTACTS_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                
                if (response){
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[response valueForKey:@"departments"]];
                    NSMutableArray *tempResult = [NSMutableArray new];
                    for (NSDictionary *dic in tempArray){
                        [tempResult addObject:[Contact createObjectFromDictionary:dic]];
                    }
                    
                    //ordenando a lista
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    membersList = [[NSMutableArray alloc] initWithArray:[tempResult sortedArrayUsingDescriptors:sortDescriptors]];
                    
                    [collectionViewMenu reloadData];
                }
            }
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)clickLinkedIn:(id)sender
{
    if (selectedContact.linkedin != nil && ![selectedContact.linkedin isEqualToString:@""])
    {
       // [Answers logShareWithMethod:@"LinkedIn" contentName:@"Contato" contentType:@"Perfil" contentId:@"" customAttributes:@{}];
        
        [ToolBox graphicHelper_ApplyRippleEffectAnimationInView:(UIView*)sender withColor:AppD.styleManager.colorPalette.backgroundNormal andRadius:0.0];
        //
        NSString *string = [NSString stringWithFormat:@"%@", selectedContact.linkedin];
        NSURL *url = [NSURL URLWithString:string];
        BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
        
        if (canOpenURL)
        {
            url = [NSURL URLWithString:selectedContact.linkedin];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (IBAction)clickCloseCard:(id)sender
{
    [UIView animateWithDuration:0.300 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewCard.frame = CGRectMake(viewCard.frame.origin.x, self.view.frame.size.height + 64, viewCard.frame.size.width, viewCard.frame.size.height);
        collectionViewMenu.alpha = 1.0;
    } completion:^(BOOL finished) {
        viewCard.alpha = 0.0;
    }];
}

- (void)closeSwipe:(UISwipeGestureRecognizer*)recognizer
{
    [self clickCloseCard:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return membersList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellItemTeamMember";
    
    CVC_Team_Member *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[CVC_Team_Member alloc] init];
    }
    
    //CGFloat lado = (self.view.frame.size.width - 20 - 20 ) / 3;
    
    //Data:
    Contact *actualContact = [membersList objectAtIndex:indexPath.row];
    
    //Layout
    [cell updateLayout];
    
    if (actualContact.imgProfile == nil){
        
        if (![actualContact.urlProfileImage isEqualToString:@""]){
            
            [[[AsyncImageDownloader alloc] initWithFileURL:actualContact.urlProfileImage successBlock:^(NSData *data) {
                
                if (data != nil){
                    Contact *contact = [membersList objectAtIndex:indexPath.row];
                    contact.imgProfile = [UIImage imageWithData:data];
                    //
                    [collectionViewMenu reloadItemsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil]];
                }
                
            } failBlock:^(NSError *error) {
                NSLog(@"Erro ao buscar imagem: %@", error.domain);
            }] startDownload];
            
        }else{
            
            AppD.loggedUser.profilePic = [UIImage imageNamed:@"icon-user-default"];
        }
    }
    else{
        cell.imvPerson.image = actualContact.imgProfile;
        [cell.indicator stopAnimating];
        cell.indicator.hidden = true;
    }

    cell.lblName.text = actualContact.name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isTouchResolved)
    {
        isTouchResolved = false;
        
        selectedContact = [(Contact*)[membersList objectAtIndex:indexPath.row] copyObject];
        
        lblNameMember.text = selectedContact.name;
        lblCargoMember.text = selectedContact.department;
        imvMember.image = selectedContact.imgProfile;
        
        CGSize size = [selectedContact.department sizeWithFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS] constrainedToSize:CGSizeMake(self.view.frame.size.width - 80, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        constraitCargo.constant = (size.height < 26.0) ? 26.0 : size.height;
        [viewCard layoutIfNeeded];
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineHeightMultiple = 26.0f;
//        paragraphStyle.maximumLineHeight = 26.0f;
//        paragraphStyle.minimumLineHeight = 26.0f;
//        
//        NSDictionary *ats = @{NSFontAttributeName : [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS], NSParagraphStyleAttributeName : paragraphStyle,};
//        CGRect rectSize = [selectedContact.department boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 80, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) attributes:ats context:nil]; //NSStringDrawingContext
//        constraitCargo.constant = (rectSize.size.height < 26.0) ? 26.0 : rectSize.size.height;
//        [viewCard layoutIfNeeded];
        
        viewCard.frame = CGRectMake(viewCard.frame.origin.x, self.view.frame.size.height + 64, viewCard.frame.size.width, viewCard.frame.size.height);
        viewCard.alpha = 1.0;

        [UIView animateWithDuration:0.300 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            collectionView.alpha = 0.0;
            viewCard.frame = CGRectMake(viewCard.frame.origin.x, 20.0, viewCard.frame.size.width, viewCard.frame.size.height);;
            [viewCard layoutIfNeeded];
        } completion:^(BOOL finished) {
            isTouchResolved = true;
        }];
    }
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (self.view.frame.size.width - 20 - 20 - 4) / 3;
    CGFloat altura = lado * 1.6;
    return CGSizeMake(lado, altura);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
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

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    collectionViewMenu.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    //CardView

    viewCard.backgroundColor = [UIColor whiteColor];
    imvBackground.backgroundColor = nil;
    imvMember.backgroundColor = nil;
    lblNameCard.backgroundColor = nil;
    lblCargoCard.backgroundColor = nil;
    lblNameMember.backgroundColor = nil;
    lblCargoMember.backgroundColor = nil;
    btnLinkedin.backgroundColor = nil;
    imvLinkedimLogo.backgroundColor = nil;
    btnCloseCard.backgroundColor = nil;
    //
    [viewCard.layer setBorderWidth:2.0];
    [viewCard.layer setBorderColor:AppD.styleManager.colorPalette.backgroundNormal.CGColor];
    [viewCard.layer setCornerRadius:10.0];
    [ToolBox graphicHelper_ApplyShadowToView:viewCard withColor:[UIColor blackColor] offSet:CGSizeMake(5.0, 5.0) radius:4.0 opacity:0.5];
    //
    [lblNameCard setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
    [lblCargoCard setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
    //
    [lblNameCard setTextColor:AppD.styleManager.colorCalendarAvailable];
    [lblCargoCard setTextColor:AppD.styleManager.colorCalendarAvailable];
    //
    lblNameCard.text = [NSLocalizedString(@"PLACEHOLDER_NAME", @"") uppercaseString];
    lblCargoCard.text = [NSLocalizedString(@"PLACEHOLDER_ROLE", @"") uppercaseString];
    //
    [lblNameMember setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [lblCargoMember setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    //
    [lblNameMember setTextColor:[UIColor blackColor]];
    [lblCargoMember setTextColor:[UIColor blackColor]];
    //
    imvLinkedimLogo.image = [UIImage imageNamed:@"icon-share-linkedin"];
    //
    btnLinkedin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnLinkedin.contentEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 0);
    btnLinkedin.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    [btnLinkedin setTitle:NSLocalizedString(@"BUTTON_TITLE_OPEN_LINKEDIN", @"") forState:UIControlStateNormal];
    //
    [btnCloseCard.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [btnCloseCard setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCloseCard.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    [btnCloseCard setTintColor:[UIColor whiteColor]];
    [btnCloseCard setTitle:NSLocalizedString(@"ALERT_OPTION_CLOSE",@"") forState:UIControlStateNormal];
}

@end

