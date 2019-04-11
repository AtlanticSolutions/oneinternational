//
//  VirtualShowcaseMaskEditionVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VirtualShowcaseMaskEditionVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VirtualShowcaseMaskEditionVC()

@property (nonatomic, weak) IBOutlet UIView *viewPhotos;
@property (nonatomic, weak) IBOutlet UIView *viewFooter;
@property (nonatomic, weak) IBOutlet UILabel *lblProductName;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraintProductName;
@property (nonatomic, weak) IBOutlet UICollectionView *cvProducts;
@property (nonatomic, weak) IBOutlet UIButton *btnAddLayer;
@property (nonatomic, weak) IBOutlet UIButton *btnRemoveLayer;
@property (nonatomic, strong) UIView *viewContainerImages;
@property (nonatomic, strong) UIImageView *imvUserPhoto;
@property (nonatomic, strong) UIImageView *imvProductMask;
//
@property (nonatomic, assign) CGFloat maskAngle;
@property (nonatomic, assign) CGFloat maskScale;
@property (nonatomic, assign) CGPoint imvOffsetOriginPosition;
@property (nonatomic, strong) UIImage* combinedPhoto;
@property (nonatomic, assign) CGPoint leftEyeDetectedPositionPoint;
@property (nonatomic, assign) CGPoint rightEyeDetectedPositionPoint;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSMutableArray<UIImage*>* photoLayersList;

@end

