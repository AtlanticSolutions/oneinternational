//
//  PrototypeMenuVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "PrototypeMenuVC.h"
#import "FloatingPickerView.h"
#import "AppDelegate.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface PrototypeMenuVC ()<FloatingPickerViewDelegate>

@property(nonatomic, strong) FloatingPickerView *pickerView;

@end

#pragma mark - • IMPLEMENTATION
@implementation PrototypeMenuVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize pickerView;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pickerView = [FloatingPickerView newFloatingPickerView];
    pickerView.contentStyle = FloatingPickerViewContentStyleAuto;
    pickerView.backgroundTouchForceCancel = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Prototype Menu"];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionPickerView:(id)sender
{
    [pickerView showFloatingPickerViewWithDelegate:self];
}

-(IBAction)actionExit:(id)sender
{
    [self pop:1];
}

-(IBAction)actionGO:(id)sender
{
    [self push:@"SegueToVC" backButton:@" " sender:self];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    NSMutableArray *elements = [NSMutableArray new];
    
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"Opção 1" selection:NO tagID:0 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"Opção 2" selection:NO tagID:0 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"Opção 3" selection:YES tagID:0 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"Opção 4" selection:NO tagID:0 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"Opção 5 - Muito maior que as outras 4 (precisa de 2 linhas)." selection:NO tagID:0 enum:0 andData:nil]];
    
    return elements;
}

//Appearence:
- (NSString* _Nonnull)floatingPickerViewTextForCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Cancelar";
}

- (NSString* _Nonnull)floatingPickerViewTextForConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Confirmar";
}

- (NSString* _Nonnull)floatingPickerViewTitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Floating Picker View";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Selecione uma das opções abaixo:";
}

//Control:
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    return YES;
}

- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    return YES;
}

- (void)floatingPickerViewDidShow:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidShow");
}

- (void)floatingPickerViewDidHide:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidHide");
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
}

@end
