//
//  VC_NewChat.m
//  GS&MD
//
//  Created by Lucas Correia on 05/12/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_NewContactChat.h"
#import "GroupChat.h"
#import "CustomLetterViewSectionIndex.h"
#import "TVC_ChatPersonItem.h"
#import "TVC_AssociateItem.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_NewContactChat() <UISearchBarDelegate>
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, strong) GroupChat *selectedGroup;
@property (nonatomic, strong) NSArray *indexTitlesList;
@property (nonatomic, strong) NSArray *filteredList;
@property (nonatomic, strong) CustomLetterViewSectionIndex *letterView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tbvNewChat;
@property (nonatomic, assign) BOOL isSeaching;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_NewContactChat
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize chatList, paramList,tbvNewChat, isGroup;
@synthesize selectedUser, selectedGroup;
@synthesize indexTitlesList, letterView;

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
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_NEW_CHAT", @"");
	
	_filteredList = @[];
    indexTitlesList = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    letterView = [CustomLetterViewSectionIndex createComponent];
    [letterView bindWithTableView:tbvNewChat];
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
    
    if(isGroup)
    {
        [self setupDataGroup];
    }
    else
    {
        [self setupDataSingleChat];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Segue_NewChat"])
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

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.isSeaching){
		return self.filteredList.count;
	}
	
    return chatList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *auxArray;
	if (self.isSeaching){
		auxArray = self.filteredList;
	}
	else{
		auxArray = chatList;
	}
	
	
    if (isGroup){
        
        static NSString *CellIdentifier = @"CustomCellDepartment";
        
        TVC_AssociateItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[TVC_AssociateItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell updateLayout];
        
        cell.imvArrow.image = [UIImage imageNamed:@"icon-checkmark"];
        cell.imvArrow.alpha = 0.0;
        
        GroupChat *group = [auxArray objectAtIndex:indexPath.row];
        cell.lblTitle.text = group.groupName;
        
        for (GroupChat* grupo in paramList) {
            if(group.groupId == grupo.groupId)
            {
                cell.imvArrow.alpha = 1.0;
                break;
            }
        }

        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"CustomCellDepartment2";
        
        TVC_ChatPersonItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[TVC_ChatPersonItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell updateLayout];
        
        cell.imvArrow.image = [UIImage imageNamed:@"icon-checkmark"];
        cell.imvArrow.alpha = 0.0;

        User *user = [auxArray objectAtIndex:indexPath.row];
        cell.lblTitle.text = user.name;
		cell.lblNote.text = [user.jobRoleDescription isKindOfClass:[NSNull class]] || !user.jobRoleDescription ? @"-": user.jobRoleDescription;
		//
		if (user.city == nil || [user.city isEqualToString:@""]){
			if (user.state == nil || [user.state isEqualToString:@""]){
				cell.lblLocal.text = @"-";
			}else{
				cell.lblLocal.text = user.state;
			}
		}else{
			if (user.state == nil || [user.state isEqualToString:@""]){
				cell.lblLocal.text = user.city;
			}else{
				cell.lblLocal.text = [NSString stringWithFormat:@"%@ - %@", user.city, user.state];
			}
		}
		
        for (User* auxUser in paramList) {
            if(auxUser.userID == user.userID)
            {
                cell.imvArrow.alpha = 1.0;
                break;
            }
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSArray *auxArray;
	if (self.isSeaching){
		auxArray = self.filteredList;
	}
	else{
		auxArray = chatList;
	}
	
    //Animação de seleção
    TVC_AssociateItem *cell = (TVC_AssociateItem*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            nil;
        }];
    });
    
    if(isGroup)
    {
        selectedGroup = [auxArray objectAtIndex:indexPath.row];
        
        bool inscrever = true;
        
        for (GroupChat *chat in paramList){
            
            if (selectedGroup.groupId == chat.groupId){
                inscrever = false;
                break;
            }
        }
        
        if (inscrever){
            
            ConnectionManager *connection = [[ConnectionManager alloc] init];
            
            if ([connection isConnectionActive])
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
                });
                
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                [dataDic setValue:@(AppD.loggedUser.userID) forKey:@"app_user_id"];
                [dataDic setValue:@(selectedGroup.groupId) forKey:@"group_chat_id"];
                
                [connection addUserToGroupWithParameters:dataDic withCompletionHandler:^(NSDictionary *response, NSError *error) {
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    
                    if (error){
                        
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GROUP_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        
                    }else{
                        
                        [paramList addObject:[selectedGroup copyObject]];
                        [tbvNewChat reloadData];
                        //
                        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self performSegueWithIdentifier:@"Segue_NewChat" sender:nil];
                    }
                }];
                
            }else{
                
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }
    }
    else
    {
        selectedUser = [auxArray objectAtIndex:indexPath.row];
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self performSegueWithIdentifier:@"Segue_NewChat" sender:nil];
    }
}

