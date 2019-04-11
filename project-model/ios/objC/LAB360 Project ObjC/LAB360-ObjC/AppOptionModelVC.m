//
//  AppOptionModelVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AppOptionModelVC.h"
#import "AppDelegate.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppOptionModelVC()
//Data:

//Layout:

@end

#pragma mark - • IMPLEMENTATION
@implementation AppOptionModelVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
//@synthesize

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: ...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Nome da Tela"];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

#pragma mark - UTILS (General Use)

@end
