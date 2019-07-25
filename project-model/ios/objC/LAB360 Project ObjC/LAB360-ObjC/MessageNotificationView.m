//
//  MessageNotificationView.m
//  AHK-100anos
//
//  Created by Erico GT on 11/14/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "MessageNotificationView.h"

@interface MessageNotificationView()

@property (nonatomic, assign) bool isConfigured;
@property (nonatomic, assign) bool isShowing;
@property (nonatomic, assign) bool needHide;
@property (nonatomic, strong) ChatMessage *chatMessageObject;
@property (nonatomic, strong) UIImage *imageChat;
@property (nonatomic, strong) UIImage *imageMegaphone;

@end

@implementation MessageNotificationView

@synthesize isConfigured, isShowing, chatMessageObject, needHide;
@synthesize contentView, imvIcon, lblTitle, lblMessage;
@synthesize imageChat, imageMegaphone;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)configureLayout
{
    isConfigured = true;
    isShowing = false;
    needHide = true;
    chatMessageObject = nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    contentView.backgroundColor = AppD.styleManager.colorPalette.primaryButtonNormal;
    
    imvIcon.backgroundColor = [UIColor clearColor];
    imageChat = [[UIImage imageNamed:@"icon-button-chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageMegaphone = [[UIImage imageNamed:@"icon-button-megaphone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvIcon.tintColor = [UIColor whiteColor];//AppD.styleManager.colorButtonText;
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS];
    lblTitle.textColor = [UIColor whiteColor];//AppD.styleManager.colorButtonText;
    
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS];
    lblMessage.textColor = [UIColor whiteColor];//AppD.styleManager.colorButtonText;
    
    CGFloat height = 86.0;
    self.frame = CGRectMake(0, -height, self.frame.size.width, height);
    
    [ToolBox graphicHelper_ApplyShadowToView:self.contentView withColor:[UIColor blackColor] offSet:CGSizeMake(2, 2) radius:4.0 opacity:0.5];

    self.alpha = 0.0;
}

-(IBAction)clickInNotification:(id)sender
{
    isShowing = true;
    needHide = false;
    
    [AppD.soundManager speakText:@" "];
    
    if (chatMessageObject){
        
        [self.contentView setBackgroundColor:AppD.styleManager.colorPalette.backgroundLight];
        dispatch_async(dispatch_get_main_queue(),^{
            [UIView animateWithDuration:ANIMA_TIME_SUPER_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
				
				if (chatMessageObject.auxAlert == nil){
					//vermelho (mensagens chat)
					[self.contentView setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
				}else{
					//azul (propagandas...)
					[self.contentView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:166.0/255.0 blue:233.0/255.0 alpha:1.0]];
				}
				
            } completion:^(BOOL finished) {
                nil;
            }];
        });
		
		if (chatMessageObject.auxAlert != nil){
			
            NSLog(@"chatMessageObject.auxAlert.targetName: %@", chatMessageObject.auxAlert.targetName);
            
            //TODO: ericogt (17/04/2018) >> Pelo chatMessageObject.auxAlert.targetName pode-se analisar um conteúdo específico, para, por exemplo, destinar o usuário a uma tela do app.
            
            /*
			if (AppD.rootViewController && chatMessageObject.auxAlert.showInScreen){
				
				//Abrindo a tela de 'pesquisa':
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
				ProductViewController *productController = (ProductViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
				productController.dicProductData = nil;
				productController.showBackButton = YES;
				productController.targetName = chatMessageObject.auxAlert.targetName;
				productController.executeAutoLaunch = YES;
				
				[productController awakeFromNib];
				//
				UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
				topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
				topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
				//
				//Abrindo a tela
				[AppD.rootViewController.navigationController pushViewController:productController animated:YES];
				
				//Readaptando a lista de controllers:
				NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
				NSMutableArray *listaF = [NSMutableArray new];
				[listaF addObject:[listaC objectAtIndex:0]];
				[listaF addObject:[listaC objectAtIndex:1]];
				[listaF addObject:productController];
				
				//Carregando dados
				AppD.rootViewController.navigationController.viewControllers = listaF;
			}
             */
			
		}else{
		
			if (AppD.rootViewController && ![[AppD.rootViewController.navigationController topViewController] isKindOfClass:[VC_Chat class]]){
				
				if (![[AppD.rootViewController.navigationController topViewController] isKindOfClass:[VC_Chat class]]){
					
					if ([[AppD.rootViewController.navigationController topViewController] isKindOfClass:[VC_ContactsChat class]]){
						
						UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
						VC_Chat *vcChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_Chat"];
						[vcChat awakeFromNib];
						//
						if (chatMessageObject.messageType == eChatMessageType_Single){
							vcChat.chatType = eChatScreenType_Single;
							//
							User *rUser = [User new];
							rUser.userID = chatMessageObject.userID;
							rUser.name = chatMessageObject.userName;
							vcChat.outerUser = rUser;
						}else if(chatMessageObject.messageType == eChatMessageType_Group){
							vcChat.chatType = eChatScreenType_Group;
							//
							GroupChat *rGroup = [GroupChat new];
							rGroup.groupId = chatMessageObject.outerGroupID;
							rGroup.groupName = chatMessageObject.chatName;
							vcChat.receiverGroup = rGroup;
						}
						//
						UIViewController *vc = [AppD.rootViewController.navigationController topViewController];
						vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
						vc.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
						//Abrindo a tela
						[vc.navigationController pushViewController:vcChat animated:YES];
						
					}else{
						
						UIViewController *vc = [AppD.rootViewController.navigationController topViewController];
						vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
						vc.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
						//==============================================================================================
						//Readaptando a lista de controllers para que o voltar seja para a tela de grupos:
						UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
						VC_ContactsChat *vcContactChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_ContactsChat"];
						[vcContactChat awakeFromNib];
						//
						[vc.navigationController pushViewController:vcContactChat animated:NO];
						
						//==============================================================================================
						//Tela de chat:
						//UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
						VC_Chat *vcChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_Chat"];
						[vcChat awakeFromNib];
						
						if (chatMessageObject.messageType == eChatMessageType_Single){
							
							vcChat.chatType = eChatScreenType_Single;
							//
							User *oUser = [User new];
							oUser.userID = chatMessageObject.userID;
							oUser.name = chatMessageObject.userName;
							vcChat.outerUser = oUser;
							//Group = null
							vcChat.receiverGroup = nil;
							
						}else if(chatMessageObject.messageType == eChatMessageType_Group){
							
							vcChat.chatType = eChatScreenType_Group;
							//
							GroupChat *gChat = [GroupChat new];
							gChat.groupId = chatMessageObject.outerGroupID;
							gChat.groupName = chatMessageObject.chatName;
							vcChat.receiverGroup = gChat;
							//User = null
							vcChat.outerUser = nil;
						}
						
						UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
						topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
						topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
						//
						[topVC.navigationController pushViewController:vcChat animated:NO];
					}
				}
			}
		}
    }
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction  animations:^{
        self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
        isShowing = false;
        [self removeFromSuperview];
    }];
}

