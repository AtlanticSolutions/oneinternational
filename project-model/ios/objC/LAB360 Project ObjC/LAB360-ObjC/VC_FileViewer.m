//
//  VC_FileViewer.m
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "VC_FileViewer.h"

@interface VC_FileViewer ()

@end

@implementation VC_FileViewer

@synthesize fileToShow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Layout
    [self.view layoutIfNeeded];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //[Answers logCustomEventWithName:@"Acesso a tela Visualizar Arquivo" customAttributes:@{}];
}

#pragma mark -

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    if (fileToShow){
        self.navigationItem.title = fileToShow.title;
    }else{
        self.navigationItem.title = @"...";
    }
}

@end
