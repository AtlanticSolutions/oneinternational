//
//  FileManager.m
//  AdAlive
//
//  Created by Monique Trevisan on 11/12/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "FileManager.h"
#import "SSZipArchive.h"

@implementation FileManager

+(id)sharedInstance
{
    static FileManager *sharedFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFileManager = [[self alloc] init];
    });
    return sharedFileManager;
}
#pragma mark - General Methods

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
	return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

//#pragma mark - Products Methods
//
//-(NSString *)getProductImageDirectory
//{
//     NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
//    
//    return [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PRODUCT_IMAGE_DIRECTORY]];
//}
//
//-(NSString *)getProductDirectory:(BOOL)isFavorite
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
//    
//    if(isFavorite)
//    {
//        return [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", FAVORITE_DIRECTORY]];
//    }
//    else
//    {
//        return [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PRODUCT_DIRECTORY]];
//    }
//}
//
//-(NSString *)getProductPath:(NSString *)productName
//{
//    NSString *productPath = [[self getProductDirectory:NO] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//    
//    return productPath;
//}
//
//-(NSArray *)loadProductsFileNames
//{
//    NSString *productDataDir = [self getProductDirectory:NO];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    return [fileManager contentsOfDirectoryAtPath:productDataDir error:nil];
//}
//
//-(NSArray *)loadProductItemsWithFileNames:(NSArray *)fileNames
//{
//    NSString *productDataDir = [self getProductDirectory:NO];
//    
//    NSMutableArray *mArrayProducts = [NSMutableArray array];
//    
//    for (int i = 0; i < [fileNames count]; i++)
//    {
//        NSDictionary *dicProduct = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", productDataDir, [fileNames objectAtIndex:i]]];
//        
//        if(dicProduct)
//            [mArrayProducts addObject:dicProduct];
//    }
//    
//    return mArrayProducts;
//}
//
//-(NSDictionary *)getProductWithName:(NSString *)productName
//{
//	productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//	NSString *filePath = [[self getProductDirectory:NO] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//	
//	return [NSDictionary dictionaryWithContentsOfFile:filePath];
//}
//
//-(BOOL)saveProductData:(NSDictionary *)dicProductData
//{
//    NSString *productName = [NSString stringWithFormat:@"%@",[dicProductData objectForKey:PRODUCT_ID_KEY]];
//    productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//    
//    NSString *productDataDir = [self getProductDirectory:NO];
//    
//    if (![self directoryExists:productDataDir])
//    {
//        if (![self createDirectoryAtPath:productDataDir]) {
//            return NO;
//        }
//    }
//    
//    NSString *productDataFile = [productDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//    
//    if (![self fileExists:productDataFile])
//    {
//        if (![self createFileAtPath:productDataFile])
//        {
//            return NO;
//        }
//    }
//    
//    return [dicProductData writeToFile:productDataFile atomically:YES];
//}
//
//- (BOOL)removeProductWithName:(NSString *)productName
//{
//	productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//	NSString *productDataFile = [[self getProductDirectory:NO] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//	
//	if ([self fileExists:productDataFile])
//	{
//		[self removeFavoriteProductWithName:productName];
//		
//		NSFileManager *fileManager = [NSFileManager defaultManager];
//		return [fileManager removeItemAtPath:productDataFile error:nil];
//	}
//	
//	return YES;
//}
//
#pragma mark - Beacon methods

-(BOOL)saveBeaconData:(NSArray *)arrayBeacon
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *beaconDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", BEACON_DIRECTORY]];
    
    if (![self directoryExists:beaconDataDir])
    {
        if (![self createDirectoryAtPath:beaconDataDir]) {
            return NO;
        }
    }
    
    NSString *beaconDataFile = [beaconDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", BEACON_FILE]];
    
    if (![self fileExists:beaconDataFile])
    {
        if (![self createFileAtPath:beaconDataFile])
        {
            return NO;
        }
    }
    
    return [arrayBeacon writeToFile:beaconDataFile atomically:YES];
}

-(NSArray *)getBeaconData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *beaconDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", BEACON_DIRECTORY]];
    
    NSString *beaconDataFile = [beaconDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", BEACON_FILE]];
    
    return [NSArray arrayWithContentsOfFile:beaconDataFile];
}

//#pragma mark - Profile Methods

#pragma mark - User Data

