//
//  2DNavigatorVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "ZoneNavigatorVC.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "AsyncImageDownloader.h"
#import "ZoneActionInfoView.h"
#import "VIPhotoView.h"

#define ZONE_ACTION_BUTTON_DEFAULT_SIDE 40.0

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ZoneNavigatorVC()<ZoneActionInfoViewDelegate, UIScrollViewDelegate, VIPhotoViewDelegate>

//Data:
@property(nonatomic, assign) BOOL isLoaded;
@property(nonatomic, strong) NSMutableArray* actionButtonList;

//Layout:
@property(nonatomic, strong) UIImageView *mapView;
@property(nonatomic, strong) ZoneActionInfoView *infoView;
@property(nonatomic, weak) IBOutlet UIView *viewScrollBarIndicator;
@property(nonatomic, strong) UIView *viewScrollAreaIndicator;

@end

#pragma mark - • IMPLEMENTATION
@implementation ZoneNavigatorVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize currentZone, isLoaded, actionButtonList;
@synthesize mapView, infoView, viewScrollBarIndicator, viewScrollAreaIndicator;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoaded = NO;
    
    actionButtonList = [NSMutableArray new];
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
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isLoaded){
        
        [self createSampleZones];
        
        [self setupLayout:@"Zone Navigator"];
        
        isLoaded = YES;
        
        [self updateCurrentZone:currentZone];
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                self.navigationItem.rightBarButtonItem = [self createMapButton];
            }];
            [alert showSuccess:NSLocalizedString(@"ALERT_TITLE_ZONE_NAVIGATOR_TITLE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ZONE_NAVIGATOR_TITLE", @"") closeButtonTitle:nil duration:0.0];
        });
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionZone:(UIButton*)sender
{
    ZoneAction *action = nil;
    for (ZoneAction *a in currentZone.actions){
        if (a.actionID == sender.tag){
            action = a;
            break;
        }
    }
    
    if (action){
        if (action.type == ZoneActionTypeInfo){
            [self showInfoAction:action];
        }else{
            if (action.destinationZone){
                [self updateCurrentZone:action.destinationZone];
            }
        }
    }
}

- (IBAction)actionShowMapImage:(id)sender
{
    UIImage *map = [UIImage imageNamed:@"ZonaInterativaMapaExemplo.jpg"];
    //
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:map backgroundImage:nil andDelegate:self];
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

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//ZoneActionInfoViewDelegate
- (void)zoneActionInfoViewExecuteCloseAction:(ZoneActionInfoView *)infoView
{
    [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        infoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.scrollViewBackground setUserInteractionEnabled:YES];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat widthFactor = self.scrollViewBackground.frame.size.width / self.scrollViewBackground.contentSize.width;
    CGFloat areaWidth = viewScrollBarIndicator.frame.size.width * widthFactor;
    
    CGFloat offsetFactor = self.scrollViewBackground.contentOffset.x / self.scrollViewBackground.contentSize.width;
    CGFloat areaPosition = viewScrollBarIndicator.frame.size.width * offsetFactor;
    
    [viewScrollAreaIndicator setFrame:CGRectMake(areaPosition, 1.0, areaWidth, viewScrollBarIndicator.frame.size.height - 2.0)];
}

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

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    [super setupLayout:screenName];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.scrollViewBackground.backgroundColor = [UIColor blackColor];
    self.scrollViewBackground.delegate = self;
    
    mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    mapView.backgroundColor = [UIColor blackColor];
    [mapView setContentMode:UIViewContentModeScaleAspectFit];
    mapView.image = nil;
    
    [self.scrollViewBackground addSubview:mapView];
    
    infoView = [ZoneActionInfoView newZoneActionInfoViewWithFrame:CGRectMake(40.0, 40.0, self.view.frame.size.width - 80.0, self.view.frame.size.height - 80.0) andDelegate:self];
    infoView.alpha = 0.0;
    [self.view addSubview:infoView];
    
    viewScrollBarIndicator.backgroundColor = [UIColor blackColor];
    [viewScrollBarIndicator.layer setCornerRadius:viewScrollBarIndicator.frame.size.height / 2.0];
    viewScrollBarIndicator.alpha = 0.65;
    [viewScrollBarIndicator setClipsToBounds:YES];
    
    viewScrollAreaIndicator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, 10.0, (viewScrollBarIndicator.frame.size.height - 2.0))];
    viewScrollAreaIndicator.backgroundColor = [UIColor whiteColor];
    [viewScrollAreaIndicator.layer setCornerRadius:viewScrollAreaIndicator.frame.size.height / 2.0];
    [viewScrollBarIndicator addSubview:viewScrollAreaIndicator];
}

