//
//  VirtualObjectProperties.h
//  LAB360-ObjC
//
//  Created by Erico GT on 17/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface VirtualObjectProperties : NSObject

typedef struct{
    CGFloat W;
    CGFloat H;
    CGFloat L;
    //
    CGFloat minX;
    CGFloat maxX;
    CGFloat minY;
    CGFloat maxY;
    CGFloat minZ;
    CGFloat maxZ;
    SCNVector3 center;
} ObjectBoxSize;

@property(nonatomic, strong) NSURL *imageRef;
@property(nonatomic, strong) UIImage *image;
//
@property(nonatomic, assign) BOOL invalidMapAssetDetected;
//
@property(nonatomic, assign) BOOL reflectionMap;
@property(nonatomic, assign) BOOL transparencyMap;
@property(nonatomic, assign) CGFloat transparencyValue;

+ (VirtualObjectProperties*)newVOP:(NSURL*)iRef reflection:(BOOL)r transparency:(BOOL)t;

+ (NSDictionary*)loadMaterialPropertiesInfoForFile:(NSURL*)fileURL;

+ (ObjectBoxSize)boxSizeForObject:(SCNNode*)node;

@end