-(BOOL)saveProfileData:(NSDictionary *)dicUser
{
     dicUser = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicUser withString:@""];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
	NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
	
	if (![self directoryExists:profileDataDir])
	{
		if (![self createDirectoryAtPath:profileDataDir]) {
			return NO;
		}
	}
	
	NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_FILE]];
	
	if (![self fileExists:profileDataFile])
	{
		if (![self createFileAtPath:profileDataFile])
		{
			return NO;
		}
	}
	
	return [dicUser writeToFile:profileDataFile atomically:YES];

}

-(BOOL)deleteProfileData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_FILE]];
    //
    if([[NSFileManager defaultManager]isDeletableFileAtPath:profileDataFile])
    {
        NSError * err = NULL;
        if([[NSFileManager defaultManager] removeItemAtPath:profileDataFile error:&err])
        {
            return YES;
        }else{
            NSLog(@"Error: %@", err.description);
            return NO;
        }
    }
    else{
        return NO;
    }
}

-(NSDictionary *)getProfileData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_FILE]];
    
    return [NSDictionary dictionaryWithContentsOfFile:profileDataFile];
}

-(BOOL)removeProfile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
	NSString *profileDataFile = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", PROFILE_DIRECTORY, PROFILE_FILE]];
	
	if ([self fileExists:profileDataFile])
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		return [fileManager removeItemAtPath:profileDataFile error:nil];
	}
	
	return YES;
}

#pragma mark - Download Data

-(BOOL)saveDownloadsData:(NSDictionary *)dicDownloads
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_DIRECTORY]];
    
    if (![self directoryExists:profileDataDir])
    {
        if (![self createDirectoryAtPath:profileDataDir]) {
            return NO;
        }
    }
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_FILE_DATA]];
    
    if (![self fileExists:profileDataFile])
    {
        if (![self createFileAtPath:profileDataFile])
        {
            return NO;
        }
    }
    
    return [dicDownloads writeToFile:profileDataFile atomically:YES];
}

-(BOOL)deleteDownloadsData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_DIRECTORY]];
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_FILE_DATA]];
    //
    if([[NSFileManager defaultManager]isDeletableFileAtPath:profileDataFile])
    {
        NSError * err = NULL;
        if([[NSFileManager defaultManager] removeItemAtPath:profileDataFile error:&err])
        {
            return YES;
        }else{
            NSLog(@"Error: %@", err.description);
            return NO;
        }
    }
    else{
        return NO;
    }
}

-(NSDictionary*)getDownloadsData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *downloadDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_DIRECTORY]];
    
    if (![self directoryExists:downloadDataDir])
    {
        if (![self createDirectoryAtPath:downloadDataDir]) {
            NSLog(@"Não foi possível criar o diretório para armazenamento dos downloads.");
            return nil;
        }
    }
    
    NSString *downloadDataFile = [downloadDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", DOWNLOAD_FILE_DATA]];
    
    return [NSDictionary dictionaryWithContentsOfFile:downloadDataFile];
}

#pragma mark -

-(BOOL)saveScannerAdAliveHistory:(NSDictionary*)historyData toUser:(long)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", SCANNERHISTORY_DIRECTORY]];
    
    if (![self directoryExists:profileDataDir])
    {
        if (![self createDirectoryAtPath:profileDataDir]) {
            return NO;
        }
    }
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@%li", SCANNERHISTORY_FILEDATA, userID]];
    
    if (![self fileExists:profileDataFile])
    {
        if (![self createFileAtPath:profileDataFile])
        {
            return NO;
        }
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:historyData];
    return [data writeToFile:profileDataFile atomically:YES];
    
    //return [historyData writeToFile:profileDataFile atomically:YES];
}

-(NSDictionary*)loadScannerAdAliveHistoryToUser:(long)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *downloadDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", SCANNERHISTORY_DIRECTORY]];
    
    if (![self directoryExists:downloadDataDir])
    {
        if (![self createDirectoryAtPath:downloadDataDir]) {
            NSLog(@"Não foi possível criar o diretório para armazenamento do histórico do scanner adAlive.");
            return nil;
        }
    }
    
    NSString *downloadDataFile = [downloadDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@%li", SCANNERHISTORY_FILEDATA, userID]];
    
    NSData *data = [NSData dataWithContentsOfFile:downloadDataFile];
    NSDictionary *jsonObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return jsonObject;
    
    //return [NSDictionary dictionaryWithContentsOfFile:downloadDataFile];
}

