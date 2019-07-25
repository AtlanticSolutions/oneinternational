//
//  VC_MyEvents.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 24/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_MyEvents.h"
#import "TVC_EventItem.h"
#import "TVC_DayEventItem.h"
#import "Event.h"
#import "VC_EventDesc.h"

#define BAR_CALENDAR 0
#define BAR_LIST 1

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_MyEvents()

//Lista
@property (nonatomic, weak) IBOutlet UIView *viewEventsList;
@property (nonatomic, weak) IBOutlet UITableView *tvEventsList;
//Calendário
@property (nonatomic, weak) IBOutlet UIView *viewEventsCalendar;
@property (weak, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblDateInfo;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) NSDate *dateSelected;
@property (nonatomic, assign) CGFloat calendarContentViewNormalHeight;
@property (nonatomic, assign) CGFloat calendarContentViewWeekHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (nonatomic, weak) IBOutlet UITableView *tvDayEventsList;
@property (nonatomic, weak) IBOutlet UIImageView *imvLineSeparator;
//Segment
@property (nonatomic, weak) IBOutlet UIView *viewSegmentBar;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentBar;
//Rodape
@property (nonatomic, weak) IBOutlet UIView *viewFooter;
@property (nonatomic, weak) IBOutlet UILabel *lblFooter;

//Others
@property (nonatomic, strong) NSMutableArray *eventsList;
@property (nonatomic, strong) NSMutableArray *favoriteList;
@property (nonatomic, strong) NSMutableArray *eventsDayList;
@property (nonatomic, assign) bool isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_MyEvents
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize viewSegmentBar, segmentBar;
@synthesize viewEventsList, tvEventsList;
@synthesize viewEventsCalendar, calendarContentView, calendarMenuView, lblDateInfo, calendarManager, dateSelected, calendarContentViewNormalHeight, calendarContentViewWeekHeight, calendarContentViewHeight, tvDayEventsList, imvLineSeparator;
@synthesize viewFooter, lblFooter;

