//
//  BaseLayoutApp.m
//  GS&MD
//
//  Created by Erico GT on 11/30/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "BaseLayoutManager.h"

@interface BaseLayoutManager()

@end

@implementation BaseLayoutManager

@synthesize isImageBackgroundLoaded, isImageLogoLoaded, isImageBannerLoaded;
@synthesize urlBackground, urlLogo, urlBanner;
@synthesize imageBackground, imageLogo, imageBanner;
@synthesize defaultBackground, defaultLogo, defaultBanner;

- (BaseLayoutManager*)init
{
    self = [super init];
    if (self) {
        isImageBackgroundLoaded = false;
        isImageLogoLoaded = false;
        isImageBannerLoaded = false;
        //
        urlBackground = @"";
        urlLogo = @"";
        urlBanner = @"";
        //
        imageBackground = nil;
        imageLogo = nil;
        imageBanner = nil;
        //
        defaultBackground = [UIImage imageNamed:@"default-background.png"];
        defaultLogo = nil; //[UIImage imageNamed:@"default-logo.png"];
        defaultBanner = nil;
    }
    return self;
}

+ (BaseLayoutManager*)createNewBaseLayoutAppUsingStoredValues
{
    BaseLayoutManager *blm = [BaseLayoutManager new];
    //
    return blm;
}

- (void)updateImagesFromURLs:(bool)needsForce
{
    //Background:
    if (urlBackground != nil && ![urlBackground isEqualToString:@""]){
		if (!isImageBackgroundLoaded || needsForce) {
			[[[AsyncImageDownloader alloc] initWithFileURL:urlBackground successBlock:^(NSData *data) {
				
				if (data != nil){
					imageBackground = [UIImage imageWithData:data];
					isImageBackgroundLoaded = true;
				}
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:self];
				});
				
			} failBlock:^(NSError *error) {
				NSLog(@"Erro ao buscar imagem: %@", error.domain);
			}] startDownload];
		}
    }
	
    //Logotipo:
    if (urlLogo != nil && ![urlLogo isEqualToString:@""] && !isImageLogoLoaded){
        
        [[[AsyncImageDownloader alloc] initWithFileURL:urlLogo successBlock:^(NSData *data) {
            
            if (data != nil){
                imageLogo = [UIImage imageWithData:data];
                isImageLogoLoaded = true;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:self];
            });
            
        } failBlock:^(NSError *error) {
            NSLog(@"Erro ao buscar imagem: %@", error.domain);
        }] startDownload];
    }
    
    //Banner:
    if (urlBanner != nil && ![urlBanner isEqualToString:@""] && !isImageBannerLoaded){
        
        [[[AsyncImageDownloader alloc] initWithFileURL:urlBanner successBlock:^(NSData *data) {
            
            if (data != nil){
                imageBanner = [UIImage imageWithData:data];
                isImageBannerLoaded = true;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:self];
            });
            
        } failBlock:^(NSError *error) {
            NSLog(@"Erro ao buscar imagem: %@", error.domain);
        }] startDownload];
    }
}

- (void)saveConfiguration
{
    @try {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
        NSString *dataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_DIRECTORY]];
        
        if (![self directoryExists:dataDir])
        {
            [self createDirectoryAtPath:dataDir];
        }
        
        NSString *dataFile = [dataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_FILE]];
        
        if (![self fileExists:dataFile])
        {
            [self createFileAtPath:dataFile];
        }
        
        //Info:
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        [mDic setValue:(self.urlBackground ? self.urlBackground : @"") forKey:@"url_image_background"];
        [mDic setValue:(self.urlLogo ? self.urlLogo : @"") forKey:@"url_image_logo"];
        [mDic setValue:(self.urlBanner ? self.urlBanner : @"") forKey:@"url_image_banner"];
        [mDic writeToFile:dataFile atomically:YES];
        
        //Imagens:
        if (self.imageBackground){
            NSString *dataImageBackgroundPath = [dataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_IMAGE_BACKGROUND]];
            [UIImageJPEGRepresentation(self.imageBackground, 1.0) writeToFile:dataImageBackgroundPath atomically:YES];
        }
        
        if (self.imageLogo){
            NSString *dataImageLogoPath = [dataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_IMAGE_LOGO]];
            [UIImagePNGRepresentation(self.imageLogo) writeToFile:dataImageLogoPath atomically:YES];

        }
        
        if (self.imageBanner){
            NSString *dataImageBannerPath = [dataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_IMAGE_BANNER]];
            [UIImagePNGRepresentation(self.imageLogo) writeToFile:dataImageBannerPath atomically:YES];
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"BaseLayoutManager - SaveConfiguration - Error: %@", exception.reason);
    }
}

- (void)loadConfiguration
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *layoutDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_DIRECTORY]];
    
    NSString *layoutDataFilePath = [layoutDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_FILE]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:layoutDataFilePath];
    
    //Info:
    if (dic){
        self.urlBackground = [dic valueForKey:@"url_image_background"];
        self.urlLogo = [dic valueForKey:@"url_image_logo"];
        self.urlBanner = [dic valueForKey:@"url_image_banner"];
    }
    
    //Imagens:
    NSString *dataImageBackgroundPath = [layoutDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_IMAGE_BACKGROUND]];
    NSData *backgroundData = [NSData dataWithContentsOfFile:dataImageBackgroundPath];
    if (backgroundData){
        self.imageBackground  = [[UIImage alloc] initWithData:backgroundData];
    }
    //
    NSString *dataImageLogoPath = [layoutDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_IMAGE_LOGO]];
    NSData *logoData = [NSData dataWithContentsOfFile:dataImageLogoPath];
    if (logoData){
        self.imageLogo  = [[UIImage alloc] initWithData:logoData];
    }
    //
    NSString *dataImageBannerPath = [layoutDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", LAYOUT_IMAGE_BANNER]];
    NSData *logoBanner = [NSData dataWithContentsOfFile:dataImageBannerPath];
    if (logoBanner){
        self.imageBanner  = [[UIImage alloc] initWithData:logoBanner];
    }
}

#pragma mark -

-(BOOL)directoryExists:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

@end
