//
//  VC_SideMenu.m
//  AHK-100anos
//
//  Created by Erico GT on 10/4/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "VC_SideMenu.h"
//
#import "VC_Account.h"
#import "VC_MyEvents.h"
#import "TVC_SideMenuItem.h"
#import "TVC_SideMenuFooter.h"
#import "VC_DownloadsList.h"
#import "VC_ContactsChat.h"
#import "VC_VideoList.h"
#import "VC_Events.h"
#import "VC_Sponsor.h"
#import "VC_Team.h"
#import "VC_CameraAdAlive.h"
#import "VC_Promotions.h"
#import "VC_InvoiceScan.h"
#import "VC_MyInvoices.h"
#import "VC_StoresSearch.h"
#import "VC_PromotionsExtract.h"
#import "VC_WebDocumentsViewer.h"
#import "VC_GenericUserProfile.h"
#import "VC_PostsGallery.h"
#import "VC_Participants.h"
#import "VC_About.h"
#import "ProductViewController.h"
#import "WebItemToShow.h"
#import "MaskViewController.h"
#import "VirtualShowcaseMainVC.h"
#import "Viewer360MainVC.h"
#import "DigitalCardMainVC.h"
#import "PromotionalCardMainVC.h"
#import "VC_WebAbout.h"
#import "PrototypeMenuVC.h"
#import "AppConfigDataSource.h"
#import "VC_WebViewCustom.h"
#import "AppManagerVC.h"
#import "ScannerAdAliveHistoryVC.h"
#import "BeaconShowroomMainVC.h"
#import "VC_Category.h"
#import "FloatingPickerView.h"
#import "AppOptionsVC.h"
#import "UtilitiesMainVC.h"
#import "QuestionnaireSearchVC.h"
#import "UIImage+animatedGIF.h"
//
#import "CustomSurveyAvailableSamplesVC.h"
#import "ActionModel3D_SamplesVC.h"
#import "Horus3DViewerVC.h"
#import "AnimaLayerVC.h"

@interface VC_SideMenu ()

//Layout:
@property(nonatomic, weak) IBOutlet UIView *vMenu;
@property(nonatomic, weak) IBOutlet UILabel *lblUserName;
@property(nonatomic, weak) IBOutlet UILabel *lblUserEmail;
@property(nonatomic, weak) IBOutlet UITableView *tvMenu;
@property(nonatomic, weak) IBOutlet UIButton *btBack;
@property(nonatomic, weak) IBOutlet UIImageView *imvPhoto;
//
@property (nonatomic, assign) IBOutlet NSLayoutConstraint* constraitLeftUserName;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint* constraitLeftUserEmail;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint* constraitMenu;
//
@property (nonatomic, strong) NSMutableArray *optionsList;
@property (nonatomic, strong) NSMutableArray *completeOptionsList;
@property (nonatomic, assign) BOOL isTouchResolved;
@property (nonatomic, assign) BOOL inUse;
//
@property (nonatomic, strong) UIImage *defaultUserIcon;
@property (nonatomic, strong) UIImage *imgFlagUp;
@property (nonatomic, strong) UIImage *imgFlagDown;

//Data:
@property(nonatomic, strong) SideMenuConfig *configuration;
@property(nonatomic, strong) SideMenuConfig *tempConfiguration;
@property(nonatomic, strong) NSDate *updateTimeControl;
//
@property(nonatomic, assign) CGPoint touchPoint;

//salva url do carrinho para posterior uso

@property(nonatomic, assign)NSUserDefaults  *itemCar;

@end

@implementation VC_SideMenu

#pragma mark - • SYNTESIZES

@synthesize vMenu, lblUserName, lblUserEmail, tvMenu, btBack, imvPhoto, imgFlagUp, imgFlagDown;
@synthesize optionsList, completeOptionsList, isTouchResolved, inUse, constraitLeftUserName, constraitLeftUserEmail, constraitMenu;
@synthesize configuration, tempConfiguration, defaultUserIcon, menuDelegate, updateTimeControl, touchPoint;

