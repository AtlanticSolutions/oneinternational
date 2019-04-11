//
//  DownloadItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "DownloadItem.h"

#define CLASS_DOWNLOAD_ITEM_DEFAULT @"download_item"
#define CLASS_DOWNLOAD_ITEM_ID @"id"
#define CLASS_DOWNLOAD_ITEM_TITLE @"title"
#define CLASS_DOWNLOAD_ITEM_EVENT_TITLE @"event_title"
#define CLASS_DOWNLOAD_ITEM_EVENT_ID @"event_id"
#define CLASS_DOWNLOAD_ITEM_MASTER_EVENT_ID @"master_event_id"
#define CLASS_DOWNLOAD_ITEM_AUTHOR @"author"
#define CLASS_DOWNLOAD_ITEM_DESCRIPTION @"description"
#define CLASS_DOWNLOAD_ITEM_LANGUAGE @"language"
#define CLASS_DOWNLOAD_ITEM_NUMBER_OF_PAGES @"number_of_pages"
#define CLASS_DOWNLOAD_ITEM_URL_FILE @"url_file"
#define CLASS_DOWNLOAD_ITEM_DOWNLOAD_DATE @"download_date"
#define CLASS_DOWNLOAD_ITEM_FILE_NAME @"file_name"
#define CLASS_DOWNLOAD_ITEM_FILE_EXTENSION @"file_extension"
#define CLASS_DOWNLOAD_ITEM_CATEGORY @"category_id"
#define CLASS_DOWNLOAD_ITEM_SUBCATEGORY @"subcategory_id"
#define CLASS_DOWNLOAD_ITEM_THUMB_URL @"url_image"


@implementation DownloadItem

@synthesize downloadID, title, referenceEventTitle, referenceEventID, author, subjectDescription, language, numberOfPages, downloadDate, urlFile, fileName, fileExtension, categoryId, subcategoryId, thumbUrl, imgThumb;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        downloadID = DOMP_OPD_INT;
        title = DOMP_OPD_STRING;
        referenceEventTitle = DOMP_OPD_STRING;
        referenceEventID = DOMP_OPD_INT;
        author = DOMP_OPD_STRING;
        subjectDescription = DOMP_OPD_STRING;
        language = DOMP_OPD_STRING;
        numberOfPages = DOMP_OPD_INT;
        downloadDate = DOMP_OPD_DATE;
        urlFile = DOMP_OPD_STRING;
        fileName = DOMP_OPD_STRING;
        fileExtension = DOMP_OPD_STRING;
        categoryId = DOMP_OPD_INT;
        subcategoryId = DOMP_OPD_INT;
        thumbUrl = DOMP_OPD_STRING;
        imgThumb = DOMP_OPD_IMAGE;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(DownloadItem*)newObject
{
    DownloadItem *di = [DownloadItem new];
    return di;
}

+(NSString*)className
{
    return CLASS_DOWNLOAD_ITEM_DEFAULT;
}

