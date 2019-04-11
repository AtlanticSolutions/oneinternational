//
//  OCRViewController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <FirebaseMLVision/FirebaseMLVision.h>
//
#import "OCRViewController.h"
#import "AppDelegate.h"
#import "ToolBox.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface OCRViewController()
//Data:

//Layout:
@property(nonatomic, weak) IBOutlet UILabel* lblTitle;
@property(nonatomic, weak) IBOutlet UITextView* txtResult;

@end

#pragma mark - • IMPLEMENTATION
@implementation OCRViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize imageToProcess;
@synthesize lblTitle, txtResult;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"OCR"];
    
    [self detectText];
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

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.text = @"Resultado";
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_TITLE_NAVBAR]];
    
    txtResult.backgroundColor = [UIColor whiteColor];
    txtResult.text = @"";
    [txtResult setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [txtResult setTextContainerInset:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [txtResult setClipsToBounds:YES];
    [txtResult.layer setCornerRadius:4.0];
}

- (void)detectText
{
    if (imageToProcess == nil){
        txtResult.text = @"Imagem inválida!";
    }else{
        
        //https://firebase.google.com/docs/ml-kit/ios/recognize-text
        
        FIRVision *vision = [FIRVision vision];
        FIRVisionTextRecognizer *textRecognizer = [vision onDeviceTextRecognizer];
        
        //Para habilitar o versão cloud precisa de configurações adicionais no console do app no Firebase
        //FIRVisionCloudTextRecognizerOptions *options = [[FIRVisionCloudTextRecognizerOptions alloc] init];
        //options.languageHints = @[@"pt"];
        //FIRVisionTextRecognizer *textRecognizer = [vision cloudTextRecognizerWithOptions:options];
        
        FIRVisionImage *image = [[FIRVisionImage alloc] initWithImage:imageToProcess];
        
        [textRecognizer processImage:image completion:^(FIRVisionText *_Nullable result, NSError *_Nullable error) {
            if (error != nil) {
                txtResult.text = [error localizedDescription];
                return;
            }else if (result == nil){
                txtResult.text = @"Nenhum texto detectado na imagem!";
                return;
            }
            
            // Recognized text
            NSString *resultText = result.text;
            NSLog(@"Recognized text: %@", resultText);
            
            NSMutableString *str = [NSMutableString new];
            
            for (FIRVisionTextBlock *block in result.blocks) {
                NSString *blockText = block.text;
                [str appendString:blockText];
                [str appendString:@"\n"];
                
                /*
                NSNumber *blockConfidence = block.confidence;
                NSArray<FIRVisionTextRecognizedLanguage *> *blockLanguages = block.recognizedLanguages;
                NSArray<NSValue *> *blockCornerPoints = block.cornerPoints;
                CGRect blockFrame = block.frame;
                for (FIRVisionTextLine *line in block.lines) {
                    NSString *lineText = line.text;
                    NSNumber *lineConfidence = line.confidence;
                    NSArray<FIRVisionTextRecognizedLanguage *> *lineLanguages = line.recognizedLanguages;
                    NSArray<NSValue *> *lineCornerPoints = line.cornerPoints;
                    CGRect lineFrame = line.frame;
                    for (FIRVisionTextElement *element in line.elements) {
                        NSString *elementText = element.text;
                        NSNumber *elementConfidence = element.confidence;
                        NSArray<FIRVisionTextRecognizedLanguage *> *elementLanguages = element.recognizedLanguages;
                        NSArray<NSValue *> *elementCornerPoints = element.cornerPoints;
                        CGRect elementFrame = element.frame;
                    }
                }
                 */
            }
            
            txtResult.text = str;
            
          }];
    }
}

#pragma mark - UTILS (General Use)

@end
