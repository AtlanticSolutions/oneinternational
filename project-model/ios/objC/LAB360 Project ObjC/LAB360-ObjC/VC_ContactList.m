//
//  VC_ContactList.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 24/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_ContactList.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_ContactList()

@property (nonatomic, weak) IBOutlet UITableView* tbvDepartment;
@property (nonatomic, strong)  Contact* selectedContact;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_ContactList
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize departmentList, tbvDepartment;
@synthesize selectedContact;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
	[self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_CONTACT", @"");
	
    departmentList = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    //Layout
    [self.view layoutIfNeeded];
    [self setupLayout];
    [tbvDepartment reloadData];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VC_ContactDetail *destViewController = (VC_ContactDetail*)segue.destinationViewController;
    destViewController.selectedContact = [selectedContact copyObject];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[Answers logCustomEventWithName:@"Acesso a tela Lista de contatos" customAttributes:@{}];
}


//tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return departmentList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellDepartment";
    
    TVC_AssociateItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_AssociateItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell updateLayout];
    
    Contact *cont = [departmentList objectAtIndex:indexPath.row];
    cell.lblTitle.text = cont.department;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    selectedContact = [departmentList objectAtIndex:indexPath.row];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"SegueToContactDetail" sender:self];
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
}

-(void) setupData
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
            [connection getContactsListWithCompletionHandler:^(NSArray *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONTACTS_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"departments"]];
                departmentList = [NSMutableArray new];
                
                for (NSDictionary *dic in tempResult){
                    [departmentList addObject:[Contact createObjectFromDictionary:dic]];
                }
                
                if (departmentList.count != 0)
                {
                    
                    [tbvDepartment reloadData];
                }
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

@end
