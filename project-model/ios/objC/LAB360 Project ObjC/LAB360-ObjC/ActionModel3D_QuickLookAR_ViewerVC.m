//
//  ActionModel3D_QuickLookAR_ViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <ModelIO/ModelIO.h>
#import <SceneKit/SceneKit.h>
#import <SceneKit/ModelIO.h>
#import <SpriteKit/SpriteKit.h>
#import <ARKit/ARKit.h>
#import <QuickLook/QuickLook.h>
//
#import "ActionModel3D_QuickLookAR_ViewerVC.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "VirtualObjectProperties.h"
#import "AsyncImageDownloader.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "SSZipArchive.h"
#import "ActionModel3D_AR_DataManager.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ActionModel3D_QuickLookAR_ViewerVC ()<InternetConnectionManagerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

//Data: ========================================================
@property (nonatomic, strong) NSString *modelErrorMessage;
@property (nonatomic, strong) ActionModel3D_AR_DataManager *modelManager;
@property (nonatomic, assign) BOOL loadedContent;

//Layout: ========================================================
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;

@end

#pragma mark - • IMPLEMENTATION
@implementation ActionModel3D_QuickLookAR_ViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize actionM3D, backgroundPreviewImage, loadedContent;
@synthesize modelManager, modelErrorMessage;
@synthesize imvBackground;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commomInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (void)commomInit
{
    modelErrorMessage = nil;
    loadedContent = NO;
}

#pragma mark - • DEALLOC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    modelManager = [ActionModel3D_AR_DataManager sharedInstance];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionReturn:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self.view layoutIfNeeded];
    
    if (!loadedContent){
        [self setupLayout:actionM3D.screenSet.screenTitle];
        
        if ([ToolBox textHelper_CheckRelevantContentInString:self.actionM3D.objSet.objLocalURL]){
            [self openPreviewController];
        }else{
            [self loadActionContent];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
        [self.view layoutIfNeeded];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionReturn:(id)sender
{
    [self.navigationController popViewControllerAnimated:self.animatedTransitions];
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
    NSURL *fileURL = [NSURL fileURLWithPath:actionM3D.objSet.objLocalURL];
    return fileURL;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller
{
    [self actionReturn:nil];
}

#pragma mark - InternetConnectionManagerDelegate

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccess:(id _Nullable)responseObject
{
    NSLog(@"didConnectWithSuccess");
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithFailure:(NSError * _Nullable)error
{
    [self showProcessError:[error localizedDescription]];
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccessData:(id _Nullable)responseObject
{
    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
    [AppD updateLoadingAnimationMessage:@""];
    //
    [self processDataForOBJ:(NSData*)responseObject];
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager downloadProgress:(float)dProgress
{
    dProgress = dProgress < 0.0 ? 0.0 : (dProgress > 1.0 ? 1.0 : dProgress);
    [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.1f %%", (dProgress * 100.0)]];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[UIColor colorWithWhite:0.0 alpha:0.75]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.view layoutIfNeeded];
    
    [imvBackground setContentMode:UIViewContentModeScaleAspectFill];
    imvBackground.image = backgroundPreviewImage;
    
    loadedContent = YES;
}

- (void)showProcessError:(NSString*)errorMessage
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
    //
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
        [self.navigationController popViewControllerAnimated:self.animatedTransitions];
    }];
    [alert showError:@"Erro" subTitle:errorMessage closeButtonTitle:nil duration:0.0];
}

- (void)communicateError:(NSString*)errorMessage
{
    modelErrorMessage = errorMessage;
}

#pragma mark -

- (void)didRecieveWillResignActiveNotification:(NSNotification*)notification
{
    //
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    //
}

#pragma mark - Load Data

- (void)loadActionContent
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
    });
    
    actionM3D = [modelManager loadResourcesFromDiskUsingReference:actionM3D];
    
    if ([ToolBox textHelper_CheckRelevantContentInString:actionM3D.sceneSet.backgroundURL]){
        
        [self fetchDownloadImagesWithCompletion:^(NSString* errorMessage, int readyImages) {

            if (readyImages > 0){
                self.imvBackground.image = self.actionM3D.sceneSet.backgroundImage;
            }
            //
            [self fetchDownloadModelOBJ];
            
        }];
        
    }else{
        [self fetchDownloadModelOBJ];
    }
}

-(void)fetchDownloadImagesWithCompletion:(void (^)(NSString* errorMessage, int readyImages))completion
{
    __block NSString *msgError = @"";
    __block int totalImagesReady = 0;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    //Background Image
    if (self.actionM3D.sceneSet.backgroundImage == nil){
        
        dispatch_group_enter(serviceGroup);
        [[[AsyncImageDownloader alloc] initWithFileURL:self.actionM3D.sceneSet.backgroundURL successBlock:^(NSData *data) {
            if (data != nil){
                @try {
                    self.actionM3D.sceneSet.backgroundImage = [UIImage imageWithData:data];
                    totalImagesReady += 1;
                } @catch (NSException *exception) {
                    self.actionM3D.sceneSet.backgroundImage = nil;
                }
            }
            dispatch_group_leave(serviceGroup);
        } failBlock:^(NSError *error) {
            msgError = [NSString stringWithFormat:@"%@\n%@", msgError, [error localizedDescription]];
            dispatch_group_leave(serviceGroup);
        }] startDownload];
        
    }else{
        totalImagesReady += 1;
    }
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(),^{
        completion(msgError, totalImagesReady);
    });
}