//#pragma mark - Favorite Methods
//
//-(NSArray *)loadFavoriteFileNames
//{
//    NSString *productDataDir = [self getProductDirectory:YES];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    return [fileManager contentsOfDirectoryAtPath:productDataDir error:nil];
//}
//
//-(NSArray *)loadFavoritesItemsWithNames:(NSArray *)fileNames
//{
//    NSString *productDataDir = [self getProductDirectory:YES];
//    
//    NSMutableArray *mArrayProducts = [NSMutableArray array];
//    
//    for (int i = 0; i < [fileNames count]; i++)
//    {
//        NSDictionary *dicProduct = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", productDataDir, [fileNames objectAtIndex:i]]];
//        
//        if(dicProduct)
//            [mArrayProducts addObject:dicProduct];
//    }
//    
//    return mArrayProducts;
//}
//
//-(NSDictionary *)getFavoriteWithName:(NSString *)productName
//{
//	productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//	NSString *filePath = [[self getProductDirectory:YES] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//	
//	return [NSDictionary dictionaryWithContentsOfFile:filePath];
//}
//
//-(BOOL)saveProductLikeFavorite:(NSDictionary *)dicFavoriteProduct
//{
//    NSString *productName = [NSString stringWithFormat:@"%@", [dicFavoriteProduct objectForKey:PRODUCT_ID_KEY]];;
//    productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//    
//    NSString *productDataDir = [self getProductDirectory:YES];
//    
//    if (![self directoryExists:productDataDir])
//    {
//        if (![self createDirectoryAtPath:productDataDir])
//        {
//            return NO;
//        }
//    }
//    
//    NSString *productDataFile = [productDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//    
//    if (![self fileExists:productDataFile])
//    {
//        if (![self createFileAtPath:productDataFile]) {
//            return NO;
//        }
//    }
//    
//    return [dicFavoriteProduct writeToFile:productDataFile atomically:YES];
//}
//
//-(BOOL)removeFavoriteProduct:(NSDictionary *)dicFavoriteProduct
//{
//    NSString *productName = [NSString stringWithFormat:@"%@", [dicFavoriteProduct objectForKey:PRODUCT_ID_KEY]];
//    productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//    
//    NSString *productDataFile = [[self getProductDirectory:YES] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//    
//    if ([self fileExists:productDataFile])
//    {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        return [fileManager removeItemAtPath:productDataFile error:nil];
//    }
//    
//    return YES;
//}
//
//-(BOOL)removeFavoriteProductWithName:(NSString *)productName
//{
//	productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//	
//	NSString *productDataFile = [[self getProductDirectory:YES] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//	
//	if ([self fileExists:productDataFile])
//	{
//		NSFileManager *fileManager = [NSFileManager defaultManager];
//		return [fileManager removeItemAtPath:productDataFile error:nil];
//	}
//	
//	return YES;
//}
//
//-(BOOL)isFavoriteProduct:(NSDictionary *)dicProductData
//{
//    NSString *productName = [NSString stringWithFormat:@"%@", [dicProductData objectForKey:PRODUCT_ID_KEY]];
//    productName = [productName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
//    
//    NSString *productDataFile = [[self getProductDirectory:YES] stringByAppendingString:[NSString stringWithFormat:@"/%@", productName]];
//    
//    return [self fileExists:productDataFile];
//}
//
//#pragma mark - Product Image Methods
//
//- (BOOL)saveProductImage:(UIImage *)productImage withName:(NSString *)imageName
//{
//    NSString *productImageDir = [self getProductImageDirectory];
//    
//    if (![self directoryExists:productImageDir])
//    {
//        if(![self createDirectoryAtPath:productImageDir])
//        {
//            return NO;
//        }
//    }
//    
//    NSString *productImageFile = [productImageDir stringByAppendingString:[NSString stringWithFormat:@"/%@", imageName]];
//    
//    if (![self fileExists:productImageFile])
//    {
//        if ([self createFileAtPath:productImageFile])
//        {
//            NSData *dataImage = UIImagePNGRepresentation(productImage);
//            return [dataImage writeToFile:productImageFile atomically:YES];
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    else
//    {
//        NSData *dataImage = UIImagePNGRepresentation(productImage);
//        return [dataImage writeToFile:productImageFile atomically:YES];
//    }
//    
//    return NO;
//}
//
//-(UIImage *)loadImageWithName:(NSString *)imageName
//{
//    NSString *productImageDir = [self getProductImageDirectory];
//    
//    NSString *fileImageName = [NSString stringWithFormat:@"%@/%@", productImageDir, imageName];
//    
//    if ([self fileExists:fileImageName])
//    {
//        NSData *dataImage = [NSData dataWithContentsOfFile:fileImageName];
//        return [UIImage imageWithData:dataImage];
//    }
//    else
//    {
//        return nil;
//    }
//}
//
//#pragma mark - Catalog Data
//
//-(NSString *)getCatalogDirectory
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
//    
//    return [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", CATALOG_DIRECTORY]];
//   
//}
//
//-(NSArray *)getCatalogData
//{
//    NSString *catalogDataFile = [[self getCatalogDirectory] stringByAppendingString:@"catalogData"];
//    return [NSArray arrayWithContentsOfFile:catalogDataFile];
//}
//
//-(BOOL)saveCatalogData:(NSArray *)arrayCatalogData
//{
//    
//    NSString *catalogDataDir = [self getCatalogDirectory];
//    
//    if (![self directoryExists:catalogDataDir])
//    {
//        if (![self createDirectoryAtPath:catalogDataDir]) {
//            return NO;
//        }
//    }
//    
//    NSString *catalogDataFile = [catalogDataDir stringByAppendingString:@"catalogData"];
//    
//    if (![self fileExists:catalogDataFile])
//    {
//        if (![self createFileAtPath:catalogDataFile])
//        {
//            return NO;
//        }
//    }
//    
//    return [arrayCatalogData writeToFile:catalogDataFile atomically:YES];
//}
//
//-(BOOL)removeCatalogData:(NSString *)productName
//{
//    NSString *catalogDataFile = [[self getCatalogDirectory] stringByAppendingString:@"catalogData"];
//    
//    if ([self fileExists:catalogDataFile])
//    {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        return [fileManager removeItemAtPath:catalogDataFile error:nil];
//    }
//    
//    return YES;
//}