//@synthesize originalTouchPosition, isDraging, lastOffset;

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isTouchResolved = YES;
    inUse = NO;
    touchPoint = CGPointZero;
    
    self.view.backgroundColor = [UIColor clearColor];
	vMenu.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    btBack.backgroundColor = [UIColor blackColor];
    tvMenu.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal; //[UIColor whiteColor];
    //
    lblUserName.backgroundColor = [UIColor clearColor];
    lblUserName.textColor = AppD.styleManager.colorPalette.textNormal;
    lblUserName.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:32];
    //
    lblUserEmail.backgroundColor = [UIColor clearColor];
    lblUserEmail.textColor = AppD.styleManager.colorPalette.textNormal;
    lblUserEmail.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:14];
    //
    imvPhoto.backgroundColor = [UIColor clearColor];
    imvPhoto.contentMode = UIViewContentModeScaleAspectFill;
    imvPhoto.image = nil;
    imvPhoto.layer.cornerRadius = imvPhoto.frame.size.width / 2.0;
    imvPhoto.layer.borderColor = AppD.styleManager.colorPalette.textNormal.CGColor;
    imvPhoto.layer.borderWidth = 1.5;
    [imvPhoto.layer setMasksToBounds:YES];
    [imvPhoto setClipsToBounds:YES];
    //
    [btBack setTitle:@"" forState:UIControlStateNormal];
    [btBack setExclusiveTouch:YES];
	
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delaysTouchesBegan = NO;
    panGesture.delaysTouchesEnded = NO;
    [self.view addGestureRecognizer:panGesture];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPressGesture:)];
    longPress.minimumPressDuration = 2.0;
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = 10.0;
    longPress.delaysTouchesBegan = NO;
    longPress.delegate = self;
    [tvMenu addGestureRecognizer:longPress];
    
    //Shadow
    [ToolBox graphicHelper_ApplyShadowToView:vMenu withColor:[UIColor blackColor] offSet:CGSizeMake(3.0, 0.0) radius:5.0 opacity:0.5];
    
    defaultUserIcon = [[UIImage imageNamed:@"icon-user-default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgFlagUp = [[UIImage imageNamed:@"SideMenuArrowUP"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgFlagDown = [[UIImage imageNamed:@"SideMenuArrowDOWN"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    updateTimeControl = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //
    isTouchResolved = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [AppD statusBarStyleForViewController:self];
}

#pragma mark - • PUBLIC METHODS

- (void)show
{
    //[Answers logCustomEventWithName:@"Acesso a tela Menu Lateral" customAttributes:@{}];
   
    //Identificação do usuário =================================================================
    
    lblUserName.text = AppD.loggedUser.name;
    //NSLog(@"%@", AppD.loggedUser.name);
    
    if(![AppD.loggedUser.email isEqualToString:@""]){
        lblUserEmail.text = AppD.loggedUser.email;
    }else{
        lblUserEmail.text = @"";
    }
    
    if (configuration.showUserPhoto){
        if (AppD.loggedUser.profilePic){
            imvPhoto.image = AppD.loggedUser.profilePic;
            imvPhoto.tintColor = nil;
        }else{
            imvPhoto.image = defaultUserIcon;
            imvPhoto.tintColor = AppD.styleManager.colorPalette.textNormal;
        }
        [imvPhoto setHidden:NO];
        constraitLeftUserName.constant = 70.0;
        constraitLeftUserEmail.constant = 70.0;
    }else{
        imvPhoto.image = nil;
        [imvPhoto setHidden:YES];
        constraitLeftUserName.constant = 10.0;
        constraitLeftUserEmail.constant = 10.0;
    }
    
    [self.view layoutIfNeeded];

    //Opções do Menu =================================================================
    
    [tvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [tvMenu reloadData];
    
    //Layout e Animação =================================================================
    btBack.alpha = 0.0;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    constraitMenu.constant = - vMenu.frame.size.width;
    [self.view layoutIfNeeded];
    constraitMenu.constant = 0;
    //
    UIViewController *vc = [AppD.rootViewController.navigationController.viewControllers lastObject];
    [vc.view endEditing:YES];
    //
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        btBack.alpha = 0.6;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        inUse = YES;
        
        //DidShow:
        if (menuDelegate){
            if ([menuDelegate respondsToSelector:@selector(sideMenuDidShow:)]){
                [menuDelegate sideMenuDidShow:self];
            }
        }
    }];
}

- (void)registerConfiguration:(SideMenuConfig*)config
{
    self.configuration = [config copyObject];
    
    optionsList = [NSMutableArray new];
    completeOptionsList = [NSMutableArray new];
    
    BOOL enableChat = NO;
    
    for (SideMenuItem *item in self.configuration.items) {
        
        SideMenuItem *copyItem = [item copyObject];
        
        copyItem.uiControlState = SideMenuItemControlState_Compressed;
        copyItem.uiControlOptionLevel = 0;
        copyItem.uiControlGroupIdentifier = [NSString stringWithFormat:@"GROUP_%i", copyItem.itemInternalCode];
        
        [optionsList addObject:copyItem];
        
        SideMenuItem *originalCopyItem = [item copyObject];
        [completeOptionsList addObject:originalCopyItem];
        for (SideMenuItem *subItem in originalCopyItem.subItems){
            [completeOptionsList addObject:subItem];
        }
        
        //Controle para a exibição de componentes de interface para chat:
        if (item.itemInternalCode == SideMenuItemCode_Chat){
            enableChat = YES;
        }
    }
    
    AppD.chatInteractionEnabled = enableChat;
    
    //Menus protótipo.
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    if ([appID isEqualToString:@"1000012"]){
        [self insertPrototypeMenus];
    }
    
}

- (void)updateConfigurationsFromServer
{
    AppConfigDataSource *configDS = [AppConfigDataSource new];
    
    [configDS getSideMenuConfigurationFromServerWithCompletionHandler:^(SideMenuConfig * _Nullable data, DataSourceResponse * _Nonnull response) {
        
        if (response.status == DataSourceResponseStatusSuccess) {
            
            if (inUse) {
                tempConfiguration = data;
            }else{
                [self registerConfiguration:data];
            }
            
        }else{
            NSLog(@"SideMenuVC >> updateConfigurationsFromServer >> Error >> %@", response.message);
        }
        
    }];
}

- (void)createBarButtonsForRegisteredConfiguration
{
    if (completeOptionsList.count == 0){
        
        //Nenhum item necessário:
        if ([self.menuDelegate respondsToSelector:@selector(sideMenu:barButtonsForRegisteredConfiguration:)]){
            [self.menuDelegate sideMenu:self barButtonsForRegisteredConfiguration:[NSArray new]];
        }
        
    }else{
        
        dispatch_group_t serviceGroup = dispatch_group_create();
        
        for (NSInteger i=0; i<completeOptionsList.count; i++){
            
            SideMenuItem *item = [completeOptionsList objectAtIndex:i];
            
            if (item.icon == nil || item.iconDataGIF == nil){
                
                dispatch_group_enter(serviceGroup);
                [[[AsyncImageDownloader alloc] initWithFileURL:item.iconURL successBlock:^(NSData *data) {
                    
                    if (data != nil){
                        if ([item.iconURL hasSuffix:@"GIF"] || [item.iconURL hasSuffix:@"gif"]) {
                            item.iconDataGIF = [NSData dataWithData:data];
                            item.icon = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                        }else{
                            item.icon = [UIImage imageWithData:data];
                        }
                    }else{
                        item.icon = [item defaultImageForCode:item.itemInternalCode];
                    }
                    
                    dispatch_group_leave(serviceGroup);
                } failBlock:^(NSError *error) {
                    dispatch_group_leave(serviceGroup);
                }] startDownload];
                
            }
            
        }
        
        dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
            
            NSMutableArray *buttons = [NSMutableArray new];
            
            int usableItems = 0;
            
            for (NSInteger i=0; i<completeOptionsList.count; i++){
                SideMenuItem *item = [completeOptionsList objectAtIndex:i];
                if (usableItems < 5){
                    if (item.showShortcut){

                        if (usableItems != 0){
                            [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
                        }
                        //
                        UIBarButtonItem *b = [self createBarButtonWithTag:item.itemInternalCode andIcon:item.icon];
                        [buttons addObject:b];
                        //
                        usableItems += 1;
                    }
                }else{
                    break;
                }
            }
            
            if (usableItems > 0){
                if ([self.menuDelegate respondsToSelector:@selector(sideMenu:barButtonsForRegisteredConfiguration:)]){
                    [self.menuDelegate sideMenu:self barButtonsForRegisteredConfiguration:buttons];
                }
            }else{
                if ([self.menuDelegate respondsToSelector:@selector(sideMenu:barButtonsForRegisteredConfiguration:)]){
                    [self.menuDelegate sideMenu:self barButtonsForRegisteredConfiguration:[NSArray new]];
                }
            }
            
        });
    }
}

