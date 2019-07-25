//
//  CS_AnswerImage_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <Photos/Photos.h>
//
#import "CS_AnswerImage_TVC.h"
#import "CS_AnswerImageItem_CVC.h"
#import "VIPhotoView.h"
#import "UIImage+fixOrientation.h"

@interface CS_AnswerImage_TVC()<VIPhotoViewDelegate>

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) CGFloat imageMaxDimension;
@property(nonatomic, assign) CGFloat imageQuality;
@property(nonatomic, strong) NSMutableArray *imagesList;
@property(nonatomic, strong) UIImage *placeholderImage;
@property(nonatomic, strong) CustomSurveyAnswer *currentAnswer;

@end

@implementation CS_AnswerImage_TVC

@synthesize cvImages, cellRow, cellSection, imagesList, placeholderImage, currentAnswer, vcDelegate, imageMaxDimension, imageQuality;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    cvImages.delegate = self;
    cvImages.dataSource = self;
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerImageItem_CVC" bundle:nil];
        [cvImages registerNib:nib forCellWithReuseIdentifier:@"CS_AnswerImageItem_CVC_Identifier"];
    }
    
    placeholderImage = [UIImage imageNamed:@"CustomSurveyIconPhotoSlot"];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cvImages.backgroundColor = [UIColor clearColor];
    
    cellRow = 0;
    cellSection = 0;
    imageMaxDimension = 0;
    imageQuality = 1.0;
    imagesList = [NSMutableArray new];
    currentAnswer = nil;
    
    [self.contentView layoutIfNeeded];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
        
    //Quantidade de items:
    for (int i=0; i<element.question.selectableItems; i++){
        
        CustomSurveyAnswer *answer = nil;
        if (i < element.question.userAnswers.count){
            CustomSurveyAnswer *userAnswer = [element.question.userAnswers objectAtIndex:i];
            answer = [userAnswer copyObject];
        }else{
            answer = [CustomSurveyAnswer newObject];
        }
        //
        answer.referenceIndex = i;
        //
        [imagesList addObject:answer];
    }
    
    cellRow = indexPath.row;
    cellSection = indexPath.section;
    imageMaxDimension = element.question.maxImageDimension;
    imageQuality = element.question.imageQuality;
    
    [self layoutIfNeeded];
    [tableView beginUpdates];
    [tableView endUpdates];
    
    [cvImages reloadData];
    
    //exibindo o último slot disponível na tela
    if (element.question.userAnswers.count > 0 && (element.question.userAnswers.count != element.question.selectableItems)){
        [cvImages scrollToItemAtIndexPath:[NSIndexPath indexPathForItem: (element.question.userAnswers.count - 1) inSection: 0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 120.0;
}

#pragma mark - CollectionView Delegates...

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CS_AnswerImageItem_CVC_Identifier";
    
    CS_AnswerImageItem_CVC *cell = (CS_AnswerImageItem_CVC*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CustomSurveyAnswer *answer = [imagesList objectAtIndex:indexPath.row];
    
    if (answer.image == nil){
        [cell setupLayoutWithImage:placeholderImage];
    }else{
        [cell setupLayoutWithImage:answer.image];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0 && vcDelegate)
    {
        collectionView.tag = 1;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            [self resolveSelectionForElementAtIndex:indexPath.row];
            collectionView.tag = 0;
        }];
    }
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = collectionView.frame.size.height;
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    CGFloat max = (imageMaxDimension <= 0 ? MAX(chosenImage.size.width, chosenImage.size.height) : imageMaxDimension);
    
    UIImage* editedPhoto = [chosenImage fixOrientation];
    UIImage* finalPhoto = [ToolBox graphicHelper_NormalizeImage:editedPhoto maximumDimension:max quality:imageQuality];

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if (vcDelegate){
        [vcDelegate didEndSelectingComponentAtSection:cellSection row:cellRow collectionIndex:currentAnswer.referenceIndex withImage:finalPhoto];
    }else{
        currentAnswer.image = finalPhoto;
        [cvImages reloadData];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - VIPhotoViewDelegate

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

#pragma mark - Private Methods

- (void)resolveSelectionForElementAtIndex:(NSInteger)index
{
    currentAnswer = [imagesList objectAtIndex:index];
    //currentAnswer.referenceIndex = index;
    
    if (currentAnswer.image == nil){
        
        //Usuário precisa escolher uma imagem
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self resolvePhotoLibraryPermitions];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self resolveCameraPermitions];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        [alert showInfo:@"Seleção de Imagem" subTitle:NSLocalizedString(@"ALERT_MESSAGE_PICK_PHOTO", @"") closeButtonTitle:nil duration:0.0] ;
        
    }else{
        
        //Usuário já escolheu uma imagem
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"Ampliar" withType:SCLAlertButtonType_Normal actionBlock:^{
            [self viewPhotoDetail:currentAnswer.image];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self resolvePhotoLibraryPermitions];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self resolveCameraPermitions];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_DELETE", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
            
            if (vcDelegate){
                [vcDelegate didEndSelectingComponentAtSection:cellSection row:cellRow collectionIndex:currentAnswer.referenceIndex withImage:nil];
            }else{
                currentAnswer.image = nil;
                [cvImages reloadData];
            }
            
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        [alert showInfo:@"Seleção de Imagem" subTitle:@"É possível ampliar, substituir ou excluir a imagem utilizada atualmente." closeButtonTitle:nil duration:0.0];
        
    }
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
        [vcDelegate presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:@"Autorize o uso da câmera para poder tirar fotos com seu dispositivo." closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoFromCamera:YES];
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
        
        [vcDelegate presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_PHOTO_LIBRARY_PERMISSION", "") subTitle:@"Sua autorização é necessária para a seleção de imagens da galeria." closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == PHAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoFromCamera:NO];
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

- (void)takePhotoFromCamera:(BOOL)openCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    //
    if (openCamera){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //
    [vcDelegate presentViewController:picker animated:YES completion:NULL];
}

- (void)viewPhotoDetail:(UIImage*)image
{
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:currentAnswer.image backgroundImage:nil andDelegate:self];
    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    photoView.autoresizingMask = (1 << 6) -1;
    photoView.alpha = 0.0;
    //
    [AppD.window addSubview:photoView];
    [AppD.window bringSubviewToFront:photoView];
    //
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 1.0;
    }];
}

//- (CGFloat)heightForImage:(UIImage*)image
//{
//    if (image == nil){
//        return 40.0;
//    }else{
//        CGFloat imageRatio = image.size.width / image.size.height;
//        if (imageRatio < 1.0){
//            //image portrait:
//            return self.imvImage.frame.size.width;
//        }else{
//            //image landscape:
//            CGFloat h = (self.imvImage.frame.size.width / imageRatio);
//            return (h >= 40.0 ? h : 40.0);
//        }
//    }
//}

@end