#pragma mark - • IMPLEMENTATION
@implementation VirtualShowcaseMaskEditionVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize category, userPhoto, isLoaded, combinedPhoto, leftEyeDetectedPositionPoint, rightEyeDetectedPositionPoint;
@synthesize viewPhotos, viewFooter, imvUserPhoto, imvProductMask, viewContainerImages, lblProductName, cvProducts, bottomConstraintProductName, btnAddLayer, btnRemoveLayer;
@synthesize maskAngle, maskScale, imvOffsetOriginPosition, photoLayersList;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finalizar" style:UIBarButtonItemStylePlain target:self action:@selector(actionShowResult:)];
    
    isLoaded = NO;
    maskAngle = 0.0;
    maskScale = 1.0;
    leftEyeDetectedPositionPoint = CGPointZero;
    rightEyeDetectedPositionPoint = CGPointZero;
    imvOffsetOriginPosition = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout];
        //
        photoLayersList = [NSMutableArray new];
        [photoLayersList addObject:userPhoto];
        combinedPhoto = [UIImage imageWithData:UIImagePNGRepresentation(userPhoto)];
        //
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
        });
        [self loadProductImagesForIndex:0];
        isLoaded = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToPhotoResult"]){
        VirtualShowcasePhotoResultVC *vcPhotoResult = segue.destinationViewController;
        vcPhotoResult.photo = (UIImage*)sender;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)actionShowResult:(id)sender
{
    //Desenhando a imagem resultante:
    UIImage *finalMask = [self drawMaskInPhoto];
    
    //watermark frame + userPhoto + mask
    UIImage *basePhoto = [ToolBox graphicHelper_MergeImage:[UIImage imageNamed:@"showcase-base-photo-watermark.jpg"] withImage:combinedPhoto position:CGPointMake(20, 20) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    UIImage *photoResult = [ToolBox graphicHelper_MergeImage:basePhoto withImage:finalMask position:CGPointMake(20, 20) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    
    [self performSegueWithIdentifier:@"SegueToPhotoResult" sender:photoResult];
}

-(UIImage*)drawMaskInPhoto
{
    //**************************************************
    //PARTE 1
    //**************************************************
    
    //Achando as proporções da imagem rotacionada
    float aspectoDesenho = imvProductMask.bounds.size.width/imvProductMask.bounds.size.height;
    float newLarguraDesenho = imvProductMask.image.size.width;
    float newAlturaDesenho = imvProductMask.image.size.height;
    if((imvProductMask.image.size.width/imvProductMask.image.size.height)>aspectoDesenho){
        newAlturaDesenho = imvProductMask.image.size.width / aspectoDesenho;
    }else{
        newLarguraDesenho = imvProductMask.image.size.height * aspectoDesenho;
    }
    
    //view de comparacao
    UIImageView *viewTeste = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, newLarguraDesenho, newAlturaDesenho)];
    viewTeste.transform = CGAffineTransformMakeRotation(maskAngle);
    
    float larguraAlteradaDesenho = viewTeste.frame.size.width;
    float alturaAlteradaDesenho = viewTeste.frame.size.height;
    float aspectoX = larguraAlteradaDesenho/viewTeste.bounds.size.width;
    float aspectoY = alturaAlteradaDesenho/viewTeste.bounds.size.height;
    float novaLargura = aspectoX * newLarguraDesenho;
    float novaAltura = aspectoY * newAlturaDesenho;
    
    //Desenhando o fundo no angulo correto
    CGSize tam = CGSizeMake(novaLargura, novaAltura);
    UIGraphicsBeginImageContext(tam);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, novaLargura/2, novaAltura/2);
    transform = CGAffineTransformRotate(transform, maskAngle);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGContextConcatCTM(context, transform);
    //Aqui o desenho é aplicado no contexto
    CGContextDrawImage(context, CGRectMake(-(imvProductMask.image.size.width/2), -(imvProductMask.image.size.height/2), imvProductMask.image.size.width, imvProductMask.image.size.height), imvProductMask.image.CGImage);
    //Aqui o desenho é salvo em uma variável
    UIImage *backgroundImage = [[UIImage alloc]init];
    backgroundImage = [UIImage imageWithCGImage: CGBitmapContextCreateImage(context)];
    UIGraphicsEndImageContext();
    
    //**************************************************
    //PARTE 2
    //**************************************************
    
    //A imagem já rotacionada deve ter seu tamanho ajustado a resolução da máscara:
    float aspectoMascara = (float)imvUserPhoto.frame.size.width/(float)imvUserPhoto.frame.size.height;
    float newLarguraMascara = imvUserPhoto.image.size.width;
    float newAlturaMascara = imvUserPhoto.image.size.height;
    
    if(((float)imvUserPhoto.image.size.width/(float)imvUserPhoto.image.size.height)>aspectoMascara){
        newAlturaMascara = (float)imvUserPhoto.image.size.width / aspectoMascara;
    }else{
        newLarguraMascara = (float)imvUserPhoto.image.size.height * aspectoMascara;
    }
    
    //Desenhando a mascara com um fundo correto
    CGSize tam2 = CGSizeMake(newLarguraMascara, newAlturaMascara);
    UIGraphicsBeginImageContext(tam2);
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGAffineTransform transform2 = CGAffineTransformIdentity;
    transform2 = CGAffineTransformTranslate(transform2, newLarguraMascara/2, newAlturaMascara/2);
    transform2 = CGAffineTransformScale(transform2, 1.0, -1.0);
    CGContextConcatCTM(context2, transform2);
    //Aqui o desenho é aplicado no contexto
    CGContextDrawImage(context2, CGRectMake(-(imvUserPhoto.image.size.width/2), -(imvUserPhoto.image.size.height/2), imvUserPhoto.image.size.width, imvUserPhoto.image.size.height), imvUserPhoto.image.CGImage);
    //Aqui o desenho é salvo em uma variável
    UIImage *maskImage = [[UIImage alloc]init];
    maskImage = [UIImage imageWithCGImage: CGBitmapContextCreateImage(context2)];
    UIGraphicsEndImageContext();
    
    //**************************************************
    //PARTE 3
    //**************************************************
    
    float proporcaoAltura = (float)imvProductMask.frame.size.height / (float)imvUserPhoto.frame.size.height;
    float proporcaoLargura = (float)imvProductMask.frame.size.width / (float)imvUserPhoto.frame.size.width;
    float larguraFinalDesenho = (float)proporcaoLargura*maskImage.size.width;
    float alturaFinalDesenho = (float)proporcaoAltura*maskImage.size.height;
    float deslocamentoX = (float)imvProductMask.frame.origin.x / (float)imvUserPhoto.frame.size.width;
    float deslocamentoY = (float)imvProductMask.frame.origin.y / (float)imvUserPhoto.frame.size.height;
    
    //Desenhando a mascara com um fundo correto
    CGSize tam3 = CGSizeMake(maskImage.size.width, maskImage.size.height);
    UIGraphicsBeginImageContext(tam3);
    CGContextRef context3 = UIGraphicsGetCurrentContext();
    CGAffineTransform transform3 = CGAffineTransformIdentity;
    transform3 = CGAffineTransformTranslate(transform3, (float)maskImage.size.width/2.0, (float)maskImage.size.height/2.0);
    transform3 = CGAffineTransformScale(transform3, 1.0, -1.0);
    CGContextConcatCTM(context3, transform3);
    //Aqui o desenho é aplicado no contexto
    CGContextSetRGBFillColor(context3, 1.0, 1.0, 1.0, 1.0); //Retângulo branco
    CGContextFillRect(context3, CGRectMake(-(maskImage.size.width/2), -(maskImage.size.height/2), maskImage.size.width, maskImage.size.height));
    //Imagens
    float posicaoFundoX = -((float)maskImage.size.width/2.0)+((float)maskImage.size.width*deslocamentoX);
    //y sobe aumentando
    float posicaoFundoY =  -((float)maskImage.size.height/2.0)+(maskImage.size.height)+(maskImage.size.height*deslocamentoY)*(-1)-(alturaFinalDesenho);
    //CGContextDrawImage(context3, CGRectMake(posicaoFundoX,posicaoFundoY,larguraFinalDesenho,alturaFinalDesenho),backgroundImage.CGImage);
    CGContextDrawImage(context3, CGRectMake(-((float)maskImage.size.width/2.0), -((float)maskImage.size.height/2.0), (float)maskImage.size.width, (float)maskImage.size.height),maskImage.CGImage);
    CGContextDrawImage(context3, CGRectMake(posicaoFundoX,posicaoFundoY,larguraFinalDesenho,alturaFinalDesenho),backgroundImage.CGImage);
    //Aqui o desenho é salvo em uma variável
    UIImage *finalImage = [[UIImage alloc]init];
    finalImage = [UIImage imageWithCGImage: CGBitmapContextCreateImage(context3)];
    UIGraphicsEndImageContext();
    //
    return finalImage;
}