- (void)openNewZone:(NavigationZone*)destinationZone
{
    if (destinationZone.image){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Viewers" bundle:nil];
        ZoneNavigatorVC *zoneVC = (ZoneNavigatorVC *)[sb instantiateViewControllerWithIdentifier:@"ZoneNavigatorVC"];
        [zoneVC awakeFromNib];
        zoneVC.currentZone = destinationZone;
        //
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:zoneVC animated:YES];
        
    }else{
        
        [self showActivityIndicatorView];
        
        [[[AsyncImageDownloader alloc] initWithMediaURL:destinationZone.urlImage successBlock:^(UIImage *image) {
            
            if (image){
                destinationZone.image = image;
                [self openNewZone:destinationZone];
            }else{
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:NSLocalizedString(@"ALERT_TITLE_ZONE_NAVIGATOR_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ZONE_NAVIGATOR_ERROR_LOAD_MAP", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            [self hideActivityIndicatorView];
            
        } failBlock:^(NSError *error) {
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:NSLocalizedString(@"ALERT_TITLE_ZONE_NAVIGATOR_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ZONE_NAVIGATOR_ERROR_LOAD_MAP", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            //
            [self hideActivityIndicatorView];
            
        }] startDownload];
    }
}

- (void)updateMapView
{
    [UIView animateWithDuration:ANIMA_TIME_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.scrollViewBackground.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        CGFloat iRatio = currentZone.image.size.width / currentZone.image.size.height;
        CGFloat height = self.scrollViewBackground.frame.size.height;
        CGFloat width = iRatio * height;
        
        [mapView setFrame:CGRectMake(0.0, 0.0, width, height)];
        mapView.image = currentZone.image;
        
        [self.scrollViewBackground setContentSize:mapView.frame.size];
        [self.scrollViewBackground scrollRectToVisible:CGRectZero animated:NO];
        
        //Removendo botões de ação caso já existam:
        for (UIButton *button in actionButtonList){
            [button removeFromSuperview];
        }
        [actionButtonList removeAllObjects];
        
        //Criando as views das ações:
        for (ZoneAction *action in currentZone.actions){
            //Calculando a posição para os botões na view, conforme pontuado na imagem:
            CGFloat xFactor = action.positionInImage.x / currentZone.image.size.width;
            CGFloat yFactor = action.positionInImage.y / currentZone.image.size.height;
            action.positionInView = CGPointMake(mapView.frame.size.width * xFactor, mapView.frame.size.height * yFactor);
            //Criando o botão:
            UIButton *button = [action createFriendlyButtonWithSize:CGSizeMake(ZONE_ACTION_BUTTON_DEFAULT_SIDE, ZONE_ACTION_BUTTON_DEFAULT_SIDE)];
            [button addTarget:self action:@selector(actionZone:) forControlEvents:UIControlEventTouchUpInside];
            [actionButtonList addObject:button];
            //
            [self.scrollViewBackground addSubview:button];
        }
        
        CGFloat xFactor = currentZone.enterPosition.x / currentZone.image.size.width;
        CGFloat areaPosition = self.scrollViewBackground.contentSize.width * xFactor;
        CGRect areaVisible = CGRectMake((areaPosition - (self.scrollViewBackground.frame.size.width / 2.0)), 0.0, self.scrollViewBackground.frame.size.width, self.scrollViewBackground.frame.size.height);
        
        [self.scrollViewBackground scrollRectToVisible:areaVisible animated:NO];

        self.scrollViewBackground.alpha = 1.0;
        //[self scrollViewDidScroll:self.scrollViewBackground];
    }];
    
}

- (void)showInfoAction:(ZoneAction*)infoAction
{
    [self.scrollViewBackground setUserInteractionEnabled:NO];
    
    [infoView updateContentToZoneAction:infoAction];
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        infoView.alpha = 1.0;
    } completion:nil];
    
}

- (void)updateCurrentZone:(NavigationZone*)newZone
{
    currentZone = newZone; //[newZone copyObject];
    
    NSString *str = @"???";
    if (currentZone && currentZone.name){
        str = currentZone.name;
    }
    self.navigationItem.title = str;
    
    [self updateMapView];
}

- (UIBarButtonItem*)createMapButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"ZoneActionMap"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionShowMapImage:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

