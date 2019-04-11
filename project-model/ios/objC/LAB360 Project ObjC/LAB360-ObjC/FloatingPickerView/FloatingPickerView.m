//
//  FloatingPickerView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AppDelegate.h"
#import "FloatingPickerView.h"
#import "ToolBox.h"
#import "FloatingPickerTableViewCell.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface FloatingPickerView()<UITableViewDelegate, UITableViewDataSource>

//Data:
@property(nonatomic, strong) NSArray<FloatingPickerElement*>* _Nullable pickerElements;
@property(nonatomic, weak) UIViewController<FloatingPickerViewDelegate>* _Nullable delegate;
@property(nonatomic, strong) UIColor *selectedBackgroundColor;

//Layout:
@property(nonatomic, weak) IBOutlet UIVisualEffectView *effectView;
@property(nonatomic, weak) IBOutlet UIView *containerView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *containerHeightConstraint;
//
@property(nonatomic, weak) IBOutlet UIView *titleView;
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblSubtitle;
@property(nonatomic, weak) IBOutlet UIImageView *imvTitle;
//
@property(nonatomic, weak) IBOutlet UIView *bodyView;
@property(nonatomic, weak) IBOutlet UITableView *tvBody;
//
@property(nonatomic, weak) IBOutlet UIView *buttonsView;
@property(nonatomic, weak) IBOutlet UIButton *btnCancel;
@property(nonatomic, weak) IBOutlet UIButton *btnConfirm;
//
@property(nonatomic, weak) IBOutlet UIButton *btnClose;

@end

#pragma mark - • IMPLEMENTATION
@implementation FloatingPickerView
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize tag, delegate, pickerElements, multiSelection, blurEffectBackground, contentStyle, selectedBackgroundColor, backgroundTouchForceCancel;
@synthesize effectView, containerView, containerHeightConstraint, titleView, lblTitle, lblSubtitle, imvTitle, bodyView, tvBody, buttonsView, btnCancel, btnConfirm, btnClose;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    tag = 0;
    pickerElements = nil;
    multiSelection = NO;
    blurEffectBackground = NO;
    backgroundTouchForceCancel = NO;
    contentStyle = FloatingPickerViewContentStyleAuto;
    //
    selectedBackgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    pickerElements = [NSArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self setupLayout];
    
    [tvBody reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [AppD statusBarStyleForViewController:self];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

+ (FloatingPickerView* _Nonnull)newFloatingPickerView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Prototype" bundle:[NSBundle mainBundle]];
    FloatingPickerView *vc = [storyboard instantiateViewControllerWithIdentifier:@"FloatingPickerView"];
    [vc awakeFromNib];
    //
    return vc;
}

//
- (void)showFloatingPickerViewWithDelegate:(UIViewController<FloatingPickerViewDelegate>* _Nonnull)vcDelegate
{
    delegate = vcDelegate;
    
    if (delegate){
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [delegate presentViewController:self animated:YES completion:^{
            [delegate floatingPickerViewDidShow:self];
        }];
    }
}

- (void)hideFloatingPickerView
{
    if (delegate){
        [delegate dismissViewControllerAnimated:YES completion:^{
            [delegate floatingPickerViewDidHide:self];
        }];
    }
}

#pragma mark - • ACTION METHODS

- (IBAction)actionCancel:(id)sender
{
    if (delegate){
        NSMutableArray *selectedItems = [NSMutableArray new];
        for (FloatingPickerElement *element in pickerElements){
            if (element.selected){
                [selectedItems addObject:element];
            }
        }
        //
        if ([delegate floatingPickerView:self willCancelPickerWithSelectedElements:selectedItems]){
            [delegate dismissViewControllerAnimated:YES completion:^{
                [delegate floatingPickerViewDidHide:self];
            }];
        }
    }
}

- (IBAction)actionConfirm:(id)sender
{
    if (delegate){
        NSMutableArray *selectedItems = [NSMutableArray new];
        for (FloatingPickerElement *element in pickerElements){
            if (element.selected){
                [selectedItems addObject:element];
            }
        }
        //
        if ([delegate floatingPickerView:self willConfirmPickerWithSelectedElements:selectedItems]){
            [delegate dismissViewControllerAnimated:YES completion:^{
                [delegate floatingPickerViewDidHide:self];
            }];
        }
    }
}