- (void)panGestureAction:(UIPanGestureRecognizer*)gestureRecognizer
{
//    CGPoint offset = [gestureRecognizer translationInView:self.view];
//    gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + offset.x, gestureRecognizer.view.center.y + offset.y);
//    [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGPoint offset = [gestureRecognizer translationInView:self.view];
    imvProductMask.center = CGPointMake(imvProductMask.center.x + offset.x,imvProductMask.center.y + offset.y);
    [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer*)gestureRecognizer
{
//    maskScale = maskScale * gestureRecognizer.scale;
//    NSLog(@"Scale: %f", maskScale);
//    gestureRecognizer.view.transform = CGAffineTransformScale(gestureRecognizer.view.transform, gestureRecognizer.scale, gestureRecognizer.scale);
//    gestureRecognizer.scale = 1.0;

    maskScale = maskScale * gestureRecognizer.scale;
    NSLog(@"Scale: %f", maskScale);
    imvProductMask.transform = CGAffineTransformScale(imvProductMask.transform, gestureRecognizer.scale, gestureRecognizer.scale);
    gestureRecognizer.scale = 1.0;
}

- (void)rotationGestureAction:(UIRotationGestureRecognizer*)gestureRecognizer
{
//    maskAngle = maskAngle + gestureRecognizer.rotation;
//    NSLog(@"Angle: %f", maskAngle);
//    CGAffineTransform transform = gestureRecognizer.view.transform;
//    gestureRecognizer.view.transform = CGAffineTransformRotate(transform, gestureRecognizer.rotation);
//    gestureRecognizer.rotation = 0;
    
    maskAngle = maskAngle + gestureRecognizer.rotation;
    NSLog(@"Angle: %f", maskAngle);
    CGAffineTransform transform = imvProductMask.transform;
    imvProductMask.transform = CGAffineTransformRotate(transform, gestureRecognizer.rotation);
    gestureRecognizer.rotation = 0;
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer*)gestureRecognizer
{
//    maskAngle = 0.0;
//    maskScale = 1.0;
//    [UIView animateWithDuration:0.2 animations:^{
//        gestureRecognizer.view.transform = CGAffineTransformIdentity;
//        gestureRecognizer.view.frame = imvUserPhoto.frame;
//    }];
    
    maskAngle = 0.0;
    maskScale = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        imvProductMask.transform = CGAffineTransformIdentity;
        imvProductMask.frame = imvUserPhoto.frame;
    }];
}