- (UIBarButtonItem*)createBarButtonWithTag:(NSInteger)tag andIcon:(UIImage*)icon
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeSystem];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [userButton setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)];
    //
    [userButton setImage:icon forState:UIControlStateNormal];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    //
    [userButton setFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton addTarget:self action:@selector(actionBarButton:) forControlEvents:UIControlEventTouchUpInside];
    userButton.tag = tag;
    //
    [[userButton.widthAnchor constraintEqualToConstant:44.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}



#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//MARK: UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (configuration) {
        if (configuration.showAppVersionInFooter) {
            return 2;
        }else{
            return 1;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"CellIdentifierOption";
    
    //Célula para itens normais da listagem
    TVC_SideMenuItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    
    if(cell == nil){
        cell = [[TVC_SideMenuItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    cell.backgroundView.tag = indexPath.row;
    
    SideMenuItem *item = [optionsList objectAtIndex:indexPath.row];
    
    if([item.itemName isEqualToString:@"Carrinho"]){
        
        // NSLog(@" valor do item %@",optionsList[indexPath.row]);
        NSLog(@" valor do item %@",item.webPageURL);
      
        NSUserDefaults *carrinhoTemp = [NSUserDefaults standardUserDefaults];
        [carrinhoTemp setValue:item.webPageURL  forKey:@"CarrinhoURL"];
        [carrinhoTemp synchronize];
   
        NSUserDefaults *recover = [NSUserDefaults standardUserDefaults];
        NSString *carrinhoURL = [recover valueForKey:@"CarrinhoURL"];
        NSLog(@" valor da url do carrinho %@",carrinhoURL);
    }
    
    if (item.uiControlOptionLevel == 0) {
        
        //root item:
        if (configuration.showIcons) {
            
            if (item.iconDataGIF != nil){
                item.icon = [UIImage animatedImageWithAnimatedGIFData:item.iconDataGIF];
            }
            if(item.itemName){
                
                
            }

            if (item.icon != nil) {
                [cell updateLayoutWithImage:item.icon highlighted:item.highlighted];
            }else{
                
                if ([ToolBox textHelper_CheckRelevantContentInString:item.iconURL]){
                    [cell updateLayoutWithImage:[item defaultImageForCode:item.itemInternalCode] highlighted:item.highlighted];
                    [self loadImageForIndex:indexPath.row];
                }else{
                    item.icon = [item defaultImageForCode:item.itemInternalCode];
                    [cell updateLayoutWithImage:item.icon highlighted:item.highlighted];
                }
                
                //NOTE: marcado para deleção
                //[cell updateLayoutWithImage:[item defaultImageForCode:item.itemInternalCode] highlighted:item.highlighted];
                //[self loadImageForIndex:indexPath.row];
            }
            
        }else{
            [cell updateLayoutWithImage:nil highlighted:item.highlighted];
        }
        
        if (item.subItems.count > 0) {
            
            if (item.uiControlState == SideMenuItemControlState_Compressed) {
                cell.imvFlag.image = imgFlagDown;
            }else{
                cell.imvFlag.image = imgFlagUp;
            }
            
            [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                cell.imvFlag.alpha = 1.0;
            }];
        }else{
            cell.imvFlag.image = nil;
        }
        
        cell.lblItem.attributedText = nil;
        cell.lblItem.text = item.itemName;
        
    } else {
        
        //somente o root item mostra ícones:
        
        [cell updateLayoutWithImage:nil highlighted:item.highlighted];
        
        cell.imvFlag.image = nil;
        
        cell.lblItem.text = nil;
        //Usar este:
        //cell.lblItem.attributedText = [self applyStyleForSubItem:item.itemName];
        //Ou estes:
        cell.lblItem.text = [NSString stringWithFormat:@"    %@", item.itemName];
        cell.lblItem.textColor = [UIColor grayColor];
    }

    //controle do shortcut
    if (item.showShortcut){
        [cell.imvShortcut setHidden:NO];
    }
    
    //A preferência do 'badge' é da configuração do servidor (valor fixo). Somente se ela não existir usamos a dinâmica.
    if (item.badgeCount == 0) {
        if (self.menuDelegate){
            int badge = [self.menuDelegate sideMenu:self dynamicBadgeValueForItem:[item copyObject]];
            if (badge <= 0){
                [cell.lblBadge setHidden:YES];
            }else{
                cell.lblBadge.text = [NSString stringWithFormat:@"%i", badge];
                [cell.lblBadge setHidden:NO];
            }
        }else{
            [cell.lblBadge setHidden:YES];
        }
    }else{
        cell.lblBadge.text = [NSString stringWithFormat:@"%i", item.badgeCount];
        [cell.lblBadge setHidden:NO];
    }
    
    //Destaque para céluas protótipo:
    if (item.itemInternalCode == SideMenuItemCode_Prototype) {
        cell.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    }
    
    cell.lblFeature.text = [item.featuredMessage uppercaseString];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //O toque na célula é tratado desta forma pois a animação e o processo a ser executado ocorrem na main thread, o que impede a execução da animação da forma correta.
    //Controlando por uma variável, impedimos que dois toques seguidos sejam iniciados.
    
    if (isTouchResolved)
    {
        isTouchResolved = false;
        
        TVC_SideMenuItem *cell = (TVC_SideMenuItem*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        cell.imvFlag.alpha = 0.0;
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion:nil];
        
        //Resolução da seleção
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_SUPER_FAST * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            SideMenuItem *currentItem = [optionsList objectAtIndex:indexPath.row];
            
            if (currentItem.blocked) {
                if ([ToolBox textHelper_CheckRelevantContentInString:currentItem.blockedMessage]) {
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showInfo:currentItem.itemName subTitle:currentItem.blockedMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    isTouchResolved = true;
                }
            } else {
                
                //Controle de subitens
                if (currentItem.subItems.count > 0) {
                   
                    
                    NSMutableArray<NSIndexPath*> *indexPathList = [NSMutableArray new];
                    //
                    if (currentItem.uiControlState == SideMenuItemControlState_Compressed) {
                        
                        //inserindo itens:
                        for (int i=0; i<currentItem.subItems.count; i++) {
                            SideMenuItem *subItem = [[currentItem.subItems objectAtIndex:i] copyObject];
                            subItem.uiControlOptionLevel = currentItem.uiControlOptionLevel + 1;
                            subItem.uiControlGroupIdentifier = [NSString stringWithFormat:@"GROUP_%i", currentItem.itemInternalCode];
                            [optionsList insertObject:subItem atIndex:(indexPath.row + (i + 1))];
                            [indexPathList addObject:[NSIndexPath indexPathForRow:(indexPath.row + (i + 1)) inSection:0]];
                        }
                        //
                        currentItem.uiControlState = SideMenuItemControlState_Expanded;
                        //
                        [tableView beginUpdates];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                        [tableView insertRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationBottom]; //UITableViewRowAnimationFade
                        [tableView endUpdates];
                        //
                        [tableView scrollToRowAtIndexPath:[indexPathList lastObject] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        
                    }else{
                        
                        //removendo itens
                        for (int i=0; i<currentItem.subItems.count; i++) {
                            [optionsList removeObjectAtIndex:(indexPath.row + 1)];
                            [indexPathList addObject:[NSIndexPath indexPathForRow:(indexPath.row + (i + 1)) inSection:0]];
                        }
                        //
                        currentItem.uiControlState = SideMenuItemControlState_Compressed;
                        //
                        [tableView beginUpdates];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                        [tableView deleteRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationBottom]; //UITableViewRowAnimationFade
                        [tableView endUpdates];
                        //
                        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    }
                    
                    isTouchResolved = true;
                    
                }else{
                    [self selectionResolverForIndex:indexPath.row completeSearch:NO];
                }
                
            }
            
        });
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return optionsList.count;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 36.0;
//        if (configuration.showAppVersionInFooter) {
//            return 36.0;
//        }else{
//            return 0.0;
//        }
    }else{
        return 0.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    
    if (configuration.showAppVersionInFooter) {
        [footerView setFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 36.0)];
        footerView.backgroundColor = [UIColor whiteColor];
        //
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, tableView.frame.size.width - 20.0, 36.0)];
        footerLabel.backgroundColor = [UIColor clearColor];
        footerLabel.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:14.0];
        [footerLabel setTextAlignment:NSTextAlignmentCenter];
        footerLabel.textColor = AppD.styleManager.colorPalette.backgroundNormal;
        //
        NSString *sei = [AppD serverEnvironmentIdentifier];
        footerLabel.text = [NSString stringWithFormat:@"%@: %@ %@", NSLocalizedString(@"LABEL_APP_VERSION", @""),[ToolBox applicationHelper_VersionBundle], sei];
        //
        [footerView addSubview:footerLabel];
    }
    
    return footerView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass: [UILongPressGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass: [UIScreenEdgePanGestureRecognizer class]]){
        return NO;
    }else if([gestureRecognizer isKindOfClass: [UIScreenEdgePanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass: [UILongPressGestureRecognizer class]]){
        return NO;
    }
    
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    return YES;
//}

#pragma mark - • ACTION METHODS

- (void)actionPanGesture:(UIPanGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            touchPoint = [gesture locationInView:self.view];
        }break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint actualTouchPoint = [gesture locationInView:self.view];
            CGFloat offSet = actualTouchPoint.x - touchPoint.x;
            
            vMenu.frame = CGRectMake((offSet > 0.0 ? 0.0 : offSet), 0.0, vMenu.frame.size.width, vMenu.frame.size.height);
            //
            CGFloat alpha = ((offSet > 0.0 ? 0.0 : offSet) / -(vMenu.frame.size.width));
            alpha = alpha < 0.0 ? 0.0 : (alpha > 1.0 ? 1.0 : alpha);
            btBack.alpha = 0.6 - (0.6 * alpha);
        }break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            if ((vMenu.frame.origin.x < -(vMenu.frame.size.width / 2.0)) || ([gesture velocityInView:self.view].x < -1200)){
                [self hide:nil];
            }else{
                [UIView animateKeyframesWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    vMenu.frame = CGRectMake(0.0, 0.0, vMenu.frame.size.width, vMenu.frame.size.height);
                    btBack.alpha = 0.6;
                } completion:nil];
            }
        }break;
            
        default:
            return;
            break;
    }
}

