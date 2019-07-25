//
//  VC_ChatList.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 05/12/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_ContactsChat.h"
#import "GroupChat.h"
#import "VC_NewContactChat.h"
#import "TVC_ChatPersonItem.h"
#import "TVC_AssociateItem.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_ContactsChat()

@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, strong) GroupChat *selectedGroup;
@property (nonatomic, strong) UIImage *imageBlocked;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_ContactsChat
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    int _lastTagUsed;
    
}

#pragma mark - • SYNTESIZES
@synthesize tbvChatList, chatGroup, chatPerson, chatSpeaker;
@synthesize isGroup, imageBlocked;
@synthesize selectedUser, selectedGroup;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
    selectedUser = [User new];
    selectedGroup = [GroupChat new];
    
    self.tbvChatList.allowsMultipleSelectionDuringEditing = NO;
    
    imageBlocked = [[UIImage imageNamed:@"icon-block-talk"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_CHAT", @"")];
    
    [self setupData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Segue_AddChat"])
    {
        if(_lastTagUsed == 0)
        {
            isGroup = true;
            VC_NewContactChat *vcNewChat = (VC_NewContactChat*)segue.destinationViewController;
            vcNewChat.isGroup = isGroup;
            vcNewChat.paramList = chatGroup;
        }
        else if(_lastTagUsed == 1)
        {
            isGroup = false;
            VC_NewContactChat *vcNewChat = (VC_NewContactChat*)segue.destinationViewController;
            vcNewChat.isGroup = isGroup;
            vcNewChat.paramList = chatPerson;
        }
    }
    else if([segue.identifier isEqualToString:@"SegueToChat"])
    {
        if(isGroup)
        {
            VC_Chat *vcChat = (VC_Chat*)segue.destinationViewController;
            vcChat.chatType = eChatScreenType_Group;
            vcChat.receiverGroup = [selectedGroup copyObject];
        }
        else
        {
            VC_Chat *vcChat = (VC_Chat*)segue.destinationViewController;
            vcChat.outerUser = [selectedUser copyObject];
            vcChat.chatType = eChatScreenType_Single;
        }
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(void)clickAddGroup
{
    _lastTagUsed = 0;
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"Segue_AddChat" sender:nil];
}

-(void)clickAddSimpleChat
{
    _lastTagUsed = 1;
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"Segue_AddChat" sender:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return chatGroup.count;
    }
    else if(section == 1)
    {
        return chatPerson.count;
    }
	else{
		return chatSpeaker.count;
	}
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 2; //Para remover última opção
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
        static NSString *CellIdentifierGroup = @"CustomCellGroupChat";
        
        TVC_AssociateItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup];
        
        if(cell == nil)
        {
            cell = [[TVC_AssociateItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGroup];
        }
        
        [cell updateLayout];
        cell.imvArrow.image = nil;
        
        GroupChat *grupo = [chatGroup objectAtIndex:indexPath.row];
        cell.lblTitle.text = grupo.groupName;
        
        return cell;
        
    }else if(indexPath.section == 1){
        
        static NSString *CellIdentifierChat = @"CustomCellOpenedChat";
        
        TVC_ChatPersonItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierChat];
        
        if(cell == nil)
        {
            cell = [[TVC_ChatPersonItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierChat];
        }
        
        [cell updateLayout];
        cell.imvArrow.image = nil;
        
        User *user = [chatPerson objectAtIndex:indexPath.row];
        //
        cell.lblTitle.text = user.name;
        cell.lblNote.text = [user.jobRoleDescription isKindOfClass:[NSNull class]] || !user.jobRoleDescription ? @"-": user.jobRoleDescription;
		NSString *city = [user.city isKindOfClass:[NSNull class]] || !user.city ? @"": user.city;
		NSString *state = [user.state isKindOfClass:[NSNull class]] || !user.state ? @"": user.state;
		cell.lblLocal.text = [NSString stringWithFormat:@"%@ - %@", city, state];
		
        if (user.chatBlocked){
            cell.imvArrow.image = imageBlocked;
            [cell.imvArrow setTintColor:[UIColor lightGrayColor]];
        }
		
		if (user.notReadCount > 0) {
			
			// Create label
			CGFloat fontSize = FONT_SIZE_BUTTON_BOTTOM
			;
			UILabel *label = [[UILabel alloc] init];
			label.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:fontSize];
			label.textAlignment = NSTextAlignmentCenter;
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor redColor];
			
			// Add count to label and size to fit
			label.text = [NSString stringWithFormat:@"%ld", user.notReadCount];
			[label sizeToFit];
			
			// Adjust frame to be square for single digits or elliptical for numbers > 9
			CGRect frame = label.frame;
			frame.size.height += (int)(0.4*fontSize);
			frame.size.width = (user.notReadCount <= 9) ? frame.size.height : frame.size.width + (int)fontSize;
			label.frame = frame;
			
			// Set radius and clip to bounds
			label.layer.cornerRadius = frame.size.height/2.0;
			label.clipsToBounds = true;
			
			// Show label in accessory view and remove disclosure
			cell.accessoryView = label;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		// Count = 0, show disclosure
		else {
			cell.accessoryView = nil;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
        return cell;
    }
	else{
		static NSString *CellIdentifierChat = @"CustomCellOpenedChat";
		
		TVC_ChatPersonItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierChat];
		
		if(cell == nil)
		{
			cell = [[TVC_ChatPersonItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierChat];
		}
		
		[cell updateLayout];
		cell.imvArrow.image = nil;
		
		User *user = [chatSpeaker objectAtIndex:indexPath.row];
		//
		cell.lblTitle.text = user.name;
		cell.lblNote.text = [user.jobRoleDescription isKindOfClass:[NSNull class]] || !user.jobRoleDescription ? @"-": user.jobRoleDescription;
		NSString *city = [user.city isKindOfClass:[NSNull class]] || !user.city ? @"": user.city;
		NSString *state = [user.state isKindOfClass:[NSNull class]] || !user.state ? @"": user.state;
		cell.lblLocal.text = [NSString stringWithFormat:@"%@ - %@", city, state];
		if (user.chatBlocked){
			cell.imvArrow.image = imageBlocked;
			[cell.imvArrow setTintColor:[UIColor lightGrayColor]];
		}
		
		return cell;
	}

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        isGroup = true;
        selectedGroup = [chatGroup objectAtIndex:indexPath.row];
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self performSegueWithIdentifier:@"SegueToChat" sender:nil];
    }
    else if(indexPath.section == 1)
    {
        selectedUser = [chatPerson objectAtIndex:indexPath.row];
        isGroup = false;
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self performSegueWithIdentifier:@"SegueToChat" sender:nil];
    }
	else{
		selectedUser = [chatSpeaker objectAtIndex:indexPath.row];
		isGroup = false;
		self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
		[self performSegueWithIdentifier:@"SegueToChat" sender:nil];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = tableView.frame;

	UIButton *addButton;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
    title.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    title.textColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    imv.backgroundColor = nil;
    imv.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    if(section == 0)
    {
		addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 130, 5, 120, 40)];
		[addButton setImage:[[UIImage imageNamed:@"icon-add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		
		addButton.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
        title.text = NSLocalizedString(@"SECTION_TITLE_GROUP", @"");
        [addButton addTarget:self action:@selector(clickAddGroup) forControlEvents:UIControlEventTouchUpInside];
        imv.image = [[UIImage imageNamed:@"icon-chat-group"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else if(section == 1)
    {
		addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 130, 5, 120, 40)];
		[addButton setImage:[[UIImage imageNamed:@"icon-add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		
        addButton.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
        title.text = NSLocalizedString(@"SECTION_TITLE_CHAT", @"");
        [addButton addTarget:self action:@selector(clickAddSimpleChat) forControlEvents:UIControlEventTouchUpInside];
        imv.image = [[UIImage imageNamed:@"icon-chat-dialogue"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
	else{
		title.text = NSLocalizedString(@"SECTION_TITLE_SPEAKER", @"");
//		[addButton addTarget:self action:@selector(clickAddSimpleChat) forControlEvents:UIControlEventTouchUpInside];
		imv.image = [[UIImage imageNamed:@"icon-chat-dialogue"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	}
	
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 52)];
    headerView.backgroundColor = nil;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    subView.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    [subView addSubview:title];
    [subView addSubview:imv];
    [subView addSubview:addButton];
    [headerView addSubview:subView];
    
    [ToolBox graphicHelper_ApplyShadowToView:subView withColor:[UIColor blackColor] offSet:CGSizeMake(0, 2.0) radius:2.0 opacity:0.25];
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *actions = [NSMutableArray new];
    
    if (indexPath.section == 0){
        //GRUPOS
        UITableViewRowAction *actionLeave = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"ALERT_OPTION_LEAVE", @"") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self leaveGroup:(int)indexPath.row];
        }];
        [actions addObject:actionLeave];
    }else{
        //CONVERSAS
        User *refUser = [chatPerson objectAtIndex:indexPath.row];
        NSString *status;
        UITableViewRowActionStyle style;
        if (refUser.chatBlocked){
            status = NSLocalizedString(@"ALERT_OPTION_CHAT_UNBLOCK", @"");
            style = UITableViewRowActionStyleNormal;
        }else{
            status = NSLocalizedString(@"ALERT_OPTION_CHAT_BLOCK", @"");
            style = UITableViewRowActionStyleDestructive;
        }
        //
        UITableViewRowAction *actionBlock = [UITableViewRowAction rowActionWithStyle:style title:status handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"Block User: %li", (long)indexPath.row);
            [self blockOrUnblockUser:(int)indexPath.row];
        }];
        [actions addObject:actionBlock];
    }
    
    return actions;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)refreshTableView
{
    [self setupData];
}

-(void)setupData
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
        });
        
        //carrega lista de grupos
        [connection getGroupsListForUserID:AppD.loggedUser.userID fromAccountID:AppD.loggedUser.accountID withCompletionHandler:^(NSArray *response, NSError *error) {
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONVERSATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"group_chats"]];
                chatGroup = [NSMutableArray new];
                
                for (NSDictionary *dic in tempResult)
                {
                    //adiciona na lista de grupos
                    [chatGroup addObject:[GroupChat createObjectFromDictionary:dic]];
                }
                
                if (chatGroup.count > 0){
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    chatGroup = [[NSMutableArray alloc] initWithArray:[chatGroup sortedArrayUsingDescriptors:sortDescriptors]];
                }
                
                [tbvChatList reloadData];
                
                if ([connection isConnectionActive])
                {
                    //carrega lista de chat 1x1
                    [connection getPersonalChatListForUserID:AppD.loggedUser.userID fromAccountID:AppD.loggedUser.accountID withCompletionHandler:^(NSDictionary *response, NSError *error) {
                        
                        if (error){
                            
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONVERSATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            
                        }else{
                            
                            NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"single_chat_users"]];
                            chatPerson = [NSMutableArray new];
                            
                            for (NSDictionary *dic in tempResult)
                            {
                                int userID = [[dic valueForKey:@"app_user_id"] intValue];
                                
                                //Adiciona na lista apenas outros usuários:
                                if (userID != AppD.loggedUser.userID){
                                    
                                    User *userAux = [User new];
                                    userAux.accountID = AppD.loggedUser.accountID;
                                    userAux.userID = [[dic valueForKey:@"app_user_id"] intValue];
                                    userAux.name = [dic valueForKey:@"name"];
                                    userAux.email = [dic valueForKey:@"email"];
                                    userAux.urlProfilePic = [dic valueForKey:@"profile_image"];
									userAux.city = [dic valueForKey:@"city"];
									userAux.state = [dic valueForKey:@"state"];
									userAux.jobRoleDescription = [dic valueForKey:@"job_role"];
                                    //status bloqueado vem como texto:
                                    NSString *status = [dic valueForKey:@"status"];
                                    userAux.chatBlocked = [status isEqualToString:@"blocked"];
									userAux.notReadCount = [[dic valueForKey:@"not_read"] integerValue];
                                    //
                                    [chatPerson addObject:userAux];
                                }
                            }
                            
                            if (chatPerson.count > 0){
                                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                chatPerson = [[NSMutableArray alloc] initWithArray:[chatPerson sortedArrayUsingDescriptors:sortDescriptors]];
                            }
                            
                            [tbvChatList reloadData];
                        }
                        
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    }];
					

					[connection getSpeakersChatListForUserID:AppD.loggedUser.userID fromAccountID:AppD.loggedUser.accountID withCompletionHandler:^(NSDictionary *response, NSError *error) {
						
						if (error){
							
							SCLAlertView *alert = [AppD createDefaultAlert];
							[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONVERSATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
							
						}else{
							NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"speakers"]];
							chatSpeaker = [NSMutableArray new];
							
							for (NSDictionary *dic in tempResult)
							{
								User *userAux = [User new];
								userAux.accountID = AppD.loggedUser.accountID;
								userAux.userID = [[dic valueForKey:@"id"] intValue];
								userAux.name = [dic valueForKey:@"first_name"];
								userAux.email = [dic valueForKey:@"email"];
								userAux.urlProfilePic = [dic valueForKey:@"profile_image"];
								userAux.city = [dic valueForKey:@"city"];
								userAux.state = [dic valueForKey:@"state"];
								userAux.jobRoleDescription = [dic valueForKey:@"job_role"];
								//status bloqueado vem como texto:
								NSString *status = [dic valueForKey:@"status"];
								userAux.chatBlocked = [status isEqualToString:@"blocked"];
								userAux.notReadCount = [[dic valueForKey:@"not_read"] integerValue];
								//
								[chatSpeaker addObject:userAux];
							}
							
							if (chatSpeaker.count > 0){
								NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
								NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
								chatSpeaker = [[NSMutableArray alloc] initWithArray:[chatSpeaker sortedArrayUsingDescriptors:sortDescriptors]];
							}
							
							[tbvChatList reloadData];
						}
						
						[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
					}];
					
                }else{
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    //
                    chatGroup = nil;
                    chatPerson = nil;
                    //
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            }
			
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
		
    }else{
		
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)leaveGroup:(int)indexRow
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];

    GroupChat *referenceGroup = [chatGroup objectAtIndex:indexRow];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_LEAVE", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{

        ConnectionManager *connection = [[ConnectionManager alloc] init];

        if ([connection isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
            });

            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
            [dataDic setValue:@(AppD.loggedUser.userID) forKey:@"app_user_id"];
            [dataDic setValue:@(referenceGroup.groupId) forKey:@"group_chat_id"];

            [connection removeUserFromGroupWithParameters:dataDic withCompletionHandler:^(NSDictionary *response, NSError *error) {

                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];

                if (error){

                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_LEAVE_CHAT_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];

                }else{

                    [chatGroup removeObjectAtIndex:indexRow];
                    [tbvChatList reloadData];
                }
            }];

        }else{

            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }];

    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Normal actionBlock:nil];

    [alert showQuestion:self title:NSLocalizedString(@"ALERT_TITLE_LEAVE_CHAT", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_LEAVE_CHAT", @"") closeButtonTitle:nil duration:0.0];
}

- (void)blockOrUnblockUser:(int)indexRow
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
    User *referenceUser = [chatPerson objectAtIndex:indexRow];
    
    NSString *title;
    NSString *messageAlert;
    if (referenceUser.chatBlocked){
        title = NSLocalizedString(@"ALERT_OPTION_CHAT_UNBLOCK", @"");
        messageAlert = NSLocalizedString(@"ALERT_MESSAGE_CHAT_UNBLOCK", @"");
    }else{
        title = NSLocalizedString(@"ALERT_OPTION_CHAT_BLOCK", @"");
        messageAlert = NSLocalizedString(@"ALERT_MESSAGE_CHAT_BLOCK", @"");
    }
    
    [alert addButton:title withType:SCLAlertButtonType_Destructive actionBlock:^{
        
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
            });
            
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
            [dataDic setValue:@(referenceUser.userID) forKey:@"app_user_id"];
            [dataDic setValue:@(AppD.loggedUser.accountID) forKey:@"account_id"];
            
            [connection blockOrUnblockUserWithParamters:dataDic FromUser:AppD.loggedUser.userID blocking:!referenceUser.chatBlocked withCompletionHandler:^(NSDictionary *response, NSError *error) {
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                if (error){
                    
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_LEAVE_CHAT_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }else{
                    User *referenceUser = [chatPerson objectAtIndex:indexRow];
                    referenceUser.chatBlocked = !referenceUser.chatBlocked;
                    [tbvChatList reloadData];
                }
            }];
            
        }else{
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Normal actionBlock:nil];
    
    [alert showQuestion:self title:title subTitle:messageAlert closeButtonTitle:nil duration:0.0];
}

@end
