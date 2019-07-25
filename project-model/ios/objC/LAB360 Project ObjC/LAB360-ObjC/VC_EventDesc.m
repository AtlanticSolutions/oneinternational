//
//  VC_EventDesc.m
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import "VC_EventDesc.h"
#import "TVC_SpeakerCell.h"

@interface VC_EventDesc ()

@property (nonatomic, weak) IBOutlet UITableView* tbvEvent;
@property (nonatomic, weak) IBOutlet UIView* viewTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblTitle;

@end

@implementation VC_EventDesc

//controle
@synthesize tbvEvent, viewTitle, lblTitle;

//objeto
@synthesize event;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_MYEVENTS", @"");
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [tbvEvent reloadData];
    [self.view layoutIfNeeded];
    [self updateLayout];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[Answers logCustomEventWithName:@"Acesso a tela Detalhes Eventos" customAttributes:@{}];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if([segue.identifier isEqualToString:@"Segue_Subscribe"])
    {
        VC_EventSubscribe *vc_event = [segue destinationViewController];
        vc_event.event = event;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierSpeaker = @"SpeakerCell";
    static NSString *CellIdentifierDesc = @"CellEventDescription";
    static NSString *CellIdentifierSubscribe = @"CellEventSubscribe";
	
		if(indexPath.row == 0)
		{
			TVC_SpeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSpeaker];
			
			if(cell == nil)
			{
				cell = [[TVC_SpeakerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSpeaker];
			}
			
			cell.lblSpeakerTitle.text = NSLocalizedString(@"LABEL_EVENT_DESC_TITLE_PALES", @"");
			[cell.speakerPhoto setImageWithURL:[NSURL URLWithString:event.speakerPhotoURL] placeholderImage:[[UIImage imageNamed:@"icon-user-default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
			cell.speakerPhoto.tintColor = [UIColor grayColor];
			cell.lblSpeakerName.text = event.speakerName;
			cell.lblSpeakerDescription.text = event.speakerDescription;
			CGSize size = [self returnSizeForText:indexPath.row];
			if(size.height < 20)
			{
				size.height = 20;
			}
			cell.lblSpeakerDescription.frame = CGRectMake(cell.lblSpeakerDescription.frame.origin.x, cell.lblSpeakerDescription.frame.origin.y, size.width, size.height);
			
			
			[cell updateLayout];
			
			return cell;
			
		}
        else if(indexPath.row == 1)
        {
            TVC_EventDescription *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDesc];
			
            if(cell == nil)
            {
                cell = [[TVC_EventDescription alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDesc];
            }
        
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_EVENT_DESC_TITLE_SYNOPSIS", @"");
            cell.lblTexto.text = event.synopsis ;
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            
            [cell updateLayout];
            
            return cell;

        }
        else if(indexPath.row == 2)
        {
            TVC_EventDescription *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDesc];
            
            if(cell == nil)
            {
                cell = [[TVC_EventDescription alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDesc];
            }
            
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_EVENT_DESC_TITLE_DATETIME", @"");
            cell.lblTexto.text = [ToolBox dateHelper_StringFromDate:event.schedule withFormat:TOOLBOX_DATA_BARRA_INFORMATIVA];
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            [cell updateLayout];
            
            return cell;
        }
        else if(indexPath.row == 3)
        {
            TVC_EventDescription *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDesc];
            
            if(cell == nil)
            {
                cell = [[TVC_EventDescription alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDesc];
            }
            
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_EVENT_DESC_TITLE_LOCAL", @"");
            cell.lblTexto.text = event.local;
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            [cell updateLayout];

            return cell;
        }
        else if(indexPath.row == 4)
        {
            TVC_EventSubscribe *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSubscribe];
            
            if(cell == nil){
                cell = [[TVC_EventSubscribe alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSubscribe];
            }
            [cell layoutIfNeeded];
            [cell updateLayout];
            
            //Botão Favoritar Evento
            if(event.userRegistrationStatus != eUserRegistrationStatus_Subscribed){
                [cell.btnSubscribe setTitle:NSLocalizedString(@"BUTTON_TITLE_EVENT_FAVORITE", @"") forState:UIControlStateNormal];
                [cell.btnSubscribe setTitle:NSLocalizedString(@"BUTTON_TITLE_EVENT_FAVORITE", @"") forState:UIControlStateHighlighted];
                //[cell.btnSubscribe addTarget:self action:@selector(clickSubscribe:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [cell.btnSubscribe setTitle:NSLocalizedString(@"BUTTON_TITLE_EVENT_UNFAVORITE", @"") forState:UIControlStateNormal];
                [cell.btnSubscribe setTitle:NSLocalizedString(@"BUTTON_TITLE_EVENT_UNFAVORITE", @"") forState:UIControlStateHighlighted];
            }
            
            //Botão downloads
            [cell.btnDownloads setTitle:NSLocalizedString(@"LABEL_TITLE_EVENT_DOWNLOAD", @"") forState:UIControlStateNormal];
            [cell.btnDownloads setTitle:NSLocalizedString(@"LABEL_TITLE_EVENT_DOWNLOAD", @"") forState:UIControlStateHighlighted];
            //cell.btnDownloads.enabled = false;
            
            return cell;
        }
    
    return [UITableViewCell new];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0){
		return 212 + [self returnSizeForText:indexPath.row].height;
	}
    else if (indexPath.row < 3){
        //Demais linhas
        return [self returnSizeForText:indexPath.row].height + 60;
    }else{
        //Última linha
        return (20.0 + 40.0 + 20.0 + 40.0 + 20.0);
    }
}

- (IBAction)clickSubscribeOrUnsubscribe:(id)sender
{
    if(event.userRegistrationStatus != eUserRegistrationStatus_Subscribed){
        [self clickSubscribe:sender];
    }else{
        [self clickUnsubscribe:sender];
    }
}

-(void)clickSubscribe:(id)sender
{
    NSMutableDictionary* dicData = [[NSMutableDictionary alloc]init];
    [dicData setValue:@(event.eventID) forKey:@"event_id"];
    [dicData setValue:@(AppD.loggedUser.userID) forKey:@"app_user_id"];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        
        [connectionManager sendEventInfoToServerForMasterEventID:AppD.masterEventID withParameters:dicData withCompletionHandler:^(NSDictionary *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUBSCRIBE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            else
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                    
                    event.userRegistrationStatus = eUserRegistrationStatus_Subscribed;
                    [tbvEvent reloadData];
                    
                }];
                
                [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUBSCRIBE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUBSCRIBE_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                
            }
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }

}

-(void)clickUnsubscribe:(id)sender
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        //connectionManager.delegate = self;
        
        NSMutableDictionary* dicData = [[NSMutableDictionary alloc]init];
        [dicData setValue:@(event.eventID) forKey:@"event_id"];
        [dicData setValue:@(AppD.loggedUser.userID) forKey:@"app_user_id"];
        
        [connectionManager removeEventInfoFromServerForMasterEventID:AppD.masterEventID withParameters:dicData withCompletionHandler:^(NSDictionary *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_UPDATE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            else
            {
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                    
                    event.userRegistrationStatus = eUserRegistrationStatus_Cancelled;
                    
                   //[Answers logCustomEventWithName:@"Click em Cancelar Inscrição" customAttributes:@{}];
                    
                    [tbvEvent reloadData];
                    
                }];
                
                [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_DELETE_EVENT_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                
            }
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (IBAction)clickShowDownloads:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Downloads" bundle:[NSBundle mainBundle]];
    VC_DownloadsList *vcDownloads = [storyboard instantiateViewControllerWithIdentifier:@"VC_DownloadsList"];
    [vcDownloads awakeFromNib];
    vcDownloads.menuType = eDownloadListType_EventFiles;
    vcDownloads.event = [event copyObject];
    //
	self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vcDownloads animated:YES];
}

-(void) updateLayout
{
    self.view.backgroundColor = [UIColor clearColor];
    //
    tbvEvent.backgroundColor = [UIColor whiteColor];
    
    viewTitle.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = AppD.styleManager.colorPalette.textDark;
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    lblTitle.text = event.title;
}

-(CGSize) returnSizeForText:(int)index
{
    
     NSString *str;
    
    switch (index) {
		case 0:
			str = event.speakerDescription;
			break;
        case 1:
            str = event.synopsis;
            break;
        case 2:
            str = [ToolBox dateHelper_StringFromDate:event.schedule withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL];
            break;
        case 3:
            str = event.local;
            break;
        case 4:
            str = event.language;
            break;
            
        default:
            break;
    }
    
    CGSize size = [str sizeWithFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS] constrainedToSize:CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;

}


@end
