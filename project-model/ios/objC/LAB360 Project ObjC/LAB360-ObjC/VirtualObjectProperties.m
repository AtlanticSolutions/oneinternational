//
//  VirtualObjectProperties.m
//  LAB360-ObjC
//
//  Created by Erico GT on 17/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "VirtualObjectProperties.h"

@implementation VirtualObjectProperties

@synthesize imageRef, image, reflectionMap, transparencyMap, transparencyValue, invalidMapAssetDetected;

- (instancetype)init
{
    self = [super init];
    if (self) {
        imageRef = nil;
        image = nil;
        reflectionMap = NO;
        transparencyMap = NO;
        transparencyValue = 0.0;
        invalidMapAssetDetected = NO;
    }
    return self;
}

+ (VirtualObjectProperties*)newVOP:(NSURL*)iRef reflection:(BOOL)r transparency:(BOOL)t
{
    VirtualObjectProperties *vop = [VirtualObjectProperties new];
    vop.imageRef = iRef;
    vop.reflectionMap = r;
    vop.transparencyMap = t;
    vop.transparencyValue = 0.0;
    //
    return vop;
}

+ (NSDictionary*)loadMaterialPropertiesInfoForFile:(NSURL*)fileURL
{
    NSMutableDictionary *propertiesDic = [NSMutableDictionary new];
    
    NSString *file = [fileURL lastPathComponent];
    
    NSString *mtlFile = [[file componentsSeparatedByString:@"."] firstObject];
    
    NSString *url = [[[fileURL absoluteString] stringByReplacingOccurrencesOfString:file withString:@""] stringByReplacingOccurrencesOfString:@"file:/" withString:@""];
    
    NSString *filepath = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mtl", mtlFile]];
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error){
        return propertiesDic;
    }
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    NSString *scopeMaterial = nil;
    for (NSString *line in fileLines){
        
        NSString *formatedLine = [line stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        //encontrando o material atual:
        if ([formatedLine rangeOfString:@"newmtl"].location != NSNotFound) {
            scopeMaterial = [[formatedLine componentsSeparatedByString:@" "] lastObject];
        }else{
            
            //Buscando mapas de textura inválidas:
//            NSString *trimmedLine = [formatedLine stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            if ([trimmedLine hasPrefix:@"map_Ka"] || [trimmedLine hasPrefix:@"map_Kd"] || [trimmedLine hasPrefix:@"map_Ks"] || [trimmedLine hasPrefix:@"map_refl"] || [trimmedLine hasPrefix:@"map_d"] || [trimmedLine hasPrefix:@"map_bump"] || [trimmedLine hasPrefix:@"bump"]){
//                NSArray *lineComponents = [trimmedLine componentsSeparatedByString:@" "];
//                if (lineComponents.count > 1){
//                    NSString *secondComponent = [lineComponents objectAtIndex:1];
//                    if ([secondComponent hasPrefix:@"-"]){
//                        if ([[propertiesDic allKeys] containsObject:scopeMaterial]){
//                            VirtualObjectProperties *vop = [propertiesDic objectForKey:scopeMaterial];
//                            vop.invalidMapAssetDetected = YES;
//                        }else{
//                            VirtualObjectProperties *vop = [VirtualObjectProperties newVOP:nil reflection:NO transparency:NO];
//                            vop.invalidMapAssetDetected = YES;
//                            [propertiesDic setValue:vop forKey:scopeMaterial];
//                        }
//                    }
//                }
//            }
            
            //encontrando a imagem atual (mapa de reflexão):
            if ([formatedLine rangeOfString:@"map_refl"].location != NSNotFound) {
                NSString *imageName = [[formatedLine componentsSeparatedByString:@" "] lastObject];
                NSURL *imageURL = [NSURL fileURLWithPath:[url stringByAppendingPathComponent:imageName]];
                //
                if ([[propertiesDic allKeys] containsObject:scopeMaterial]){
                    VirtualObjectProperties *vop = [propertiesDic objectForKey:scopeMaterial];
                    vop.reflectionMap = YES;
                    vop.imageRef = imageURL;
                }else{
                    VirtualObjectProperties *vop = [VirtualObjectProperties newVOP:imageURL reflection:YES transparency:NO];
                    [propertiesDic setValue:vop forKey:scopeMaterial];
                }
            }
            
            //encontrando dados sobre transparência:
            double transparencyValue = 0.0;
            if ([formatedLine rangeOfString:@"Tr "].location != NSNotFound) {
                NSString *tValue = [[formatedLine componentsSeparatedByString:@" "] lastObject];
                if ([self validateString:tValue withPattern:@"^[0-9]+(.{1}[0-9]+)?$"]){
                    transparencyValue = [tValue doubleValue];
                }
            }
            //
            if (transparencyValue > 0.0){
                if ([[propertiesDic allKeys] containsObject:scopeMaterial]){
                    VirtualObjectProperties *vop = [propertiesDic objectForKey:scopeMaterial];
                    vop.transparencyMap = YES;
                    vop.transparencyValue = 1.0 - transparencyValue;
                }else{
                    VirtualObjectProperties *vop = [VirtualObjectProperties newVOP:nil reflection:NO transparency:YES];
                    vop.transparencyValue = 1.0 - transparencyValue;
                    [propertiesDic setValue:vop forKey:scopeMaterial];
                }
            }
        }
    }
    
    return propertiesDic;
}

+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (regex == nil){
        return NO;
    }
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    return didValidate;
}

+ (ObjectBoxSize)boxSizeForObject:(SCNNode*)node
{
    ObjectBoxSize oos;
    oos.W = 0.0;
    oos.H = 0.0;
    oos.L = 0.0;
    //x
    oos.minX = 0.0;
    oos.maxX = 0.0;
    //y
    oos.minY = 0.0;
    oos.maxY = 0.0;
    //z
    oos.minZ = 0.0;
    oos.maxZ = 0.0;
    //center
    oos.center.x = 0.0;
    oos.center.y = 0.0;
    oos.center.z = 0.0;
    
    SCNVector3 min = SCNVector3Zero;
    SCNVector3 max = SCNVector3Zero;
    if ([node getBoundingBoxMin:&min max:&max]){
        oos.W = max.x - min.x;
        oos.H = max.y - min.y;
        oos.L = max.z - min.z;
        //x
        oos.minX = min.x;
        oos.maxX = max.x;
        //y
        oos.minY = min.y;
        oos.maxY = max.y;
        //z
        oos.minZ = min.z;
        oos.maxZ = max.z;
        //center
        oos.center.x = min.x + ((max.x - min.x) / 2.0);
        oos.center.y = min.y + ((max.y - min.y) / 2.0);
        oos.center.z = min.z + ((max.z - min.z) / 2.0);
    }
    
    return oos;
}

@end
