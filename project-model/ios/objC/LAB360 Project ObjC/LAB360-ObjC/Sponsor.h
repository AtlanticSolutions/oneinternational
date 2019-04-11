//
// Sponsor.h
// GS&MD
//
// Created by Lucas Correia on 2016/12/01 15:28:53 -0200.
// Copyright (c) Atlantic Solutions. All rights reserved.
//
// Note: Classe para representação do objeto de dados do Patrocinador do projeto GSMD.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DefaultObjectModelProtocol.h"

@interface Sponsor : NSObject<DefaultObjectModelProtocol>

//Properties
@property(nonatomic, strong) NSString* sponsorLink;
@property(nonatomic, strong) UIImage* image;
@property(nonatomic, strong) NSString* imageUrl;
@property(nonatomic, strong) NSString* name;

//Protocol Methods
//@required
+(Sponsor*)newObject;
+(NSString*)className;
+(Sponsor*)createObjectFromDictionary:(NSDictionary*)dicData;
-(NSDictionary*)dictionaryJSON;

//@optional
-(Sponsor*)copyObject;
-(bool)isEqualToObject:(id)object;
-(void)defaultObject;
-(void)updateObjectFromJSON:(NSDictionary*)dictionaryData reseting:(bool)reset;
@end