- (void)showMessageNotificationWithTitle:(NSString*)title andMessage:(NSString*)message object:(ChatMessage*)messageObject
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSLog(@"UIInterfaceOrientation: %li", orientation);
    
    /*
    1 - UIInterfaceOrientation orientation = self.interfaceOrientation; returns UIInterfaceOrientation, current orientation of the interface. It is a property in UIViewController, you can access to this one only in UIViewController classes.
    2 - UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation]; returns UIInterfaceOrientation, current orientation of the application's status bar. You can access to that property in any point of your application. My experience shows that this is the most effective way to retrieve real interface orientation.
    3 - UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation]; returns UIDeviceOrientation, device orientation. You can access to that property in any point of your application. But note that UIDeviceOrientation is not always UIInterfaceOrientation. For example, when your device is on a plain table you can receive unexpected value.
    */
    
    if (isConfigured && !isShowing && (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)){
        
        [AppD.window addSubview:self];
        
        self.userInteractionEnabled = true;
        isShowing = true;
        needHide = true;
        
        self.alpha = 1.0;
        self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self.superview bringSubviewToFront:self];
        
        lblTitle.text = title;
        lblMessage.text = message;
        chatMessageObject = messageObject ? [messageObject copyObject] : nil;
        
        __block double extraTime = 0.0;
        
        if (chatMessageObject != nil && chatMessageObject.auxAlert == nil){
            //vermelho (mensagens chat)
            contentView.backgroundColor = AppD.styleManager.colorPalette.primaryButtonNormal;
            imvIcon.image = imageChat;
        }else{
            //azul (propagandas...)
            contentView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:166.0/255.0 blue:233.0/255.0 alpha:1.0];
            imvIcon.image = imageMegaphone;
            extraTime += 2.0;
        }
        
//#if DEBUG
        [AppD.soundManager playSound:SoundMediaNameSuccess withVolume:1.0];
//#endif
        
#if DEBUG
        [AppD.soundManager speakText:message];
#endif
        
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(0, 0 + 20, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((3.0 + extraTime) * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                if (needHide){
                    [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                    } completion:^(BOOL finished) {
                        self.alpha = 0.0;
                        isShowing = false;
                        [self removeFromSuperview];
                    }];
                }
            });
        }];
    }
}

@end
