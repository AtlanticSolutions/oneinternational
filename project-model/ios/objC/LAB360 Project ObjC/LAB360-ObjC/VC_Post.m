//
//  VC_NewPost.m
//  GS&MD
//
//  Created by Lab360 on 19/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "VC_Post.h"
#import "SCLAlertViewPlus.h"
#import "ConnectionManager.h"
#import "LocationService.h"
#import "AppDelegate.h"
#import "Post.h"
#import "UIImage+animatedGIF.h"

@interface VC_Post () <UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextViewDelegate>

#define MAX_LENGHT_POST_TEXT_VIEW 512 //255

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *btnPhotoFull;
@property (nonatomic, weak) IBOutlet UIButton *btnPhotoMiddle;
@property (nonatomic, weak) IBOutlet UIButton *btnExcluir;
@property (weak, nonatomic) IBOutlet UIView *viewBaseButtons;
@property (weak, nonatomic) IBOutlet UIView *viewOneButton;
@property (weak, nonatomic) IBOutlet UIView *viewTwoButtons;
@property(nonatomic, weak) IBOutlet UITextView *tvPost;
@property(nonatomic, strong) Post *post;
@property(nonatomic, weak) IBOutlet UIImageView *selectedPhoto;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewButtonHeight;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, weak) IBOutlet UIView *viewImage;
@property (nonatomic, strong) LocationService *location;

@end

@implementation VC_Post

