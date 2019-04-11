//
//  ColorPickerViewController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "ColorPickerViewController.h"
#import "AppDelegate.h"

#define CLAMP_COLOR_VALUE(v) (v) = (v) < 0 ? 0 : (v) > 1 ? 1 : (v)

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ColorPickerViewController()<UITextFieldDelegate>

//Data:

//Layout:
@property(nonatomic, weak) IBOutlet HRColorPickerView *colorPickerView;
//@property (nonatomic, weak) IBOutlet UIView <HRColorInfoView> *colorInfoView;
//@property (nonatomic, weak) IBOutlet UIControl <HRColorMapView> *colorMapView;
//@property (nonatomic, weak) IBOutlet UIControl <HRBrightnessSlider> *brightnessSlider;
//
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;

@end

#pragma mark - • IMPLEMENTATION
@implementation ColorPickerViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize titleScreen, selectedColor;
@synthesize colorPickerView, btnConfirm;

#pragma mark - • CLASS METHODS

+ (NSString*)colorNameForHex:(NSString*)hexColor
{
    if (hexColor){
        
        @try {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"colors_names" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //
            if (error == nil && json){
                NSString *uHex = [hexColor uppercaseString];
                NSString *nameColor = [json valueForKey:uHex];
                //
                return nameColor;
            }
        } @catch (NSException *exception) {
            NSLog(@"colorNameForHex >> Error >> %@", [exception reason]);
        }
        
    }
    
    return nil;
}

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
    
    [self setupLayout:titleScreen];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    colorPickerView.color = selectedColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionCustomColor:)];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [colorPickerView setAlpha:1.0];
    }];
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

- (void)actionCustomColor:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
    UITextField *textField = [alert addTextField:@"#FFFFFF"];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    [textField setDelegate:self];
    
    [alert addButton:@"Buscar Cor" withType:SCLAlertButtonType_Normal actionBlock:^{
        [textField resignFirstResponder];
        
        if (![textField.text isEqualToString:@""]){
            
            NSString *hex = textField.text;
            
            if (![hex hasPrefix:@"#"]){
                hex = [NSString stringWithFormat:@"#%@", hex];
            }
            
            UIColor *color = nil;
            
            @try {
                color = [ToolBox graphicHelper_colorWithHexString:hex];
            } @catch (NSException *exception) {
                NSLog(@"actionCustomColor >> Error >> %@", [exception reason]);
            } @finally {
                if (color){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        colorPickerView.color = color;
                        selectedColor = colorPickerView.color;
                    });
                }
            }
            
        }
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showInfo:self title:@"Paleta" subTitle:@"Insira o valor hexa da cor que deseja buscar." closeButtonTitle:nil duration:0.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_FAST * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField becomeFirstResponder];
    });
    
}

- (void)actionColorPicker:(id)sender
{
    selectedColor = colorPickerView.color;
}

- (IBAction)actionConfirmColor:(id)sender
{
    NSMutableDictionary *colorData = [NSMutableDictionary new];
    
    [colorData setObject:[ToolBox graphicHelper_hexStringFromUIColor:selectedColor] forKey:@"SPECIAL_INPUT_KEY_COLORPICKER_HEX"];
    
    [colorData setObject:[self RGBfromColor:selectedColor] forKey:@"SPECIAL_INPUT_KEY_COLORPICKER_RGB"];
    
    //[colorData setObject:[self HSBfromColor:selectedColor] forKey:@"SPECIAL_INPUT_KEY_COLORPICKER_HSB"];
    
    //[colorData setObject:[self CMYKfromColor:selectedColor] forKey:@"SPECIAL_INPUT_KEY_COLORPICKER_CMYK"];
    
    NSString *name = [ColorPickerViewController colorNameForHex:[ToolBox graphicHelper_hexStringFromUIColor:selectedColor]];
    if (name){
        [colorData setObject:name forKey:@"SPECIAL_INPUT_KEY_COLORPICKER_NAME"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:COLOR_PICKER_RESULT_NOTIFICATION_KEY object:colorData userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    
    //Max Lenght
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 7){
        return NO;
    }
    
    //Valid Content
    NSString *changedString = [[textField.text stringByReplacingCharactersInRange:range withString:string] uppercaseString];
    
    if ([changedString isEqualToString:@""]){
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"#0123456789ABCDEF"];
    
    if (![[changedString stringByTrimmingCharactersInSet:set] isEqualToString:@""]){
        //Invalid characters in string.
        return NO;
    }
    
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    colorPickerView.backgroundColor = [UIColor whiteColor];
    
    //Button
    btnConfirm.backgroundColor = [UIColor clearColor];
    btnConfirm.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    [btnConfirm setTitle:@"CONFIRMAR COR" forState:UIControlStateNormal];
    [btnConfirm setExclusiveTouch:YES];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:COLOR_MA_GRAY] forState:UIControlStateHighlighted];
    //
    [btnConfirm setEnabled:YES];
 
    [colorPickerView addTarget:self action:@selector(actionColorPicker:) forControlEvents:UIControlEventValueChanged];
    [colorPickerView setAlpha:0.0];
}

#pragma mark - UTILS (General Use)

- (NSString*)RGBfromColor:(UIColor*)color
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    NSString *RGB = [NSString stringWithFormat:@"%li, %li, %li", lroundf(red * 255.0), lroundf(green * 255.0), lroundf(blue * 255.0)];
    //
    return RGB;
}

- (NSString*)HSBfromColor:(UIColor*)color
{
    CGFloat h = 0.0, s = 0.0, b = 0.0, a =0.0;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    
    NSString *HSB = [NSString stringWithFormat:@"%liº, %li%%, %li%%", lroundf(h * 360.0), lroundf(s * 100.0), lroundf(b * 100.0)];
    //
    return HSB;
}

- (NSString*)CMYKfromColor:(UIColor*)color
{
    //NOTE: para saber mais:
    //https://github.com/ibireme/YYCategories/blob/master/YYCategories/UIKit/UIColor%2BYYAdd.m
    
    CGFloat c = 0.0, m = 0.0, y = 0.0, k = 0.0;
    CGFloat r = 0.0, g = 0.0, b = 0.0;
    
    [color getRed:&r green:&g blue:&b alpha:nil];
    
    CLAMP_COLOR_VALUE(r);
    CLAMP_COLOR_VALUE(g);
    CLAMP_COLOR_VALUE(b);
        
    c = 1.0 - r;
    m = 1.0 - g;
    y = 1.0 - b;
    k = fmin(c, fmin(m, y));
    
    if (k == 1.0) {
        c = m = y = 0.0;   // Pure black
    } else {
        c = (c - k) / (1.0 - k);
        m = (m - k) / (1.0 - k);
        y = (y - k) / (1.0 - k);
    }
    
    NSString *CMYK = [NSString stringWithFormat:@"%li%%, %li%%, %li%%, %li%%", lroundf(c * 100.0), lroundf(m * 100.0), lroundf(y * 100.0), lroundf(k * 100.0)];
    
    return CMYK;
    
}

@end
