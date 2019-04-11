//
//  VC_Chat.m
//  AHK-100anos
//
//  Created by Erico GT on 11/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Chat.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Chat()

#define MAX_LENGHT_TEXT_VIEW 255

@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (nonatomic, weak) IBOutlet UITextView *txtMessage;
@property (nonatomic, weak) IBOutlet UITableView *tvChat;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewConstraintHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *footerConstraintHeight;
@property (nonatomic, strong) UILabel *lblAux;
//
@property (nonatomic, strong) NSMutableArray<ChatMessage*> *messageList;
@property (nonatomic, strong) NSMutableArray<SectionItemList*> *messageSections;
@property (nonatomic, assign) bool loadingMessages;
@property (nonatomic, assign) bool sendingMessages;
@property (nonatomic, assign) bool firstLoad;
//
@property (nonatomic, strong) NSTimer *timer;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Chat
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize footerView, btnSend, txtMessage, tvChat, lblAux;
@synthesize messageList, loadingMessages, sendingMessages, tableViewConstraintHeight, footerConstraintHeight, messageSections;
@synthesize outerUser, receiverGroup, chatType;
@synthesize timer, firstLoad;

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
	
    
    loadingMessages = false;
    sendingMessages = false;
    firstLoad = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    lblAux = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80, CGFLOAT_MAX)];
    [lblAux setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    lblAux.numberOfLines = 0;
    
    footerConstraintHeight.constant = 50.0;
    tableViewConstraintHeight.constant = AppD.rootViewController.view.frame.size.height - 64.0 - footerConstraintHeight.constant;
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    //Observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageNotification:) name:SYSNOT_CHAT_NEW_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self getMessagesFromServerSinceTimeStamp:0];
    
    if (!AppD.isEnableForRemoteNotifications){
        
        //Temporizador para gets:
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(autoCallToGetMessages) userInfo:nil repeats:YES];
    }
    
    messageList = [NSMutableArray new];
    
    //Screen Name
    if (chatType == eChatScreenType_Single){
        self.navigationItem.title = outerUser.name;
    }else if(chatType == eChatScreenType_Group){
        self.navigationItem.title = receiverGroup.groupName;
    }
    
    [self reloadMessages];
    
    if (outerUser.chatBlocked){
        [btnSend setEnabled:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //Remove Observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_CHAT_NEW_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //Timer
    if (timer){
        [timer invalidate];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)clickSendMessage:(id)sender
{
    NSString *str = txtMessage.text;
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:charSet];
    if (![trimmedString isEqualToString:@""]) {
    
        //Dados da mensagem:
        __block ChatMessage *msg = [ChatMessage new];
        msg.messageID = 0;
        msg.userID = AppD.loggedUser.userID;
        msg.outerUserID = (outerUser ? outerUser.userID : 0);
        msg.outerGroupID = (receiverGroup ? receiverGroup.groupId : 0);
        //
        if (chatType == eChatScreenType_Single){msg.chatName = NSLocalizedString(@"LABEL_TITLE_EVENT_CHAT", @"");}
        else if (chatType == eChatScreenType_Group){msg.chatName = receiverGroup.groupName;}
        //
        msg.userName = AppD.loggedUser.name;
        msg.message = str;
        msg.date = [NSDate date];
        msg.messageStatus = eChatMessageStatus_Sending;
        //
        int code = 0;
        if (chatType == eChatScreenType_Single){code = outerUser.userID;}
        else if (chatType == eChatScreenType_Group){code = receiverGroup.groupId;}
        msg.hash = [ChatMessage createHashForEvent:code andUser:AppD.loggedUser.userID];
        
        //Readequando o layout da tela:
        [messageList addObject:msg];
        txtMessage.text = @"";
        [txtMessage resignFirstResponder];
        [self resolveTextViewHeightForComponent:txtMessage andString:@""];
        [self reloadMessages];
        //SendToServer:
        [self sendMessageToServer:msg];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionItemList *actualSection = [messageSections objectAtIndex:section];
    return actualSection.valueArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return messageSections.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionItemList *actualSection = [messageSections objectAtIndex:indexPath.section];
    ChatMessage *chat = [actualSection.valueArray objectAtIndex:indexPath.row];
    lblAux.text = chat.message;
    CGSize size = [lblAux sizeThatFits:CGSizeMake(lblAux.frame.size.width, MAXFLOAT)];
    CGFloat height = (size.height < 40 ? 40 : size.height);
    //
    return height + 10 + 20 + 10 + 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierPanelist = @"CustomCellPanelist";
    static NSString *CellIdentifierUser = @"CustomCellUser";
    
    SectionItemList *actualSection = [messageSections objectAtIndex:indexPath.section];
    ChatMessage *chat = [actualSection.valueArray objectAtIndex:indexPath.row];
    
    TVC_ChatMessage *cell = nil;
    
    [cell layoutIfNeeded];
    
    if (chat.userID == AppD.loggedUser.userID){
        //SELF
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPanelist];
        if(cell == nil)
        {
            cell = [[TVC_ChatMessage alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPanelist];
        }
        //
        [cell updateLayoutForSender:eChatMessageSender_Self withActivity:chat.messageStatus];
    }else{
        //OTHER
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierUser];
        if(cell == nil)
        {
            cell = [[TVC_ChatMessage alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierUser];
        }
        //
        [cell updateLayoutForSender:eChatMessageSender_Other withActivity:chat.messageStatus];
    }
    
    cell.lblUser.text = chat.userName;
    cell.lblMessage.text = chat.message;
    cell.lblDate.text = [ToolBox dateHelper_StringFromDate:chat.date withFormat:@"HH:mm"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [txtMessage resignFirstResponder];
    
    SectionItemList *item = [messageSections objectAtIndex:indexPath.section];
    ChatMessage *msg = [item.valueArray objectAtIndex:indexPath.row];
    
    if(msg.messageStatus == eChatMessageStatus_Error){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_RESEND", @"") withType:SCLAlertButtonType_Question actionBlock:^{
            
            //RESEND MESSAGE
            txtMessage.text = @"";
            [txtMessage becomeFirstResponder];
            //
            [self resolveTextViewHeightForComponent:txtMessage andString:msg.message];
            
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_DELETE", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
            
            //DELETAR
            int indexToRemove = -1;
            for(int i=0; i < messageList.count; i++){
                ChatMessage *cm = [messageList objectAtIndex:i];
                if (cm == msg){
                    indexToRemove = i;
                    break;
                }
            }
            if(indexToRemove != -1){
                [messageList removeObjectAtIndex:indexToRemove];
            }
            [self reloadMessages];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
            //FECHAR
        }];
        [alert showQuestion:self title:NSLocalizedString(@"ALERT_TITLE_SEND_MESSAGE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SEND_MESSAGE_ERROR", @"") closeButtonTitle:nil duration:0.0];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AppD.rootViewController.view.frame.size.width, 28.0)];
    label.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    label.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    label.textColor = AppD.styleManager.colorPalette.textDark;
    label.textAlignment = NSTextAlignmentCenter;
    //
    SectionItemList *actualSection = [messageSections objectAtIndex:section];
    label.text = [ToolBox dateHelper_IdentifiesYesterdayTodayTomorrowFromDate:[ToolBox dateHelper_DateFromString:actualSection.keyString withFormat:@"ddMMyyyy"]];
    //
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AppD.rootViewController.view.frame.size.width, 38.0)];
    view.backgroundColor=[UIColor clearColor];
    [view addSubview:label];
    //
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38.0;
}

