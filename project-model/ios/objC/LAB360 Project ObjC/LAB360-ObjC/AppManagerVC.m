//
//  AppManagerVC.m
//  LAB360-ObjC
//
//  Created by Alexandre on 28/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AppManagerVC.h"
#import "AppManager.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppManagerVC()

//Data:
@property(nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSMutableArray<AppManager*> *itemsList;
//
@property (nonatomic, assign) BOOL isLoaded;

//Layout
@property(nonatomic, weak) IBOutlet UITableView *tvApp;

@end


#pragma mark - • IMPLEMENTATION
@implementation AppManagerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize itemsList, isLoaded, tvApp, placeholderImage;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoaded = NO;
    
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    
    [self getDataForApps];
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
        [self setupLayout:@"Gerenciador"];
        isLoaded = YES;
    }
}

#pragma mark - UITabelView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CustomCellAppItem";
    
    TVC_AppManager *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[TVC_AppManager alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell layoutIfNeeded];
    
    [cell updateLayout];
    
    //Data:
    AppManager *card = [itemsList objectAtIndex:indexPath.row];
    
    cell.lblName.text = card.appName;
    cell.lblVersion.text = [NSString stringWithFormat:@"Versão: %@", card.appVesion];
    cell.lblBuild.text = [NSString stringWithFormat:@"Build: %@", card.appBuild];
    //    cell.tvDescription.text = card.appDescription;
    
    if (card.appVesion == [ToolBox applicationHelper_VersionBundle] && card.appName == [ToolBox applicationHelper_AppName]) {
        [cell.btAction setTitle:@"Versão Atual" forState:UIControlStateNormal];
    }else if (card.appVesion > [ToolBox applicationHelper_VersionBundle] && card.appName == [ToolBox applicationHelper_AppName]){
        [cell.btAction setTitle:@"Atualizar" forState:UIControlStateNormal];
    }else{
        [cell.btAction setTitle:@"Baixar" forState:UIControlStateNormal];
    }
    
    cell.btAction.backgroundColor = [UIColor clearColor];
    [cell.btAction setExclusiveTouch:YES];
    cell.btAction.tag = indexPath.row;
    [cell.btAction addTarget:self action:@selector(executeAction:) forControlEvents:UIControlEventTouchDown];
    [cell.btAction setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:cell.btAction.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [cell.btAction setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:cell.btAction.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    cell.btInfo.backgroundColor = [UIColor clearColor];
    [cell.btInfo setExclusiveTouch:YES];
    cell.btInfo.tag = indexPath.row;
    [cell.btInfo addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchDown];
    
    UIImage *imgNormal = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonNormal andImageTemplate:[UIImage imageNamed:@"info-button"]];
    UIImage *imgSel = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonSelected andImageTemplate:[UIImage imageNamed:@"info-button"]];
    [cell.btInfo setImage:imgNormal forState:UIControlStateNormal];
    [cell.btInfo setImage:imgSel forState:UIControlStateHighlighted];
    
    [cell.imvApp setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:card.appUrlimgIcon]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.imvApp.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        cell.imvApp.image = self.placeholderImage;
    }];
    
    return cell;
}


#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(void)executeAction:(UIButton*)sender {
    AppManager *card = [itemsList objectAtIndex:sender.tag];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:card.appUrl]];
}

-(void)infoAction:(UIButton*)sender {
    
    AppManager *card = [itemsList objectAtIndex:sender.tag];
    
    NSString *textToShare = @"De uma olhada nessa versão do nosso aplicativo para iOS!";
    NSURL *Website = [NSURL URLWithString:card.appUrl];
    
    NSArray *objectsToShare = @[textToShare, Website];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToFacebook];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:card.appUrl]];
}


#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - Text Field Delegate

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    tvApp.backgroundColor = nil;
    [tvApp setTableFooterView:[UIView new]];
}

#pragma mark - Connections

- (void)getDataForApps {
    //TODO:modifique aqui a forma de aquisição dos dados (endpoint adalive, por exemplo)
    
    NSURL *cardDataURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/version/app.xml"]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:cardDataURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //backgroundSessionConfigurationWithIdentifier:@"br.com.lab360.download.task"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error){
            [self showErrorMessageWithDetail:[error localizedDescription]];
        }else{
            NSPropertyListFormat format;
            NSError *errorStr = nil;
            NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:&errorStr];
            //
            if (errorStr){
                [self showErrorMessageWithDetail:[errorStr localizedDescription]];
            }else{
                if (dictionary){
                    
                    self.itemsList = [NSMutableArray new];
                    
                    NSArray *Dics = [[NSArray alloc] initWithArray:[dictionary valueForKey:@"app_manager"]];
                    for (NSDictionary *dic in Dics){
                        [self.itemsList addObject:[AppManager createObjectFromDictionary:dic]];
                    }
                    
                    [self.tvApp reloadData];
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    
                }else{
                    [self showErrorMessageWithDetail:@"Nenhum conteúdo encontrado."];
                }
            }
        }
    }] resume];
}

- (void)showErrorMessageWithDetail:(NSString*)messageDetail
{
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    //
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:@"Erro" subTitle:messageDetail closeButtonTitle:@"OK" duration:0.0];
    //
    NSLog(@"showErrorMessageWithDetail: %@", messageDetail);
}

@end