@synthesize eventsDayList, isLoaded, eventsList, favoriteList;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    isLoaded = false;
        
    //Data selecionada
    dateSelected = nil;
    
    //Listas
    eventsList = [NSMutableArray new];
    eventsDayList = [NSMutableArray new];
    favoriteList = [NSMutableArray new];
	
	//Controll
	viewEventsCalendar.alpha = 1.0;
	tvDayEventsList.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        
        //Layout
        [self.view layoutIfNeeded];
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_AGENDA", @"")];
        
        calendarContentViewNormalHeight = 260.0;
        calendarContentViewWeekHeight = 85.0;
        
        //Calendar setup
        calendarManager = [JTCalendarManager new];
        calendarManager.delegate = self;
        calendarManager.dateHelper.calendar.timeZone = [NSTimeZone defaultTimeZone];
        calendarManager.dateHelper.calendar.locale = [NSLocale currentLocale];
        //
        [calendarManager setMenuView:calendarMenuView];
        [calendarManager setContentView:calendarContentView];
        [calendarManager setDate:[NSDate date]];
        //
        calendarMenuView.backgroundColor = [UIColor clearColor];
        calendarContentView.backgroundColor = [UIColor clearColor];
        
        //Calendar
        [calendarManager reload];
        [self updateDateInfo];
        
        //Proteção contra retorno de outra tela (popViewController)
        isLoaded = true;
    }
    
    [favoriteList removeAllObjects];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        connectionManager.delegate = self;
        
        //Buscando eventos AHK
        [connectionManager getAllEventsAvailableForMasterEventID:AppD.masterEventID  withCompletionHandler:^(NSArray *response, NSError *error) {
            
            if (error){
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EVENTLIST_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                
                if (response){
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[response valueForKey:@"events"]];
                    NSMutableArray *tempResult = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in tempArray){
                        [tempResult addObject:[Event createObjectFromDictionary:dic]];
                    }
                    
                    //ordenando a lista
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"schedule" ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    eventsList = [[NSMutableArray alloc] initWithArray:[tempResult sortedArrayUsingDescriptors:sortDescriptors]];
                    
                    //Fazendo a requisição para pegar os eventos inscritos do usuário
                    if ([connectionManager isConnectionActive])
                    {
                        [connectionManager getEventsForUser:AppD.loggedUser.userID andMasterEventID:AppD.masterEventID withCompletionHandler:^(NSDictionary *response, NSError *error) {
                            
                            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                            
                            if (error){
                                
                                SCLAlertView *alert = [AppD createDefaultAlert];
                                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUBSCRIBE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            }
                            else
                            {
                                NSArray* sevent = [[NSArray alloc] initWithArray:[response valueForKey:@"events"]];
                                
                                for (Event* evento in eventsList) {
                                    for(int x = 0; x<sevent.count; x++){
                                        if(evento.eventID == [((NSNumber*)[sevent objectAtIndex:x]) intValue])
                                        {
                                            evento.userRegistrationStatus = eUserRegistrationStatus_Subscribed;
                                        }
                                    }
                                }
                                
                                for (Event *event in eventsList) {
                                    if(event.userRegistrationStatus == eUserRegistrationStatus_Subscribed)
                                    {
                                        [favoriteList addObject:event];
                                    }
                                }
                                
                                
                                
                                NSLog(@"%@", eventsList);
                                
                                [tvEventsList reloadData];
                                [calendarManager reload];
                            }
                        }];
                    }else{
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                }else{
                    //No response
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                }
            }
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (segmentBar.selectedSegmentIndex == BAR_LIST){
//        [Answers logCustomEventWithName:@"Acesso a tela Lista Eventos" customAttributes:@{}];
//    }else{
//        [Answers logCustomEventWithName:@"Acesso a tela Calendário Eventos" customAttributes:@{}];
//    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)segmentedControlChanged:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == BAR_LIST){
        viewEventsList.alpha = 1.0;
        viewEventsCalendar.alpha = 0.0;
        //[Answers logCustomEventWithName:@"Acesso a tela Lista Eventos" customAttributes:@{}];
    }else{
        viewEventsList.alpha = 0.0;
        viewEventsCalendar.alpha = 1.0;
        //[Answers logCustomEventWithName:@"Acesso a tela Calendário Eventos" customAttributes:@{}];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tvEventsList){
        return favoriteList.count;
    }
    
    if (tableView == tvDayEventsList){
        return eventsDayList.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierEvent = @"CustomCellEvent";
    static NSString *CellIdentifierDayEvent = @"CustomCellDayEvent";
    
    if (tableView == tvEventsList){
        
        TVC_EventItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierEvent];
        
        if(cell == nil)
        {
            cell = [[TVC_EventItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierEvent];
        }
        
        Event *actualEvent = [favoriteList objectAtIndex:indexPath.row];
        
        cell.lblTitle.text = actualEvent.title;
        cell.lblPeriod.text = [ToolBox dateHelper_StringFromDate:actualEvent.schedule withFormat:TOOLBOX_DATA_BARRA_INFORMATIVA];
        
        if (actualEvent.userRegistrationStatus == eUserRegistrationStatus_Available || actualEvent.userRegistrationStatus == eUserRegistrationStatus_Undefined){
            cell.lblStatus.text = NSLocalizedString(@"LABEL_EVENT_AVAILABLE", @"");
            [cell updateLayoutForRegistered:false];
        }else{
            cell.lblStatus.text = NSLocalizedString(@"LABEL_EVENT_SUBSCRIBED", @"");
            [cell updateLayoutForRegistered:true];
        }
        
        return cell;
    }
    
    if (tableView == tvDayEventsList){
        
        TVC_DayEventItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDayEvent];
        
        if(cell == nil)
        {
            cell = [[TVC_DayEventItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDayEvent];
        }
        
        Event *actualEvent = [eventsDayList objectAtIndex:indexPath.row];
        
        cell.lblHourStart.text = [ToolBox dateHelper_StringFromDate:actualEvent.schedule withFormat:@"HH:mm"];
        cell.lblTitle.text = actualEvent.title;
        
        if (actualEvent.userRegistrationStatus == eUserRegistrationStatus_Available || actualEvent.userRegistrationStatus == eUserRegistrationStatus_Undefined){
            cell.lblStatus.text = NSLocalizedString(@"LABEL_EVENT_AVAILABLE", @"");
            [cell updateLayoutForRegistered:false];
        }else{
            cell.lblStatus.text = NSLocalizedString(@"LABEL_EVENT_SUBSCRIBED", @"");
            [cell updateLayoutForRegistered:true];
        }
        
        return cell;
        
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tvEventsList){
        
        //Animação de seleção
        TVC_EventItem *cell = (TVC_EventItem*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
            } completion:^(BOOL finished) {
                nil;
            }];
        });
        
        //Resolução da seleção
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetail" bundle:[NSBundle mainBundle]];
        VC_EventDesc *vcEventDesc = [storyboard instantiateViewControllerWithIdentifier:@"VC_EventDesc"];
        [vcEventDesc awakeFromNib];
        vcEventDesc.event = [((Event*)[favoriteList objectAtIndex:indexPath.row]) copyObject];
        //
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vcEventDesc animated:YES];
    }
    
    if (tableView == tvDayEventsList){
        
        //Animação de seleção
        TVC_DayEventItem *cell = (TVC_DayEventItem*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
            } completion:^(BOOL finished) {
                nil;
            }];
        });
        
        //Resolução da seleção
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EventDetail" bundle:[NSBundle mainBundle]];
        VC_EventDesc *vcEventDesc = [storyboard instantiateViewControllerWithIdentifier:@"VC_EventDesc"];
        [vcEventDesc awakeFromNib];
        vcEventDesc.event = [((Event*)[eventsDayList objectAtIndex:indexPath.row]) copyObject];
        //
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vcEventDesc animated:YES];
    }
}