//TEXTVIEW DELEGATE

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Prevent crashing undo bug
    if(range.length + range.location > textView.text.length){
        return NO;
    }
    
    //Max lenght
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (newLength <= MAX_LENGHT_TEXT_VIEW){
        
        NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        UITextView *textAux = [[UITextView alloc] initWithFrame:textView.frame];
        [self resolveTextViewHeightForComponent:textAux andString:finalString];
        return YES;
    }
    
    return NO;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
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
    
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    //Footer
    footerView.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    btnSend.backgroundColor = [UIColor clearColor];
    UIImage *imgNormal = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonNormal andImageTemplate:[UIImage imageNamed:@"icon-button-send"]];
    UIImage *imgSel = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonSelected andImageTemplate:[UIImage imageNamed:@"icon-button-send"]];
    [btnSend setImage:imgNormal forState:UIControlStateNormal];
    [btnSend setImage:imgSel forState:UIControlStateHighlighted];
    
    //TextView
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    
    NSString *finalString = @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS] range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, finalString.length)];
    //
    txtMessage.attributedText = attributedString;
    
    [txtMessage setTextColor:AppD.styleManager.colorPalette.textDark];
    
    [txtMessage.layer setCornerRadius:5.0];
    [txtMessage.layer setBorderWidth:1.0];
    [txtMessage.layer setBorderColor:AppD.styleManager.colorCalendarAvailable.CGColor];
    
    [txtMessage setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];
    
    //TableView
    [tvChat setBackgroundColor:[UIColor clearColor]];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        tableViewConstraintHeight.constant = (self.view.frame.size.height - footerConstraintHeight.constant - kbSize.height);
        [tvChat layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        tableViewConstraintHeight.constant = (self.view.frame.size.height - footerConstraintHeight.constant);
        [tvChat layoutIfNeeded];
    }];
}