- (void)actionLongPressGesture:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan){
        
        CGPoint p = [gesture locationInView:tvMenu];
        
        NSIndexPath *indexPath = [tvMenu indexPathForRowAtPoint:p];
        if (indexPath != nil) {
            
            SideMenuItem *item = [optionsList objectAtIndex:indexPath.row];
            NSLog(@"valor do array para pegar o item do carrinho %@",item.itemName);
            if (!item.blocked && item.subItems.count == 0 && item.itemInternalCode != SideMenuItemCode_Home) {
                
                if (tvMenu.tag == 0){
                    
                    tvMenu.tag = 1;
                    TVC_SideMenuItem *cell = (TVC_SideMenuItem*)[tvMenu cellForRowAtIndexPath:indexPath];
                    __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
                    [cell setBackgroundColor:COLOR_MA_RED];
                    
                    [UIView animateWithDuration:ANIMA_TIME_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
                        [cell setBackgroundColor:originalBColor];
                    } completion:^(BOOL finished){
                        tvMenu.tag = 0;
                        
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        
                        if (item.showShortcut){
                            
                            [alert addButton:@"Remover Atalho" withType:SCLAlertButtonType_Destructive actionBlock:^{
                                item.showShortcut = !item.showShortcut;
                                [self changeShortcutStatusForItemCode:item.itemInternalCode];
                                [cell.imvShortcut setHidden:YES];
                            }];
                            [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
                            [alert showQuestion:@"Atalho" subTitle:[NSString stringWithFormat:@"O atalho para o item '%@' já está definido.\nDeseja removê-lo do menu principal?", item.itemName] closeButtonTitle:nil duration:0.0];
                            
                        }else{
                            
                            if ([self countNumberOfActualShortcuts] < 5){
                                [alert addButton:@"Definir Atalho" withType:SCLAlertButtonType_Question actionBlock:^{
                                    item.showShortcut = !item.showShortcut;
                                    [self changeShortcutStatusForItemCode:item.itemInternalCode];
                                    [cell.imvShortcut setHidden:NO];
                                }];
                                [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
                                [alert showQuestion:@"Atalho" subTitle:[NSString stringWithFormat:@"Deseja inserir um atalho para o item '%@' no menu principal?\n\nAté 5 atalhos podem estar ativos ao mesmo tempo.", item.itemName] closeButtonTitle:nil duration:0.0];
                            }
                            
                        }
                    }];
                }
                
            }
            
        }
    }
}

