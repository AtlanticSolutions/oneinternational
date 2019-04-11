//
//  AdAliveScannerTargetManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 07/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AdAliveScannerTargetManager.h"
#import "FileManager.h"

@interface AdAliveScannerTargetManager()

@end

@implementation AdAliveScannerTargetManager

@synthesize productsFound;

- (instancetype)init
{
    self = [super init];
    if (self) {
        productsFound = [NSMutableDictionary new];
    }
    return self;
}

- (BOOL)saveIdentifiedProductsToUser:(long)userID
{
    NSMutableArray *pData = [NSMutableArray new];
    
    NSArray *keys = [productsFound allKeys];
    for (NSString *k in keys) {
        AdAliveIdentifiedProduct *iProduct = [productsFound objectForKey:k];
        //
        NSMutableDictionary *dicProduct = [NSMutableDictionary new];
        [dicProduct setValue:iProduct.targetID forKey:@"target"];
        [dicProduct setValue:iProduct.identificationDate forKey:@"date"];
        [dicProduct setValue:iProduct.productData forKey:@"detail"];
        //
        [pData addObject:dicProduct];
    }
    
    NSMutableDictionary *historyData = [NSMutableDictionary new];
    [historyData setObject:(pData.count == 0 ? [NSArray new] : pData) forKey:@"data"];
    
    FileManager *fileManager = [FileManager new];
    return [fileManager saveScannerAdAliveHistory:historyData toUser:userID];
}

- (BOOL)loadIdentifiedProductsToUser:(long)userID
{
    self.productsFound = [NSMutableDictionary new];
    
    FileManager *fileManager = [FileManager new];
    NSDictionary *historyData = [fileManager loadScannerAdAliveHistoryToUser:userID];
    
    if (historyData && [historyData allKeys].count > 0) {
        
        NSArray *pData = [historyData objectForKey:@"data"];
        
        for (NSDictionary *dicProduct in pData) {
            AdAliveIdentifiedProduct *iProduct = [AdAliveIdentifiedProduct new];
            iProduct.targetID = [dicProduct valueForKey:@"target"];
            iProduct.identificationDate = [dicProduct valueForKey:@"date"];
            iProduct.productData = [dicProduct valueForKey:@"detail"];
            //
            iProduct.objDate = [ToolBox dateHelper_DateFromString:iProduct.identificationDate withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL];
            //
            [self.productsFound setObject:iProduct forKey:iProduct.targetID];
        }
    }
    return YES;
}

@end