- (IBAction)actionAddLayer:(id)sender
{
    //Cria uma nova camada mesclando a imagem de fundo com a máscara atual:
    UIImage* newLayer = [self drawMaskInPhoto];
    [photoLayersList addObject:newLayer];
    combinedPhoto = [UIImage imageWithData:UIImagePNGRepresentation(newLayer)];
    
    //Atualizando a tela:
    imvUserPhoto.image = combinedPhoto;
    
    [self showProductNameLabel:@"Máscara extra adicionada!"];
    
    [btnRemoveLayer setHidden:NO];
    
//    for (VirtualShowcaseProduct *product in category.products){
//        if (product.selected){
//            imvProductMask.image = product.mask;
//            [self showProductNameLabel:product.name];
//            [self analyzeFaceForProduct:product];
//            //
//            [btnRemoveLayer setHidden:NO];
//            break;
//        }
//    }
}

- (IBAction)actionRemoveLayer:(id)sender
{
    if (photoLayersList.count > 1){
        //Removendo a última camada:
        [photoLayersList removeLastObject];
        combinedPhoto = [UIImage imageWithData:UIImagePNGRepresentation([photoLayersList lastObject])];
        
        //Atualizando a tela:
        imvUserPhoto.image = combinedPhoto;
        
        [self showProductNameLabel:@"Máscara extra removida!"];
        
        if (photoLayersList.count == 1){
            [btnRemoveLayer setHidden:YES];
        }
        
//        for (VirtualShowcaseProduct *product in category.products){
//            if (product.selected){
//                imvProductMask.image = product.mask;
//                [self analyzeFaceForProduct:product];
//                //
//                if (photoLayersList.count == 1){
//                    [btnRemoveLayer setHidden:YES];
//                }
//                break;
//            }
//        }
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return category.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ShowcaseProductCustomCell";
    
    ShowcaseProductCollectionViewCell *cell = (ShowcaseProductCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setupLayout];
    
    cell.backgroundColor = nil;
    
    __block VirtualShowcaseProduct *product = [category.products objectAtIndex:indexPath.row];
    
    cell.imvProduct.image = product.picture;
    
    if (product.selected){
        cell.layer.borderWidth = 3.0;
        cell.layer.borderColor = AppD.styleManager.colorPalette.primaryButtonNormal.CGColor;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (VirtualShowcaseProduct *product in category.products){
        product.selected = NO;
    }
    VirtualShowcaseProduct *product = [category.products objectAtIndex:indexPath.row];
    product.selected = YES;
    
    imvProductMask.image = product.mask;
    [self showProductNameLabel:product.name];
    [self analyzeFaceForProduct:product];
    
    [collectionView reloadData];
}

/////////////

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lado = (collectionView.frame.size.height - 10);
    return CGSizeMake(lado, lado);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = category.name;
    
    viewPhotos.backgroundColor = nil;
    viewPhotos.clipsToBounds = YES;
    
    viewFooter.backgroundColor = [UIColor blackColor];
    viewFooter.clipsToBounds = YES;
    
    lblProductName.backgroundColor = AppD.styleManager.colorPalette.primaryButtonSelected;
    [lblProductName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    lblProductName.textColor = [UIColor whiteColor];
    lblProductName.text = @"";
    
    btnAddLayer.backgroundColor = nil;
    [btnAddLayer setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnAddLayer.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnAddLayer.frame.size.height/2.0, btnAddLayer.frame.size.height/2.0) andColor:COLOR_MA_GREEN] forState:UIControlStateNormal];
    [btnAddLayer setTintColor:[UIColor whiteColor]];
    [btnAddLayer setExclusiveTouch:YES];
    [btnAddLayer.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_LABEL_LARGE]];
    [btnAddLayer setTitle:@"+" forState:UIControlStateNormal];
    
    btnRemoveLayer.backgroundColor = nil;
    [btnRemoveLayer setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRemoveLayer.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnRemoveLayer.frame.size.height/2.0, btnRemoveLayer.frame.size.height/2.0) andColor:COLOR_MA_RED] forState:UIControlStateNormal];
    [btnRemoveLayer setTintColor:[UIColor whiteColor]];
    [btnRemoveLayer setExclusiveTouch:YES];
    [btnRemoveLayer.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_LABEL_LARGE]];
    [btnRemoveLayer setTitle:@"-" forState:UIControlStateNormal];
    [btnRemoveLayer setHidden:YES];
    
    bottomConstraintProductName.constant = -(lblProductName.frame.size.height);
    
    cvProducts.backgroundColor = [UIColor blackColor];
}