- (void)actionBarButton:(UIButton*)sender
{
    NSInteger index = -1;
    
    for (NSInteger i = 0; i < completeOptionsList.count; i++){
        SideMenuItem *item = [completeOptionsList objectAtIndex:i];
        if (item.itemInternalCode == sender.tag){
            index = i;
            break;
        }
    }
    
    if (index != -1){
        [self selectionResolverForIndex:index completeSearch:YES];
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (IBAction)hide:(id)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        vMenu.frame = CGRectMake(-vMenu.frame.size.width, 0, vMenu.frame.size.width, vMenu.frame.size.height);
        //btBack.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, btBack.frame.size.height);
        btBack.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        inUse = NO;
        //
        if (tempConfiguration) {
            [self registerConfiguration:tempConfiguration];
            tempConfiguration = nil;
        }else{
        
            //Comprime items expandidos
            NSMutableArray *itemsToRemove = [NSMutableArray new];
            for (SideMenuItem *currentItem in optionsList) {
                currentItem.uiControlState = SideMenuItemControlState_Compressed;
                //
                if (currentItem.uiControlOptionLevel != 0){
                    [itemsToRemove addObject:currentItem];
                }
            }
            [optionsList removeObjectsInArray:itemsToRemove];
            
            //Controle de atualização do menu:
            NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMinute fromDate:updateTimeControl toDate:[NSDate date] options:0];
            if ([components minute] > 60) {
                updateTimeControl = [NSDate date];
                [self updateConfigurationsFromServer];
            }
        }
        
        //DidHide:
        if (menuDelegate){
            if ([menuDelegate respondsToSelector:@selector(sideMenuDidHide:)]){
                [menuDelegate sideMenuDidHide:self];
            }
        }
        
    }];
}

