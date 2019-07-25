//
//  VideoData.m
//  GS&MD
//
//  Created by Erico GT on 12/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "VideoData.h"

#define CLASS_VIDEODATA_DEFAULT @"VideoData"
//
#define CLASS_VIDEODATA_URLYOUTUBE @"url"
#define CLASS_VIDEODATA_TITLE @"title"
#define CLASS_VIDEODATA_NAME @"name"
#define CLASS_VIDEODATA_AUTHOR @"author"
#define CLASS_VIDEODATA_DESCRIPTION @"description"
#define CLASS_VIDEODATA_TIME @"duration"
#define CLASS_VIDEODATA_CATEGORY @"category"
#define CLASS_VIDEODATA_DATE @"date"
#define CLASS_VIDEODATA_ID @"id"
#define CLASS_VIDEODATA_THUMBNAIL @"thumbnail_url"
#define CLASS_VIDEODATA_URL_VIDEO @"href_video"
#define CLASS_VIDEODATA_URL_VIDEO_THUMB @"picture_url"
#define CLASS_VIDEODATA_URL_VIDEO_CATEGORY_ID @"category_id"
#define CLASS_VIDEODATA_URL_VIDEO_SUBCATEGORY_ID @"subcategory_id"

@implementation VideoData

@synthesize urlYouTube, title, nameCustom, author, vDescription, time, category, videoID, date, urlThumbnail, thumbnail, urlVideo, urlVideoThumb, categoryId, subcategoryId;

- (VideoData*)init
{
    self = [super init];
    if (self) {
        urlYouTube = nil;
        title = nil;
        nameCustom = nil;
        author = nil;
        vDescription = nil;
        time = nil;
        category = nil;
        videoID = nil;
        date = nil;
        urlThumbnail = nil;
        thumbnail = nil;
        urlVideoThumb = nil;
        urlVideo = nil;
        categoryId = 0;
        subcategoryId = 0;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+(VideoData*)newObject
{
    VideoData *vd = [VideoData new];
    return vd;
}

+(NSString*)className
{
    return CLASS_VIDEODATA_DEFAULT;
}

+(VideoData*)createObjectFromDictionary:(NSDictionary*)dicData
{
    VideoData *vd = [VideoData new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        vd.urlYouTube = [keysList containsObject:CLASS_VIDEODATA_URLYOUTUBE] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_URLYOUTUBE]] : vd.urlYouTube;
        vd.title = [keysList containsObject:CLASS_VIDEODATA_TITLE] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_TITLE]] : vd.title;
        vd.nameCustom = [keysList containsObject:CLASS_VIDEODATA_NAME] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_NAME]] : vd.nameCustom;
        vd.author = [keysList containsObject:CLASS_VIDEODATA_AUTHOR] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_AUTHOR]] : vd.author;
        vd.vDescription = [keysList containsObject:CLASS_VIDEODATA_DESCRIPTION] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_DESCRIPTION]] : vd.vDescription;
        //
        vd.time = [keysList containsObject:CLASS_VIDEODATA_TIME] ? [self secondsToString:((NSUInteger)[[neoDic valueForKey:CLASS_VIDEODATA_TIME] integerValue])] : vd.time;
        //
        vd.category = [keysList containsObject:CLASS_VIDEODATA_CATEGORY] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_CATEGORY]] : vd.category;
        vd.videoID = [self extractYoutubeIdFromLink:vd.urlYouTube];
        //
        vd.date = [keysList containsObject:CLASS_VIDEODATA_DATE] ?  [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_DATE]] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : vd.date;
        vd.urlThumbnail = [keysList containsObject:CLASS_VIDEODATA_THUMBNAIL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_THUMBNAIL]] : vd.urlThumbnail;
        vd.thumbnail = nil;
        vd.urlVideo = [keysList containsObject:CLASS_VIDEODATA_URL_VIDEO] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_URL_VIDEO]] : vd.urlVideo;
        vd.urlVideoThumb = [keysList containsObject:CLASS_VIDEODATA_URL_VIDEO_THUMB] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_URL_VIDEO_THUMB]] : vd.urlVideoThumb;
        vd.subcategoryId = [keysList containsObject:CLASS_VIDEODATA_URL_VIDEO_SUBCATEGORY_ID] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_URL_VIDEO_SUBCATEGORY_ID]].integerValue : vd.subcategoryId;
        vd.categoryId = [keysList containsObject:CLASS_VIDEODATA_URL_VIDEO_CATEGORY_ID] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_VIDEODATA_URL_VIDEO_CATEGORY_ID]].integerValue : vd.categoryId;
    }
    
    return vd;
}

- (VideoData*)copyObject
{
    VideoData* vData = [VideoData new];
    //
    vData.urlYouTube = [NSString stringWithFormat:@"%@", self.urlYouTube];
    vData.title = [NSString stringWithFormat:@"%@", self.title];
    vData.nameCustom = [NSString stringWithFormat:@"%@", self.nameCustom];
    vData.author = [NSString stringWithFormat:@"%@", self.author];
    vData.vDescription = [NSString stringWithFormat:@"%@", self.vDescription];
    vData.time = [NSString stringWithFormat:@"%@", self.time];
    vData.category = [NSString stringWithFormat:@"%@", self.category];
    vData.videoID = [NSString stringWithFormat:@"%@", self.videoID];
    vData.date = (self.date==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.date];
    vData.urlThumbnail = [NSString stringWithFormat:@"%@", self.urlThumbnail];
    vData.urlVideo = [NSString stringWithFormat:@"%@", self.urlVideo];
    vData.urlVideoThumb = [NSString stringWithFormat:@"%@", self.urlVideoThumb];
    vData.categoryId = self.categoryId;
    vData.subcategoryId = self.subcategoryId;
    if (self.thumbnail){
        vData.thumbnail = [UIImage imageWithData:UIImagePNGRepresentation(self.thumbnail)];
    }
    //
    return vData;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:urlYouTube forKey:CLASS_VIDEODATA_URLYOUTUBE];
    [dic setValue:title forKey:CLASS_VIDEODATA_TITLE];
    [dic setValue:nameCustom forKey:CLASS_VIDEODATA_NAME];
    [dic setValue:author forKey:CLASS_VIDEODATA_AUTHOR];
    [dic setValue:vDescription forKey:CLASS_VIDEODATA_DESCRIPTION];
    [dic setValue:time forKey:CLASS_VIDEODATA_TIME];
    [dic setValue:category forKey:CLASS_VIDEODATA_CATEGORY];
    [dic setValue:videoID forKey:CLASS_VIDEODATA_ID];
    [dic setValue:[ToolBox dateHelper_StringFromDate:date withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] forKey:CLASS_VIDEODATA_DATE];
    [dic setValue:urlThumbnail forKey:CLASS_VIDEODATA_THUMBNAIL];
    //thumbnail ignorado
    return dic;
}

+ (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

+ (NSString*)secondsToString:(NSUInteger)seconds
{
    NSUInteger h = seconds / 3600;
    NSUInteger m = (seconds / 60) % 60;
    NSUInteger s = seconds % 60;
    //
    NSString *formattedTime;
    //
    if (h != 0){
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", h, m, s];
    }else{
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu", m, s];
    }
    //
    return formattedTime;
}
@end

