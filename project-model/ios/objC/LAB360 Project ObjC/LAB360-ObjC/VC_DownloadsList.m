//
//  VC_DownloadsList.m
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#define BAR_MY_DOCUMENTS 0
#define BAR_ALL_DOCUMENTS 1

#pragma mark - • HEADER IMPORT
#import "VC_DownloadsList.h"
#import "VC_FileViewer.h"
#import "VC_DownloadDetail.h"
#import "TVC_DownloadItem.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_DownloadsList()

@property(nonatomic, strong) NSArray *downloadsList;
@property(nonatomic, strong) NSArray *masterDownloadsList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *viewSegmentBar;
@property(nonatomic, weak) IBOutlet UITableView *tvDownloadsList;
@property(nonatomic, strong) DownloadItem *selectedFile;
@property BOOL isMasterDownloadsLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_DownloadsList
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES

@synthesize downloadsList, menuType, event, selectedFile, masterDownloadsList;
@synthesize tvDownloadsList;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedFile = nil;
    
	self.isMasterDownloadsLoaded = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (menuType == eDownloadListType_EventFiles){
//        [Answers logCustomEventWithName:@"Acesso a tela Lista de Downloads" customAttributes:@{}];
//    }else{
//        [Answers logCustomEventWithName:@"Acesso a tela Meus Downloads" customAttributes:@{}];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Layout
    [self.view layoutIfNeeded];
    
    NSString *screenName = @"";
    
    if (menuType == eDownloadListType_EventFiles){
        screenName = NSLocalizedString(@"SCREEN_TITLE_DOWNLOADS", @"");
        self.topTableView.constant = 0;
        self.viewSegmentBar.hidden = YES;
        
    }else{
        screenName = NSLocalizedString(@"SCREEN_TITLE_MY_DOWNLOADS", @"");
        self.topTableView.constant = 60;
        self.viewSegmentBar.hidden = NO;
    }
    
    [self setupLayout:screenName];
    
    if (menuType == eDownloadListType_EventFiles){
        //Busca downloads disponíveis para evento:
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            //connection.delegate = self;
            [connection getDownloadsForEvent:event.eventID andMasterEventID:AppD.masterEventID withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                if (error){
                    
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_NODATA_RESPONSE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    
                }else{
                    
                    if (response){
                        NSMutableArray *tempArray = [NSMutableArray new];
                        NSArray *result = [[NSArray alloc] initWithArray:[response valueForKey:@"event_files"]];
                        for (NSDictionary *dic in result){
                            [tempArray addObject:[DownloadItem createObjectFromDictionary:dic]];
                        }
                        //
                        downloadsList = [[NSArray alloc]initWithArray:tempArray];
                        [tvDownloadsList reloadData];
                        
                        if (downloadsList.count == 0){
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_FILES_AVAILABLE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_FILES_AVAILABLE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                        
                    }else{
                        //No response
                        downloadsList = [NSArray new];
                    }
                    [tvDownloadsList reloadData];
                }
            }];
            
        }else{
            
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }else{
        
        menuType = eDownloadListType_UserFiles;
        //Carrega downloads do usuário:
        [AppD loadDownloadsList];
        [tvDownloadsList reloadData];
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        if (AppD.downloadsList.count == 0){
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_DOCUMENTS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_DOCUMENTS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
}

-(void)loadMasterEventFiles{
	dispatch_async(dispatch_get_main_queue(),^{
		[AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
	});
	
	ConnectionManager *connection = [[ConnectionManager alloc] init];
	
	if ([connection isConnectionActive])
	{
		//connection.delegate = self;
		[connection getDownloadsForMasterEvent:AppD.masterEventID withCompletionHandler:^(NSDictionary *response, NSError *error) {
			
			[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
			
			if (error){
				
				SCLAlertView *alert = [AppD createDefaultAlert];
				[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_MASTER_DOWNLOAD_NODATA_RESPONSE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
				
			}else{
				
				if (response){
					NSMutableArray *tempArray = [NSMutableArray new];
					NSArray *result = [[NSArray alloc] initWithArray:[response valueForKey:@"documents"]];
					for (NSDictionary *dic in result){
						[tempArray addObject:[DownloadItem createObjectFromDictionary:dic]];
					}
					//
					masterDownloadsList = [[NSArray alloc]initWithArray:tempArray];
					
					
					if (masterDownloadsList.count == 0){
						SCLAlertViewPlus *alert = [AppD createDefaultAlert];
						[alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_FILES_AVAILABLE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_MASTER_FILES_AVAILABLE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
					}
					[tvDownloadsList reloadData];
					
				}else{
					//No response
					masterDownloadsList = [NSArray new];
				}
				
				[tvDownloadsList reloadData];
			}
		}];
		
	}else{
		
		SCLAlertView *alert = [AppD createDefaultAlert];
		[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
	}
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - PreviewController

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", DOWNLOAD_DIRECTORY, selectedFile.fileName]];
    //
    return [NSURL fileURLWithPath:filePath];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifierDownloadItem";
    
    //Célula de rodapé
    TVC_DownloadItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_DownloadItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Layout
    [cell updateLayout];
    
    //Data
    DownloadItem *dI = nil;
    if (menuType == eDownloadListType_UserFiles){
        dI = [AppD.downloadsList objectAtIndex:indexPath.row];
    }else if(menuType == eDownloadListType_EventFiles){
        dI = [downloadsList objectAtIndex:indexPath.row];
    }
	else{
		dI = [masterDownloadsList objectAtIndex:indexPath.row];
	}
    cell.lblTitle.text = dI.title;
    if (menuType == eDownloadListType_UserFiles){
        //cell.lblInfo.text = [NSString stringWithFormat:@"%@: %@\n%@: %i (%@)", NSLocalizedString(@"TABLE_VIEW_CELL_LANGUAGE", @"") ,dI.language, NSLocalizedString(@"TABLE_VIEW_CELL_NUMBER_OF_PAGES", @""), dI.numberOfPages, dI.fileExtension];
        cell.lblInfo.text = [NSString stringWithFormat:@"%@\n%@", dI.author, dI.subjectDescription];
        cell.imvArrow.alpha = 0.0;
    }else{
        cell.lblInfo.text = [NSString stringWithFormat:@"%@\n%@", dI.author, dI.subjectDescription];
        //Verificando se o download já foi feito:
        cell.imvArrow.alpha = 1.0;
        if ([self checkDownloadStatus:dI]){
            cell.imvArrow.image = [[UIImage imageNamed:@"icon-downloaded"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.imvArrow setTintColor:AppD.styleManager.colorCalendarRegistered];
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVC_DownloadItem *cell = (TVC_DownloadItem*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
    
    //UI - Animação de seleção
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [cell setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            nil;
        }];
    });
    
    //Resolução da seleção
    if (menuType == eDownloadListType_UserFiles){
        selectedFile = [AppD.downloadsList objectAtIndex:indexPath.row];
        
        [self openDocumentsViewer];
        
    }else if(menuType == eDownloadListType_EventFiles){
        selectedFile = [downloadsList objectAtIndex:indexPath.row];
        
        if ([self checkDownloadStatus:selectedFile]){
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_DOWNLOAD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_EXISTS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }else{
            self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            //Mostra detalhes do download para potencial download:
            [self performSegueWithIdentifier:@"SegueToDownloadDetail" sender:self];
        }
    }
	else{
		selectedFile = [masterDownloadsList objectAtIndex:indexPath.row];
		
		if ([self checkDownloadStatus:selectedFile]){
			SCLAlertView *alert = [AppD createDefaultAlert];
			[alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_DOWNLOAD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_EXISTS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
		}else{
			self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
			//Mostra detalhes do download para potencial download:
			[self performSegueWithIdentifier:@"SegueToDownloadDetail" sender:self];
		}
	}
}

- (void)openDocumentsViewer
{
    VC_FileViewer *previewController = [[VC_FileViewer alloc] init];
    previewController.dataSource = self;
    previewController.currentPreviewItemIndex = 0;
    [previewController.view setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [previewController.navigationController setHidesBarsOnTap:YES];
    previewController.navigationItem.rightBarButtonItems = nil;
    
    //Data:
    previewController.fileToShow = [selectedFile copyObject];
    
    //Return Button:
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Navigation Style:
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    self.navigationController.toolbar.tintColor = AppD.styleManager.colorPalette.textNormal;
    [self.navigationController.toolbar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.navigationController.toolbar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forToolbarPosition:UIBarPositionBottom];
    
    //Push:
    [self.navigationController pushViewController:previewController animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (menuType == eDownloadListType_UserFiles){
        return AppD.downloadsList.count;
    }else if(menuType == eDownloadListType_EventFiles){
        return downloadsList.count;
    }
	else{
		return masterDownloadsList.count;
	}
    return 0;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (menuType == eDownloadListType_UserFiles){
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CONTINUE_AND_DELETE", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
            [AppD.downloadsList removeObjectAtIndex:indexPath.row];
            [AppD saveAndUpdateDownloadsList:AppD.downloadsList];
            [tableView reloadData];
        }];
        
        [alert showQuestion:self title:NSLocalizedString(@"ALERT_TITLE_DOWNLOAD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DOWNLOAD_DELETE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") duration:0.0];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"ALERT_OPTION_DELETE", @"");
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //TableView
    tvDownloadsList.backgroundColor = [UIColor clearColor];
	
	//Segmented
	_viewSegmentBar.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
	_segmentedControl.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
	[_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.backgroundNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]} forState:UIControlStateNormal];
	[_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]} forState:UIControlStateSelected];
	[_segmentedControl setTitle:NSLocalizedString(@"SEGMENTEDCONTROL_OPTION_MY_DOCUMENTS", @"") forSegmentAtIndex:BAR_MY_DOCUMENTS];
	[_segmentedControl setTitle:NSLocalizedString(@"SEGMENTEDCONTROL_OPTION_ALL_DOCUMENTS", @"") forSegmentAtIndex:BAR_ALL_DOCUMENTS];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VC_DownloadDetail *destViewController = (VC_DownloadDetail*)segue.destinationViewController;
    destViewController.fileSelected = [selectedFile copyObject];
}

- (bool)checkDownloadStatus:(DownloadItem *)download
{
    for (DownloadItem *di in AppD.downloadsList){
        if (download.downloadID == di.downloadID){
			if (download.referenceMasterEventID == di.referenceMasterEventID)
			{
				return true;
			}
			else if(download.referenceEventID == di.referenceEventID){
				return true;
			}
		}
    }
	
    return false;
}

#pragma mark - Segmented method

-(IBAction)changeValue:(UISegmentedControl *)sender{
	
	if (sender.selectedSegmentIndex == BAR_MY_DOCUMENTS){
		menuType = eDownloadListType_UserFiles;
		//[Answers logCustomEventWithName:@"Acesso a tela Lista Meus Downloads" customAttributes:@{}];
		[tvDownloadsList reloadData];
	}else{
		
		menuType = eDownloadListType_MasterEventFiles;
		
		if(!self.isMasterDownloadsLoaded){
			[self loadMasterEventFiles];
			self.isMasterDownloadsLoaded = YES;
		}
		else{
			[tvDownloadsList reloadData];
		}
		
		//[Answers logCustomEventWithName:@"Acesso a tela Lista Todos os Downloads" customAttributes:@{}];
	}
	
	
}

@end