//CALENDAR

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    enumUserRegistrationStatus status = [self haveEventForDay:dayView.date];
    
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Selected date
    else if(dateSelected && [calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date])
    {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = AppD.styleManager.colorCalendarSelected;
        dayView.dotView.backgroundColor = AppD.styleManager.colorCalendarSelected;
        dayView.textLabel.textColor = AppD.styleManager.colorPalette.textNormal;
    }
    //Hoje
    else if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date])
    {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = AppD.styleManager.colorCalendarToday;
        dayView.dotView.backgroundColor = AppD.styleManager.colorCalendarToday;
        dayView.textLabel.textColor = [UIColor darkTextColor];
    }
    //Evento
    else if(status != eUserRegistrationStatus_Unavailable)
    {
        if (status == eUserRegistrationStatus_Available){
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = [UIColor whiteColor];
            dayView.textLabel.textColor = [UIColor darkTextColor];
            //
            //            dayView.circleView.layer.borderColor = AppD.styleManager.colorCalendarAvailable.CGColor;
            //            dayView.circleView.layer.borderWidth = 2.0;
        }else if (status == eUserRegistrationStatus_Subscribed){
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = AppD.styleManager.colorCalendarRegistered;
            dayView.textLabel.textColor = AppD.styleManager.colorPalette.textNormal;
            //
            //            dayView.circleView.layer.borderColor = AppD.styleManager.colorCalendarRegistered.CGColor;
            //            dayView.circleView.layer.borderWidth = 2.0;
        }
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor darkTextColor];
    }
    
    if (status == eUserRegistrationStatus_Available){
        dayView.circleView.layer.borderColor = AppD.styleManager.colorCalendarAvailable.CGColor;
    }else if(status == eUserRegistrationStatus_Subscribed){
        dayView.circleView.layer.borderColor = AppD.styleManager.colorCalendarRegistered.CGColor;
    }else{
        dayView.circleView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    dayView.circleView.layer.borderWidth = 2.0;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // Use to indicate the selected date
    dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [calendarManager reload];
                    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    //    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
    //        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
    //            [calendarContentView loadNextPageWithAnimation];
    //        }
    //        else{
    //            [calendarContentView loadPreviousPageWithAnimation];
    //        }
    //    }
    
    eventsDayList = [NSMutableArray new];
    
    for (Event *event in favoriteList){
        
        if ([ToolBox dateHelper_CompareDate:event.schedule withDate:dateSelected usingRule:tbComparationRule_Equal]){
            [eventsDayList addObject:[event copyObject]];
        }
    }
    
    [self didChangeModeTouch];
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL];
    view.textLabel.textColor = [UIColor darkTextColor];
    
    return view;
}