#pragma mark - Sample Zones

- (void)createSampleZones
{
    //*************************************************************************
    NavigationZone *zone1 = [NavigationZone new];
    zone1.zoneID = 1;
    zone1.name = @"Area Dev";
    zone1.image = [UIImage imageNamed:@"zone-action-area1.jpg"];
    zone1.urlImage = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area1.jpg";
    zone1.enterPosition = CGPointMake(919.0, 350.0);
    //
    NavigationZone *zone2 = [NavigationZone new];
    zone2.zoneID = 2;
    zone2.name = @"Area Copa";
    zone2.image = [UIImage imageNamed:@"zone-action-area2.jpg"];
    zone2.urlImage = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area2.jpg";
    zone2.enterPosition = CGPointMake(5652.0, 885.0);
    
    //*************************************************************************
    ZoneAction *zAction1 = [ZoneAction new];
    zAction1.actionID = 1;
    zAction1.positionInImage = CGPointMake(266.0, 447.0);
    zAction1.positionInView = CGPointZero;
    zAction1.type = ZoneActionTypeInfo;
    zAction1.infoTitle = @"Parede Branca";
    zAction1.infoMessage = @"Esta é uma linda parede branca. Apenas isso.";
    zAction1.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area1-info1.jpg";
    zAction1.infoImage = nil;
    zAction1.orientation = ZoneActionOrientation_N;
    zAction1.destinationZone = nil;
    
    ZoneAction *zAction2 = [ZoneAction new];
    zAction2.actionID = 2;
    zAction2.positionInImage = CGPointMake(919.0, 350.0);
    zAction2.positionInView = CGPointZero;
    zAction2.type = ZoneActionTypeInfo;
    zAction2.infoTitle = @"Felipe Palma";
    zAction2.infoMessage = @"CEO Atlantic Solutions.";
    zAction2.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area1-info2.jpg";
    zAction2.infoImage = nil;
    zAction2.orientation = ZoneActionOrientation_N;
    zAction2.destinationZone = nil;
    
    ZoneAction *zAction3 = [ZoneAction new];
    zAction3.actionID = 3;
    zAction3.positionInImage = CGPointMake(2660.0, 486.0);
    zAction3.positionInView = CGPointZero;
    zAction3.type = ZoneActionTypeInfo;
    zAction3.infoTitle = @"Erico GT";
    zAction3.infoMessage = @"Desenvolvedor iOS da LAB360.";
    zAction3.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area1-info3.jpg";
    zAction3.infoImage = nil;
    zAction3.orientation = ZoneActionOrientation_N;
    zAction3.destinationZone = nil;
    
    ZoneAction *zAction4 = [ZoneAction new];
    zAction4.actionID = 4;
    zAction4.positionInImage = CGPointMake(4507.0, 366.0);
    zAction4.positionInView = CGPointZero;
    zAction4.type = ZoneActionTypeInfo;
    zAction4.infoTitle = @"Banheiro Feminino";
    zAction4.infoMessage = @"\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"";
    zAction4.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area1-info4.jpg";
    zAction4.infoImage = nil;
    zAction4.orientation = ZoneActionOrientation_N;
    zAction4.destinationZone = nil;
    
    ZoneAction *zAction5 = [ZoneAction new];
    zAction5.actionID = 5;
    zAction5.positionInImage = CGPointMake(4011.0, 366.0);
    zAction5.positionInView = CGPointZero;
    zAction5.type = ZoneActionTypeDirection;
    zAction5.infoTitle = nil;
    zAction5.infoMessage = nil;
    zAction5.infoImageURL = nil;
    zAction5.infoImage = nil;
    zAction5.orientation = ZoneActionOrientation_N;
    zAction5.destinationZone = zone2;
    
    ZoneAction *zAction6 = [ZoneAction new];
    zAction6.actionID = 6;
    zAction6.positionInImage = CGPointMake(3429.0, 483.0);
    zAction6.positionInView = CGPointZero;
    zAction6.type = ZoneActionTypeInfo;
    zAction6.infoTitle = @"Mesa Android";
    zAction6.infoMessage = @"Android is a mobile operating system developed by Google, based on a modified version of the Linux kernel and other open source software and designed primarily for touchscreen mobile devices such as smartphones and tablets. In addition, Google has further developed Android TV for televisions, Android Auto for cars, and Wear OS for wrist watches, each with a specialized user interface. Variants of Android are also used on game consoles, digital cameras, PCs and other electronics.";
    zAction6.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area1-info6.jpg";
    zAction6.infoImage = nil;
    zAction6.orientation = ZoneActionOrientation_N;
    zAction6.destinationZone = nil;
    
    [zone1.actions addObject:zAction1];
    [zone1.actions addObject:zAction2];
    [zone1.actions addObject:zAction3];
    [zone1.actions addObject:zAction4];
    [zone1.actions addObject:zAction5];
    [zone1.actions addObject:zAction6];
    
    //*************************************************************************
    
    ZoneAction *zzAction1 = [ZoneAction new];
    zzAction1.actionID = 1;
    zzAction1.positionInImage = CGPointMake(637.0, 1403.0);
    zzAction1.positionInView = CGPointZero;
    zzAction1.type = ZoneActionTypeInfo;
    zzAction1.infoTitle = @"Carrinho Metal";
    zzAction1.infoMessage = @"O carrinho Vinny é ideal para quem gosta de praticidade e não abre mão do estilo na hora de comprar seus itens. Multifuncional, o carrinho tem 3 cestos aramados para armazenar frutas e alimentos que não precisam de refrigeração, ou também pode ser utilizado como organizador de objetos. O móvel tem estrutura em aço carbono com acabamento em pintura epóxi na cor branca. Para facilitar a mobilidade, o produto tem rodinhas para circular livremente no espaço. Cada cesto suporta até 2,5kg. Confira já!";
    zzAction1.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area2-info1.jpg";
    zzAction1.infoImage = nil;
    zzAction1.orientation = ZoneActionOrientation_N;
    zzAction1.destinationZone = nil;
    
    ZoneAction *zzAction2 = [ZoneAction new];
    zzAction2.actionID = 2;
    zzAction2.positionInImage = CGPointMake(2696.0, 630.0);
    zzAction2.positionInView = CGPointZero;
    zzAction2.type = ZoneActionTypeInfo;
    zzAction2.infoTitle = @"Área Descanso";
    zzAction2.infoMessage = @"A área de descanso é o local ideal para tomar aquele café especial e pensar na vida...";
    zzAction2.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area2-info2.jpg";
    zzAction2.infoImage = nil;
    zzAction2.orientation = ZoneActionOrientation_N;
    zzAction2.destinationZone = nil;
    
    ZoneAction *zzAction3 = [ZoneAction new];
    zzAction3.actionID = 3;
    zzAction3.positionInImage = CGPointMake(5652.0, 885.0);
    zzAction3.positionInView = CGPointZero;
    zzAction3.type = ZoneActionTypeDirection;
    zzAction3.infoTitle = nil;
    zzAction3.infoMessage = nil;
    zzAction3.infoImageURL = nil;
    zzAction3.infoImage = nil;
    zzAction3.orientation = ZoneActionOrientation_N;
    zzAction3.destinationZone = zone1;
    
    ZoneAction *zzAction4 = [ZoneAction new];
    zzAction4.actionID = 4;
    zzAction4.positionInImage = CGPointMake(4887.0, 900.0);
    zzAction4.positionInView = CGPointZero;
    zzAction4.type = ZoneActionTypeInfo;
    zzAction4.infoTitle = @"Sala TI";
    zzAction4.infoMessage = @"Sala de controle TI da empresa.";
    zzAction4.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area2-info4.jpg";
    zzAction4.infoImage = nil;
    zzAction4.orientation = ZoneActionOrientation_N;
    zzAction4.destinationZone = nil;
    
    ZoneAction *zzAction5 = [ZoneAction new];
    zzAction5.actionID = 5;
    zzAction5.positionInImage = CGPointMake(8006.0, 666.0);
    zzAction5.positionInView = CGPointZero;
    zzAction5.type = ZoneActionTypeInfo;
    zzAction5.infoTitle = @"Copa";
    zzAction5.infoMessage = @"Todo tipo de gostosura passa por essa sala. Altas emoções!";
    zzAction5.infoImageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/zonenavigator/zone-action-area2-info5.jpg";
    zzAction5.infoImage = nil;
    zzAction5.orientation = ZoneActionOrientation_N;
    zzAction5.destinationZone = nil;
    
    [zone2.actions addObject:zzAction1];
    [zone2.actions addObject:zzAction2];
    [zone2.actions addObject:zzAction3];
    [zone2.actions addObject:zzAction4];
    [zone2.actions addObject:zzAction5];
    
    self.currentZone = zone1;
}

@end