- (void)keyboardChangeFrame:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        tableViewConstraintHeight.constant = (self.view.frame.size.height - footerConstraintHeight.constant - kbSize.height);
        [tvChat layoutIfNeeded];
    }];
}

- (void)reloadMessages
{
    //ordenando a lista
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *workList = [[NSMutableArray alloc] initWithArray:[messageList sortedArrayUsingDescriptors:sortDescriptors]];
    
    //Separando a lista em dias:
    messageSections = [NSMutableArray new];
    for (int i=0; i<messageList.count; i++){
        ChatMessage *chatAtual = [workList objectAtIndex:i];
        NSString *dataResumida = [ToolBox dateHelper_StringFromDate:chatAtual.date  withFormat:@"ddMMyyyy"];
        
        bool achou = false;
        
        for (SectionItemList *item in messageSections){
            if ([item.keyString isEqualToString:dataResumida]){
                [item.valueArray addObject:chatAtual];
                achou = true;
                break;
            }
        }
        
        if (!achou){
            SectionItemList *newItem = [SectionItemList new];
            newItem.keyString = dataResumida;
            [newItem.valueArray addObject:chatAtual];
            [messageSections addObject:newItem];
        }
    }
    
    [self reloadTableView];
}

- (void)reloadTableView
{
    [tvChat reloadData];
    
    if(messageList.count > 0){
        dispatch_async(dispatch_get_main_queue(),^{
            if (!tvChat.isDragging && ![txtMessage isFirstResponder]){
                [tvChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([messageSections lastObject].valueArray.count - 1) inSection:(messageSections.count - 1)] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        });
    }
}

- (void)resolveTextViewHeightForComponent:(UITextView*)textView andString:(NSString*)string
{
//    NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    
//    UITextView *textAux = [[UITextView alloc] initWithFrame:textView.frame];
//    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, string.length)];
    //
    textView.attributedText = attributedString;
    
    [textView setFont:[UIFont fontWithName:txtMessage.font.fontName size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [textView setTextColor:AppD.styleManager.colorPalette.textDark];
    
    [textView setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];
    
    CGFloat altura = size.height;
    
    if (altura > 100.0){
        altura = 100.0;
    }else if (altura < 40.0){
        altura = 40.0;
    }
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        CGFloat diferenca = footerConstraintHeight.constant;
        footerConstraintHeight.constant = altura + 10;
        diferenca = footerConstraintHeight.constant - diferenca;
        tableViewConstraintHeight.constant = (tableViewConstraintHeight.constant - diferenca);
        [footerView layoutIfNeeded];
        //
        //NSLog(@"%.2f, %.2f, %.2f, %.2f", textView.textContainerInset.top, textView.textContainerInset.bottom, textView.textContainerInset.right, textView.textContainerInset.left);
    }];
}

#pragma mark - GET/SET MESSAGES

- (void)newMessageNotification:(NSNotification*)notification
{
    ChatMessage *neoMessage = (ChatMessage*)[notification object];
    
    if (neoMessage){
        if (!messageList){
            messageList = [NSMutableArray new];
        }
        [messageList addObject:[neoMessage copyObject]];
        //
        [self reloadMessages];
        //
#if DEBUG
        [AppD.soundManager speakText:[NSString stringWithFormat:@"%@ disse:...\n %@", neoMessage.userName, neoMessage.message]];
#endif
        //
    }else{
        NSLog(@"Erro ao converter mensagem em objeto ou objeto não pertence a tela atual do chat!");
    }
}

- (void)autoCallToGetMessages
{
    NSTimeInterval since = 0;
    if (messageList.count > 0){
        ChatMessage *msg = [messageList lastObject];
        since = [ToolBox dateHelper_TimeStampFromDate:msg.date];
    }
    
    [self getMessagesFromServerSinceTimeStamp:since];
}

#pragma mark -

- (void)getMessagesFromServerSinceTimeStamp:(NSTimeInterval)time
{
    if (firstLoad){
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
        });
    }
    
    if (!loadingMessages){
        if (chatType == eChatScreenType_Single){
            [self getMessagesFromUserSinceTimeStamp:time];
        }else if (chatType == eChatScreenType_Group){
            [self getMessagesFromGroupSinceTimeStamp:time];
        }
    }
}