- (void) showProductNameLabel:(NSString*)pName
{
    lblProductName.text = pName;
    
    if (bottomConstraintProductName.constant != 0.0){
        bottomConstraintProductName.constant = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (bottomConstraintProductName.constant == 0){
                    bottomConstraintProductName.constant = -(lblProductName.frame.size.height);
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.view layoutIfNeeded];
                    }];
                }
            });
        }];
    }
}

- (void)loadProductImagesForIndex:(long)index
{
    if (index == category.products.count){
        //Acabou de percorrer todas as imagens:
        [self configureMaskViews];
    }else{
        __block VirtualShowcaseProduct *product = [category.products objectAtIndex:index];
        
        //thumb:
        [[[AsyncImageDownloader alloc] initWithFileURL:product.pictureURL successBlock:^(NSData *data) {
            product.picture = [UIImage imageWithData:data];
        } failBlock:^(NSError *error) {
            product.picture = [UIImage imageNamed:@""];
        }] startDownload];
        
        //mask:
        [[[AsyncImageDownloader alloc] initWithFileURL:product.maskURL successBlock:^(NSData *data) {
            product.mask = [UIImage imageWithData:data];
            [self loadProductImagesForIndex:(index + 1)];
        } failBlock:^(NSError *error) {
            product.mask = nil;
            [self loadProductImagesForIndex:(index + 1)];
        }] startDownload];
    }
}