-(void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    [self updateDateInfo];
}

-(void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    [self updateDateInfo];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //SegmentControl
	viewSegmentBar.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
	segmentBar.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
	[segmentBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.backgroundNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]} forState:UIControlStateNormal];
	[segmentBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]} forState:UIControlStateSelected];
	[segmentBar setTitle:NSLocalizedString(@"SEGMENTEDCONTROL_OPTION_LIST", @"") forSegmentAtIndex:BAR_LIST];
	[segmentBar setTitle:NSLocalizedString(@"SEGMENTEDCONTROL_OPTION_CALENDAR", @"") forSegmentAtIndex:BAR_CALENDAR];
	[segmentBar setBackgroundColor:[UIColor whiteColor]];
    
    //Views
    viewEventsList.backgroundColor = [UIColor whiteColor];
    viewEventsCalendar.backgroundColor = [UIColor whiteColor];
    
    //Line Separator
    imvLineSeparator.backgroundColor = AppD.styleManager.colorPalette.primaryButtonTitleNormal;
    //[ToolBox graphicHelper_ApplyShadowToView:imvLineSeparator withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, 2.0) radius:2.0 opacity:0.5];
    
    //Tabelas
    tvEventsList.backgroundColor = [UIColor clearColor];
    tvDayEventsList.backgroundColor = [UIColor clearColor];
    
    //Calendar
    calendarContentView.backgroundColor = [UIColor whiteColor];
    lblDateInfo.backgroundColor = [UIColor clearColor];
    lblDateInfo.textColor = [UIColor grayColor]; //AppD.styleManager.colorPalette.primaryButtonTitleNormal;
    
    //Footer
    viewFooter.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    //
    [self setupFooterStyleContent];
}

- (enumUserRegistrationStatus)haveEventForDay:(NSDate*)referenceDate
{
    enumUserRegistrationStatus status = eUserRegistrationStatus_Unavailable;
    
    for (Event *event in favoriteList){
        
        if ([ToolBox dateHelper_CompareDate:event.schedule withDate:referenceDate usingRule:tbComparationRule_Equal]){
            if (status == eUserRegistrationStatus_Unavailable){
                status = eUserRegistrationStatus_Available;
            }
            //
            if (event.userRegistrationStatus == eUserRegistrationStatus_Subscribed){
                status = eUserRegistrationStatus_Subscribed;
            }
        }
    }
    
    return status;
}

- (void)updateDateInfo
{
    NSString *mounth = [ToolBox dateHelper_MonthNameForIndex:(int)[ToolBox dateHelper_ValueForUnit:NSCalendarUnitMonth referenceDate:calendarManager.date] usingAbbreviation:YES];
    NSString *key = [NSString stringWithFormat:@"MONTH_NAME_%@", mounth];
    
    lblDateInfo.text = [NSString stringWithFormat:@"%i  |  %@", (int)[ToolBox dateHelper_ValueForUnit:NSCalendarUnitYear referenceDate:calendarManager.date], NSLocalizedString(key, @"")];
}