-(void)setChatToReadWithChatID:(long)chatID{
//	postReadPersonalChat
	ConnectionManager *connection = [[ConnectionManager alloc] init];
	
	if ([connection isConnectionActive])
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		[connection postReadPersonalChat:chatID user:AppD.loggedUser.userID senderUserID:outerUser.userID withCompletionHandler:^(NSDictionary *response, NSError *error) {
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			if (error){
				
				//MARK: Atualmente não faz nada caso dê algum erro ao pegar as mensagens.
				NSLog(@"%@", error.description);
				
			}}];
	}

}

- (void)getMessagesFromUserSinceTimeStamp:(NSTimeInterval)time
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
	
    if ([connection isConnectionActive])
    {
        loadingMessages = true;
		
        NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] init];
        [dicParameters setValue:@"findSingleMessages" forKey:@"action"];
        [dicParameters setValue:@(AppD.loggedUser.accountID) forKey:@"accountId"];
        [dicParameters setValue:@(AppD.loggedUser.userID) forKey:@"userId1"];
        [dicParameters setValue:@(outerUser.userID) forKey:@"userId2"];
        [dicParameters setValue:@(0) forKey:@"total"];
        [dicParameters setValue:@((time_t) (time * 1000)) forKey:@"sendDateNewerMilli"];
		
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
        [connection getMessagesFromSingleChatWithParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
			
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                //MARK: Atualmente não faz nada caso dê algum erro ao pegar as mensagens.
                NSLog(@"%@", error.description);
                
            }else{
                
                if (response){
                    
                    NSDictionary *dicResult = response; //[ToolBox converterHelper_NewDictionaryReplacingPlusSymbolFromDictionary:response];
                    
                    NSString *result = [dicResult valueForKey:@"status"];
                    if (result && [result isEqualToString:@"SUCCESS"]){
                        NSArray *arrayResult = [[NSArray alloc] initWithArray:[dicResult valueForKey:@"messages"]];
                        
                        if (arrayResult.count > 0){
                            
                            if (time == 0){
                                messageList = [NSMutableArray new];
                            }
							
							NSInteger lastMessageID = 0;
                            for (NSDictionary *messageObj in arrayResult){
                                
                                ChatMessage *actualMessage = [ChatMessage createObjectFromDictionary:messageObj];
                                
                                //Bloqueio contra gambiarra do nome não vir no item.
                                if (actualMessage.userID == AppD.loggedUser.userID){
                                    actualMessage.userName = [NSString stringWithFormat:@"%@", AppD.loggedUser.name];
                                }else{
                                    actualMessage.userName = [NSString stringWithFormat:@"%@", outerUser.name];
                                }
                                
                                //Adiciona as mensagens recebidas na lista
								lastMessageID = actualMessage.messageID;
                                [messageList addObject:actualMessage];
                            }
						
						[self setChatToReadWithChatID:lastMessageID];
							
                        }else{
                            
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showInfo:self title:NSLocalizedString(@"LABEL_TITLE_EVENT_CHAT", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CHAT_NO_MESSAGE_TO_SHOW", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                    }else{
                        NSString *errorType = [response valueForKey:@"errorType"];
                        if (errorType && [errorType isEqualToString:@"SINGLE_CHAT_BLOQUED"]){
                            [btnSend setEnabled:NO];
                            [timer invalidate];
                            timer = nil;
                        }
                    }
                }
            }
            
            [self reloadMessages];
            
            if (outerUser.chatBlocked){
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_CHAT_BLOCKED_USER", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CHAT_BLOCKED_USER", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            
            loadingMessages = false;
        }];
    }
}

