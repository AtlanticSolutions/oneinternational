//
//  VC_DropList.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 07/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_DropList.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_DropList()

@property (nonatomic, strong) id selectedItem;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_DropList
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tbvDrop;
@synthesize dropList, userDropList;
@synthesize isState;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;

    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
	
    if (self.screenTitle){
        self.navigationItem.title = self.screenTitle;
    }else{
        self.navigationItem.title = NSLocalizedString(@"PLACEHOLDER_ROLE", @"");
    }
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
    [tbvDrop reloadData];
}


#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.user != nil){
        return userDropList.count;
    }else{
        return dropList.count;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellAssociateItem";
    
    TVC_AssociateItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_AssociateItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell updateLayout];
	
	
	NSString *text;
	if (isState) {
		text = [dropList objectAtIndex:indexPath.row];
	}
	else{
        
        if (self.user != nil){
            NSDictionary *dicItem = [userDropList objectAtIndex:indexPath.row];
            text = [dicItem objectForKey:@"description"];
        }else{
            text = [dropList objectAtIndex:indexPath.row];
        }
	}
	
    cell.imvArrow.image = [UIImage imageNamed:@"icon-checkmark"];
    if(isState)
    {
        cell.imvArrow.alpha = 0.0;
    }
    else
    {
        if([[dropList objectAtIndex:indexPath.row] isEqual:self.selectedItem])
        {
            cell.imvArrow.alpha = 1.0;
        }
        else
        {
            cell.imvArrow.alpha = 0.0;
        }
    }
	
	cell.lblTitle.text = text;
	
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVC_AssociateItem *cell = (TVC_AssociateItem*)[tableView cellForRowAtIndexPath:indexPath];
//    if(isSector)
//    {
        //Animação de seleção
        
	[cell.contentView setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
	
	dispatch_async(dispatch_get_main_queue(),^{
		[UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
			[cell.contentView setBackgroundColor:[UIColor clearColor]];
		} completion:^(BOOL finished) {
			nil;
		}];
	});

    if (self.user != nil){
        
        self.selectedItem = [userDropList objectAtIndex:indexPath.row];
        
        if (isState) {
            self.user.state = (NSString *)self.selectedItem;
        }else{
            NSDictionary *dicData = (NSDictionary *)self.selectedItem;
            NSNumber *jobId = [NSNumber numberWithLong:[[dicData objectForKey:@"id"] longValue]];
            self.user.jobRole = jobId;
        }
    }else{
        
        if([self.dropListDelegate respondsToSelector:@selector(dropListProtocolDidSelectItem:atIndex:)]) {
            [self.dropListDelegate dropListProtocolDidSelectItem:(NSString*)[dropList objectAtIndex:indexPath.row] atIndex:indexPath.row];
        }
    }
	
	[self.navigationController popViewControllerAnimated:true];
//    }
//    else
//    {
//        if(dropList[indexPath.row].selected == true)
//        {
//            dropList[indexPath.row].selected = false;
//            cell.imvArrow.alpha = 0.0;
//        }
//        else
//        {
//            dropList[indexPath.row].selected = true;
//            cell.imvArrow.alpha = 1.0;
//        }
//        
//    }
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
    
}

@end

