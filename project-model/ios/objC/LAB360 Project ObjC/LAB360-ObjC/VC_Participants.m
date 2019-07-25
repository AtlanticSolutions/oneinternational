//
//  VC_Participants.m
//  GS&MD
//
//  Created by Lab360 on 02/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "VC_Participants.h"
#import "TVC_Participant.h"
#import "Contact.h"
#import "AppDelegate.h"

@interface VC_Participants () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tvList;

//Controls
@property (nonatomic, strong) NSArray *participantsList;
@end

@implementation VC_Participants

@synthesize participantsList, tvList;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.automaticallyAdjustsScrollViewInsets = false;
	
	//Button Profile Pic
	self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
	
	//Title
	[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
	[self.navigationItem setHidesBackButton:YES];
	self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_PARTICIPANTS", @"");
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
		
		//Buscando Feed de Vídeos
		[connectionManager getParticipantsWithMasterEventID:AppD.masterEventID withCompletionHandler:^(NSDictionary *response, NSError *error) {
			
			[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
			
			if (error){
				SCLAlertView *alert = [AppD createDefaultAlert];
				[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PARTICIPANTS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
			}else{
				
				if (response){
					
					NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[response objectForKey:@"app_users"]];
					NSMutableArray *tempResult = [NSMutableArray new];
					for (NSDictionary *dic in tempArray){
						[tempResult addObject:[Contact createObjectFromDictionary:dic]];
					}
					
					//ordenando a lista
					NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
					NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
					participantsList = [[NSArray alloc] initWithArray:[tempResult sortedArrayUsingDescriptors:sortDescriptors]];
					
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

//TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return participantsList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CustomCellInfo";
	
	TVC_Participant *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell = [[TVC_Participant alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	[cell updateLayout];
	
	Contact *auxUser = [participantsList objectAtIndex:indexPath.row];
	
	cell.lblTitle.text = auxUser.name;
	cell.lblTime.text = auxUser.email;
	cell.lblRole.text = auxUser.role;
	
	if (!auxUser.imgProfile){
		
		NSString *imageUrl = auxUser.urlProfileImage;
		[cell.imvThumbnail setBackgroundColor:[UIColor lightGrayColor]];
		
		if([imageUrl isEqualToString:@""] || !imageUrl){
			[cell.activityIndicator stopAnimating];
			auxUser.imgProfile = [UIImage imageNamed:@"icon-user-default"];
			cell.imvThumbnail.image = auxUser.imgProfile;
			
		}
		else{
			[cell.activityIndicator startAnimating];
			//
			[[[AsyncImageDownloader alloc] initWithFileURL:imageUrl successBlock:^(NSData *data) {
				
				UIImage *img = nil;
				
				if (data != nil){
					img = [UIImage imageWithData:data];
					
					Contact *user = [participantsList objectAtIndex:indexPath.row];
					user.imgProfile = img;
					
					dispatch_async(dispatch_get_main_queue(), ^{
						
						TVC_Participant *updateCell = (id)[tvList cellForRowAtIndexPath:indexPath];
						if (updateCell && img){
							updateCell.imvThumbnail.image = img;
						}
						else if(updateCell){
							user.imgProfile = [UIImage imageNamed:@"icon-user-default"];
							updateCell.imvThumbnail.image = [UIImage imageNamed:@"icon-user-default"];
						}
						
						[updateCell.activityIndicator stopAnimating];
					});
				}
				
			} failBlock:^(NSError *error) {
				NSLog(@"Erro ao buscar imagem: %@", error.domain);
			}] startDownload];
			
		}
	
	}else{
		cell.imvThumbnail.image = auxUser.imgProfile;
		[cell.imvThumbnail setBackgroundColor:[UIColor lightGrayColor]];
		[cell.activityIndicator stopAnimating];
	}
	
	return cell;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

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

@end
