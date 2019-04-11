//
//  AppOptionRegionMonitoringVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <CoreLocation/CoreLocation.h>
//
#import "AppOptionRegionMonitoringVC.h"
#import "AppOptionGeofenceMapVC.h"
#import "AppDelegate.h"
#import "AppOptionItemTVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppOptionRegionMonitoringVC()<UITableViewDelegate, UITableViewDataSource>
//Data:
@property(nonatomic, strong) NSMutableArray *geofenceList;
@property(nonatomic, strong) NSMutableArray *beaconList;

//Layout:
@property(nonatomic, weak) IBOutlet UITableView *tvMonitoredRegions;
@property(nonatomic, weak) IBOutlet UISegmentedControl *segmentedRegionControl;
@property(nonatomic, strong) UIView *tableHeaderView;
@property(nonatomic, strong) UIBarButtonItem *geofenceBarButton;
//
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

#pragma mark - • IMPLEMENTATION
@implementation AppOptionRegionMonitoringVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize geofenceList, beaconList;
@synthesize tvMonitoredRegions, segmentedRegionControl, tableHeaderView, geofenceBarButton, refreshControl;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tvMonitoredRegions.delegate = self;
    tvMonitoredRegions.dataSource = self;
    
    [tvMonitoredRegions registerNib:[UINib nibWithNibName:@"AppOptionItemTVC" bundle:nil] forCellReuseIdentifier:@"AppOptionItemCell"];
    [tvMonitoredRegions setTableFooterView:[UIView new]];
    
    geofenceBarButton = [self createBarButton];
    
    [self loadMonitoredRegions];
    
    if (geofenceList.count > 0){
        self.navigationItem.rightBarButtonItem = geofenceBarButton;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_MONITORED_REGIONS", @"")];
    
    [tvMonitoredRegions reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([segue.identifier isEqualToString:@"SegueToGeofenceMap"]){
        
        AppOptionGeofenceMapVC *vc = segue.destinationViewController;
        vc.showAppMenu = NO;
        vc.screenName = @"Geofences";
        //
        NSMutableArray *regions = [NSMutableArray new];
        for (CLCircularRegion *r in geofenceList){
            //Removendo o prefixo 'AdAliveGeofence' dos identificadores para não exibir a região 0 (área maior):
            if (![[r.identifier stringByReplacingOccurrencesOfString:@"AdAliveGeofence" withString:@""] isEqualToString:@"0"]){
                [regions addObject:r];
            }
        }
        //
        vc.regionsToShow = regions;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToGeofenceDetail"]){
        
        long index = [((NSNumber*)sender) longValue];
        CLCircularRegion *region = (CLCircularRegion*)[geofenceList objectAtIndex:index];
        //
        AppOptionGeofenceMapVC *vc = segue.destinationViewController;
        vc.showAppMenu = NO;
        vc.screenName = [region identifier];
        //
        vc.regionsToShow = @[region];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)actionSegmentedControl:(UISegmentedControl*)sender
{
    [tvMonitoredRegions reloadData];
    
    if (segmentedRegionControl.selectedSegmentIndex == 0 && geofenceList.count > 0){
        self.navigationItem.rightBarButtonItem = geofenceBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(IBAction)actionShowAllGeofences:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToGeofenceMap" sender:nil];
}

- (IBAction)actionRefreshControl:(id)sender
{
    [self loadMonitoredRegions];
    
    if (segmentedRegionControl.selectedSegmentIndex == 0){
        if (geofenceList.count > 0){
            self.navigationItem.rightBarButtonItem = geofenceBarButton;
        }
    }
    
    [refreshControl endRefreshing];
    
    [tvMonitoredRegions reloadData];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = (UILabel*)[tableHeaderView viewWithTag:1];
    if (label){
        long total = geofenceList.count + beaconList.count;
        if (segmentedRegionControl.selectedSegmentIndex == 0){
            [label setText:[NSString stringWithFormat:@"Geofence: %li   |   Total Regiões: %li",  geofenceList.count, total]];
        }else{
            [label setText:[NSString stringWithFormat:@"Beacon: %li   |   Total Regiões: %li",  beaconList.count, total]];
        }
    }
    return tableHeaderView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segmentedRegionControl.selectedSegmentIndex == 0){
        return geofenceList.count;
    }else{
        return beaconList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"AppOptionItemCell";
    AppOptionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[AppOptionItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    if (segmentedRegionControl.selectedSegmentIndex == 0){
        
        [cell setupLayoutForType:AppOptionItemCellTypeArrow];
        
        CLCircularRegion *geoRegion = [geofenceList objectAtIndex:indexPath.row];
        //
        cell.lblTitle.text = [NSString stringWithFormat:@"Geofence [%@]", geoRegion.identifier];
        cell.lblDescription.text = [NSString stringWithFormat:@"LAT: %f, LONG: %f, R: %.1fm", geoRegion.center.latitude, geoRegion.center.longitude, geoRegion.radius];
        
    }else{
        
        [cell setupLayoutForType:AppOptionItemCellTypeNone];
        
        CLBeaconRegion *beaconRegion = [beaconList objectAtIndex:indexPath.row];
        //
        cell.lblTitle.text = [NSString stringWithFormat:@"Beacon [%@]", beaconRegion.identifier];
        cell.lblDescription.text = [NSString stringWithFormat:@"UUID: %@,\nMajor: %@, Minor: %@", [beaconRegion.proximityUUID UUIDString], beaconRegion.major, beaconRegion.minor];
        
    }
    
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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [segmentedRegionControl setBackgroundColor:[UIColor whiteColor]];
    [segmentedRegionControl setTintColor:AppD.styleManager.colorPalette.primaryButtonSelected];
    //
    UIFont *font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segmentedRegionControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tvMonitoredRegions.frame.size.width, 40.0)];
    tableHeaderView.backgroundColor = [UIColor darkGrayColor];
    //
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, (tvMonitoredRegions.frame.size.width - 20.0), 30.0)];
    lblHeader.tag = 1;
    [lblHeader setBackgroundColor:[UIColor clearColor]];
    [lblHeader setNumberOfLines:2];
    [lblHeader setAdjustsFontSizeToFitWidth:YES];
    [lblHeader setMinimumScaleFactor:0.5];
    lblHeader.textColor = [UIColor whiteColor];
    [lblHeader setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL]];
    [lblHeader setText:@""];
    [tableHeaderView addSubview:lblHeader];
    
    //Refresh Control
    refreshControl = [UIRefreshControl new];
    refreshControl.backgroundColor = nil;
    refreshControl.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    refreshControl.attributedTitle = nil;
    //
    [tvMonitoredRegions addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(actionRefreshControl:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)loadMonitoredRegions
{
    geofenceList = [NSMutableArray new];
    beaconList = [NSMutableArray new];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    for (CLRegion *monRegion in [locationManager monitoredRegions])
    {
        if ([monRegion isKindOfClass:[CLCircularRegion class]]) {
            CLCircularRegion *geoRegion = (CLCircularRegion*)monRegion;
            CLCircularRegion *copyRegion = [[CLCircularRegion alloc] initWithCenter:geoRegion.center radius:geoRegion.radius identifier:geoRegion.identifier];
            //
            [geofenceList addObject:copyRegion];
        }else if ([monRegion isKindOfClass:[CLBeaconRegion class]]) {
            CLBeaconRegion *beaconRegion = (CLBeaconRegion*)monRegion;
            CLBeaconRegion *copyRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconRegion.proximityUUID major:[beaconRegion.major unsignedShortValue] minor:[beaconRegion.minor unsignedShortValue] identifier:beaconRegion.identifier];
            //
            [beaconList addObject:copyRegion];
        }
    }
}

- (void)resolveOptionSelectionWith:(NSInteger)selectedItemIndex
{
    if (segmentedRegionControl.selectedSegmentIndex == 0){
        //Somente abre cercas virtuais do tipo 'geofence'
        [self performSegueWithIdentifier:@"SegueToGeofenceDetail" sender:@(selectedItemIndex)];
    }
}

#pragma mark - UTILS (General Use)

- (UIBarButtonItem*)createBarButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //    if (loggedUser.profilePic){
    //        [userButton setImage:loggedUser.profilePic forState:UIControlStateNormal];
    //        [userButton setImage:loggedUser.profilePic forState:UIControlStateHighlighted];
    //    }else{
    UIImage *img = [[UIImage imageNamed:@"PinMapGeofence"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //    }
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    //[userButton.layer setCornerRadius:16];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionShowAllGeofences:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

@end
