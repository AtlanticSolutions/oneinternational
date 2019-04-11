//
//  RotationalImageViewer.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "RotationalImageViewer.h"

@interface RotationalImageViewer()

//Layout:
@property(nonatomic, strong) UIImageView *imageViewer;
@property(nonatomic, strong) UIButton *zoomButton;

//Data:
@property(nonatomic, weak) id<RotationalImageViewerDelegate> viewDelegate;
@property(nonatomic, assign) int actualIndex;
@property(nonatomic, assign) int actualLayer;
@property(nonatomic, assign) int numberOfItems;
@property(nonatomic, assign) int numberOfLayers;
@property(nonatomic, assign) BOOL layerChangeEnabled;
@property(nonatomic, assign) CGPoint touchReferencePosition;
@property(nonatomic, assign) RotationalImageViewerScrollDirection rotationDirection;
@property(nonatomic, assign) RotationalImageViewerZoomButtonPosition currentZoomPosition;
@property(nonatomic, assign) RotationalImageViewerScrollSensibility movimentSensibility;

@end

@implementation RotationalImageViewer

@synthesize imageViewer, zoomButton;
@synthesize viewDelegate, actualIndex, actualLayer, numberOfItems, numberOfLayers, layerChangeEnabled, rotationDirection, currentZoomPosition, movimentSensibility, touchReferencePosition;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        viewDelegate = nil;
        actualIndex = 0;
        actualLayer = 0;
        numberOfItems = 0;
        numberOfLayers = 0;
        layerChangeEnabled = NO;
        rotationDirection = RotationalImageViewerScrollDirectionHorizontal;
        movimentSensibility = RotationalImageViewerScrollSensibilityNormal;
        currentZoomPosition = RotationalImageViewerZoomButtonPositionBottomLeft;
        touchReferencePosition = CGPointZero;
        //
        [self setupImageView];
        [self setupZoomButton];
        //
        [self setClipsToBounds:YES];
    }
    return self;
}

- (RotationalImageViewer* _Nullable)initWithFrame:(CGRect)frame andDelegate:(id<RotationalImageViewerDelegate> _Nonnull)viewerDelegate
{
    RotationalImageViewer *riv = [[RotationalImageViewer alloc] initWithFrame:frame];
    riv.viewDelegate = viewerDelegate;
    
    return riv;
}

- (void)reloadData
{
    if ([viewDelegate respondsToSelector:@selector(rotationalImageViewerNumberOfItems:)] && [viewDelegate respondsToSelector:@selector(rotationalImageViewerNumberOfLayers:)]){
        int n = [viewDelegate rotationalImageViewerNumberOfItems:self];
        numberOfItems = n > 0 ? n : 0;
        //
        int l = [viewDelegate rotationalImageViewerNumberOfLayers:self];
        numberOfLayers = l > 0 ? l : 0;
    }else{
        NSAssert(false, @"O objeto RotationalImageViewer não possui um delegate em conformidade.");
        return;
    }
    
    actualIndex = 0;
    actualLayer = 0;
    
    [self updateImageView];
}

- (int)currentIndex
{
    return actualIndex;
}

- (int)currentLayer
{
    return actualLayer;
}

- (void)setRotationDirection:(RotationalImageViewerScrollDirection)newDirection;
{
    if (rotationDirection != newDirection){
        rotationDirection = newDirection;
        
        //A troca de layer não ocorre quando o componente é utilizado no sentido vertical.
        if (rotationDirection == RotationalImageViewerScrollDirectionVertical){
            layerChangeEnabled = NO;
            actualLayer = 0;
        }
    }
}

- (void)setMovementSensibility:(RotationalImageViewerScrollSensibility)sensibility;
{
    movimentSensibility = sensibility;
}

- (void)setEnableLayerChange:(BOOL)enable
{
    //Somente quando o componente está em seu modo rotação horizontal esta veriável pode ser modificada.
    if (rotationDirection == RotationalImageViewerScrollDirectionHorizontal){
        layerChangeEnabled = enable;
    }
}

- (void)setImageAspect:(UIViewContentMode)mode
{
    [imageViewer setContentMode:mode];
}

- (void)setViewerBackgroundColor:(UIColor* _Nonnull)bColor
{
    imageViewer.backgroundColor = bColor;
}