- (void)configureMaskViews
{
    CGFloat ratio = 320.0/416.0;
    CGFloat margin = 10.0;
    CGFloat maxViewWidth = viewPhotos.frame.size.width - margin;
    CGFloat maxViewHeight = viewPhotos.frame.size.height - margin;
    
    CGFloat newWidth = maxViewWidth;
    CGFloat newHeight = maxViewHeight;
    
    CGFloat viewRatio = maxViewWidth / maxViewHeight;
    
    if (viewRatio < ratio){
        //Height fixo
        newHeight = maxViewWidth / ratio;
    }else{
        //Width fixo
        newWidth = maxViewHeight * ratio;
    }
    
    imvOffsetOriginPosition = CGPointMake(((maxViewWidth - newWidth) / 2.0) + (margin/2.0), ((maxViewHeight - newHeight) / 2.0) + (margin/2.0));
    
    //Tamanhos e posições:
    viewContainerImages = [[UIView alloc] initWithFrame:CGRectMake(imvOffsetOriginPosition.x, imvOffsetOriginPosition.y, newWidth, newHeight)];
    viewContainerImages.backgroundColor = [UIColor blackColor];
    viewContainerImages.clipsToBounds = YES;
    [viewContainerImages setUserInteractionEnabled:YES];
    //Bordas:
    viewContainerImages.layer.borderColor = [UIColor whiteColor].CGColor;
    viewContainerImages.layer.borderWidth = 2.0;
    viewContainerImages.layer.cornerRadius = 8.0;
    //
    imvUserPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, newWidth, newHeight)];
    imvUserPhoto.backgroundColor = nil;
    imvUserPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [imvUserPhoto setUserInteractionEnabled:NO];
    //
    imvProductMask = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, newWidth, newHeight)];
    imvProductMask.backgroundColor = nil;
    imvProductMask.contentMode = UIViewContentModeScaleAspectFit;
    [imvProductMask setUserInteractionEnabled:YES];
    
    //Gestos para mover e dar zoom:
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureAction:)];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGestureAction:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureAction:)];
    [doubleTap setNumberOfTouchesRequired:1];
    [doubleTap setNumberOfTapsRequired:2];
    pan.delegate = self;
    pinch.delegate = self;
    rotation.delegate = self;
    doubleTap.delegate = self;
    [viewContainerImages addGestureRecognizer:pinch]; // imvProductMask antes
    [viewContainerImages addGestureRecognizer:pan];
    [viewContainerImages addGestureRecognizer:rotation];
    [viewContainerImages addGestureRecognizer:doubleTap];
    
    //Selecionando o primeiro elemento como o ativo:
    VirtualShowcaseProduct *product = [category.products objectAtIndex:0];
    product.selected = YES;
    
    imvUserPhoto.image = combinedPhoto;
    imvProductMask.image = product.mask;
    
    [viewPhotos addSubview:viewContainerImages];
    [viewContainerImages addSubview:imvUserPhoto];
    [viewContainerImages addSubview:imvProductMask];
    
    [self showProductNameLabel:product.name];
    
    [self analyzeFaceForProduct:product];
    
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];

    [cvProducts reloadData];
    [cvProducts setFrame:CGRectMake(0.0, 0.0, cvProducts.frame.size.width, cvProducts.frame.size.height)];
    [self.view layoutSubviews];
}

