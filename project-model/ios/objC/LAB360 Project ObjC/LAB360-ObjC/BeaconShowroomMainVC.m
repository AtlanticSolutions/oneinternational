//
//  BeaconShowroomMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 12/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BeaconShowroomMainVC.h"
#import "AppDelegate.h"
#import "BeaconShowroomItem.h"
#import "BeaconShowroomShelfVC.h"
#import "BeaconShowroomItemTVC.h"
//
#import "BeaconShowroomDataSource.h"
#import "AdAliveWS.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BeaconShowroomMainVC()<AdAliveWSDelegate>

//Data:
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSMutableArray<BeaconShowroomItem*> *showroomList;
@property(nonatomic, strong) UIImage *placeholderImage;

//Layout:
@property (nonatomic, weak) IBOutlet UILabel *lblEmptyList;
@property (nonatomic, weak) IBOutlet UILabel *lblHeader;
@property (nonatomic, weak) IBOutlet UITableView *tvShowroom;

@end

#pragma mark - • IMPLEMENTATION
@implementation BeaconShowroomMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize isLoaded, showroomList, placeholderImage;
@synthesize lblEmptyList, lblHeader, tvShowroom;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoaded = NO;
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self setupLayout:@"Beacon Showroom"];
        [self loadShowroomListFromServer];
        isLoaded = YES;
    }else{
        if (showroomList.count == 0){
            [self loadShowroomListFromServer];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToShelfVC"]){
        BeaconShowroomShelfVC *vc = segue.destinationViewController;
        vc.currentShowroom = sender;
    }
    
    tvShowroom.tag = 0;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//MARK: UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showroomList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"CellShowroomItem";
    __block BeaconShowroomItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[BeaconShowroomItemTVC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    __block BeaconShowroomItem *item = [showroomList objectAtIndex:indexPath.row];
    
    BOOL showImage = YES;
    
    if ([ToolBox textHelper_CheckRelevantContentInString:item.imageURL]){
        [cell updateLayoutUsingImage:YES];
    }else{
        [cell updateLayoutUsingImage:NO];
        showImage = NO;
    }
    
    cell.lblName.text = item.name;
    cell.lblDetail.text = item.detail;
    
    if (showImage){
        if (item.image){
            cell.imvItemImage.image = item.image;
        }else{
            [cell.activityIndicator startAnimating];
            [cell.imvItemImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.imageURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                item.image = image;
                //
                [cell.activityIndicator stopAnimating];
                cell.imvItemImage.image = image;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [cell.activityIndicator stopAnimating];
                cell.imvItemImage.image = placeholderImage;
            }];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //O toque na célula é tratado desta forma pois a animação e o processo a ser executado ocorrem na main thread, o que impede a execução da animação da forma correta.
    //Controlando por uma variável, impedimos que dois toques seguidos sejam iniciados.
    
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        
        BeaconShowroomItemTVC *cell = (BeaconShowroomItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];

        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion:^(BOOL finished) {
            BeaconShowroomItem *showroom = [showroomList objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"SegueToShelfVC" sender:[showroom copyObject]];
        }];
    }
}



#pragma mark - AdAliveWSDelegate

-(void)didReceiveResponse:(AdAliveWS *)adalivews withSuccess:(NSDictionary *)response{
    
//    NSArray *allKeys = [response allKeys];
//
//    if([allKeys containsObject:@"beacons"]){
//        NSArray *beacons = [response objectForKey:@"beacons"];
//        [self configureBeacons: beacons];
//    }else{
//        [self updateBeaconViewShowingContent:NO];
//        //
//        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//        //
//        [self initiateRefreshDataTimer];
//    }
}

-(void)didReceiveResponse:(AdAliveWS *)adalivews withError:(NSError *)error
{
//    [self updateBeaconViewShowingContent:NO];
//    //
//    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//    //
//    [self initiateRefreshDataTimer];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    [super setupLayout:screenName];
    
    lblEmptyList.text = @"Nenhum showroom foi encontrado para este aplicativo. Por favor, verifique sua conexão ou tente novamente mais tarde.";
    lblEmptyList.textColor = [UIColor grayColor];
    lblEmptyList.backgroundColor = nil;
    lblEmptyList.numberOfLines = 0;
    lblEmptyList.textAlignment = NSTextAlignmentCenter;
    lblEmptyList.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
    
    lblHeader.text = @"Selecione o showroom para monitoramento";
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.backgroundColor = [UIColor grayColor];
    lblHeader.numberOfLines = 0;
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:15];
    
    tvShowroom.backgroundColor = [UIColor whiteColor];
    [tvShowroom setTableFooterView:[UIView new]];
    
    [lblEmptyList setAlpha:0.0];
    [lblHeader setAlpha:0.0];
    [tvShowroom setAlpha:0.0];
    
}

- (void)loadShowroomListFromServer
{
    BeaconShowroomDataSource *ds = [BeaconShowroomDataSource new];

    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });

    [ds getShowroomsFromServerWithCompletionHandler:^(NSMutableArray<BeaconShowroomItem *> * _Nullable data, DataSourceResponse * _Nonnull response) {

        if (response.status == DataSourceResponseStatusSuccess){
            self.showroomList = [[NSMutableArray alloc] initWithArray:data];
            
        }else{
            self.showroomList = [NSMutableArray new];
        }

        [tvShowroom reloadData];
        
        [self updateComponentsVisibility];

    }];
}

- (void)updateComponentsVisibility
{
    if (showroomList.count == 0) {
        [lblHeader setAlpha:0.0];
        [tvShowroom setAlpha:0.0];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [lblEmptyList setAlpha:1.0];
        }];
    }else{
        [lblEmptyList setAlpha:0.0];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [lblHeader setAlpha:1.0];
            [tvShowroom setAlpha:1.0];
        }];
    }
    //
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

@end
