//
//  ReportsMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "ReportsMainVC.h"
#import "AppDelegate.h"
#import "LMLineGraphView.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ReportsMainVC()
//Data:

//Layout:
@property(nonatomic, weak) IBOutlet UIView *graphicView;

@end

#pragma mark - • IMPLEMENTATION
@implementation ReportsMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize graphicView;

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
    
    [self setupLayout:@"Gráficos"];
    
    [self createUsageGraphicWithIndex:0];
    [self createUsageGraphicWithIndex:1];
    [self createUsageGraphicWithIndex:2];
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
    
    graphicView.backgroundColor = [UIColor clearColor];
}

- (void)createUsageGraphicWithIndex:(int)index
{
    LMLineGraphView *graphView = [[LMLineGraphView alloc] initWithFrame:CGRectMake(0.0, (CGFloat)index * (graphicView.frame.size.height / 3.0), graphicView.frame.size.width, (graphicView.frame.size.height / 3.0))];
    graphView.backgroundColor = [UIColor darkGrayColor];
    graphView.title = [NSString stringWithFormat:@"VALORES ALEATÓRIOS - %i", (index + 1)];
    
    //X Axis:
    graphView.xAxisValues = @[@{ @1 : @"JAN" },
                              @{ @2 : @"FEV" },
                              @{ @3 : @"MAR" },
                              @{ @4 : @"ABR" },
                              @{ @5 : @"MAI" },
                              @{ @6 : @"JUN" },
                              @{ @7 : @"JUL" },
                              @{ @8 : @"AGO" },
                              @{ @9 : @"SET" },
                              @{ @10 : @"OUT" },
                              @{ @11 : @"NOV" },
                              @{ @12 : @"DEZ" }];
    
    //Y Axis:
    graphView.yAxisMaxValue = 100;
    graphView.yAxisUnit = @"QTD";
    
    //Layout:
    graphView.layout.startPlotFromZero = NO;
    graphView.layout.drawMovement = YES;

    graphView.layout.xAxisScrollableOnly = YES;
    graphView.layout.xAxisGridHidden = NO;
    graphView.layout.xAxisGridDashLine = YES;
    graphView.layout.xAxisIntervalInPx = 60.0;
    graphView.layout.xAxisMargin = 0.0;

    graphView.layout.xAxisZeroHidden = NO;
    graphView.layout.xAxisZeroDashLine = NO;
    graphView.layout.xAxisLinesWidth = 0.5;
    graphView.layout.xAxisLinesStrokeColor = [UIColor lightGrayColor];
    graphView.layout.xAxisLabelHeight = 40.0;
    graphView.layout.xAxisLabelFont = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:12.0];
    graphView.layout.xAxisLabelColor = [UIColor whiteColor];

    graphView.layout.yAxisSegmentCount = 5;
    graphView.layout.yAxisZeroHidden = NO;
    graphView.layout.yAxisZeroDashLine = NO;
    graphView.layout.yAxisGridHidden = NO;
    graphView.layout.yAxisGridDashLine = YES;
    graphView.layout.yAxisLinesStrokeColor = [UIColor lightGrayColor];
    graphView.layout.yAxisLinesWidth = 0.5;
    graphView.layout.yAxisLabelWidth = 30.0;
    graphView.layout.yAxisLabelHeight = 20.0;
    graphView.layout.yAxisLabelFont = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:12.0];
    graphView.layout.yAxisLabelColor = [UIColor whiteColor];

    graphView.layout.yAxisUnitLabelFont = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:10.0];
    graphView.layout.yAxisUnitLabelColor = [UIColor whiteColor];

    graphView.layout.titleLabelHeight = 25.0;
    graphView.layout.titleLabelFont = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:14.0];
    graphView.layout.titleLabelColor = [UIColor whiteColor];

    graphView.layout.movementLineWidth = 2.0;
    graphView.layout.movementLineColor = [UIColor whiteColor];
    graphView.layout.movementDotColor = [UIColor redColor];
    
    //Plots (RGB):
    LMGraphPlot *plot1 = [[LMGraphPlot alloc] init];
    plot1.strokeColor = [UIColor redColor];
    plot1.fillColor = [UIColor clearColor];
    plot1.graphPointColor = [UIColor redColor];
    //
    LMGraphPlot *plot2 = [[LMGraphPlot alloc] init];
    plot2.strokeColor = [UIColor greenColor];
    plot2.fillColor = [UIColor clearColor];
    plot2.graphPointColor = [UIColor greenColor];
    //
    LMGraphPlot *plot3 = [[LMGraphPlot alloc] init];
    plot3.strokeColor = [UIColor blueColor];
    plot3.fillColor = [UIColor clearColor];
    plot3.graphPointColor = [UIColor blueColor];
    //
    NSMutableArray *plots = [NSMutableArray new];
    [plots addObject:plot1];
    [plots addObject:plot2];
    [plots addObject:plot3];
    //
    //for (LMGraphPlot *plot in plots){
    {
        LMGraphPlot *plot = [plots objectAtIndex:index];
    
        int v1 = RandomPositiveNumber(1, 100);
        int v2 = RandomPositiveNumber(1, 100);
        int v3 = RandomPositiveNumber(1, 100);
        int v4 = RandomPositiveNumber(1, 100);
        int v5 = RandomPositiveNumber(1, 100);
        int v6 = RandomPositiveNumber(1, 100);
        int v7 = RandomPositiveNumber(1, 100);
        int v8 = RandomPositiveNumber(1, 100);
        int v9 = RandomPositiveNumber(1, 100);
        int v10 = RandomPositiveNumber(1, 100);
        int v11 = RandomPositiveNumber(1, 100);
        int v12 = RandomPositiveNumber(1, 100);
        //
        plot.graphPoints = @[LMGraphPointMake(CGPointMake(1, v1), @"1", [NSString stringWithFormat:@"%i", v1]),
                             LMGraphPointMake(CGPointMake(2, v2), @"2", [NSString stringWithFormat:@"%i", v2]),
                             LMGraphPointMake(CGPointMake(3, v3), @"3", [NSString stringWithFormat:@"%i", v3]),
                             LMGraphPointMake(CGPointMake(4, v4), @"4", [NSString stringWithFormat:@"%i", v4]),
                             LMGraphPointMake(CGPointMake(5, v5), @"5", [NSString stringWithFormat:@"%i", v5]),
                             LMGraphPointMake(CGPointMake(6, v6), @"6", [NSString stringWithFormat:@"%i", v6]),
                             LMGraphPointMake(CGPointMake(7, v7), @"7", [NSString stringWithFormat:@"%i", v7]),
                             LMGraphPointMake(CGPointMake(8, v8), @"8", [NSString stringWithFormat:@"%i", v8]),
                             LMGraphPointMake(CGPointMake(9, v9), @"9", [NSString stringWithFormat:@"%i", v9]),
                             LMGraphPointMake(CGPointMake(10, v10), @"10", [NSString stringWithFormat:@"%i", v10]),
                             LMGraphPointMake(CGPointMake(11, v11), @"11", [NSString stringWithFormat:@"%i", v11]),
                             LMGraphPointMake(CGPointMake(12, v12), @"12", [NSString stringWithFormat:@"%i", v12])];
        
        graphView.graphPlots = @[plot];
    }
    //
    //graphView.graphPlots = @[plot1, plot2, plot3];
    
    [graphicView addSubview:graphView];
    
}

#pragma mark - UTILS (General Use)

@end