- (void)selectionResolverForIndex:(long)index completeSearch:(BOOL)completeSearch
{
    bool hideNow = true;

    SideMenuItem *currentItem = nil;
    if (completeSearch){
        currentItem = [completeOptionsList objectAtIndex:index];
    }else{
        currentItem = [optionsList objectAtIndex:index];
    }

    switch (currentItem.itemInternalCode) {
            
        //******************************************************************************************
        case SideMenuItemCode_Prototype:
        {
            //Não possui tela específica. Verificar o campo 'prototypeID' para identificar a tela destino.
            //Esta tela deve ser para fins de DEBUG e nunca estar disponível na versão de produção.
            
            //Animation Layer
            /*
            if (currentItem.prototypeID == 1) {
                //Instanciando a nova view destino
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Prototype" bundle:[NSBundle mainBundle]];
                AnimaLayerVC *vcH = [storyboard instantiateViewControllerWithIdentifier:@"AnimaLayerVC"];
                vcH.showAppMenu = !configuration.showReturnButtonInRootMenus;
                [vcH awakeFromNib];
                //
                UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                //Abrindo a tela
                [AppD.rootViewController.navigationController pushViewController:vcH animated:YES];
                
                //Readaptando a lista de controllers:
                NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
                NSMutableArray *listaF = [NSMutableArray new];
                [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
                [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
                [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
                [listaF addObject:vcH];
                
                //Carregando dados
                AppD.rootViewController.navigationController.viewControllers = listaF;
            }
            */
            
            //Horus - 3D Viewer
            if (currentItem.prototypeID == 2) {
                //Instanciando a nova view destino
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Prototype" bundle:[NSBundle mainBundle]];
                Horus3DViewerVC *vcH = [storyboard instantiateViewControllerWithIdentifier:@"Horus3DViewerVC"];
                vcH.showAppMenu = !configuration.showReturnButtonInRootMenus;
                [vcH awakeFromNib];
                //
                UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                //Abrindo a tela
                [AppD.rootViewController.navigationController pushViewController:vcH animated:YES];

                //Readaptando a lista de controllers:
                NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
                NSMutableArray *listaF = [NSMutableArray new];
                [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
                [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
                [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
                [listaF addObject:vcH];

                //Carregando dados
                AppD.rootViewController.navigationController.viewControllers = listaF;
            }
            
        }break;
         
        //******************************************************************************************
        case SideMenuItemCode_Home:{
        
            //Retorna para a timeline (o viewController 2 será sempre a timeline)
            NSArray *array = [AppD.rootViewController.navigationController viewControllers];
            [AppD.rootViewController.navigationController popToViewController:[array objectAtIndex:2] animated:YES];
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Profile:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserProfile" bundle:[NSBundle mainBundle]];
            VC_GenericUserProfile *vcGUP = [storyboard instantiateViewControllerWithIdentifier:@"VC_GenericUserProfile"];
            vcGUP.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcGUP awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcGUP animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcGUP];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Events:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Events" bundle:[NSBundle mainBundle]];
            VC_Events *vcEvents = [storyboard instantiateViewControllerWithIdentifier:@"VC_Events"];
            vcEvents.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcEvents awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcEvents animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcEvents];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Agenda:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Events" bundle:[NSBundle mainBundle]];
            VC_MyEvents *vcEvents = [storyboard instantiateViewControllerWithIdentifier:@"VC_MyEvents"];
            vcEvents.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcEvents awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcEvents animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcEvents];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Documents:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
            VC_Category *vcDownloads = [storyboard instantiateViewControllerWithIdentifier:@"VC_Category"];
            vcDownloads.showAppMenu = !configuration.showReturnButtonInRootMenus;
            vcDownloads.categoryType = eCategoryType_Document;
            [vcDownloads awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcDownloads animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcDownloads];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Chat:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
            VC_ContactsChat *vcGroupChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_ContactsChat"];
            vcGroupChat.isMenuSelection = YES;
            vcGroupChat.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcGroupChat awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcGroupChat animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcGroupChat];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Sponsor:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            VC_Sponsor *vcSponsor = [storyboard instantiateViewControllerWithIdentifier:@"VC_Sponsor"];
            vcSponsor.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcSponsor awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcSponsor animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcSponsor];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Videos:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
            VC_Category *vcVideoList = [storyboard instantiateViewControllerWithIdentifier:@"VC_Category"];
            vcVideoList.showAppMenu = !configuration.showReturnButtonInRootMenus;
            vcVideoList.categoryType = eCategoryType_Video;
            [vcVideoList awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcVideoList animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcVideoList];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_BeaconShowroom:{
            
            //Beacon (Estimote) Showroom
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BeaconShowroom" bundle:[NSBundle mainBundle]];
            BeaconShowroomMainVC *vcBS = [storyboard instantiateViewControllerWithIdentifier:@"BeaconShowroomMainVC"];
            vcBS.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcBS awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcBS animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcBS];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Questionnaire:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CustomSurvey" bundle:[NSBundle mainBundle]];
            CustomSurveyAvailableSamplesVC *csVC = [storyboard instantiateViewControllerWithIdentifier:@"CustomSurveyAvailableSamplesVC"];
            csVC.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [csVC awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:csVC animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:csVC];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
            //******************************************************************************************
        case SideMenuItemCode_QuestionnaireSearch:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CustomSurvey" bundle:[NSBundle mainBundle]];
            QuestionnaireSearchVC *csVC = [storyboard instantiateViewControllerWithIdentifier:@"QuestionnaireSearchVC"];
            csVC.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [csVC awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:csVC animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:csVC];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_ScannerAdAlive:{
            
            hideNow = false;
            [self resolveScannerPermitions];
            
        }break;
           
        //******************************************************************************************
        case SideMenuItemCode_ScannerAdAliveHistory:{
            
            //Histórico da Camera
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ScannerAdAliveHistoryVC *vcSH = [storyboard instantiateViewControllerWithIdentifier:@"ScannerAdAliveHistoryVC"];
            vcSH.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcSH awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcSH animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcSH];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_GiftCard:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DigitalCard" bundle:[NSBundle mainBundle]];
            DigitalCardMainVC *vcDigitalCard = [storyboard instantiateViewControllerWithIdentifier:@"DigitalCardMainVC"];
            vcDigitalCard.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcDigitalCard awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcDigitalCard animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcDigitalCard];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_VirtualShowcase:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Showcase" bundle:[NSBundle mainBundle]];
            VirtualShowcaseMainVC *vcShowcase = [storyboard instantiateViewControllerWithIdentifier:@"VirtualShowcaseMainVC"];
            vcShowcase.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcShowcase awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcShowcase animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcShowcase];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Showcase360:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Viewers" bundle:[NSBundle mainBundle]];
            Viewer360MainVC *vcViewer = [storyboard instantiateViewControllerWithIdentifier:@"Viewer360MainVC"];
            vcViewer.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcViewer awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcViewer animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcViewer];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_PromotionalCardScratch:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PromotionalCard" bundle:[NSBundle mainBundle]];
            PromotionalCardMainVC *vcPC = [storyboard instantiateViewControllerWithIdentifier:@"PromotionalCardMainVC"];
            vcPC.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcPC awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcPC animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcPC];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_WebPage:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WebView" bundle:[NSBundle mainBundle]];
            VC_WebViewCustom *vcWV = [storyboard instantiateViewControllerWithIdentifier:@"WKWebViewVC"];
            vcWV.fileURL = currentItem.webPageURL;
            vcWV.titleNav = currentItem.itemName;
            vcWV.hideViewButtons = !currentItem.webShowControls;
            vcWV.showShareButton = currentItem.webShowShareButton;
            vcWV.checkUrl = currentItem.webNeedCheckUrl;
            //
            [vcWV awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcWV animated:YES];
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcWV];
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Utilities:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Utilities" bundle:[NSBundle mainBundle]];
            UtilitiesMainVC *vcU = [storyboard instantiateViewControllerWithIdentifier:@"UtilitiesMainVC"];
            vcU.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcU awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcU animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcU];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Options:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AppOptions" bundle:[NSBundle mainBundle]];
            AppOptionsVC *vcOPT = [storyboard instantiateViewControllerWithIdentifier:@"AppOptionsVC"];
            vcOPT.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcOPT awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcOPT animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcOPT];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_About:{
            
            //Instanciando a nova view destino
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            VC_WebAbout *vcA = [storyboard instantiateViewControllerWithIdentifier:@"VC_WebAbout"];
            vcA.showAppMenu = !configuration.showReturnButtonInRootMenus;
            [vcA awakeFromNib];
            //
            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
            //
            //Abrindo a tela
            [AppD.rootViewController.navigationController pushViewController:vcA animated:YES];
            
            //Readaptando a lista de controllers:
            NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
            NSMutableArray *listaF = [NSMutableArray new];
            [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
            [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
            [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
            [listaF addObject:vcA];
            
            //Carregando dados
            AppD.rootViewController.navigationController.viewControllers = listaF;
            
        }break;
            
        //******************************************************************************************
        case SideMenuItemCode_Exit:{
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:NSLocalizedString(@"ALERT_TITLE_LOGOUT", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
                //PushNotification - Firebase
                [AppD removeForRemoteNotifications];
                //
                [AppD registerLogoutForCurrentUser];
                [AppD.rootViewController.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
            [alert showQuestion:NSLocalizedString(@"ALERT_TITLE_LOGOUT", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_LOGOUT", @"") closeButtonTitle:nil duration:0.0];
            
        }break;
            
        case SideMenuItemCode_MenuGroup: {
            //O tipo 'MenuGroup' nunca é executado na prática pois apenas abre/fecha submenus.
            break;
        }
    }

    if (hideNow){
        [self hide:nil];
    }
}

- (void)resolveScannerPermitions
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
		
        //Segue para o leitor normalmente
        [self hide:nil];
        [self segueToScanner];
		
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
		
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self hide:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
            isTouchResolved = YES;
        }];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CAMERA_SCANNER_PERMISSION", "") closeButtonTitle:nil duration:0.0];
		
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
		
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
				dispatch_async(dispatch_get_main_queue(), ^{
                    [self hide:nil];
                    [self segueToScanner];
                });
            }
            isTouchResolved = YES;
        }];
    }
}