#pragma mark - Catalog Data

#pragma mark - Order Data

-(NSString*)getOrderDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    
    return [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", ORDERS_DIRECTORY]];
    
}

-(NSArray*)getOrderData
{
    NSString *orderDataFile = [[self getOrderDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@", ORDERS_FILE]];
    return [NSArray arrayWithContentsOfFile:orderDataFile];
}

-(BOOL)saveOrderData:(NSArray*)arrayOrderData
{
    NSString *orderDataDir = [self getOrderDirectory];
    
    if (![self directoryExists:orderDataDir])
    {
        if (![self createDirectoryAtPath:orderDataDir]) {
            return NO;
        }
    }
    
    NSString *orderDataFile = [orderDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", ORDERS_FILE]];
    
    if (![self fileExists:orderDataFile])
    {
        if (![self createFileAtPath:orderDataFile])
        {
            return NO;
        }
    }
    
    return [arrayOrderData writeToFile:orderDataFile atomically:YES];
}

-(BOOL)removeOrderData
{
    NSString *orderDataFile = [[self getOrderDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@", ORDERS_FILE]];
    
    if ([self fileExists:orderDataFile])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:orderDataFile error:nil];
    }
    
    return YES;
}

#pragma mark - ZIP

-(void)unzipFileAtPath:(NSString* _Nonnull)filePath toPath:(NSString* _Nonnull)destinationPath withCompletionHandler:(void (^_Nullable)(BOOL succeeded, NSError* _Nullable error))handler
{
    //Criando o diretório de destino, caso ainda não exista:
    if (![self directoryExists:destinationPath]){
        if (![self createDirectoryAtPath:destinationPath]) {
            handler(NO, nil);
            return;
        }
    }
    
    [SSZipArchive unzipFileAtPath:filePath toDestination:destinationPath progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        handler(succeeded, error);
    }];
}

#pragma mark - Exemplos

- (bool)saveUserScans:(NSArray*)scanList withUserIdentifier:(NSString*)userIdentifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    if (![self directoryExists:profileDataDir])
    {
        if (![self createDirectoryAtPath:profileDataDir]) {
            return NO;
        }
    }
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", userIdentifier]];
    
    if (![self fileExists:profileDataFile])
    {
        if (![self createFileAtPath:profileDataFile])
        {
            return NO;
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:scanList,  userIdentifier,nil];
    return [dic writeToFile:profileDataFile atomically:YES];
}

- (NSArray*)loadUserScans:(NSString*)userIdentifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", userIdentifier]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:profileDataFile];
    
    if(dic){
        return [NSArray arrayWithArray:[dic valueForKey:userIdentifier]];
    }else{
        return [NSArray new];
    }
}

@end
