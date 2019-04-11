//
//  SurveyViewController.m
//  AdAlive
//
//  Created by Lab360 on 1/28/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LocationService.h"
#import "SurveyViewController.h"
#import "SurveyNumberTableViewCell.h"
#import "SurveyMultipleTableViewCell.h"
#import "SurveyAnswer.h"
#import "AppDelegate.h"

@interface SurveyViewController () <UITableViewDataSource, UITableViewDelegate, ConnectionManagerDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *mQuestions;
@property(nonatomic, strong) NSArray *arrayAnswered;
@property(nonatomic, strong) LocationService *location;

@end

@implementation SurveyViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SURVEY_SEND", @"") style:UIBarButtonItemStyleDone target:self action:@selector(clickSendButton:)];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    self.location = [LocationService initAndStartMonitoringLocation];
    
    self.mQuestions = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [self.dicSurveyData objectForKey:SURVEY_NAME];
    
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"required == %@", @1];
    
    NSArray *filtered = [arrayQuestions filteredArrayUsingPredicate:predicate];
    
    if ([filtered count] > 0)
    {
        self.tableView.tableHeaderView = [self getHeaderTableView];
    }else{
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 18.0)];
    }
}

#pragma UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:section];
    NSString *headerText = [NSString stringWithFormat:@"%li) %@ *",section + 1, [dicQuestion objectForKey:@"query"]];
    
    return [self getLabelHeight:headerText] + 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:section];
    NSString *headerText = [NSString stringWithFormat:@"%li) %@ *", section + 1, [dicQuestion objectForKey:@"query"]];
    
    UILabel *teste = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width - 20, [self getLabelHeight:headerText])];
    teste.numberOfLines = 0;
    teste.lineBreakMode = NSLineBreakByWordWrapping;
    teste.backgroundColor = [UIColor clearColor];
    [teste setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    if ([[dicQuestion objectForKey:@"required"] boolValue])
    {
        if (self.arrayAnswered)
        {
            BOOL contains = NO;
            for (NSNumber *value in self.arrayAnswered)
            {
                if ([value integerValue] == section)
                {
                    contains = YES;
                    break;
                }
            }
            
            if (contains)
            {
                teste.textColor = [UIColor grayColor];
            }
            else
            {
                teste.textColor = [UIColor redColor];
            }
            
        }
        else
        {
            teste.textColor = [UIColor grayColor];
        }
        
        teste.text = [NSString stringWithFormat:@"%li) %@ *",section + 1, [dicQuestion objectForKey:@"query"]];
    }
    else
    {
        teste.text = [NSString stringWithFormat:@"%li) %@",section + 1, [dicQuestion objectForKey:@"query"]];
        teste.textColor = [UIColor grayColor];
    }
    
    UIView *containerV = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, teste.frame.size.height + 10.0)];
    [containerV setBackgroundColor:[UIColor clearColor]];
    [containerV addSubview:teste];
    
    return containerV;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    return [arrayQuestions count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:section];
    NSArray *arrayAnswers = [dicQuestion objectForKey:SURVEY_OPTIONS];
    
    if ([arrayAnswers count] > 0)
    {
        return [arrayAnswers count];
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:indexPath.section];
    NSArray *arrayAnswers = [dicQuestion objectForKey:SURVEY_OPTIONS];
    
    NSArray *sectionKeys = [self.mQuestions allKeys];
    SurveyAnswer *survey;
    
    if ([sectionKeys containsObject:[NSString stringWithFormat:@"%d", indexPath.section]])
    {
        survey = [self.mQuestions objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]];
    }
    
    if ([arrayAnswers count] > 0)
    {
        SurveyMultipleTableViewCell *cell = (SurveyMultipleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"multipleCell" forIndexPath:indexPath];
        
        NSDictionary *dicAnswer = [arrayAnswers objectAtIndex:indexPath.row];
        [cell.answerButton setTitle:[dicAnswer objectForKey:@"option"] forState:UIControlStateNormal];
        cell.answerButton.section = (int)indexPath.section;
        cell.answerButton.row = (int)indexPath.row;
        cell.answerButton.tag = [[dicAnswer objectForKey:@"id"] integerValue];
        [cell.answerButton addTarget:self action:@selector(btnAnswerSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.answerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.answerButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        cell.answerButton.titleLabel.numberOfLines = 0;
        
        UIFont *font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
        [cell.answerButton.titleLabel setFont:font];
        
        cell.answerButton.circleColor = [UIColor grayColor];
        cell.answerButton.circleRadius = 11.0;
        cell.answerButton.circleStrokeWidth = 2.0;
        cell.answerButton.indicatorColor = AppD.styleManager.colorPalette.backgroundNormal;
        cell.answerButton.indicatorRadius = 8.0;
        
        if (survey)
        {
            if ([survey.answer isEqualToNumber:[dicAnswer objectForKey:@"id"]])
            {
                [cell.answerButton setSelected:YES];
            }
            else
            {
                [cell.answerButton setSelected:NO];
            }
        }
        else
        {
            [cell.answerButton setSelected:NO];
        }
        
        return cell;
    }
    else
    {
        SurveyNumberTableViewCell *cell = (SurveyNumberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"numberCell" forIndexPath:indexPath];
        cell.sliderAnswer.tag = indexPath.section;
        [cell.sliderAnswer addTarget:self action:@selector(didEndTouchSliderAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sliderAnswer addTarget:self action:@selector(sliderAnswerChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        NSArray *allKeys = [dicQuestion allKeys];
        
        if (survey)
        {
            cell.sliderAnswer.value = [survey.answer intValue];
            cell.lbSelectedValue.text = [NSString stringWithFormat:@"%d/10", (int)cell.sliderAnswer.value];
        }
        else
        {
            if ([allKeys containsObject:@"initial_value"])
            {
                int value = [[dicQuestion objectForKey:@"initial_value"] intValue];
                cell.sliderAnswer.value = value;
                cell.lbSelectedValue.text = [NSString stringWithFormat:@"%d/10", (int)value];
            }
            else
            {
                cell.sliderAnswer.value = 5;
                cell.lbSelectedValue.text = @"5/10";
            }
        }
        
        return cell;
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:indexPath.section];
    NSArray *arrayAnswers = [dicQuestion objectForKey:SURVEY_OPTIONS];
    
    if ([arrayAnswers count] > 0)
    {
        //SurveyMultipleTableViewCell
        
        NSDictionary *dicAnswer = [arrayAnswers objectAtIndex:indexPath.row];
        NSString *text = [dicAnswer objectForKey:@"option"];
        
        UIFont *font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width - (10.0 * 2) - 35.0, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
        
        
        if ((textRect.size.height + 20.0) < 65.0){
            return 65.0;
        }else {
            return (textRect.size.height + 20.0);
        }
        
    }else{
        //SurveyNumberTableViewCell
        
        return 65.0;
    }
}

#pragma mark - Private methods

- (CGFloat)getLabelHeight:(NSString*)text
{
    CGSize constraint = CGSizeMake(self.tableView.frame.size.width - 20, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]}
                                            context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

-(UILabel *)getHeaderTableView
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.tableView.frame.size.width, 44)];
    headerLabel.text = NSLocalizedString(@"SURVEY_REQUIRED_QUESTIONS_NEEDED", @"");
    headerLabel.numberOfLines = 0;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:188.0/255.0 green:0 blue:20.0/255.0 alpha:1];
    headerLabel.font = [UIFont boldSystemFontOfSize:13];
    
    return headerLabel;
}