- (void)getMessagesFromGroupSinceTimeStamp:(NSTimeInterval)time
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        loadingMessages = true;
        
        NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] init];
        [dicParameters setValue:@"findGroupMessages" forKey:@"action"];
        [dicParameters setValue:@(AppD.loggedUser.accountID) forKey:@"accountId"];
        [dicParameters setValue:@(receiverGroup.groupId) forKey:@"groupId"];
        [dicParameters setValue:@(0) forKey:@"total"];
        [dicParameters setValue:@((time_t) (time * 1000)) forKey:@"sendDateNewerMilli"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [connection getMessagesFromSingleChatWithParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                //MARK: Atualmente não faz nada caso dê algum erro ao pegar as mensagens.
                NSLog(@"%@", error.description);
            }else{
                
                if (response){
                    
                    NSDictionary *dicResult = response; //[ToolBox converterHelper_NewDictionaryReplacingPlusSymbolFromDictionary:response];
                    
                    NSString *result = [dicResult valueForKey:@"status"];
                    if (result && [result isEqualToString:@"SUCCESS"]){
                        
                        NSArray *arrayResult = [[NSArray alloc] initWithArray:[dicResult valueForKey:@"messages"]];
                        
                        if (arrayResult.count > 0){
                            
                            if (time == 0){
                                messageList = [NSMutableArray new];
                            }
                            
                            for (NSDictionary *messageObj in arrayResult){
                                
                                ChatMessage *actualMessage = [ChatMessage createObjectFromDictionary:messageObj];
                                //Adiciona as mensagens recebidas na lista
                                [messageList addObject:actualMessage];
                            }
                            
                        }else{
                            
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showInfo:self title:NSLocalizedString(@"LABEL_TITLE_EVENT_CHAT", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CHAT_NO_MESSAGE_TO_SHOW", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                    }
                }
            }
            
            [self reloadMessages];
            
            loadingMessages = false;
        }];
    }
}

#pragma mark - 

- (void)sendMessageToServer:(ChatMessage*)message
{
    if (chatType == eChatScreenType_Single){
        
        [self sendMessageToUser:message];
        
    }else if (chatType == eChatScreenType_Group){
        
        [self sendMessageToGroup:message];
        
    }
}

- (void)sendMessageToUser:(ChatMessage*)message
{
    if ([ToolBox textHelper_CheckRelevantContentInString:message.message]){
        
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            sendingMessages = true;
            
            NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] init];
            
            [dicParameters setValue:@"sendSingleMessage" forKey:@"action"];
            [dicParameters setValue:@(AppD.loggedUser.accountID) forKey:@"accountId"];
            [dicParameters setValue:@(AppD.loggedUser.userID) forKey:@"senderId"];
            [dicParameters setValue:@(outerUser.userID) forKey:@"receiverId"];
            //
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *token = [ud valueForKey:PLISTKEY_PUSH_NOTIFICATION_FIREBASE_TOKEN];
            AppD.tokenFirebase = token ? [NSString stringWithFormat:@"%@", token] : @"";
            [dicParameters setValue:AppD.tokenFirebase forKey:@"deviceId"];
            //
            [dicParameters setValue:message.message forKey:@"message"]; //[message.message stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] forKey:@"message"];
            [dicParameters setValue:message.hash forKey:@"hashRequest"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            NSLog(@"Message Hash: %@", message.hash);
            
            [connection postMessageToSingleChatWithParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                sendingMessages = false;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (message){
                    if (error){
                        
                        //Muda status da mensagem para 'erro'
                        message.messageStatus = eChatMessageStatus_Error;
                    }else{
                        
                        if (response){
                            
                            NSLog(@"Message Hash: %@ / Response Hash: %@", message.hash, [response valueForKey:@"hashRequest"]);
                            
                            NSString *result = [response valueForKey:@"status"];
                            if (result && [result isEqualToString:@"SUCCESS"]){
                                
                                NSDictionary *dicResult = [response valueForKey:@"singleMessage"];
                                
                                if (dicResult){
                                    
                                    NSArray* keysList = [dicResult allKeys];
                                    
                                    if (keysList.count > 0)
                                    {
                                        message.messageID =  [keysList containsObject:@"messageId"] ? [[dicResult valueForKey:@"messageId"] intValue] : message.messageID;
                                        //
                                        message.date = [keysList containsObject:@"sendDate"] ? [NSDate dateWithTimeIntervalSince1970:[[dicResult valueForKey:@"sendDate"] doubleValue]/1000] : message.date;
                                        //Muda status para entregue ('ok')
                                        message.messageStatus = eChatMessageStatus_OK;
                                    }
                                }else{
                                    //Muda status da mensagem para 'erro'
                                    message.messageStatus = eChatMessageStatus_Error;
                                }
                            }else{
                                //Muda status da mensagem para 'erro'
                                message.messageStatus = eChatMessageStatus_Error;
                                
                                NSString *errorType = [response valueForKey:@"errorType"];
                                if (errorType && [errorType isEqualToString:@"SINGLE_CHAT_BLOQUED"]){
                                    [btnSend setEnabled:NO];
                                    [timer invalidate];
                                    timer = nil;
                                }
                            }
                        }else{
                            //Muda status da mensagem para 'erro'
                            message.messageStatus = eChatMessageStatus_Error;
                        }
                    }
                }
                
                [self reloadMessages];
            }];
        }
    }
}