- (void)setCurrentIndex:(int)index
{
    if (numberOfItems != 0 && index >= 0){
        if (index >=0 && index <numberOfItems){
            actualIndex = index;
            [self updateImageView];
        }
    }
}

- (void)setCurrentLayer:(int)layerIndex
{
    if (rotationDirection == RotationalImageViewerScrollDirectionHorizontal){
        if (numberOfLayers != 0 && layerIndex >= 0){
            if (layerIndex >=0 && layerIndex <numberOfLayers){
                actualLayer = layerIndex;
                [self updateImageView];
            }
        }
    }
}

- (void)setZoomButtonPosition:(RotationalImageViewerZoomButtonPosition)position
{
    [zoomButton setHidden:NO];
    CGFloat margin = 10.0;
    
    switch (position) {
        case RotationalImageViewerZoomButtonPositionTopLeft:{
            [zoomButton setFrame:CGRectMake(margin, margin, zoomButton.frame.size.width, zoomButton.frame.size.height)];
        }break;
        //
        case RotationalImageViewerZoomButtonPositionTopRight:{
            [zoomButton setFrame:CGRectMake((self.frame.size.width - margin - zoomButton.frame.size.width), margin, zoomButton.frame.size.width, zoomButton.frame.size.height)];
        }break;
            //
        case RotationalImageViewerZoomButtonPositionBottomLeft:{
            [zoomButton setFrame:CGRectMake(10.0, (self.frame.size.height - margin - zoomButton.frame.size.height), zoomButton.frame.size.width, zoomButton.frame.size.height)];
        }break;
            //
        case RotationalImageViewerZoomButtonPositionBottomRight:{
            [zoomButton setFrame:CGRectMake((self.frame.size.width - margin - zoomButton.frame.size.width), (self.frame.size.height - margin - zoomButton.frame.size.height), zoomButton.frame.size.width, zoomButton.frame.size.height)];
        }break;
            //
        case RotationalImageViewerZoomButtonPositionHidden:{
            [zoomButton setHidden:YES];
        }break;
    }
}

