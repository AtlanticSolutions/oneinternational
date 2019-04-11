//
//  VC_DownloadDetail.m
//  AHK-100anos
//
//  Created by Erico GT on 10/19/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_DownloadDetail.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_DownloadDetail()

@property (nonatomic, weak) IBOutlet UIView *viewHeader;
@property (nonatomic, weak) IBOutlet UIView *viewFooter;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnDownload;
@property (nonatomic, weak) IBOutlet UITableView *tvDetail;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_DownloadDetail
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize fileSelected;
@synthesize viewHeader, viewFooter, lblTitle, btnDownload, tvDetail;

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
//    self.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_FILE", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Layout
    [self.view layoutIfNeeded];
    [self setupLayout];
}

//MARK: TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    switch (indexPath.row) {
        case 0:
            str = fileSelected.subjectDescription; //author
            break;
        case 1:
            str = fileSelected.author; //subjectDescription
            break;
        case 2:
            str = fileSelected.language;
            break;
        case 3:
            str = [NSString stringWithFormat:@"%i %@", fileSelected.numberOfPages, NSLocalizedString(@"TABLE_VIEW_CELL_PAGES", @"")];
            break;
    }
    
    CGSize size = [self returnSizeForText:str];
    if(size.height < 20)
    {
        size.height = 20; //Impede que a linha tenha uma altura pequena demais
    }
    return size.height + 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDownloadDetail";
    
    TVC_EventDescription *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_EventDescription alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *strField = @"";
    NSString *strValue = @"";
    
    switch (indexPath.row) {
        case 0:{
            strField = NSLocalizedString(@"TVC_LABEL_FIELD_DESCRIPTION", @""); //TVC_LABEL_FIELD_AUTHOR
            strValue = fileSelected.subjectDescription;
        }break;
         //
        case 1:{
            strField = NSLocalizedString(@"TVC_LABEL_FIELD_AUTHOR", @""); //TVC_LABEL_FIELD_DESCRIPTION
            strValue = fileSelected.author;
        }break;
        //
        case 2:{
            strField = NSLocalizedString(@"TVC_LABEL_FIELD_LANGUAGE", @"");
            strValue = fileSelected.language;
        }break;
        //
        case 3:{
            strField = NSLocalizedString(@"TVC_LABEL_FIELD_NUMBER_OF_PAGES", @"");
            strValue = [NSString stringWithFormat:@"%i %@ (%@)", fileSelected.numberOfPages, NSLocalizedString(@"TABLE_VIEW_CELL_PAGES", @""), fileSelected.fileExtension];
        }break;
    }
    
    cell.lblTitulo.text = strField;
    cell.lblTexto.text = strValue;
    
    CGSize size = [self returnSizeForText:strValue];
    if(size.height < 20)
    {
        size.height = 20; //Impede que a linha tenha uma altura pequena demais
    }
    cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
    
    [cell updateLayout];
    
    return cell;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)downloadFile:(id)sender
{
    AppD.downloadConnectionManager = [[ConnectionManager alloc] init];
    
    if ([AppD.downloadConnectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
        });
        
        AppD.downloadConnectionManager.delegate = self;
        
        [AppD.downloadConnectionManager downloadFileFromURL:[NSURL URLWithString:fileSelected.urlFile] WithCompletionHandler:^(NSData *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                
                //Salvando o arquivo de download
                bool result = true;
                
                @try {
                    fileSelected.fileName = [NSString stringWithFormat:@"%@.%@", [fileSelected.title stringByReplacingOccurrencesOfString:@" " withString:@""], fileSelected.fileExtension];//[NSString stringWithFormat:@"%lu.%@", [ToolBox dateHelper_TimeStampFromDate:[NSDate date]], fileSelected.fileExtension];
                    NSURL *nsurl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
                    NSString *path = [nsurl.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", DOWNLOAD_DIRECTORY,fileSelected.fileName]];
                    result =  [response writeToFile:path atomically:YES];
                    //
                    [AppD.downloadsList addObject:[fileSelected copyObject]];
                    [AppD saveAndUpdateDownloadsList:AppD.downloadsList];
                }
                @catch (NSException *exception)
                {
                    NSLog(@"Erro ao salvar arquivo: %@.", exception.description);
                    result = false;
                }
                @finally {
                    NSLog(@"Arquivo salvo: %i.", result);
                }
                
                if (result){
                    
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                        
                        //Volta o usuário para a tela anterior:
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_DOWNLOAD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                    
                }else{
                    
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") actionBlock:^{
                        
                        //Volta o usuário para a tela anterior:
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_DOWNLOAD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_ERROR_SAVE_TO_DISC", @"") closeButtonTitle:nil duration:0.0];
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

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

-(void)downloadProgress:(float)dProgress
{
    NSLog(@"Download progress: %@", [NSString stringWithFormat:@"%.0f %%", (dProgress * 100.0)]);
    
    if (dProgress < 0.0){
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD updateLoadingAnimationMessage:@""];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.0f %%", (dProgress * 100.0)]];
        });
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Views
    viewHeader.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    viewFooter.backgroundColor = [UIColor whiteColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = AppD.styleManager.colorPalette.primaryButtonTitleNormal;
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    lblTitle.text = fileSelected.title;
    //
    btnDownload.backgroundColor = [UIColor clearColor];
    [btnDownload.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnDownload setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnDownload.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnDownload setTitle:NSLocalizedString(@"BUTTON_TITLE_DOWNLOAD_FILE", @"") forState:UIControlStateNormal];
    [btnDownload setTitle:NSLocalizedString(@"BUTTON_TITLE_DOWNLOAD_FILE", @"") forState:UIControlStateHighlighted];
    [btnDownload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //TableView
    tvDetail.backgroundColor = [UIColor clearColor];
}

-(CGSize) returnSizeForText:(NSString*)str
{
    CGSize size = [str sizeWithFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS] constrainedToSize:CGSizeMake(self.view.frame.size.width - 40, 999) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

@end
