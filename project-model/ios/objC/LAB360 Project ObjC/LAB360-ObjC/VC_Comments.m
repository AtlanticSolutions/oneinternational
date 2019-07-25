//
//  VC_Comments.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 18/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Comments.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Comments()

#define MAX_LENGHT_TEXT_VIEW 255

@property (nonatomic, weak) IBOutlet UITableView *tbvComments;
@property (nonatomic, weak) IBOutlet UIView *viewPostComment;
@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (nonatomic, weak) IBOutlet UITextView *txvComment;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewConstraintHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *footerConstraintHeight;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Comments
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize selectedPost;
@synthesize tbvComments;
@synthesize viewPostComment, btnSend, txvComment;
@synthesize tableViewConstraintHeight, footerConstraintHeight;

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
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_COMMENTS", @"");
    
    txvComment.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    footerConstraintHeight.constant = 50.0;
    tableViewConstraintHeight.constant = AppD.rootViewController.view.frame.size.height - 64.0 - footerConstraintHeight.constant;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [self.view layoutIfNeeded];
    [self setupLayout];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS
-(IBAction)sendComment:(id)sender
{
    if ([ToolBox textHelper_CheckRelevantContentInString:txvComment.text]){
        
        [txvComment resignFirstResponder];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
        });
        
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive])
        {
            [connectionManager postAddCommentForPost:selectedPost.postID userID:AppD.loggedUser.userID message:txvComment.text withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                if (error){
        
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_AUTHENTICATION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SEND_COMMENT_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    
                }else{
                    selectedPost = [Post createObjectFromDictionary:response];
                    txvComment.text = @"";
                    [tbvComments reloadData];
                    //
                    AppD.forceTimelineUpdate = true;
                }
            }];
        }
        else
        {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Prevent crashing undo bug
    if(range.length + range.location > textView.text.length){
        return NO;
    }
    
    //Max lenght
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (newLength <= MAX_LENGHT_TEXT_VIEW){
        
        NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        UITextView *textAux = [[UITextView alloc] initWithFrame:textView.frame];
        [self resolveTextViewHeightForComponent:textAux andString:finalString];
        return YES;
    }
    
    return NO;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - • TABLEVIEW DELEGATE
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierComment = @"CellComment";

    TVC_Comment *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierComment];
    
    if(cell == nil)
    {
        cell = [[TVC_Comment alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierComment];
    }
    
    PostComment *comment = [selectedPost.commentsList objectAtIndex:indexPath.row];
    
    cell.lblName.text = comment.user.name;
    cell.lblDate.text = [ToolBox dateHelper_StringFromDate:comment.date withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL]; //[ToolBox dateHelper_FriendlyStringFromDate:comment.date];
    cell.lblComment.text = comment.message;
    //
    [cell.imvProfile setImageWithURL:[NSURL URLWithString:comment.user.pictureURL] placeholderImage:[[UIImage imageNamed:@"icon-user-default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    cell.imvProfile.tintColor = AppD.styleManager.colorPalette.primaryButtonSelected;
    
    CGSize size = [self returnSizeForText:cell.lblComment.text];
    if(size.height < 20)
    {
        size.height = 20;
    }
    cell.lblComment.frame = CGRectMake(cell.lblComment.frame.origin.x, cell.lblComment.frame.origin.y, size.width, size.height);
    
    [cell updateLayout];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectedPost.commentsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostComment *comment = [selectedPost.commentsList objectAtIndex:indexPath.row];
    
    return [self returnSizeForText:comment.message].height + 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [txvComment resignFirstResponder];
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
    
    btnSend.backgroundColor = [UIColor clearColor];
    viewPostComment.backgroundColor = [UIColor clearColor];
    

    //Footer
    viewPostComment.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    btnSend.backgroundColor = [UIColor clearColor];
    UIImage *imgNormal = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonNormal andImageTemplate:[UIImage imageNamed:@"icon-button-send"]];
    UIImage *imgSel = [ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonSelected andImageTemplate:[UIImage imageNamed:@"icon-button-send"]];
    [btnSend setImage:imgNormal forState:UIControlStateNormal];
    [btnSend setImage:imgSel forState:UIControlStateHighlighted];
    
    //TextView
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    
    NSString *finalString = @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS] range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, finalString.length)];
    //
    txvComment.attributedText = attributedString;
    
    [txvComment setTextColor:AppD.styleManager.colorPalette.textDark];
    
    [txvComment.layer setCornerRadius:5.0];
    [txvComment.layer setBorderWidth:1.0];
    [txvComment.layer setBorderColor:AppD.styleManager.colorCalendarAvailable.CGColor];
    
    [txvComment setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];

}

-(CGSize) returnSizeForText:(NSString *)string
{
    CGSize size = [string sizeWithFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL] constrainedToSize:CGSizeMake(self.view.frame.size.width - 84.0, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        tableViewConstraintHeight.constant = (self.view.frame.size.height - footerConstraintHeight.constant - kbSize.height);
        [tbvComments layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        tableViewConstraintHeight.constant = (self.view.frame.size.height - footerConstraintHeight.constant);
        [tbvComments layoutIfNeeded];
    }];
}

- (void)keyboardChangeFrame:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        tableViewConstraintHeight.constant = (self.view.frame.size.height - footerConstraintHeight.constant - kbSize.height);
        [tbvComments layoutIfNeeded];
    }];
}

- (void)resolveTextViewHeightForComponent:(UITextView*)textView andString:(NSString*)string
{
    //    NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //
    //    UITextView *textAux = [[UITextView alloc] initWithFrame:textView.frame];
    //
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, string.length)];
    //
    textView.attributedText = attributedString;
    
    [textView setFont:[UIFont fontWithName:txvComment.font.fontName size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [textView setTextColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    
    [textView setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];
    
    CGFloat altura = size.height;
    
    if (altura > 100.0){
        altura = 100.0;
    }else if (altura < 40.0){
        altura = 40.0;
    }
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        CGFloat diferenca = footerConstraintHeight.constant;
        footerConstraintHeight.constant = altura + 10;
        diferenca = footerConstraintHeight.constant - diferenca;
        tableViewConstraintHeight.constant = (tableViewConstraintHeight.constant - diferenca);
        [viewPostComment layoutIfNeeded];
        //
        //NSLog(@"%.2f, %.2f, %.2f, %.2f", textView.textContainerInset.top, textView.textContainerInset.bottom, textView.textContainerInset.right, textView.textContainerInset.left);
    }];
}

@end