-(void)analyzeFaceForProduct:(VirtualShowcaseProduct*)product
{
    //Ao alterar o 'anchorPoint' do layer, também altera-se o valor de 'position', o que provoca o deslocamento do layer.
    //Para poder alterar seu 'anchorPoint', mantendo a posição original, é preciso um método customizado:
    [self setAnchorPointToView:imvProductMask point:CGPointMake(0.5, 0.5)];
    
    CGPoint leftEyePosition = CGPointZero;
    CGPoint rightEyePosition = CGPointZero;
    
    if (product.leftEyePositionX != nil && product.leftEyePositionY != nil && ![product.leftEyePositionX isEqualToString:@""] && ![product.leftEyePositionY isEqualToString:@""]){
        leftEyePosition = CGPointMake([product.leftEyePositionX floatValue], [product.leftEyePositionY floatValue]) ;
    }
    
    if (product.rightEyePositionX != nil && product.rightEyePositionY != nil && ![product.rightEyePositionX isEqualToString:@""] && ![product.rightEyePositionY isEqualToString:@""]){
        rightEyePosition = CGPointMake([product.rightEyePositionX floatValue], [product.rightEyePositionY floatValue]) ;
    }
    
    if (leftEyePosition.x == 0.0 || leftEyePosition.y == 0.0){
        return;
    }
    if (rightEyePosition.x == 0 || rightEyePosition.y == 0){
        return;
    }
    
    BOOL needDetect = NO;
    
    if (leftEyeDetectedPositionPoint.x == 0.0 || leftEyeDetectedPositionPoint.y == 0.0){
        needDetect = YES;
    }
    if (rightEyeDetectedPositionPoint.x == 0.0 || rightEyeDetectedPositionPoint.y == 0.0){
        needDetect = YES;
    }
    
    if (needDetect){
        CIContext *context = [CIContext context];
        NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
        
        opts = @{ CIDetectorImageOrientation : @(userPhoto.imageOrientation)};
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:userPhoto.CGImage] options:opts];
        
        CIFaceFeature *feature = [features firstObject];
        
        if (feature.hasLeftEyePosition) {
            leftEyeDetectedPositionPoint = feature.leftEyePosition;
        }
        if (feature.hasRightEyePosition) {
            rightEyeDetectedPositionPoint = feature.rightEyePosition;
        }
    }
    
    BOOL leftEye = NO;
    BOOL rightEye = NO;
    
    if (leftEyeDetectedPositionPoint.x != 0.0 && leftEyeDetectedPositionPoint.y != 0.0){
        leftEye = YES;
    }
    
    if (rightEyeDetectedPositionPoint.x != 0.0 && rightEyeDetectedPositionPoint.y != 0.0){
        rightEye = YES;
    }
    
    if (leftEye && rightEye){
        //Os dois olhos podem ser alinhados:
        
        //Visual Debug To Mask Eye Position:
        //UIImage *eyes = [self drawEyes:CGPointMake(leftEyePosition.x, leftEyePosition.y) and:CGPointMake(rightEyePosition.x, rightEyePosition.y)];
        //imvProductMask.image = [ToolBox graphicHelper_MergeImage:imvProductMask.image withImage:eyes position:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
        
        imvProductMask.transform = CGAffineTransformIdentity;
        imvProductMask.frame = CGRectMake(0.0, 0.0, viewContainerImages.frame.size.width, viewContainerImages.frame.size.height);
        
        //Scale:    ========================================================================
        CGFloat xDist1 = (rightEyePosition.x - leftEyePosition.x);
        CGFloat yDist1 = (rightEyePosition.y - leftEyePosition.y);
        CGFloat distanceMask = sqrt((xDist1 * xDist1) + (yDist1 * yDist1));
        //
        CGFloat xDist2 = (rightEyeDetectedPositionPoint.x - leftEyeDetectedPositionPoint.x);
        CGFloat yDist2 = (rightEyeDetectedPositionPoint.y - leftEyeDetectedPositionPoint.y);
        CGFloat distanceFace = sqrt((xDist2 * xDist2) + (yDist2 * yDist2));
        //
        maskScale = distanceFace / distanceMask;
        
        //Angle:    ========================================================================
        CGPoint originPoint = CGPointMake(rightEyeDetectedPositionPoint.x - leftEyeDetectedPositionPoint.x, rightEyeDetectedPositionPoint.y - leftEyeDetectedPositionPoint.y);
        maskAngle = -atan2f(originPoint.y, originPoint.x);
        
        //Normalização:
        //No CoreImage o eixo y tem sua origem no canto inferior esquerdo da imagem
        CGPoint normalizedLeftEyeDestionation = CGPointMake(leftEyeDetectedPositionPoint.x, (userPhoto.size.height - leftEyeDetectedPositionPoint.y));
        CGPoint normalizedRightEyeDestionation = CGPointMake(rightEyeDetectedPositionPoint.x, (userPhoto.size.height - rightEyeDetectedPositionPoint.y));
        
        //Configurations:  ========================================================================        
        CGPoint eyeCenterPoint = CGPointMake(((MAX(normalizedRightEyeDestionation.x, normalizedLeftEyeDestionation.x) - MIN(normalizedRightEyeDestionation.x, normalizedLeftEyeDestionation.x)) / 2.0) + MIN(normalizedRightEyeDestionation.x, normalizedLeftEyeDestionation.x) , ((MAX(normalizedRightEyeDestionation.y, normalizedLeftEyeDestionation.y) - MIN(normalizedRightEyeDestionation.y, normalizedLeftEyeDestionation.y)) / 2.0) + MIN(normalizedRightEyeDestionation.y, normalizedLeftEyeDestionation.y));
        CGPoint maskCenterPoint = CGPointMake((rightEyePosition.x - leftEyePosition.x) / 2.0 + leftEyePosition.x, (rightEyePosition.y - leftEyePosition.y) / 2.0 + leftEyePosition.y);
        CGFloat eyeViewPointX = ((eyeCenterPoint.x / userPhoto.size.width) * imvProductMask.layer.bounds.size.width);
        CGFloat eyeViewPointY = ((eyeCenterPoint.y / userPhoto.size.height) * imvProductMask.layer.bounds.size.height);
        CGFloat maskViewPointX = ((maskCenterPoint.x / product.mask.size.width) * imvProductMask.layer.bounds.size.width);
        CGFloat maskViewPointY = ((maskCenterPoint.y / product.mask.size.height) * imvProductMask.layer.bounds.size.height);
        CGPoint newAnchorPoint = CGPointMake(maskViewPointX/imvProductMask.layer.bounds.size.width, maskViewPointY/imvProductMask.layer.bounds.size.height);
        //
        [self setAnchorPointToView:imvProductMask point:newAnchorPoint];
        
        [UIView animateWithDuration:0.2 animations:^{
            //Posição:  ========================================================================
            imvProductMask.transform = CGAffineTransformTranslate(imvProductMask.transform, (eyeViewPointX - maskViewPointX), (eyeViewPointY - maskViewPointY));
            //Rotação:  ========================================================================
            imvProductMask.transform = CGAffineTransformRotate(imvProductMask.transform, maskAngle);
            //Escala:   ========================================================================
            imvProductMask.transform = CGAffineTransformScale(imvProductMask.transform, maskScale, maskScale);
        }];
    }
}

