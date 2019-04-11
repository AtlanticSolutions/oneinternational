//
//  RotationalViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "RotationalViewerVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface RotationalViewerVC()

//Layout:
@property(nonatomic, weak) IBOutlet UIView *viewContainer;
@property(nonatomic, weak) IBOutlet UILabel *lblActualFrame;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, strong) RotationalImageViewer *rotationalViewer;
//Data:
@property(nonatomic, strong) NSMutableArray<NSMutableArray<UIImage*>*> *layerList;
@property(nonatomic, strong) NSMutableDictionary *cacheImagesHD;

@end

#pragma mark - • IMPLEMENTATION
@implementation RotationalViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize rotationalViewer, viewContainer, lblActualFrame, lblDescription, layerList, cacheImagesHD;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //NOTE: descomentar o trecho abaixo para imagens dentro do projeto:
//    layerList = [NSMutableArray new];
//
//    for (int l=0; l<1; l++){
//        NSMutableArray *imagesList = [NSMutableArray new];
//        for (int i=1; i<25; i++){
//            [imagesList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"IMG_00%02d.jpg", i]]];
//        }
//        [layerList addObject:imagesList];
//    }
//
//    cacheImagesHD = [NSMutableDictionary new];
    
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
    
    //NOTE: descomentar o trecho abaixo para imagens dentro do projeto:
//    rotationalViewer = [[RotationalImageViewer alloc] initWithFrame:CGRectMake(0.0, 0.0, viewContainer.frame.size.width, viewContainer.frame.size.height) andDelegate:self];
//    [rotationalViewer setViewerBackgroundColor:[UIColor whiteColor]];
//    [rotationalViewer autoCreateConstraintsToParent:viewContainer];
//    [rotationalViewer reloadData];
    
    [self getDataFromServer];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - VIPhotoView

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


#pragma mark - Rotational Viewer

- (int)rotationalImageViewerNumberOfItems:(RotationalImageViewer* _Nonnull)viewer
{
    if (layerList.count > 0){
        //Independente do número de camadas, cada camada sempre possui o mesmo número de itens, portanto, pegando o count do primeiro elemento vale por todos:
        NSMutableArray *list = [layerList objectAtIndex:0];
        return (int)list.count;
    }else{
        return 0;
    }
}

- (int)rotationalImageViewerNumberOfLayers:(RotationalImageViewer* _Nonnull)viewer
{
    return (int)layerList.count;
}

- (UIImage* _Nonnull)rotationalImageViewer:(RotationalImageViewer* _Nonnull)viewer imageForItem:(int)index atLayer:(int)layer;
{
    //TODO: verificar por layer:
    
    NSMutableArray *list = [layerList objectAtIndex:layer];
    return [list objectAtIndex:index];
}

- (void)rotationalImageViewer:(RotationalImageViewer* _Nonnull)viewer updatedIndex:(int)newIndex atLayer:(int)layer;
{
    NSMutableArray *list = [layerList objectAtIndex:0];
    lblActualFrame.text = [NSString stringWithFormat:@"%i / %li", (newIndex + 1), [list count]];
}

- (void)rotationalImageViewer:(RotationalImageViewer* _Nonnull)viewer selectedIndex:(int)index atLayer:(int)layer;
{
    NSString *key = [NSString stringWithFormat:@"IMG_I%i_L%i", (index + 1), (layer + 1)];
    
    if ([[cacheImagesHD allKeys] containsObject:key]){
        UIImage *img = [cacheImagesHD valueForKey:key];
        [self showCardStatusImage:img];
    }else{
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        //Download Image:
        NSString *url = [NSString stringWithFormat:@"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_00%02d.jpg", (index + 1)];
        [[[AsyncImageDownloader alloc] initWithFileURL:url successBlock:^(NSData *data) {
            UIImage *img = [UIImage imageWithData:data];
            [cacheImagesHD setValue:img forKey:key];
            [self showCardStatusImage:img];
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        } failBlock:^(NSError *error) {
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }] startDownload];
    }
    
    NSLog(@"Index Selected: %i, Layer Selected: %i", index, layer);
}

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //
    self.navigationItem.title = @"Visualizador Rotacional";
    
    viewContainer.layer.cornerRadius = 4.0;
    
    lblActualFrame.backgroundColor = nil;
    [lblActualFrame setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:12.0]];
    [lblActualFrame setTextColor:[UIColor grayColor]];
    lblActualFrame.text = @"";
    
    viewContainer.alpha = 0.0;
    lblActualFrame.alpha = 0.0;
    lblDescription.alpha = 0.0;
}

