//
//  VideoData.h
//  GS&MD
//
//  Created by Erico GT on 12/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"
//
#import <UIKit/UIKit.h>

@interface VideoData : NSObject<DefaultObjectModelProtocol>

@property(nonatomic, strong) NSString *urlYouTube;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *nameCustom;
@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSString *vDescription;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *category;
@property(nonatomic, strong) NSString *videoID;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSString *urlThumbnail;
@property(nonatomic, strong) UIImage *thumbnail;
@property(nonatomic, strong) NSString *urlVideo;
@property(nonatomic, strong) NSString *urlVideoThumb;
@property(nonatomic, assign) int categoryId;
@property(nonatomic, assign) int subcategoryId;

//Protocol Methods
+(VideoData*)newObject;
+(NSString*)className;
+(VideoData*)createObjectFromDictionary:(NSDictionary*)dicData;
-(VideoData*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end