-(void)fetchDownloadModelOBJ
{
    BOOL saved = [modelManager saveActionModel3D:actionM3D];
    NSLog(@"configureScene >> saveActionModel3D >> %@", (saved ? @"YES" : @"NO"));
    
    //precisa baixar o arquivo OBJ:
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        [icm downloadDataFrom:self.actionM3D.objSet.objRemoteURL withDelegate:self andCompletionHandler:nil];
        
    }else{
        
        [self showProcessError:@"O modelo 3D não pode ser baixado pois não há uma conexão com internet disponível."];
        
    }
}

- (void)processDataForOBJ:(NSData*)zipData
{
    long identifier = self.actionM3D.objSet.objID != 0 ? self.actionM3D.objSet.objID : self.actionM3D.actionID;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *mainFolder = @"objects3D";
    NSString *objFolder = [NSString stringWithFormat:@"obj%li", identifier];
    NSString *objName = [NSString stringWithFormat:@"obj%li.zip", identifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
    NSString *objPath = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objFolder]];
    
    //Controle de diretórios ******************************************************************************************************
    
    if (![self directoryExists:objPath])
    {
        if (![self createDirectoryAtPath:objPath]) {
            [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
            return;
        }
    }else{
        NSError *error;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&error];
        if (directoryContents != nil){
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                if ([fileManager removeItemAtPath:fullPath error:&error]){
                    NSLog(@"Arquivo antigo removido: %@", fullPath);
                }else{
                    [self showProcessError:[error localizedDescription]];
                    return;
                }
            }
        }else{
            [self showProcessError:[error localizedDescription]];
            return;
        }
    }
    
    NSString *objFile = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objName]];
    
    if (![self fileExists:objFile])
    {
        if (![self createFileAtPath:objFile])
        {
            [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
            return;
        }
    }
    
    [zipData writeToFile:objFile atomically:NO];
    
    //Unzip do arquivo ******************************************************************************************************
    
    if ([SSZipArchive unzipFileAtPath:objFile toDestination:objPath]){
        
        NSError *zipError;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&zipError];
        if (directoryContents != nil){
            
            NSString *currentOBJ = nil;
            
            //USDZ
            if (actionM3D.type == ActionModel3DViewerTypeQuickLookAR){
                for (NSString *path in directoryContents){
                    NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                    //
                    if ([[fullPath lowercaseString] hasSuffix:@"usdz"]){
                        currentOBJ = fullPath;
                        break;
                    }
                }
                
            }
            
            if (currentOBJ){
                
                actionM3D.objSet.objLocalURL = currentOBJ;
                [modelManager saveActionModel3D:actionM3D];
                [self openPreviewController];
                
            }else{
                [self showProcessError:@"Nenhum arquivo 3D válido foi encontrado no zip baixado."];
                return;
            }
            
        }else{
            [self showProcessError:[zipError localizedDescription]];
            return;
        }
        
    }else{
        [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
        return;
    }
}

#pragma mark - File Manipulation Methods

-(BOOL)directoryExists:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

#pragma mark -

- (void)openPreviewController
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.delegate = self;
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