-(void)showCardStatusImage:(UIImage*)img
{
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:img backgroundImage:nil andDelegate:self];
    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
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

- (void)getDataFromServer
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
    });
    
    //Para este exemplo o zip encontra-se numa pasta do S3.
    NSString *url = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImages/images.zip";
    
    //Buscando o NSData do zip:
    [[[AsyncImageDownloader alloc] initWithFileURL:url successBlock:^(NSData *data) {
        
        //Criando os diretórios necessários:
        NSString *fileID = [ToolBox dateHelper_TimeStampCompleteIOSfromDate:[NSDate date]];
        
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"ZIP/file_%@.zip", fileID]];
        NSString *destinationPath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"ZIP/FILE%@", fileID]];
        
        NSFileManager *nsFileManager = [NSFileManager defaultManager];
        
        BOOL dir = [nsFileManager createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingString:@"ZIP/"] withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (dir && [nsFileManager createFileAtPath:filePath contents:data attributes:nil]) {
        
            //Tendo o arquivo (NSData file) salvo no diretório origem, inicia-se a descompactação:
            FileManager *fileManager = [FileManager new];
            
            [fileManager unzipFileAtPath:filePath toPath:destinationPath withCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    
                    layerList = [NSMutableArray new];
                    cacheImagesHD = [NSMutableDictionary new];
                    
                    //Todos os arquivos do zip:
                    NSArray *directoryContents = [nsFileManager contentsOfDirectoryAtPath:destinationPath error:nil];
                    
                    //Filtrando apenas pelas imagens:
                    NSMutableArray *subpredicates = [NSMutableArray array];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpg'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpeg'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.gif'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.PNG'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.JPG'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.JPEG'"]];
                    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.GIF'"]];
                    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
                    
                    NSArray *onlyImages = [directoryContents filteredArrayUsingPredicate:filter];
                    
                    //Ordenando por nome:
                    NSArray *ordenedImages = [[NSArray alloc] initWithArray:[onlyImages sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
                    
                    NSMutableArray *imagesList = [NSMutableArray new];
                    for (int i = 0; i < ordenedImages.count; i++) {
                        NSString *imagePath = [destinationPath stringByAppendingPathComponent:[ordenedImages objectAtIndex:i]];
                        //Carregando as imagens (numa versão mais robusta as imagens podem ser carregadas por demanda...):
                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                        [imagesList addObject:image];
                    }
                    [layerList addObject:imagesList];
                    
                    if (layerList.count > 0) {
                        
                        //Criando a view para exibição:
                        rotationalViewer = [[RotationalImageViewer alloc] initWithFrame:CGRectMake(0.0, 0.0, viewContainer.frame.size.width, viewContainer.frame.size.height) andDelegate:self];
                        [rotationalViewer setViewerBackgroundColor:[UIColor whiteColor]];
                        [rotationalViewer autoCreateConstraintsToParent:viewContainer];
                        [rotationalViewer reloadData];
                        
                        [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
                            viewContainer.alpha = 1.0;
                            lblActualFrame.alpha = 1.0;
                            lblDescription.alpha = 1.0;
                        }];
                        
                    }else{
                        
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Atenção!" subTitle:@"Não há nenhuma imagem para visualização no momento." closeButtonTitle:@"OK" duration:0.0];
                        
                    }
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    
                }else{
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    //
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:@"Atenção!" subTitle:[error localizedDescription] closeButtonTitle:@"OK" duration:0.0];
                    
                }
            }];
            
        }else{
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            //
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Atenção!" subTitle:@"Não foi possível resgatar as imagens para o visualizador." closeButtonTitle:@"OK" duration:0.0];
            
        }
        
    } failBlock:^(NSError *error) {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Atenção!" subTitle:@"Não foi possível resgatar as imagens para o visualizador." closeButtonTitle:@"OK" duration:0.0];
        
    }] startDownload];
    
}

@end
