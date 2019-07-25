//
//  AdAliveFileTransfer.m
//  LAB360-ObjC
//
//  Created by Erico GT on 26/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>
//
#import "AdAliveFileTransferVC.h"
#import "AppDelegate.h"
#import "AdAliveFileManager.h"
#import "LocationService.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AdAliveFileTransferVC()<MFMailComposeViewControllerDelegate>
//Data:
@property (nonatomic, strong) LocationService *locationService;

//Layout:
@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (nonatomic, weak) IBOutlet UIButton *btnReceive;
@property (nonatomic, weak) IBOutlet UITextView *txtMessage;

@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property (nonatomic, weak) IBOutlet UIImageView *imvInstructions;

@end

#pragma mark - • IMPLEMENTATION
@implementation AdAliveFileTransferVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize locationService;
@synthesize btnSend, btnReceive, txtMessage, footerView, lblInstructions, imvInstructions;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: ...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.view.tag == 0){
        [self setupLayout:@"Arquivo AdAlive"];
    }
    
    locationService = [LocationService initAndStartMonitoringLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (AppD.urlFileAdAliveIncoming){
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"Visualizar" withType:SCLAlertButtonType_Question actionBlock:^{
            
            [self openFileFromURL:AppD.urlFileAdAliveIncoming];
            [self setInstructionsMessage:@"Arquivo aberto com sucesso!"];
            
        }];
        [alert addButton:@"Ignorar" withType:SCLAlertButtonType_Neutral actionBlock:^{
            AppD.urlFileAdAliveIncoming = nil;
        }];
        [alert showQuestion:@"Arquivo AdAlive" subTitle:@"Foi detectado um arquivo AdAlive aberto pela aplicação fora desta tela. Deseja visualizar seu conteúdo?" closeButtonTitle:nil duration:0.0];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (locationService){
        [locationService stopMonitoring];
        locationService = nil;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_NEW_URL_ADALIVE_OPENFILE object:nil];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionSendData:(UIButton*)sender
{
    if ([ToolBox textHelper_CheckRelevantContentInString:txtMessage.text]){
        // Teste para abertura de arquivo:
        AdAliveFile *file = [AdAliveFile new];
        file.system.author = AppD.loggedUser.name;
        file.system.date = [ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_LONGA_NORMAL];
        file.system.device = [ToolBox deviceHelper_IdentifierForVendor];
        file.system.os = [NSString stringWithFormat:@"iOS %@", [ToolBox deviceHelper_SystemVersion]];
        file.system.latitude = (locationService.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || locationService.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ? [NSString stringWithFormat:@"%f", locationService.latitude] : @"-");
        file.system.longitude = (locationService.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || locationService.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ? [NSString stringWithFormat:@"%f", locationService.longitude] : @"-");
        //
        AdAliveFileData *item1 = [AdAliveFileData new];
        item1.type = @"dictionary";
        item1.action = @"show_content";
        item1.content = [[NSMutableDictionary alloc] initWithObjectsAndKeys:txtMessage.text, @"message", nil];
        [file.data addObject: item1];
        
        NSURL *url = [AdAliveFileManager temporaryFileForData:file];
        //
        [self sendMailWithSubject:@"Arquivo AdAlive" attachmentURL:url];
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Ops..." subTitle:@"Por favor, insira um conteúdo relevante para criação do arquivo AdAlive." closeButtonTitle:@"OK" duration:0.0];
    }
}

- (IBAction)actionReceiveData:(UIButton*)sender
{
    if (sender.tag == 0){
        //pronto para receber
        sender.tag = 1;
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
            [btnSend setEnabled:NO];
            [btnReceive setTitle:@"Interromper" forState:UIControlStateNormal];
            [txtMessage setEditable:NO];
            [txtMessage setText:@""];
            [self setInstructionsMessage:@"Aguardando abertura de arquivo..."];
            //
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNewFileAdAlive:) name:SYSNOT_NEW_URL_ADALIVE_OPENFILE object:nil];
        }];
        [alert showInfo:@"Receber Arquivo" subTitle:@"A partir deste momento o conteúdo dos arquivos com extensão 'adAlive' abertos pela aplicação será exibido nesta tela." closeButtonTitle:nil duration:0.0];
        
    }else{
        //pronto para enviar
        sender.tag = 0;
        
        [btnSend setEnabled:YES];
        [btnReceive setTitle:@"Receber" forState:UIControlStateNormal];
        [txtMessage setEditable:YES];
        [txtMessage setText:@""];
        [self setInstructionsMessage:@"Insira um texto para criar o arquivo adAlive ou selecione a opção para receber."];
        //
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_NEW_URL_ADALIVE_OPENFILE object:nil];
    }
}

- (void)actionNewFileAdAlive:(NSNotification*)notification
{
    NSURL *url = (NSURL*)notification.object;
    //
    [self openFileFromURL:url];
}

