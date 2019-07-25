//
//  CustomSurveyShareableCodeViewerVC.m
//  LAB360-Dev
//
//  Created by Erico GT on 29/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "CustomSurveyShareableCodeViewerVC.h"
#import "AppDelegate.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface CustomSurveyShareableCodeViewerVC()

//Data:

//Layout:
@property (nonatomic, weak) IBOutlet UIView *viewContainer;
@property (nonatomic, weak) IBOutlet UILabel *lblNote;
@property (nonatomic, weak) IBOutlet UIImageView *imvCode;
@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@end

#pragma mark - • IMPLEMENTATION
@implementation CustomSurveyShareableCodeViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize shareableCode;
@synthesize viewContainer, lblNote, imvCode, btnClose;

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
    
    [self setupLayout:@"Compartilhando"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImage *img = [self createQRCodeImage];
    
    if (img){
        
        imvCode.image = img;
        
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [viewContainer setAlpha:1.0];
            [btnClose setAlpha:1.0];
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
            [self actionClose:nil];
        }];
        [alert showError:@"Ops..." subTitle:@"O código para compartilhamento não é válido ou o serviço não está disponível no momento.\nPor favor, tente mais tarde" closeButtonTitle:nil duration:0.0];
        
    }
    
}

- (UIImage*)createQRCodeImage
{
    if ([ToolBox textHelper_CheckRelevantContentInString:self.shareableCode]){
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        CGAffineTransform transform = CGAffineTransformMakeScale(10.0, 10.0);
        
        if (filter){
            NSData *strData = [self.shareableCode dataUsingEncoding:NSISOLatin1StringEncoding];
            [filter setValue:strData forKey:@"inputMessage"];
            [filter setValue:@"Q" forKey:@"inputCorrectionLevel"]; //25%
            CIImage *ciImage = [filter.outputImage imageByApplyingTransform:transform];
            UIImage *finalImage = [UIImage imageWithCIImage:ciImage];
            return  finalImage;
        }
    }
    
    return nil;
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

- (IBAction)actionClose:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor clearColor];
    
    viewContainer.backgroundColor = [UIColor blackColor];
    [viewContainer setClipsToBounds:YES];
    viewContainer.layer.masksToBounds = YES;
    viewContainer.layer.cornerRadius = 10.0;
    
    lblNote.backgroundColor = [UIColor clearColor];
    lblNote.textColor = [UIColor whiteColor];
    [lblNote setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR]];
    lblNote.text = @"Qualquer usuário pode escanear este QRCode de outro dispositivo, pelo menu 'Buscar por QRCode', para ter acesso ao conteúdo rapidamente.";
    
    imvCode.backgroundColor = [UIColor blackColor];
    imvCode.image = nil;
    
    btnClose.backgroundColor = [UIColor redColor];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS];
    [btnClose setTitle:@"FECHAR" forState:UIControlStateNormal];
    [btnClose setExclusiveTouch:YES];
    
    [viewContainer setAlpha:0.0];
    [btnClose setAlpha:0.0];
}

#pragma mark - UTILS (General Use)

@end