- (void)sendMessageToGroup:(ChatMessage*)message
{
    if ([ToolBox textHelper_CheckRelevantContentInString:message.message]){
        
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            sendingMessages = true;
            
            NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] init];
            
            [dicParameters setValue:@"sendGroupMessage" forKey:@"action"];
            [dicParameters setValue:@(AppD.loggedUser.accountID) forKey:@"accountId"];
            [dicParameters setValue:@(AppD.loggedUser.userID) forKey:@"userId"];
            [dicParameters setValue:@(receiverGroup.groupId) forKey:@"groupId"];
            //
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *token = [ud valueForKey:PLISTKEY_PUSH_NOTIFICATION_FIREBASE_TOKEN];
            AppD.tokenFirebase = token ? [NSString stringWithFormat:@"%@", token] : @"";
            [dicParameters setValue:AppD.tokenFirebase forKey:@"deviceId"];
            //
            [dicParameters setValue:message.message forKey:@"message"]; //[message.message stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] forKey:@"message"];
            [dicParameters setValue:message.hash forKey:@"hashRequest"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            NSLog(@"Message Hash: %@", message.hash);
            
            [connection postMessageToGroupChatWithParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                sendingMessages = false;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (message){
                    if (error){
                        
                        //Muda status da mensagem para 'erro'
                        message.messageStatus = eChatMessageStatus_Error;
                    }else{
                        
                        if (response){
                            
                            NSLog(@"Message Hash: %@ / Response Hash: %@", message.hash, [response valueForKey:@"hashRequest"]);
                            
                            NSString *result = [response valueForKey:@"status"];
                            if (result && [result isEqualToString:@"SUCCESS"]){
                                
                                NSDictionary *dicResult = [response valueForKey:@"message"];
                                
                                if (dicResult){
                                    
                                    NSArray* keysList = [dicResult allKeys];
                                    
                                    if (keysList.count > 0)
                                    {
                                        message.messageID =  [keysList containsObject:@"id"] ? [[dicResult valueForKey:@"id"] intValue] : message.messageID;
                                        //
                                        message.date = [keysList containsObject:@"sendDate"] ? [NSDate dateWithTimeIntervalSince1970:[[dicResult valueForKey:@"sendDate"] doubleValue]/1000] : message.date;
                                        //
                                        //Muda status para entregue ('ok')
                                        message.messageStatus = eChatMessageStatus_OK;
                                    }
                                }else{
                                    //Muda status da mensagem para 'erro'
                                    message.messageStatus = eChatMessageStatus_Error;
                                }
                            }else{
                                //Muda status da mensagem para 'erro'
                                message.messageStatus = eChatMessageStatus_Error;
                            }
                        }else{
                            //Muda status da mensagem para 'erro'
                            message.messageStatus = eChatMessageStatus_Error;
                        }
                    }
                }
                
                [self reloadMessages];
            }];
        }
    }
}

@end