//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return indexTitlesList;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    for (int i=0; i<chatList.count; i++){
//        NSString *str = nil;
//        if(isGroup){
//            str = ((GroupChat*)[chatList objectAtIndex:i]).groupName;
//        }else{
//            str = ((User*)[chatList objectAtIndex:i]).name;
//        }
//        
//        if ([str hasPrefix:title]){
//            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//            break;
//        }
//    }
//    //
//    CGFloat totalItens = indexTitlesList.count;
//    CGFloat actualIndex = 0;
//    for (int i=0; i<indexTitlesList.count; i++){
//        NSString *str = [indexTitlesList objectAtIndex:i];
//        if ([str isEqualToString:title]){
//            actualIndex = i;
//            break;
//        }
//    }
//    
//    CGFloat sobra = (tbvNewChat.frame.size.height - 363)/2;
//    CGFloat minPosition = tbvNewChat.frame.origin.y + sobra;
//    CGFloat maxPosition = minPosition + tbvNewChat.frame.size.height - (sobra*2);
//    CGFloat proportion = actualIndex / totalItens;
//    CGFloat finalPosition = ((maxPosition - minPosition) * proportion) + minPosition;
//    [letterView showWithLetter:title position:finalPosition];
//    //
//    return [indexTitlesList indexOfObject:title];
//}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
	
	//SearchBar
	self.searchBar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
	self.searchBar.tintColor = [UIColor whiteColor];
    //Para mudar a cor do botão do searchBar sem mudar o cursor:
    for ( UIView *v in [self.searchBar.subviews.firstObject subviews] )
    {
        if ( YES == [v isKindOfClass:[UITextField class]] )
        {
            [((UITextField*)v) setTintColor:[UIColor darkGrayColor]];
            break;
        }
    }
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
}

-(void) setupDataGroup
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connection getAllGroupsFromAccountID:AppD.loggedUser.accountID withCompletionHandler:^(NSArray *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GROUP_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"group_chats"]];
                chatList = [NSMutableArray new];
                
                for (NSDictionary *dic in tempResult){
                    [chatList addObject:[GroupChat createObjectFromDictionary:dic]];
                }
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                chatList = [[NSMutableArray alloc] initWithArray:[chatList sortedArrayUsingDescriptors:sortDescriptors]];
                
                [tbvNewChat reloadData];
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void) setupDataSingleChat
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connection getAllUsersFromAccountID:AppD.loggedUser.accountID forUser:AppD.loggedUser.userID withCompletionHandler:^(NSArray *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONTACTS_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"app_users"]];
                chatList = [NSMutableArray new];
                
                for (NSDictionary *dic in tempResult){
                    User *userAux = [User createObjectFromDictionary:dic];
                    if (userAux.userID != AppD.loggedUser.userID){
                        [chatList addObject:[User createObjectFromDictionary:dic]];
                    }
                }
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                chatList = [[NSMutableArray alloc] initWithArray:[chatList sortedArrayUsingDescriptors:sortDescriptors]];
                
                [tbvNewChat reloadData];
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - Search delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
	self.isSeaching = YES;
	searchBar.showsCancelButton = YES;
	self.filteredList = chatList;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	
	self.isSeaching = NO;
	searchBar.text = @"";
	searchBar.showsCancelButton = NO;
	[tbvNewChat reloadData];
	[searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	
	[searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	
	if([searchText isEqualToString:@""]){
		self.filteredList = chatList;
	}
	else{
		NSPredicate *predicateString;
		if (isGroup) {
			predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"groupName", searchText];//keySelected is NSString itself
		}
		else{
			predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@", @"name", searchText, @"jobRoleDescription", searchText];//keySelected is NSString itself
		}
		self.filteredList = [chatList filteredArrayUsingPredicate:predicateString];
	}
	
	[tbvNewChat reloadData];
}


@end