+(DownloadItem*)createObjectFromDictionary:(NSDictionary*)dicData
{
    DownloadItem *di = [DownloadItem new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        di.downloadID = [keysList containsObject:CLASS_DOWNLOAD_ITEM_ID] ? [[neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_ID] intValue] : di.downloadID;
        di.title = [keysList containsObject:CLASS_DOWNLOAD_ITEM_TITLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_TITLE]] : di.title;
        di.referenceEventTitle = [keysList containsObject:CLASS_DOWNLOAD_ITEM_EVENT_TITLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_EVENT_TITLE]] : di.referenceEventTitle;
        di.referenceEventID = [keysList containsObject:CLASS_DOWNLOAD_ITEM_EVENT_ID] ? [[neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_EVENT_ID] intValue] : di.referenceEventID;
		di.referenceMasterEventID = [keysList containsObject:CLASS_DOWNLOAD_ITEM_MASTER_EVENT_ID] ? [[neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_MASTER_EVENT_ID] intValue] : di.referenceMasterEventID;
        di.author = [keysList containsObject:CLASS_DOWNLOAD_ITEM_AUTHOR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_AUTHOR]] : di.author;
        di.subjectDescription = [keysList containsObject:CLASS_DOWNLOAD_ITEM_DESCRIPTION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_DESCRIPTION]] : di.subjectDescription;
        di.language = [keysList containsObject:CLASS_DOWNLOAD_ITEM_LANGUAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_LANGUAGE]] : di.language;
        di.numberOfPages = [keysList containsObject:CLASS_DOWNLOAD_ITEM_NUMBER_OF_PAGES] ? [[neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_NUMBER_OF_PAGES] intValue] : di.numberOfPages;
        di.downloadDate = [keysList containsObject:CLASS_DOWNLOAD_ITEM_DOWNLOAD_DATE] ? [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_DOWNLOAD_ITEM_DOWNLOAD_DATE]] withFormat:TOOLBOX_DATA_BARRA_COMPLETA_INVERTIDA] : di.downloadDate;
        di.urlFile = [keysList containsObject:CLASS_DOWNLOAD_ITEM_URL_FILE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_URL_FILE]] : di.urlFile;
        di.fileName = [keysList containsObject:CLASS_DOWNLOAD_ITEM_FILE_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_FILE_NAME]] : di.fileName;
        di.fileExtension = [keysList containsObject:CLASS_DOWNLOAD_ITEM_FILE_EXTENSION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_FILE_EXTENSION]] : di.fileExtension;
        di.categoryId = [keysList containsObject:CLASS_DOWNLOAD_ITEM_CATEGORY] ? [[neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_CATEGORY] intValue] : di.categoryId;
        di.subcategoryId = [keysList containsObject:CLASS_DOWNLOAD_ITEM_SUBCATEGORY] ? [[neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_SUBCATEGORY] intValue] : di.subcategoryId;
        di.thumbUrl = [keysList containsObject:CLASS_DOWNLOAD_ITEM_THUMB_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_DOWNLOAD_ITEM_THUMB_URL]] : di.thumbUrl;
    }
    
    return di;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData setValue:@(self.downloadID) forKey:CLASS_DOWNLOAD_ITEM_ID];
    [dicData  setValue:self.title forKey:CLASS_DOWNLOAD_ITEM_TITLE];
    [dicData  setValue:self.referenceEventTitle forKey:CLASS_DOWNLOAD_ITEM_EVENT_TITLE];
    [dicData setValue:@(self.referenceEventID) forKey:CLASS_DOWNLOAD_ITEM_EVENT_ID];
	[dicData setValue:@(self.referenceMasterEventID) forKey:CLASS_DOWNLOAD_ITEM_MASTER_EVENT_ID];
    [dicData  setValue:self.author forKey:CLASS_DOWNLOAD_ITEM_AUTHOR];
    [dicData  setValue:self.subjectDescription forKey:CLASS_DOWNLOAD_ITEM_DESCRIPTION];
    [dicData  setValue:self.language forKey:CLASS_DOWNLOAD_ITEM_LANGUAGE];
    [dicData  setValue:@(self.numberOfPages) forKey:CLASS_DOWNLOAD_ITEM_NUMBER_OF_PAGES];
    [dicData  setValue:self.urlFile forKey:CLASS_DOWNLOAD_ITEM_URL_FILE];
    [dicData  setValue:self.fileName forKey:CLASS_DOWNLOAD_ITEM_FILE_NAME];
    [dicData  setValue:self.fileExtension forKey:CLASS_DOWNLOAD_ITEM_FILE_EXTENSION];
    [dicData setValue:[ToolBox dateHelper_StringFromDate:self.downloadDate withFormat:TOOLBOX_DATA_BARRA_COMPLETA_INVERTIDA] forKey:CLASS_DOWNLOAD_ITEM_DOWNLOAD_DATE];
    //
    //NSMutableDictionary *dicFinal = [NSMutableDictionary new];
    //[dicFinal setValue:dicData forKey:[DownloadItem className]];
    return dicData;
}

- (DownloadItem *) copyObject
{
    DownloadItem *di = [DownloadItem new];
    di.downloadID = self.downloadID;
    di.title = [NSString stringWithFormat:@"%@", self.title];
    di.referenceEventTitle = [NSString stringWithFormat:@"%@", self.referenceEventTitle];
    di.referenceEventID = self.referenceEventID;
	di.referenceMasterEventID = self.referenceMasterEventID;
    di.author = [NSString stringWithFormat:@"%@", self.author];
    di.subjectDescription = [NSString stringWithFormat:@"%@", self.subjectDescription];
    di.language = [NSString stringWithFormat:@"%@", self.language];
    di.numberOfPages = self.numberOfPages;
    di.urlFile = [NSString stringWithFormat:@"%@", self.urlFile];
    di.fileName = [NSString stringWithFormat:@"%@", self.fileName];
    di.fileExtension = [NSString stringWithFormat:@"%@", self.fileExtension];
    di.downloadDate = (downloadDate==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:downloadDate];
    di.categoryId = self.categoryId;
    di.subcategoryId = self.subcategoryId;
    //
    return di;
}

@end



