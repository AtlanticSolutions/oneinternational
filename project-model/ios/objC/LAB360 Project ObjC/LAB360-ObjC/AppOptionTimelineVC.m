//
//  AppOptionTimelineVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AppOptionTimelineVC.h"
#import "AppDelegate.h"
#import "TimelineConfigurationManager.h"
#import "AppOptionItem.h"
#import "AppOptionItemTVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppOptionTimelineVC()<UITableViewDelegate, UITableViewDataSource>

//Data:
@property(nonatomic, strong) TimelineConfigurationManager *timelineManager;
@property(nonatomic, strong) NSMutableArray<AppOptionItem*> *optionsList;

//Layout:
@property(nonatomic, weak) IBOutlet UITableView *tvOptions;

@end

#pragma mark - • IMPLEMENTATION
@implementation AppOptionTimelineVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize timelineManager, optionsList;
@synthesize tvOptions;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timelineManager = [TimelineConfigurationManager newManagerLoadingConfiguration];
    
    tvOptions.delegate = self;
    tvOptions.dataSource = self;
    
    [tvOptions registerNib:[UINib nibWithNibName:@"AppOptionItemTVC" bundle:nil] forCellReuseIdentifier:@"AppOptionItemCell"];
    [tvOptions setTableFooterView:[UIView new]];
    
    [self loadOptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Timeline"];
    
    [tvOptions setAlpha:0.0];
    [tvOptions reloadData];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [tvOptions setAlpha:1.0];
    }];
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

-(IBAction)actionSwitch:(UISwitch*)sender
{
    AppOptionItem *item = [optionsList objectAtIndex:sender.tag];
    item.on = sender.on;
    
    if (sender.tag == 0){
        [timelineManager setStateToAutoPlayVideo:sender.on];
    }else if (sender.tag == 1){
        [timelineManager setStateToStartVideoMuted:sender.on];
    }else if (sender.tag == 2){
        [timelineManager setStateToAutoExpandLongPosts:sender.on];
    }else{
        [timelineManager setStateToVideoCache:sender.on];
    }
    
    [tvOptions reloadData];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return optionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"AppOptionItemCell";
    AppOptionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[AppOptionItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    AppOptionItem *currentItem = [optionsList objectAtIndex:indexPath.row];
    
    [cell setupLayoutForType:AppOptionItemCellTypeSwitch];
    if (currentItem.on){
        cell.lblDescription.text = currentItem.switchableONDescription;
    }else{
        cell.lblDescription.text = currentItem.switchableOFFDescription;
    }
    cell.swtOption.on = currentItem.on;
    cell.swtOption.tag = indexPath.row;
    [cell.swtOption addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];
    
    cell.lblTitle.text = currentItem.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        AppOptionItemTVC *cell = (AppOptionItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            [self resolveOptionSelectionWith:indexPath.row];
            tableView.tag = 0;
        }];
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    [tvOptions setAlpha:0.0];
    [tvOptions reloadData];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [tvOptions setAlpha:1.0];
    }];
}

- (void)loadOptions
{
    optionsList = [NSMutableArray new];
    
    // Vídeos ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSwitchable;
        item.identification = AppOptionItemIdentificationTimeline;
        item.title = @"Vídeos Automáticos";
        item.selectionDescription = @"";
        item.destinationDescription = @"";
        item.switchableONDescription = @"Tocar automaticamente Habilitado";
        item.switchableOFFDescription = @"Tocar automaticamente Desabilitado";
        item.blocked = NO;
        //
        item.on = timelineManager.autoPlayVideos;
        //
        [optionsList addObject:item];
    }
    
    // Iniciar vídeo sem som ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSwitchable;
        item.identification = AppOptionItemIdentificationTimeline;
        item.title = @"Iniciar Vídeo Sem Som";
        item.selectionDescription = @"";
        item.destinationDescription = @"";
        item.switchableONDescription = @"Vídeo mudo Habilitado";
        item.switchableOFFDescription = @"Vídeo mudo Desabilitado";
        item.blocked = NO;
        //
        item.on = timelineManager.startVideoMuted;
        //
        [optionsList addObject:item];
    }
    
    // Expandir Posts ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSwitchable;
        item.identification = AppOptionItemIdentificationTimeline;
        item.title = @"Expandir Posts";
        item.selectionDescription = @"";
        item.destinationDescription = @"";
        item.switchableONDescription = @"Auto expandir posts longos Habilitado";
        item.switchableOFFDescription = @"Auto expandir posts longos Desabilitado";
        item.blocked = NO;
        //
        item.on = timelineManager.autoExpandLongPosts;
        //
        [optionsList addObject:item];
    }
    
    // Video Cache ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSwitchable;
        item.identification = AppOptionItemIdentificationTimeline;
        item.title = @"Video Cache";
        item.selectionDescription = @"";
        item.destinationDescription = @"";
        item.switchableONDescription = @"Cache de vídeos Habilitado";
        item.switchableOFFDescription = @"Cache de vídeos Desabilitado";
        item.blocked = NO;
        //
        item.on = timelineManager.useVideoCache;
        //
        [optionsList addObject:item];
    }
    
}

- (void)resolveOptionSelectionWith:(NSInteger)selectedItemIndex
{
    return;
}

#pragma mark - UTILS (General Use)

@end
