//
//  VC_Notifications.m
//  GS&MD
//
//  Created by Lab360 on 05/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "VC_Notifications.h"
#import "TVC_Notifications.h"
#import "AppDelegate.h"

@interface VC_Notifications () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tvList;

//Controls
@property (nonatomic, strong) NSArray *notificationsList;
@property (nonatomic, assign) BOOL isLoaded;
@end

@implementation VC_Notifications

@synthesize notificationsList, tvList, isLoaded;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.automaticallyAdjustsScrollViewInsets = false;
	
	//Title
	[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
	[self.navigationItem setHidesBackButton:NO];
	self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_NOTIFICATIONS", @"");
    
    isLoaded = false;
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
        [self setupLayout];
        [self loadNotificationsFromService];
        isLoaded = YES;
    }
}

//TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return notificationsList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"NotificationCell";
	
	TVC_Notifications *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell = [[TVC_Notifications alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	NSDictionary *dicNote = [notificationsList objectAtIndex:indexPath.row];
	
	bool showArrow = false;
	
	if (![[dicNote valueForKey:@"info"] isKindOfClass:[NSNull class]]){
		NSString *targetName = [dicNote valueForKey:@"info"];
		if (targetName != nil && ![targetName isEqualToString:@""]){
			showArrow = true;
		}
	}
	
	[cell updateLayoutWithArrowVisible:showArrow];
	
	CGSize size = [self returnSizeForText:[dicNote objectForKey:@"message"]];
	
	if(size.height < 20)
	{
		size.height = 20;
	}
	
	cell.lblDescription.text = [dicNote objectForKey:@"message"];
	cell.lblDescription.frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, size.width, size.height);
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dicNote = [notificationsList objectAtIndex:indexPath.row];
	
	if (![[dicNote valueForKey:@"info"] isKindOfClass:[NSNull class]]){
		
        //NOTE: EricoGT (08/03/2018)
        //Para cada aplicação o toque na notificação pode ter uma ação diferente (após clonar o projeto LAB360, verifique este quesito)
        //Por padrão, considerá-se uma URL, definida pelo cliente. Caso seja possível para o sistema abrir a URL, o conteúdo será exibido.
        
        NSString *info = [dicNote valueForKey:@"info"];
		if (info != nil && ![info isEqualToString:@""]){
			NSLog(@"notification info : %@", info);

            NSURL *url = [[NSURL alloc] initWithString:info];
            
            if (url){
                if ([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url];
                }else{
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NOTIFICATION_LINK_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NOTIFICATION_LINK_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            }else{
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NOTIFICATION_LINK_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NOTIFICATION_LINK_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            
		}
	}
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dicNote = [notificationsList objectAtIndex:indexPath.row];
	return [self returnSizeForText:[dicNote objectForKey:@"message"]].height + 60;
}


#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

-(CGSize) returnSizeForText:(NSString *)text
{
	CGSize size = [text sizeWithFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_NORMAL] constrainedToSize:CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	
	return size;
	
}

- (void)setupLayout
{
	//Self
	self.view.backgroundColor = [UIColor whiteColor];
	
	//Navigation Controller
	self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
	
	self.navigationController.toolbar.translucent = YES;
	self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
	
	tvList.backgroundColor = nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (void)loadNotificationsFromService
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    NSLog(@"%i", AppD.loggedUser.userID);
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        //Buscando Feed de Vídeos
        [connectionManager getNotificationsWithUserID:AppD.loggedUser.userID withCompletionHandler:^(NSDictionary *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PARTICIPANTS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                
                if (response){
                    
                    notificationsList = [response objectForKey:@"pushs"];
                    [tvList reloadData];
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

@end