- (void)segueToScanner
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VC_CameraAdAlive *vcScanner = [storyboard instantiateViewControllerWithIdentifier:@"VC_CameraAdAlive"];
    vcScanner.showAppMenu = !configuration.showReturnButtonInRootMenus;
    vcScanner.showVideoShareButton = YES;
    [vcScanner awakeFromNib];
    //
    UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
    topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    //Abrindo a tela
    [AppD.rootViewController.navigationController pushViewController:vcScanner animated:YES];
    //Readaptando a lista de controllers:
    NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
    NSMutableArray *listaF = [NSMutableArray new];
    [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
    [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
    [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
    [listaF addObject:vcScanner];
    //Carregando dados
    AppD.rootViewController.navigationController.viewControllers = listaF;
    
}

- (void)loadImageForIndex:(long)index
{
    __block SideMenuItem *itemBlock = [optionsList objectAtIndex:index];

    [[[AsyncImageDownloader alloc] initWithFileURL:itemBlock.iconURL successBlock:^(NSData *data) {
        if (data != nil){
            if ([itemBlock.iconURL hasSuffix:@"GIF"] || [itemBlock.iconURL hasSuffix:@"gif"]) {
                itemBlock.iconDataGIF = [NSData dataWithData:data];
                itemBlock.icon = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
            }else{
                itemBlock.icon = [UIImage imageWithData:data];
            }
        }else{
            itemBlock.icon = [itemBlock defaultImageForCode:itemBlock.itemInternalCode];
        }
        [tvMenu reloadData];
    } failBlock:^(NSError *error) {
        itemBlock.icon = [itemBlock defaultImageForCode:itemBlock.itemInternalCode];
        [tvMenu reloadData];
    }] startDownload];
}

-(void) changeShortcutStatusForItemCode:(NSInteger)itemCode
{
    for (SideMenuItem *completeItem in completeOptionsList){
        if (completeItem.itemInternalCode == itemCode){
            completeItem.showShortcut = !completeItem.showShortcut;
            //
            //save
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:completeItem.showShortcut forKey:[NSString stringWithFormat:@"SideMenuShortcutForItem%uUser%i", completeItem.itemInternalCode, AppD.loggedUser.userID]];
            [userDefaults synchronize];
            //
            break;
        }
    }
    
    [self createBarButtonsForRegisteredConfiguration];
}

-(int)countNumberOfActualShortcuts
{
    int qtd = 0;
    for (SideMenuItem *item in completeOptionsList){
        if (item.showShortcut){
            qtd += 1;
        }
    }
    return qtd;
}

//NOTE: marcado para deleção
//- (void)loadImageForIndex:(long)index
//{
//    SideMenuItem *item = [optionsList objectAtIndex:index];
//
//    if (item.iconURL != nil && ![item.iconURL isEqualToString:@""]) {
//
//        [[[AsyncImageDownloader alloc] initWithFileURL:item.iconURL successBlock:^(NSData *data) {
//            SideMenuItem *itemBlock = [optionsList objectAtIndex:index];
//            if (data != nil){
//
//                //itemBlock.icon = [UIImage imageWithData:data];
//
//                if ([itemBlock.iconURL hasSuffix:@"GIF"] || [itemBlock.iconURL hasSuffix:@"gif"]) {
//                    itemBlock.iconDataGIF = [NSData dataWithData:data];
//                    itemBlock.icon = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
//                }else{
//                    itemBlock.icon = [UIImage imageWithData:data];
//                }
//
//            }else{
//                itemBlock.icon = [itemBlock defaultImageForCode:itemBlock.itemInternalCode];
//            }
//            [tvMenu reloadData];
//        } failBlock:^(NSError *error) {
//            SideMenuItem *itemBlock = [optionsList objectAtIndex:index];
//            itemBlock.icon = [itemBlock defaultImageForCode:itemBlock.itemInternalCode];
//            [tvMenu reloadData];
//        }] startDownload];
//
//    }
//
//}

#pragma mark -

- (void)createCompleteMenu
{
    //MENU:
    
    SideMenuConfig *config = [SideMenuConfig new];
    config.showIcons = YES;
    config.showUserPhoto = YES;
    config.showReturnButtonInRootMenus = YES;
    config.showAppVersionInFooter = YES;
    
    //ITEMS:
    
    //Home
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Início";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"HOME";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Profile
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Meus Dados";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"PROFILE";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Events
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Eventos";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"EVENTS";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Agenda
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Minha Agenda";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"AGENDA";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Documents
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Documentos";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"DOCUMENTS";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Chat
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Chat";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"CHAT";
        item.itemInternalCode = [item codeForString:item.itemID];
        //item.icon = [item defaultImageForCode:item.itemInternalCode];
        item.iconURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/menuimages/SideMenuItemIconChat%403x.gif";
        //
        [config.items addObject:item];
    }
    
    //Sponsor
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Patrocinadores";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"SPONSOR";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Videos
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Vídeos";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"VIDEOS";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Beacon Showroom
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Beacon Showroom";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"BEACONSHOWROOM";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Scanner AdAlive - GROUP
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Scanner AdAlive";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"MENUGROUP";
        item.itemInternalCode = [item codeForString:item.itemID];
        //item.icon = [item defaultImageForCode:item.itemInternalCode];
        item.iconURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/menuimages/SideMenuItemIconScanner%403x.png";

        //Scanner AdAlive
        SideMenuItem *item2 = [SideMenuItem new];
        item2.itemName = @"Escanear Imagem";
        item2.itemType = SideMenuItemType_App;
        item2.itemID = @"SCANNER";
        item2.itemInternalCode = [item2 codeForString:item2.itemID];
        item2.icon = [item2 defaultImageForCode:item2.itemInternalCode];
        //
        [item.subItems addObject:item2];
        
        //Scanner AdAlive - History
        SideMenuItem *item3 = [SideMenuItem new];
        item3.itemName = @"Ver Histórico";
        item3.itemType = SideMenuItemType_App;
        item3.itemID = @"SCANNERHISTORY";
        item3.itemInternalCode = [item3 codeForString:item3.itemID];
        item3.icon = [item3 defaultImageForCode:item3.itemInternalCode];
        //
        [item.subItems addObject:item3];
        
        [config.items addObject:item];
    }
    
    //Giftcard
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Cartão Presente";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"GIFTCARD";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Virtual Showcase
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Vitrine Virtual";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"VIRTUALSHOWCASE";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Vitrine 360
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Vitrine 360";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"SHOWCASE360";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Promotional Card
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Raspadinha Promocional";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"PROMOTIONALCARD";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Webpage
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Navegador";
        item.itemType = SideMenuItemType_Web;
        item.itemID = @"WEBPAGE";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        item.webPageURL = @"http://www.lab360.com.br";
        item.webShowControls = YES;
        item.webShowShareButton = YES;
        //
        [config.items addObject:item];
    }
    
    //Utilities
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Utilitários";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"UTILITIES";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    //Options
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Opções";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"OPTIONS";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Sobre";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"ABOUT";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"Sair";
        item.itemType = SideMenuItemType_App;
        item.itemID = @"EXIT";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [config.items addObject:item];
    }
    
    [self registerConfiguration:config];
    
    [tvMenu reloadData];
}

