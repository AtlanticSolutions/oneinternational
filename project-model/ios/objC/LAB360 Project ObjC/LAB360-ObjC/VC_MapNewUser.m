//
//  VC_MapNewUser.m
//  GS&MD
//
//  Created by Erico GT on 25/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_MapNewUser.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_MapNewUser()

//Layout:
@property (nonatomic, weak) IBOutlet UITableView *tvDistributors;
@property (nonatomic, weak) IBOutlet MKMapView *mvDistributors;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintTableViewHeight;

//Data:
@property (nonatomic, strong) NSMutableArray *filteredMarkers;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_MapNewUser
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tvDistributors, mvDistributors;
@synthesize markersList, filteredMarkers, constraintTableViewHeight;

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionClose:)];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = @"Distribuidores Próximos";
    
    tvDistributors.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    tvDistributors.alpha = 0.0;
    mvDistributors.alpha = 0.0;
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
    
    [tvDistributors reloadData];
    [mvDistributors showAnnotations:self.markersList animated:YES];
    constraintTableViewHeight.constant = 60.0 * filteredMarkers.count;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
        tvDistributors.alpha = 1.0;
        mvDistributors.alpha = 1.0;
    }];
}

- (void)setMarkersList:(NSArray*)newMarkersList
{
    filteredMarkers = [NSMutableArray new];
    
    if (newMarkersList){
        markersList = newMarkersList;
        for (MapMarker *m in newMarkersList){
            if (m.showInContextList){
                [filteredMarkers addObject:[m copyObject]];
            }
        }
    }else{
        [mvDistributors removeAnnotations:[mvDistributors.annotations mutableCopy]];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)actionClose:(id)sender
{
    long currentIndex = (self.navigationController.viewControllers.count - 1);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(currentIndex - 2)] animated:YES];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (filteredMarkers.count > 3 ? 3 : filteredMarkers.count);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierGroup = @"CustomMapMarkerCell";
    
    TVC_DistributorMap *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup];
    
    if(cell == nil)
    {
        cell = [[TVC_DistributorMap alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGroup];
    }
    
    [cell updateLayout];
    
    MapMarker *marker = [filteredMarkers objectAtIndex:indexPath.row];
    
    cell.lblDistributorName.text = marker.title;
    cell.lblDistributorContact.text = marker.subtitle;
    cell.imvPinMarker.image = marker.pinImage;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapMarker *marker = [filteredMarkers objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TVC_DistributorMap *cell = (TVC_DistributorMap*)[tableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.backgroundNormal];
        //UI - Animação de seleção
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [cell setBackgroundColor:[UIColor clearColor]];
        } completion:nil];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //Ligação para o distribuidor:
        NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:marker.subtitle]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:marker.subtitle]];
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [UIApplication.sharedApplication openURL:phoneUrl];
        } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl];
        }
        //    else {
        //        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        //        [alert showWarning:@"Atenção" subTitle:@"Seu dispositivo não pode fazer ligações para este número." closeButtonTitle:@"OK" duration:0.0];
        //    }
    });
    
}

#pragma mark - MapView

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationIdentifier=@"MapMarkerIdentifier";
    
    if([annotation isKindOfClass:[MapMarker class]])
    {
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        //If one isn't available, create a new one
        if(!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
        }
        
        //Here's where the magic happens (^_^):
        annotationView.image = ((MapMarker*)annotation).pinImage;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Background
    self.view.backgroundColor = [UIColor whiteColor];
    tvDistributors.backgroundColor = nil;
    
}

@end
