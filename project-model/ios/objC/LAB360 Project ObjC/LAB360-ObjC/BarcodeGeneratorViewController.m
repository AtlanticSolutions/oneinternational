//
//  BarcodeGeneratorViewController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BarcodeGeneratorViewController.h"
#import "BarcodeScanner.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BarcodeGeneratorViewController()<UITextFieldDelegate>

//Layout:
@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property (nonatomic, weak) IBOutlet UITextField *txtCode;
@property (nonatomic, weak) IBOutlet UIImageView *imgGenerated;

//Data:


@end

#pragma mark - • IMPLEMENTATION
@implementation BarcodeGeneratorViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize titleScreen, typeToGenerate;
@synthesize lblInstructions, txtCode, imgGenerated;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        //TODO
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

//- (IBAction)cameraButtonTapped:(id)sender {
//
//}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self generateImageWithText:textField.text];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Gerador %@", titleScreen];
    
    lblInstructions.backgroundColor = [UIColor clearColor];
    lblInstructions.textColor = [UIColor darkTextColor];
    lblInstructions.text = @"Insira o código abaixo:";
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    txtCode.text = @"";
    
    imgGenerated.backgroundColor = nil;
    imgGenerated.image = nil;
}

- (void)generateImageWithText:(NSString*)str
{
    imgGenerated.image = nil;
    
    if (str != nil && ![str isEqualToString:@""]){
        
        CIFilter *filter = nil;
        CGAffineTransform transform = CGAffineTransformMakeScale(10.0, 10.0);
        
        if ([typeToGenerate isEqualToString:AVMetadataObjectTypeQRCode]){
            filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            if (filter){
                NSData *strData = [str dataUsingEncoding:NSISOLatin1StringEncoding];
                [filter setValue:strData forKey:@"inputMessage"];
                [filter setValue:@"Q" forKey:@"inputCorrectionLevel"]; //25%
                CIImage *ciImage = [filter.outputImage imageByApplyingTransform:transform];
                UIImage *finalImage = [UIImage imageWithCIImage:ciImage];
                imgGenerated.image = finalImage;
            }
        }
        else if ([typeToGenerate isEqualToString:AVMetadataObjectTypeAztecCode]){
            filter = [CIFilter filterWithName:@"CIAztecCodeGenerator"];
            if (filter){
                NSData *strData = [str dataUsingEncoding:NSISOLatin1StringEncoding ];
                [filter setValue:strData forKey:@"inputMessage"];
                [filter setValue:@(50.0) forKey:@"inputCorrectionLevel"];
                [filter setValue:nil forKey:@"inputLayers"];
                [filter setValue:@(0) forKey:@"inputCompactStyle"];
                CIImage *ciImage = [filter.outputImage imageByApplyingTransform:transform];
                UIImage *finalImage = [UIImage imageWithCIImage:ciImage];
                imgGenerated.image = finalImage;
            }
        }
        else if ([typeToGenerate isEqualToString:AVMetadataObjectTypePDF417Code]){
            filter = [CIFilter filterWithName:@"CIPDF417BarcodeGenerator"];
            if (filter){
                NSData *strData = [str dataUsingEncoding:NSASCIIStringEncoding]; //NSISOLatin1StringEncoding
                [filter setValue:strData forKey:@"inputMessage"];
                [filter setValue:nil forKey:@"inputMinWidth"];
                [filter setValue:nil forKey:@"inputMaxWidth"];
                [filter setValue:nil forKey:@"inputMinHeight"];
                [filter setValue:nil forKey:@"inputMaxHeight"];
                [filter setValue:nil forKey:@"inputDataColumns"];
                [filter setValue:nil forKey:@"inputRows"];
                [filter setValue:@(1.5) forKey:@"inputPreferredAspectRatio"];
                [filter setValue:@(3) forKey:@"inputCompactionMode"]; //text
                [filter setValue:@(0) forKey:@"inputCompactStyle"];
                [filter setValue:@(4) forKey:@"inputCorrectionLevel"];
                [filter setValue:@(1) forKey:@"inputAlwaysSpecifyCompaction"];
                CIImage *ciImage = [filter.outputImage imageByApplyingTransform:transform];
                UIImage *finalImage = [UIImage imageWithCIImage:ciImage];
                imgGenerated.image = finalImage;
            }
        }
        else if ([typeToGenerate isEqualToString:AVMetadataObjectTypeCode128Code]){
            filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
            if (filter){
                NSData *strData = [str dataUsingEncoding:NSASCIIStringEncoding];
                [filter setValue:strData forKey:@"inputMessage"];
                [filter setValue:@(7.0) forKey:@"inputQuietSpace"];
                CIImage *ciImage = [filter.outputImage imageByApplyingTransform:transform];
                UIImage *finalImage = [UIImage imageWithCIImage:ciImage];
                imgGenerated.image = finalImage;
            }
        }
    }
}

@end