#pragma mark - Interface Events

-(void)btnAnswerSelected:(id)sender
{
    DLRadioButton *rButton = (DLRadioButton *)sender;
    
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:rButton.section];
    NSString *section = [NSString stringWithFormat:@"%d", rButton.section];
    
    SurveyAnswer *survey;
    
    NSArray *allKeys = [self.mQuestions allKeys];
    
    if ([allKeys containsObject:section])
    {
        survey = [self.mQuestions objectForKey:section];
    }
    else
    {
        survey = [[SurveyAnswer alloc] initWithId:[dicQuestion objectForKey:@"id"]];
    }
    
    survey.answer = [NSNumber numberWithInt:rButton.tag];
    survey.type = [dicQuestion objectForKey:@"type"];
    [self.mQuestions setObject:survey forKey:section];
    
    if (self.arrayAnswered){
        if ([[dicQuestion objectForKey:@"required"] boolValue])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [dicQuestion objectForKey:@"id"]];
            NSArray *array = [self.mQuestions allValues];
            
            NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
            
            if ([filtered count] > 0)
            {
                SurveyAnswer *survey = (SurveyAnswer *)[filtered objectAtIndex:0];
                NSArray *sections = [self.mQuestions allKeysForObject:survey];
                NSNumber *section = [sections objectAtIndex:0];
                
                if (![self.arrayAnswered containsObject:section])
                {
                    NSMutableArray *mArray = [self.arrayAnswered mutableCopy];
                    [mArray addObject:section];
                    self.arrayAnswered = mArray;
                }
                
            }
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:rButton.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didEndTouchSliderAnswer:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    SurveyNumberTableViewCell *cell = (SurveyNumberTableViewCell *)[[slider superview] superview];
    cell.lbSelectedValue.text = [NSString stringWithFormat:@"%d/10", (int)slider.value];
    
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSDictionary *dicQuestion = [arrayQuestions objectAtIndex:slider.tag];
    
    NSString *section = [NSString stringWithFormat:@"%li", slider.tag];
    
    SurveyAnswer *survey;
    
    NSArray *allKeys = [self.mQuestions allKeys];
    
    if ([allKeys containsObject:section])
    {
        survey = [self.mQuestions objectForKey:section];
    }
    else
    {
        survey = [[SurveyAnswer alloc] initWithId:[dicQuestion objectForKey:@"id"]];
    }
    
    survey.answer = [NSNumber numberWithInt:(int)slider.value];
    survey.type = [dicQuestion objectForKey:@"type"];
    [self.mQuestions setObject:survey forKey:section];
    
    if (self.arrayAnswered)
    {
        if ([[dicQuestion objectForKey:@"required"] boolValue])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [dicQuestion objectForKey:@"id"]];
            NSArray *array = [self.mQuestions allValues];
            
            NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
            
            if ([filtered count] > 0)
            {
                SurveyAnswer *survey = (SurveyAnswer *)[filtered objectAtIndex:0];
                NSArray *sections = [self.mQuestions allKeysForObject:survey];
                NSNumber *section = [sections objectAtIndex:0];
                
                if (![self.arrayAnswered containsObject:section])
                {
                    NSMutableArray *mArray = [self.arrayAnswered mutableCopy];
                    [mArray addObject:section];
                    self.arrayAnswered = mArray;
                }
                
            }
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:slider.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)sliderAnswerChangeValue:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    SurveyNumberTableViewCell *cell = (SurveyNumberTableViewCell *)[[slider superview] superview];
    cell.lbSelectedValue.text = [NSString stringWithFormat:@"%d/10", (int)slider.value];
}