@synthesize scrollView, btnPhotoFull, btnPhotoMiddle, btnExcluir, viewBaseButtons, viewOneButton, viewTwoButtons, tvPost, selectedPhoto, viewImage;
@synthesize post, viewButtonHeight, firstLoad, animating;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
	
	UIBarButtonItem *btnPost = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTON_TITLE_POST", @"") style:UIBarButtonItemStyleDone target:self action:@selector(tapPostButton:)];
	self.navigationItem.rightBarButtonItem = btnPost;
	
	UITapGestureRecognizer *gestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissKeyboard:)];
	[self.view addGestureRecognizer:gestureRecognize];
    
    [btnPhotoFull addTarget:self action:@selector(tapPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhotoMiddle addTarget:self action:@selector(tapPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnExcluir addTarget:self action:@selector(clickRemovePhoto:) forControlEvents:UIControlEventTouchUpInside];
    firstLoad = true;
    animating = false;
    viewButtonHeight.constant = 20;
    
    tvPost.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(firstLoad)
    {
        [self loadLayout];
    }
    [self.view layoutIfNeeded];
    
    self.post = [Post new];
	self.location = [LocationService initAndStartMonitoringLocation];
//	[self.location startMonitoringLocation];
}

-(void)loadLayout
{
    firstLoad = false;
	[ToolBox graphicHelper_ApplyShadowToView:tvPost withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.50];
	[tvPost.layer setCornerRadius:4.0];
    
    btnPhotoMiddle.exclusiveTouch = YES;
    btnExcluir.exclusiveTouch = YES;
    btnPhotoFull.exclusiveTouch = YES;
    
    viewBaseButtons.backgroundColor = [UIColor clearColor];
    viewOneButton.backgroundColor = [UIColor clearColor];
    viewTwoButtons.backgroundColor = [UIColor clearColor];
    btnPhotoMiddle.backgroundColor = [UIColor clearColor];
    btnExcluir.backgroundColor = [UIColor clearColor];
    btnPhotoFull.backgroundColor = [UIColor clearColor];
    
    UIImage *imgPhoto = [UIImage imageNamed:@"icon-timeline-post-modern"]; //icon-post-camera
    UIImage *imgExcluir = [UIImage imageNamed:@"icon-trash"];
    
    [imgPhoto imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imgExcluir imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    btnPhotoMiddle.tintColor = [UIColor whiteColor];
    btnExcluir.tintColor = [UIColor whiteColor];
    btnPhotoFull.tintColor = [UIColor whiteColor];
    
    [btnPhotoFull setImage:imgPhoto forState:UIControlStateNormal];
    //[btnPhotoFull setImage:imgPhoto forState:UIControlStateHighlighted];
    
    [btnExcluir setImage:imgExcluir forState:UIControlStateNormal];
    //[btnExcluir setImage:imgExcluir forState:UIControlStateHighlighted];
    
    [btnPhotoMiddle setImage:imgPhoto forState:UIControlStateNormal];
    //[btnPhotoMiddle setImage:imgPhoto forState:UIControlStateHighlighted];
    
    //[btnPhotoMiddle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //[btnExcluir setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //[btnPhotoFull setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [btnPhotoMiddle setImageEdgeInsets:UIEdgeInsetsMake(2.0, 0.0, 2.0, 0.0)];
    [btnPhotoFull setImageEdgeInsets:UIEdgeInsetsMake(2.0, 0.0, 2.0, 0.0)];
    
    btnPhotoMiddle.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnExcluir.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnPhotoFull.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnPhotoMiddle setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnPhotoMiddle.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    [btnExcluir setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnExcluir.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    [btnPhotoFull setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnPhotoFull.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
	
    btnPhotoFull.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    [btnPhotoFull setTitle:NSLocalizedString(@"ALERT_TITLE_PICK_PHOTO", @"") forState:UIControlStateNormal];
    [btnPhotoFull setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    
	[ToolBox graphicHelper_ApplyShadowToView:tvPost withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.50];
	[tvPost.layer setCornerRadius:4.0];
	
    //selectedPhoto.frame = CGRectMake(selectedPhoto.frame.origin.x, selectedPhoto.frame.origin.y, selectedPhoto.frame.size.width, selectedPhoto.frame.size.width * 0.8);
    viewTwoButtons.alpha = 0.0;
    
    tvPost.text = NSLocalizedString(@"PLACEHOLDER_POST", @"");
    tvPost.textColor = [UIColor grayColor];
    
    tvPost.inputAccessoryView = [self createAcessoryViewForTextView:tvPost];
    
    tvPost.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tapPostButton:(id)sender
{
    if (!animating){
        [self.tvPost resignFirstResponder];
        
        self.post.picture = self.selectedPhoto.image;
        self.post.message = self.tvPost.text;
        self.post.user.userID = AppD.loggedUser.userID;
        self.post.masterEventID = AppD.masterEventID;
        
        bool textOK = true;
        
        if ([post.message isEqualToString:NSLocalizedString(@"PLACEHOLDER_POST", @"")]){
            textOK = false;
            post.message = @"";
        }
        
        if (textOK){
            if (![ToolBox textHelper_CheckRelevantContentInString:post.message]){
                textOK = false;
            }
        }
        
        if ((!textOK) && post.picture == nil){
            
            //Não tem canteúdo para postar:
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_NEW_POST", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ERROR_NEW_POST", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            
        }else{
            
            ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
            
            if ([connectionManager isConnectionActive])
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Publishing];
                });
				
				NSNumber *longitude = [NSNumber numberWithFloat: self.location.longitude];
				NSNumber *latitude = [NSNumber numberWithFloat: self.location.latitude];
				
				NSDictionary *dicLog = [NSDictionary dictionaryWithObjectsAndKeys:longitude, @"longitude", latitude, @"latitude", [ToolBox deviceHelper_IdentifierForVendor], @"device_id_vendor", nil];
				
				NSDictionary *dicPost = [post dictionaryJSON];
				NSDictionary *dicP = [[NSDictionary alloc] initWithObjectsAndKeys:dicPost, @"post", dicLog, @"post_logs", nil];
				
                [connectionManager postCreatePostWithParameters:dicP withCompletionHandler:^(NSDictionary *response, NSError *error) {
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    
                    if (error)
                    {
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CREATE_POST_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                    else
                    {
                        if ([[response allKeys] containsObject:@"errors"]){
                            
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CREATE_POST_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") duration:0.0];
                        
                        }else{
                            AppD.forceTimelineUpdate = true;
                            //
                            [self.navigationController popViewControllerAnimated:true];
                        }
                    }
                }];
            }
            else
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }
    }
}

-(IBAction)tapPhotoButton:(id)sender
{
	SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
    [tvPost resignFirstResponder];
	
	[alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        
        [self resolvePhotoLibraryPermitions];
		
	}];
	
	[alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
		
         [self resolveCameraPermitions];
        
	}];
	
	[alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
	
	[alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_PICK_PHOTO", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PICK_PHOTO", @"") closeButtonTitle:nil duration:0.0] ;
}

-(void)tapToDismissKeyboard:(UIGestureRecognizer *)gesture{
	
	[self.tvPost resignFirstResponder];
}

#pragma mark - Image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	UIImage* chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	[picker dismissViewControllerAnimated:NO completion:NULL];
    //
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:chosenImage];
    cropViewController.delegate = self;
    cropViewController.customAspectRatio = CGSizeMake(10, 8);
    cropViewController.aspectRatioLockEnabled = true;
    cropViewController.aspectRatioPickerButtonHidden = true;
    cropViewController.resetAspectRatioEnabled = false;
    //
    cropViewController.title = NSLocalizedString(@"LABEL_PHOTO_CROP_AVATAR_TITLE", @"");
    //cropViewController.doneButtonTitle = @"";
    //cropViewController.cancelButtonTitle = @"";
    //
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped version of the original image
    self.selectedPhoto.image = [ToolBox graphicHelper_NormalizeImage:image maximumDimension:IMAGE_MAXIMUM_SIZE_SIDE quality:0.75];
    
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
    
    viewButtonHeight.constant = selectedPhoto.frame.size.width * 0.8 + 40;
    
    [UIView animateWithDuration:1.0 animations:^{
        viewTwoButtons.alpha = 1.0f;
        viewOneButton.alpha = 0;
        selectedPhoto.alpha = 1.0f;
        [self.view layoutIfNeeded];
        
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Text View methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Prevent crashing undo bug
    if(range.length + range.location > textView.text.length){
        return NO;
    }
    
    //Max lenght
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (newLength <= MAX_LENGHT_POST_TEXT_VIEW){
        return YES;
    }
    
    return NO;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
	if([textView.text isEqualToString:NSLocalizedString(@"PLACEHOLDER_POST", @"")])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
	
    if([textView.text isEqualToString:@""])
    {
        textView.text = NSLocalizedString(@"PLACEHOLDER_POST", @"");
        textView.textColor = [UIColor grayColor];
    }
    else
    {
        self.post.message = textView.text;
    }
}

#pragma mark - Keyboard Hide/Show

- (void)keyboardWillShow:(NSNotification*)notification
{
	NSDictionary* info = [notification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
	scrollView.contentInset = contentInsets;
	scrollView.scrollIndicatorInsets = contentInsets;
	
	// If active text field is hidden by keyboard, scroll it so it's visible
	// Your app might not need or want this behavior.
	CGRect aRect = self.view.frame;
	aRect.size.height -= kbSize.height;
    
    [scrollView scrollRectToVisible:tvPost.frame animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	scrollView.contentInset = contentInsets;
	scrollView.scrollIndicatorInsets = contentInsets;
}

-(IBAction)clickRemovePhoto:(id)sender
{
    viewButtonHeight.constant = 20;
    
    animating = true;
    
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewTwoButtons.alpha = 0;
        viewOneButton.alpha = 1.0;
        selectedPhoto.alpha = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.selectedPhoto.image = nil;
        animating = false;
        
    }];
}

- (void)resolveCameraPermitions
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CAMERA_PHOTO_PERMISSION", "") closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                    //
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

- (void)resolvePhotoLibraryPermitions
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if(authStatus == PHAuthorizationStatusAuthorized) {
                
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_PHOTO_LIBRARY_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PHOTO_LIBRARY_PERMISSION", "") closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == PHAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

#pragma mark -

-(UIView*)createAcessoryViewForTextView:(UITextView*)textView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width/2, 40)];
    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnClear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [btnClear setTitle:@"Limpar" forState:UIControlStateNormal];
    [view addSubview:btnClear];
    //    //
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    btnClose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnClose addTarget:textView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClose.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [btnClose setTitle:@"Fechar" forState:UIControlStateNormal];
    [view addSubview:btnClose];
    
    return view;
}

- (void)clearTextField:(id)sender
{
    tvPost.text = @"";
}

@end