- (void)openFileFromURL:(NSURL*)url
{
    if (url){
        AdAliveFile *file = [AdAliveFileManager loadFileFromDirectoryPath:url withName:nil];
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableString *str = [NSMutableString new];
            [str appendString:@"======================\n"];
            [str appendString:@"Conteúdo da mensagem:\n\n"];
            for (AdAliveFileData *d in file.data){
                [str appendFormat:@"%@\n", [d.content valueForKey:@"message"]];
            }
            [str appendString:@"\n======================\n"];
            [str appendString:@"Estrutura completa do arquivo:\n\n"];
            [str appendFormat:@"%@\n", [file dictionaryJSON]];
            [str appendString:@"\n======================\n"];
            
            txtMessage.text = str;
            //
            [self setInstructionsMessage:@"Arquivo recebido!"];
        });
        //
        AppD.urlFileAdAliveIncoming = nil;
    }
}

- (void)sendMailWithSubject:(NSString*)subject attachmentURL:(NSURL*)urlAttachment
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [controller setSubject:subject];
    [controller setToRecipients:@[AppD.loggedUser.email]];
    //
    NSString *htlm =
    @"<html>"
    @"<p class=\"p1\">Este &eacute; um email teste para exporta&ccedil;&atilde;o/importa&ccedil;&atilde;o de arquivo extens&atilde;o <strong>adAlive</strong>.</p>"
    @"<p class=\"p1\">O formato <strong>adAlive</strong>&nbsp;&eacute; capaz de suportar qualquer tipo de objeto, ou m&uacute;ltiplos objetos, utilizados no aplicativo, incluindo comandos complexos, conforme necessidade. Ele pode ser utilizado para compartilhamento de dados, execu&ccedil;&atilde;o de instru&ccedil;&otilde;es espec&iacute;ficas, valida&ccedil;&atilde;o de dados etc.</p>"
    @"<p class=\"p1\">Apenas a aplica&ccedil;&atilde;o <strong>LAB360</strong> &eacute; capaz de interpretar este tipo de arquivo.&nbsp;<img src=\"https://html-online.com/editor/tinymce4_6_5/plugins/emoticons/img/smiley-cool.gif\" alt=\"cool\" /></p>"
    @"<p><strong>&nbsp;</strong></p>"
    @"</html>";
    //
    [controller setMessageBody:htlm isHTML:YES];
    //
    NSData *data = [NSData dataWithContentsOfURL:urlAttachment];
    [controller addAttachmentData:data mimeType:@"application/octet-stream" fileName:@"file.adalive"];
    
    if (controller){
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    //TODO: ver dicas:
    /*
     DICAS:
     > Ao anexar um arquivo 'adalive' lembre-se de setar corretamente o mimeType ('application/octet-stream' é o mais apropriado).
     > Os arquivos abertos pelo app são notificados pelo AppDelegate, método 'application:openURL:options:'.
     > Uma cópia da url fica armazenada na variável 'AppD.urlFileAdAliveIncoming'. Limpe esta variável após consumir os dados da url.
     > Para manter compatibilidade com o Android basta utilizar as mesmas características definidas no plist (ver campos 'Document Types' e 'Exported Type UTIs').
     */
    
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error;
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent){
            [self setInstructionsMessage:@"Arquivo enviado com sucesso!"];
        }else{
            [self setInstructionsMessage:@"Insira um texto para criar o arquivo adAlive ou selecione a opção para receber."];
        }
    }];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    btnSend.backgroundColor = [UIColor clearColor];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSend.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnSend setTitle:@"Enviar" forState:UIControlStateNormal];
    [btnSend setExclusiveTouch:YES];
    [btnSend setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSend.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSend setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSend.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnReceive.backgroundColor = [UIColor clearColor];
    [btnReceive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnReceive.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnReceive setTitle:@"Receber" forState:UIControlStateNormal];
    [btnReceive setExclusiveTouch:YES];
    [btnReceive setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReceive.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnReceive setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReceive.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    //TextView
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    //
    NSString *finalString = @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR] range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, finalString.length)];
    //
    txtMessage.attributedText = attributedString;
    [txtMessage setTextColor:AppD.styleManager.colorPalette.textDark];
    [txtMessage.layer setCornerRadius:5.0];
    [txtMessage.layer setBorderWidth:1.0];
    [txtMessage.layer setBorderColor:AppD.styleManager.colorCalendarAvailable.CGColor];
    [txtMessage setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];
    
    //footer
    footerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.50];
    
    lblInstructions.backgroundColor = [UIColor clearColor];
    lblInstructions.textColor = [UIColor whiteColor];
    lblInstructions.text = @"";
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    imvInstructions.backgroundColor = [UIColor clearColor];
    imvInstructions.image = [UIImage imageNamed:@"VirtualSceneInfoIcon"];
    
    [self setInstructionsMessage:@"Insira um texto para criar o arquivo adAlive ou selecione a opção para receber."];
    
    self.view.tag = 1;
}

- (void)setInstructionsMessage:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(),^{
        lblInstructions.text = message;
    });
}

#pragma mark - UTILS (General Use)

@end
