//
//  QuizViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 12/04/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import "QuizViewController.h"
#import "AppDelegate.h"

@interface QuizViewController ()

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSDictionary *dicQuestion;
@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TODO: verificar se é necessário mostrar esse logo
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavBarQuiz"]]; //NavBarAdAlive...
    //UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    //self.navigationItem.rightBarButtonItem = logoView;
    
    [self loadItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
}

#pragma mark - Load Catalog items

-(void)loadItems
{
    AdAliveConnectionManager *connectionManager = [[AdAliveConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getRequestUsingParametersFromURL:self.questionPath withDictionaryCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle: error.localizedDescription duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    self.dicQuestion = [[NSDictionary alloc] initWithDictionary:response];
                    [self.tableView reloadData];
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
        
    }
    else
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - UITableView Methods

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.dicQuestion) {
        return [self.dicQuestion objectForKey:QUIZ_QUESTION_KEY];
    }
    
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayAnswers = [self.dicQuestion objectForKey:QUIZ_ANSWER_ARRAY_KEY];
    return [arrayAnswers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"answerCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSArray *arrayAnswers = [self.dicQuestion objectForKey:QUIZ_ANSWER_ARRAY_KEY];
    NSDictionary *dicAnswer = [arrayAnswers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dicAnswer objectForKey:QUIZ_ANSWER_ITEM_KEY];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - Private Methods
- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_QUIZ", @"");
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    
}

@end
