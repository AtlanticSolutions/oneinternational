//
//  QuizViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 12/04/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import "QuizViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface QuizViewController ()

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSDictionary *dicQuestion;
@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"SCREEN_QUIZ", @"Titles");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView;
    
#ifdef SERVER_URL
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar3"]];
#else
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_navbar2"]];
#endif
    
    UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = logoView;
    
    [self loadItems];
}

#pragma mark - Load Catalog items

-(void)loadItems
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate performSelectorOnMainThread:@selector(showLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        connectionManager.delegate = self;
        [connectionManager loadQuizQuestion:self.questionPath];
    }
    else
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_LOST_CONNECTION", @"Error Messages") message:NSLocalizedString(@"MESSAGE_LOST_CONNECTION", @"Error Messages") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        });
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
    
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

#pragma mark - Connection Manageger Delegate

-(void)didConnectWithSuccess:(NSDictionary *)response
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingAnimation];
    
    if ([response isKindOfClass:[NSDictionary class]])
    {
        self.dicQuestion = (NSDictionary *)response;
        [self.tableView reloadData];
    }
}

-(void)didConnectWithFailure:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_CONNECTION_ERROR", @"Error Messages") message:NSLocalizedString(@"MESSAGE_CONNECTION_ERROR", @"Error Messages") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