- (IBAction)actionClose:(id)sender
{
    if (backgroundTouchForceCancel){
        [self actionCancel:sender];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//MARK: UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"TableViewCellPickerElement";
    
    //Célula para itens normais da listagem
    FloatingPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[FloatingPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    FloatingPickerElement *element = [pickerElements objectAtIndex:indexPath.row];
    
    cell.selectedBackgroundColor = self.selectedBackgroundColor;
    [cell updateLayoutForSelectedElement:element.selected];
    
    cell.lblText.text = element.title;
        
    [ToolBox graphicHelper_ApplyShadowToView:cell withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:1.0 opacity:0.5];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (multiSelection){
        FloatingPickerElement *element = [pickerElements objectAtIndex:indexPath.row];
        element.selected = !element.selected;
        //
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        for (FloatingPickerElement *element in pickerElements){
            element.selected = NO;
        }
        FloatingPickerElement *element = [pickerElements objectAtIndex:indexPath.row];
        element.selected = YES;
        //
        [tvBody reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pickerElements.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    if (blurEffectBackground){
        [effectView setHidden:NO];
        self.view.backgroundColor = [UIColor clearColor];
    }else{
        [effectView setHidden:YES];
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    }
    
    containerView.backgroundColor = [UIColor clearColor];
    
    //Title
    titleView.backgroundColor = [UIColor clearColor];
    [titleView setClipsToBounds:YES];
    //
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = @"";
    lblTitle.textColor = [UIColor darkTextColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    //
    lblSubtitle.backgroundColor = [UIColor clearColor];
    lblSubtitle.text = @"";
    lblSubtitle.textColor = [UIColor grayColor];
    lblSubtitle.textAlignment = NSTextAlignmentCenter;
    lblSubtitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    //
    imvTitle.backgroundColor = [UIColor whiteColor];
    imvTitle.layer.cornerRadius = 4.0;
    
    //Body
    bodyView.backgroundColor = [UIColor clearColor];
    [bodyView setClipsToBounds:YES];
    //
    tvBody.backgroundColor = [UIColor whiteColor];
    [tvBody setTableFooterView:[UIView new]];
    tvBody.contentInset = UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0);
    tvBody.layer.cornerRadius = 4.0;
    //data:
    pickerElements = [NSArray new];
    
    //Footer
    buttonsView.backgroundColor = [UIColor clearColor];
    //
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCancel.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCancel.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_RED] forState:UIControlStateHighlighted];
    [btnCancel setTitleColor:COLOR_MA_RED forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btnCancel.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnCancel setTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") forState:UIControlStateNormal];
    [btnCancel setExclusiveTouch:YES];
    btnCancel.layer.cornerRadius = 4.0;
    //
    btnConfirm.backgroundColor = [UIColor clearColor];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_BLUE] forState:UIControlStateHighlighted];
    [btnConfirm setTitleColor:COLOR_MA_BLUE forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btnConfirm.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnConfirm setTitle:NSLocalizedString(@"ALERT_OPTION_CONFIRM", @"") forState:UIControlStateNormal];
    [btnConfirm setExclusiveTouch:YES];
    btnConfirm.layer.cornerRadius = 4.0;
    //
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setTitle:nil forState:UIControlStateNormal];

    if (delegate){
        lblTitle.text = [delegate floatingPickerViewTitle:self];
        lblSubtitle.text = [delegate floatingPickerViewSubtitle:self];
        //
        pickerElements = [delegate floatingPickerViewElementsList:self];
        //
        [btnCancel setTitle:[delegate floatingPickerViewTextForCancelButton:self] forState:UIControlStateNormal];
        //
        [btnConfirm setTitle:[delegate floatingPickerViewTextForConfirmButton:self] forState:UIControlStateNormal];
        
        //Opcionais:
        UIColor *bcCancel = [UIColor whiteColor];
        UIColor *btCancel = COLOR_MA_RED;
        UIColor *bcConfirm = [UIColor whiteColor];
        UIColor *btConfirm = COLOR_MA_BLUE;
        if ([delegate respondsToSelector:@selector(floatingPickerViewBackgroundColorCancelButton:)]){
            bcCancel = [delegate floatingPickerViewBackgroundColorCancelButton:self];
        }
        if ([delegate respondsToSelector:@selector(floatingPickerViewTextColorCancelButton:)]){
            btCancel = [delegate floatingPickerViewTextColorCancelButton:self];
        }
        if ([delegate respondsToSelector:@selector(floatingPickerViewBackgroundColorConfirmButton:)]){
            bcConfirm = [delegate floatingPickerViewBackgroundColorConfirmButton:self];
        }
        if ([delegate respondsToSelector:@selector(floatingPickerViewTextColorConfirmButton:)]){
            btConfirm = [delegate floatingPickerViewTextColorConfirmButton:self];
        }
        if ([delegate respondsToSelector:@selector(floatingPickerViewSelectedBackgroundColor:)]){
            selectedBackgroundColor = [delegate floatingPickerViewSelectedBackgroundColor:self];
        }
        //
        [btnCancel setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCancel.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:bcCancel] forState:UIControlStateNormal];
        [btnCancel setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCancel.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:btCancel] forState:UIControlStateHighlighted];
        [btnCancel setTitleColor:btCancel forState:UIControlStateNormal];
        [btnCancel setTitleColor:bcCancel forState:UIControlStateHighlighted];
        //
        [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:bcConfirm] forState:UIControlStateNormal];
        [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:btConfirm] forState:UIControlStateHighlighted];
        [btnConfirm setTitleColor:btConfirm forState:UIControlStateNormal];
        [btnConfirm setTitleColor:bcConfirm forState:UIControlStateHighlighted];
    }
    
    CGFloat screenHeight = self.view.frame.size.height - 20.0;
    switch (contentStyle) {
        case FloatingPickerViewContentStyleAuto:{
            CGFloat pickerHeight = titleView.frame.size.height + buttonsView.frame.size.height + tvBody.contentInset.top + tvBody.contentInset.bottom + ((CGFloat)pickerElements.count * 64.0) + 5.0 + 10.0;
            if (pickerHeight > screenHeight){
                containerHeightConstraint.constant = screenHeight;
            }else{
                containerHeightConstraint.constant = pickerHeight;
            }
        }break;
            //
        case FloatingPickerViewContentStyle100:{
            containerHeightConstraint.constant = screenHeight;
        }break;
            //
        case FloatingPickerViewContentStyle75:{
            containerHeightConstraint.constant = screenHeight * 0.75;
        }break;
            //
        case FloatingPickerViewContentStyle50:{
            containerHeightConstraint.constant = screenHeight * 0.5;
        }break;
    }
    
    [bodyView setNeedsUpdateConstraints];
    [btnClose setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

#pragma mark -

@end