- (void)autoCreateConstraintsToParent:(UIView* _Nonnull)view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    [self addConstraintToView:self andParent:view];
    [self setZoomButtonPosition:currentZoomPosition];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (numberOfItems > 0){
        UITouch *touch = [[event allTouches] anyObject];
        touchReferencePosition = [touch locationInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    //Verifica se o componente possui itens para exibição:
    if (numberOfItems > 0){
        
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint actualP = [touch locationInView:self];
        CGFloat delta = 0.0;
        CGFloat step = 0.0;
        
        if (rotationDirection == RotationalImageViewerScrollDirectionHorizontal){
            delta = touchReferencePosition.x - actualP.x;
            step = self.frame.size.width / (CGFloat)numberOfItems;
        }else{
            delta = touchReferencePosition.y - actualP.y;
            step = self.frame.size.height / (CGFloat)numberOfItems;
        }
        
        //Verifica se a troca de camadas está habilitada.
        if (numberOfLayers > 0 && layerChangeEnabled && rotationDirection == RotationalImageViewerScrollDirectionHorizontal){
            
            CGFloat deltaLayer = 0.0;
            CGFloat stepLayer = 0.0;
            
            deltaLayer = touchReferencePosition.y - actualP.y;
            stepLayer = self.frame.size.height / (numberOfLayers > 0 ? (CGFloat)numberOfLayers : 1);
            
            if (deltaLayer != 0.0 && stepLayer != 0.0){
                if (fabs(deltaLayer) > fabs(stepLayer)){
                    int roundedDown = (int)(deltaLayer / stepLayer);
                    //
                    NSLog(@"\n\n\ndeltaLayer: %.2f", deltaLayer);
                    NSLog(@"\nstepLayer: %.2f", stepLayer);
                    NSLog(@"\nactualLayer: %i", actualLayer);
                    NSLog(@"\nroundedDownLayer: %i", roundedDown);
                    //
                    int newActual = actualLayer;
                    if (actualLayer + roundedDown < 0){
                        newActual = 0;
                    }else if (actualLayer + roundedDown >= numberOfLayers){
                        newActual = numberOfLayers - 1;
                    }else{
                        newActual = actualLayer + roundedDown;
                    }
                    
                    if (newActual != actualLayer){
                        actualLayer = abs(newActual);
                    }
                }
            }
        }
        
        //Processa o deslocamento do toque, verificando se precisa trocar de item:
        if (delta != 0.0 && step != 0.0){
            switch (movimentSensibility) {
                case RotationalImageViewerScrollSensibilityWeak:{step = step * 2.0;}break;
                case RotationalImageViewerScrollSensibilityNormal:{step = step;}break;
                case RotationalImageViewerScrollSensibilityStrong:{step = step / 2.0;}break;
            }
            
            if (fabs(delta) > fabs(step)){
                int roundedDown = (int)(delta / step);
                //
                NSLog(@"\n\n\ndelta: %.2f", delta);
                NSLog(@"\nstep: %.2f", step);
                NSLog(@"\nactualIndex: %i", actualIndex);
                NSLog(@"\nroundedDown: %i", roundedDown);
                //
                int newActual = actualIndex;
                if (actualIndex + roundedDown < 0){
                    newActual = numberOfItems + (actualIndex + roundedDown);
                }else if (actualIndex + roundedDown >= numberOfItems){
                    newActual = numberOfItems - (actualIndex + roundedDown);
                }else{
                    newActual = actualIndex + roundedDown;
                }
                
                if (newActual != actualIndex){
                    touchReferencePosition = [touch locationInView:self];
                    actualIndex = abs(newActual);
                    [self updateImageView];
                }
            }
        }
    }
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    
//}

#pragma mark - Actions

-(IBAction)actionZoomButton:(id)sender
{
    if ([viewDelegate respondsToSelector:@selector(rotationalImageViewer:selectedIndex:atLayer:)]){
        [viewDelegate rotationalImageViewer:self selectedIndex:actualIndex atLayer:actualLayer];
    }
}

#pragma mark - Private Methods

- (void)setupImageView
{
    imageViewer = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [imageViewer setContentMode:UIViewContentModeScaleAspectFit];
    imageViewer.backgroundColor = [UIColor whiteColor];
    //
    [self addSubview:imageViewer];
    [self bringSubviewToFront:imageViewer];
    //
    [self addConstraintToView:imageViewer andParent:self];
}

- (void)setupZoomButton
{
    //NOTE: For custom button, please implement additional delegate method.
    
    zoomButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    zoomButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [zoomButton setExclusiveTouch:YES];
    [zoomButton setImage:[[UIImage imageNamed:@"RotationalZoomButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [zoomButton setTintColor:[UIColor whiteColor]];
    [zoomButton addTarget:self action:@selector(actionZoomButton:) forControlEvents:UIControlEventTouchUpInside];
    zoomButton.layer.cornerRadius = 4.0;
    //
    [self addSubview:zoomButton];
    [self bringSubviewToFront:zoomButton];
    //
    [self setZoomButtonPosition:currentZoomPosition];
}

- (void)updateImageView
{
    if ([viewDelegate respondsToSelector:@selector(rotationalImageViewer:imageForItem:atLayer:)]){
        UIImage *i = [viewDelegate rotationalImageViewer:self imageForItem:actualIndex atLayer:actualLayer];
        imageViewer.image = i;
    }else{
        NSAssert(false, @"O objeto RotationalImageViewer não possui um delegate em conformidade.");
        return;
    }
    
    if ([viewDelegate respondsToSelector:@selector(rotationalImageViewer:updatedIndex:atLayer:)]){
        [viewDelegate rotationalImageViewer:self updatedIndex:actualIndex atLayer:actualLayer];
    }
}

- (void)addConstraintToView:(UIView*)subview andParent:(UIView*)parentView
{
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Trailing
    NSLayoutConstraint *trailing =[NSLayoutConstraint
                                   constraintWithItem:subview
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parentView
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Leading
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:subview
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Top
    NSLayoutConstraint *top =[NSLayoutConstraint
                              constraintWithItem:subview
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:parentView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:0.f];
    
    //Bottom
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:subview
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:parentView
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:0.f];
    
    [parentView addConstraint:trailing];
    [parentView addConstraint:leading];
    [parentView addConstraint:top];
    [parentView addConstraint:bottom];
    //
    [parentView setNeedsLayout];
    [parentView layoutIfNeeded];
}

@end