-(IBAction)clickSendButton:(id)sender
{
    if ([self.mQuestions count] > 0)
    {
        self.arrayAnswered = [self allRequiredQuestionsAnswered];
        [self.tableView reloadData];
        
        NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"required == %@", @1];
        
        NSArray *filtered = [arrayQuestions filteredArrayUsingPredicate:predicate];
        
        if ([self.arrayAnswered count] == [filtered count])
        {
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
                });
                
                [self sendDataToServer];
            }];
            [alert addButton:NSLocalizedString(@"SURVEY_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
            [alert showInfo:self title:NSLocalizedString(@"SURVEY_ATENTION",@"") subTitle:NSLocalizedString(@"SURVEY_SEND_CONFIRM",@"") closeButtonTitle:nil duration:0.0];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SURVEY_ATENTION",@"") message:NSLocalizedString(@"SURVEY_REQUIRED_QUESTIONS_NEEDED",@"") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                            {
                                                [self scrollToFirstRequiredQuestion];
                                            }];
            [alert addAction:actionConfirm];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"SURVEY_ATENTION",@"") subTitle:NSLocalizedString(@"SURVEY_ONE_QUESTIONS_NEEDED",@"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)scrollToFirstRequiredQuestion
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    
    int selectedSection = 0;
    
    for (int i = 0; i < [arrayQuestions count]; i++)
    {
        NSDictionary *question = [arrayQuestions objectAtIndex:i];
        
        if ([[question objectForKey:@"required"] boolValue])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [question objectForKey:@"id"]];
            NSArray *array = [self.mQuestions allValues];
            
            NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
            
            if ([filtered count] == 0)
            {
                selectedSection = i;
                break;
            }
        }
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(NSArray *)allRequiredQuestionsAnswered
{
    NSArray *arrayQuestions = [self.dicSurveyData objectForKey:SURVEY_QUESTIONS];
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (NSDictionary *question in arrayQuestions)
    {
        if ([[question objectForKey:@"required"] boolValue])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [question objectForKey:@"id"]];
            NSArray *array = [self.mQuestions allValues];
            
            NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
            
            if ([filtered count] > 0)
            {
                SurveyAnswer *survey = (SurveyAnswer *)[filtered objectAtIndex:0];
                NSArray *sections = [self.mQuestions allKeysForObject:survey];
                NSNumber *section = [sections objectAtIndex:0];
                [mArray addObject:section];
            }
        }
    }
    
    return mArray;
}

-(void)sendDataToServer
{
    NSMutableDictionary *mDictionary = [NSMutableDictionary dictionary];
    
    CLLocationDegrees latitude = self.location.latitude;
    CLLocationDegrees longitude = self.location.longitude;
    
    [mDictionary setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    [mDictionary setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
    [mDictionary setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:LOG_DEVICE_ID_VENDOR_KEY];
    [mDictionary setObject:self.surveyId forKey:@"survey_id"];
    [mDictionary setObject:self.actionId forKey:@"action_id"];
    
    NSMutableArray *answers = [NSMutableArray array];
    for (SurveyAnswer *survey in [self.mQuestions allValues])
    {
        NSDictionary *dicAnswer = [NSDictionary dictionaryWithObjectsAndKeys:survey.id, @"id", survey.answer, @"answer", survey.type, @"type", nil];
        [answers addObject:dicAnswer];
    }
    
    NSDictionary *dicParameter = [NSDictionary dictionaryWithObjectsAndKeys:mDictionary, @"survey_log", answers, @"questions", AppD.loggedUser.email, @"email", nil];
    
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    [connection surveyLogWithParameters:dicParameter withCompletionHandler:^(NSDictionary *response, NSError *error) {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        if (!error) {
            
            NSString *status = [response objectForKey:@"status"];
            
            if ([status isEqualToString:@"ERROR"])
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:[response valueForKey:@"description"] closeButtonTitle:nil duration:0.0];
            }
            else
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert showSuccess:self title:NSLocalizedString(@"SURVEY_SUCCESS",@"") subTitle:NSLocalizedString(@"SURVEY_SUCCESS_MESSAGE",@"") closeButtonTitle:nil duration:0.0];
            }
            
        }
        else{
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"SURVEY_ERROR_MESSAGE",@"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
        
    }];
}

@end