- (void) insertPrototypeMenus
{
    //Insira aqui menus extras que ficam visíveis independente do retorno do servidor.
    //Este menus são para telas em desenvolvimento ou funcionalidades específicas para o app LAB360.
    
    NSMutableArray *list = [NSMutableArray new];
        
    //ANIMA
//    {
//        SideMenuItem *item = [SideMenuItem new];
//        item.itemName = @"ANIMATION LAYER";
//        item.itemType = SideMenuItemType_App;
//        item.prototypeID = 1;
//        item.itemID = @"PROTOTYPE";
//        item.highlighted = YES;
//        item.featuredMessage = @"testing...";
//        item.itemInternalCode = [item codeForString:item.itemID];
//        item.icon = [item defaultImageForCode:item.itemInternalCode];
//        //
//        [list addObject:item];
//    }
    
    //HORUS
    {
        SideMenuItem *item = [SideMenuItem new];
        item.itemName = @"HORUS";
        item.itemType = SideMenuItemType_App;
        item.prototypeID = 2;
        item.itemID = @"PROTOTYPE";
        item.highlighted = YES;
        item.featuredMessage = @"3D Viewer (OBJ)";
        item.itemInternalCode = [item codeForString:item.itemID];
        item.icon = [item defaultImageForCode:item.itemInternalCode];
        //
        [list addObject:item];
    }
    
    if (list.count > 0) {
        [optionsList addObjectsFromArray:list];
    }
}

- (NSAttributedString*)applyStyleForSubItem:(NSString*)subText
{
    UIFont *fontText = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    //
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [ToolBox graphicHelper_ImageWithTintColor:[UIColor lightGrayColor] andImageTemplate:[UIImage imageNamed:@"icon-dot"]];
    attachment.bounds = CGRectMake(0, -5, attachment.image.size.width, attachment.image.size.height);
    //
    NSDictionary *textAttributes = @{NSFontAttributeName:fontText, NSForegroundColorAttributeName:[UIColor grayColor]};
    //
    NSAttributedString *text0 = [[NSAttributedString alloc] initWithString:@"   " attributes:textAttributes];
    NSAttributedString *text1 = [NSAttributedString attributedStringWithAttachment:attachment];
    NSAttributedString *text2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", subText] attributes:textAttributes];
    //
    NSMutableAttributedString *finalAttributedString = [NSMutableAttributedString new];
    [finalAttributedString appendAttributedString:text0];
    [finalAttributedString appendAttributedString:text1];
    [finalAttributedString appendAttributedString:text2];
    //
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [finalAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [finalAttributedString length])];
    //
    return finalAttributedString;
}

@end
