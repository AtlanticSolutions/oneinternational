//
//  DownloadItem.h
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface DownloadItem : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) int downloadID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *referenceEventTitle;
@property (nonatomic, assign) int referenceEventID;
@property (nonatomic, assign) int referenceMasterEventID;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *subjectDescription;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, assign) int numberOfPages;
@property (nonatomic, strong) NSDate *downloadDate;
@property (nonatomic, strong) NSString *urlFile;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileExtension;
@property (nonatomic, assign) int categoryId;
@property (nonatomic, assign) int subcategoryId;
@property (nonatomic, strong) NSString *thumbUrl;
@property (nonatomic, strong) UIImage *imgThumb;

//Protocol Methods
+ (DownloadItem*)newObject;
+ (NSString*)className;
+ (DownloadItem*)createObjectFromDictionary:(NSDictionary*)dicData;
- (DownloadItem*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