/* O método abaixo é apenas um auxiliar para depuração. */
- (UIImage*)drawEyes:(CGPoint)leftEyePosition and:(CGPoint)rightEyePosition
{
    CGSize canvasSize = CGSizeMake(960.0, 1248.0);
    // Create the context
    UIGraphicsBeginImageContext(canvasSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // setup drawing attributes
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    // setup the circle size
    CGRect circleRect1 = CGRectMake( leftEyePosition.x, (leftEyePosition.y), 20.0, 20.0);
    CGRect circleRect2 = CGRectMake( rightEyePosition.x, (rightEyePosition.y), 20.0, 20.0);
    // Draw the Circle
    CGContextFillEllipseInRect(ctx, circleRect1);
    CGContextFillEllipseInRect(ctx, circleRect2);
    // Create Image
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(ctx);
    //
    return retImage;
}

- (void)setAnchorPointToView:(UIView*)v point:(CGPoint)p
{
    CGPoint newPoint = CGPointMake(v.bounds.size.width * p.x, v.bounds.size.height * p.y);
    CGPoint oldPoint = CGPointMake(v.bounds.size.width * v.layer.anchorPoint.x, v.bounds.size.height * v.layer.anchorPoint.y);
    //
    newPoint = CGPointApplyAffineTransform(newPoint, v.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, v.transform);
    //
    CGPoint position = v.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    //
    v.layer.position = position;
    v.layer.anchorPoint = p;
}

@end
