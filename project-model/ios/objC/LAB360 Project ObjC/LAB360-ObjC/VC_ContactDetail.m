//
//  VC_ContactDetail.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 25/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_ContactDetail.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_ContactDetail()

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_ContactDetail
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tbvDetail;
@synthesize selectedContact;

#pragma mark - • CLASS METHODS


#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Button Profile Pic
//    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = selectedContact.department;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tbvDetail reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[Answers logCustomEventWithName:@"Acesso a tela Detalhes do Contato" customAttributes:@{}];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)clickFacebook:(id)sender
{
    if (selectedContact.facebook != nil && ![selectedContact.facebook isEqualToString:@""]){
        
        //[Answers logShareWithMethod:@"Facebook" contentName:@"Contato" contentType:@"Perfil" contentId:@"" customAttributes:@{}];
        
        [ToolBox graphicHelper_ApplyRippleEffectAnimationInView:sender withColor:AppD.styleManager.colorPalette.primaryButtonNormal andRadius:0.0];
        //
        NSURL *url = [NSURL URLWithString:@"fb://"];
        BOOL canOpenFacebookApp = [[UIApplication sharedApplication] canOpenURL:url];
        
        if (canOpenFacebookApp){
            url = [NSURL URLWithString:selectedContact.facebook];
            [[UIApplication sharedApplication] openURL:url];
        }else{
            url = [NSURL URLWithString:selectedContact.facebook];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
-(IBAction)clickTwitter:(id)sender
{
    if (selectedContact.twitter != nil && ![selectedContact.twitter isEqualToString:@""])
    {
        //[Answers logShareWithMethod:@"Twitter" contentName:@"Contato" contentType:@"Perfil" contentId:@"" customAttributes:@{}];
        
        [ToolBox graphicHelper_ApplyRippleEffectAnimationInView:sender withColor:AppD.styleManager.colorPalette.primaryButtonNormal andRadius:0.0];
        //
        NSString *string = [NSString stringWithFormat:@"%@", selectedContact.twitter];
        NSURL *url = [NSURL URLWithString:string];
        BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
        
        if (canOpenURL)
        {
            url = [NSURL URLWithString:selectedContact.twitter];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(IBAction)clickLinkedIn:(id)sender
{
    if (selectedContact.linkedin != nil && ![selectedContact.linkedin isEqualToString:@""])
    {
        //[Answers logShareWithMethod:@"LinkedIn" contentName:@"Contato" contentType:@"Perfil" contentId:@"" customAttributes:@{}];
        
        [ToolBox graphicHelper_ApplyRippleEffectAnimationInView:sender withColor:AppD.styleManager.colorPalette.primaryButtonNormal andRadius:0.0];
        //
       
        NSString *string = [NSString stringWithFormat:@"%@", selectedContact.linkedin];
        NSURL *url = [NSURL URLWithString:string];
         BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
        
        if (canOpenURL)
        {
            url = [NSURL URLWithString:selectedContact.linkedin];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7; //Atributos fixos para exibição
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 160;
        
    }
    if (indexPath.row == 6)
    {
        return 80;
    }
    else
    {
        return [self returnSizeForText:indexPath.row].height + 60;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierPhoto = @"CustomCellProfilePhoto";
    static NSString *CellIdentifierShare = @"CustomCellShare";
    static NSString *CellIdentifierBody = @"CustomCellDescricao";
    
    if (indexPath.row == 6){
        TVC_AssociateShare *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierShare];
        
        if(cell == nil)
        {
            cell = [[TVC_AssociateShare alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierShare];
            //
        }
        [cell updateLayout];
        
        [cell.btnLinkedin addTarget:self action:@selector(clickLinkedIn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnFacebook addTarget:self action:@selector(clickFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTwitter addTarget:self action:@selector(clickTwitter:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    else if(indexPath.row == 0)
    {
        TVC_ProfileImage *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPhoto];
        
        if(cell == nil)
        {
            cell = [[TVC_ProfileImage alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPhoto];
            //
        }
        cell.imgPhoto.image = selectedContact.imgProfile;
        
        [cell updateLayout];
        
        [cell.actInd startAnimating];
        cell.actInd.hidden = false;
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:selectedContact.urlProfileImage] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TVC_ProfileImage *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell){
                            updateCell.imgPhoto.image = image;
                        }
                        
                        [updateCell.actInd stopAnimating];
                        updateCell.actInd.hidden = true;
                    });
                }
            }
        }];
        [task resume];
        
        return cell;
        
    }
    else
    {
        TVC_EventDescription *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierBody];
        
        if(cell == nil)
        {
            cell = [[TVC_EventDescription alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierBody];
        }
        
        if(indexPath.row == 1)
        {
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_CONTACT_DESC_TITLE_NAME", @"");
            cell.lblTexto.text = selectedContact.name;
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            [cell updateLayout];
            
        }
        
        else if(indexPath.row == 2)
        {
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_CONTACT_DESC_TITLE_ROLE", @"");
            cell.lblTexto.text = selectedContact.role;
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            [cell updateLayout];
            
        }
        
        else if(indexPath.row == 3)
        {
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_CONTACT_DESC_TITLE_PHONE", @"");
            cell.lblTexto.text = selectedContact.phone;
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            [cell updateLayout];
            
        }
        
        else if(indexPath.row == 4)
        {
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_CONTACT_DESC_TITLE_EMAIL", @"");
            cell.lblTexto.text = selectedContact.email;
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            [cell updateLayout];
            
        }
        
        else if(indexPath.row == 5)
        {
            cell.lblTitulo.text = NSLocalizedString(@"LABEL_CONTACT_DESC_TITLE_DESCRIPTION", @"");
            cell.lblTexto.text = selectedContact.departmentDescription;
            
            CGSize size = [self returnSizeForText:indexPath.row];
            if(size.height < 20)
            {
                size.height = 20;
            }
            cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
            
            [cell updateLayout];
            
        }

        //Tamanho para o título
        CGSize size = [self returnSizeForText:indexPath.row];
        if(size.height < 20)
        {
            size.height = 20;
        }
        
        cell.lblTexto.frame = CGRectMake(cell.lblTexto.frame.origin.x, cell.lblTexto.frame.origin.y, size.width, size.height);
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4)
    {
        /* create mail subject */
       // NSString *subject = [NSString stringWithFormat:@"Subject"];
        
        /* define email address */
        NSString *mail = [NSString stringWithFormat:@"%@", selectedContact.email];
        
        /* define allowed character set */
        NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
        
        /* create the URL */
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@",
                                                    [mail stringByAddingPercentEncodingWithAllowedCharacters:set]]];
        /* load the URL */
        [[UIApplication sharedApplication] openURL:url];
    }
    else if(indexPath.row == 3)
    {
        NSString *phoneNumber = [selectedContact.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", phoneNumber]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@", phoneNumber]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [UIApplication.sharedApplication openURL:phoneUrl];
        } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl];
        }
        else{
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CALL_PHONE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ERROR_CALL_PHONE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
        
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
    
}

-(CGSize) returnSizeForText:(int)index
{
    NSString *str;
    
    switch (index) {
        case 1:
            str = [NSString stringWithFormat:@"%@", selectedContact.name];
            break;
        case 2:
            str = [NSString stringWithFormat:@"%@", selectedContact.role];
            break;
        case 3:
            str = [NSString stringWithFormat:@"%@", selectedContact.phone];
            break;
        case 4:
            str = [NSString stringWithFormat:@"%@", selectedContact.email];
            break;
        case 5:
            str = [NSString stringWithFormat:@"%@", selectedContact.departmentDescription];
            break;
            
        default:
            break;
    }
    
    CGSize size = [str sizeWithFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS] constrainedToSize:CGSizeMake(self.view.frame.size.width - 40, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
    
}

@end