- (void)didChangeModeTouch
{
    if ([self haveEventForDay:dateSelected] != eUserRegistrationStatus_Unavailable){
        
        if (calendarManager.settings.weekModeEnabled == NO){
            
            calendarManager.settings.weekModeEnabled = YES;
            [calendarManager reload];
            [calendarManager setDate:dateSelected];
            //
            [tvDayEventsList reloadData];
            tvDayEventsList.alpha = 1.0;
        }else{
            [tvDayEventsList reloadData];
        }
        
    }else{
        
        if (calendarManager.settings.weekModeEnabled == YES){
            
            calendarManager.settings.weekModeEnabled = NO;
            [calendarManager reload];
            [calendarManager setDate:dateSelected];
            //
            tvDayEventsList.alpha = 0.0;
        }
    }
    
    CGFloat newHeight = calendarContentViewNormalHeight;
    if(calendarManager.settings.weekModeEnabled){
        newHeight = calendarContentViewWeekHeight;
    }
    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

- (void)setupFooterStyleContent
{
    UIFont *fontText = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    //
    NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
    attachment1.image = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorCalendarToday andImageTemplate:[UIImage imageNamed:@"icon-dot"]] ;
    attachment1.bounds = CGRectMake(0, -5, attachment1.image.size.width, attachment1.image.size.height);
    //
    NSTextAttachment *attachment2 = [[NSTextAttachment alloc] init];
    attachment2.image = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorCalendarRegistered andImageTemplate:[UIImage imageNamed:@"icon-dot"]] ;
    attachment2.bounds = CGRectMake(0, -5, attachment2.image.size.width, attachment2.image.size.height);
    //
    NSTextAttachment *attachment3 = [[NSTextAttachment alloc] init];
    attachment3.image = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorCalendarAvailable andImageTemplate:[UIImage imageNamed:@"icon-dot"]] ;
    attachment3.bounds = CGRectMake(0, -5, attachment3.image.size.width, attachment3.image.size.height);
    //
    NSTextAttachment *attachment4 = [[NSTextAttachment alloc] init];
    attachment4.image = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorCalendarSelected andImageTemplate:[UIImage imageNamed:@"icon-dot"]] ;
    attachment4.bounds = CGRectMake(0, -5, attachment4.image.size.width, attachment4.image.size.height);
    //
    NSDictionary *textAttributes = @{NSFontAttributeName:fontText, NSForegroundColorAttributeName:AppD.styleManager.colorCalendarAvailable};
    //
    NSAttributedString *text1 = [NSAttributedString attributedStringWithAttachment:attachment1];//[[NSAttributedString alloc] initWithString:@"•" attributes:sphereAttributesToday];
    NSAttributedString *text2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", NSLocalizedString(@"FOOTER_LABEL_TODAY", @"")] attributes:textAttributes];
    NSAttributedString *text3 = [NSAttributedString attributedStringWithAttachment:attachment2];//[[NSAttributedString alloc] initWithString:@"•" attributes:sphereAttributesRegistered];
    NSAttributedString *text4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", NSLocalizedString(@"FOOTER_LABEL_REGISTERED", @"")] attributes:textAttributes];
//    NSAttributedString *text5 = [NSAttributedString attributedStringWithAttachment:attachment3];//[[NSAttributedString alloc] initWithString:@"•" attributes:sphereAttributesAvailable];
//    NSAttributedString *text6 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", NSLocalizedString(@"FOOTER_LABEL_AVAILABLE", @"")] attributes:textAttributes];
    NSAttributedString *text7 = [NSAttributedString attributedStringWithAttachment:attachment4];//[[NSAttributedString alloc] initWithString:@"•" attributes:sphereAttributesSelected];
    NSAttributedString *text8 = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"FOOTER_LABEL_SELECTED", @"") attributes:textAttributes];
    //
    NSMutableAttributedString *finalAttributedString = [NSMutableAttributedString new];
    [finalAttributedString appendAttributedString:text1];
    [finalAttributedString appendAttributedString:text2];
    [finalAttributedString appendAttributedString:text3];
    [finalAttributedString appendAttributedString:text4];
//    [finalAttributedString appendAttributedString:text5];
//    [finalAttributedString appendAttributedString:text6];
    [finalAttributedString appendAttributedString:text7];
    [finalAttributedString appendAttributedString:text8];
    //
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [finalAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [finalAttributedString length])];
    //
    lblFooter.attributedText = finalAttributedString;
    lblFooter.backgroundColor = [UIColor clearColor];
}
@end
