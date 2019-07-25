//
//  BeaconShowroomDataSource.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#import "DataSourceResponse.h"
#import "BeaconShowroomItem.h"
#import "LaBeacon.h"

@interface BeaconShowroomDataSource : NSObject

/**
 @brief     Busca no servidor os showrooms disponíveis para a aplicação.
 @discussion    O servidor não retorna para cada showroom a lista de prateleiras. Será preciso solicitar estes dados em outra chamada.
 @note     O handler deste método terá o campo 'data' nulo quando não for possível obter os dados necessários.
 */
- (void)getShowroomsFromServerWithCompletionHandler:(void (^_Nullable)(NSMutableArray<BeaconShowroomItem*>* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

/**
 @brief     Busca no servidor as prateleiras disponíveis para o showroom referência.
 @note     O handler deste método terá o campo 'data' nulo quando não for possível obter os dados necessários.
 */
- (void)getShelfsForShowroom:(long)showroomID withCompletionHandler:(void (^_Nullable)(NSMutableArray<BeaconShowroomItem*>* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

/**
 @brief     Busca no servidor os beacons (estimote) para uma dada prateleira referência.
 @note     O handler deste método terá o campo 'data' nulo quando não for possível obter os dados necessários.
 */
- (void)getBeaconsForShowroom:(long)showroomID shelf:(long)shelfID withCompletionHandler:(void (^_Nullable)(NSMutableArray<LaBeacon*>* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

/**
 @brief     Busca no servidor os dados do produto associado ao SKU informado pelo beacon.
 */
- (void)getProductInfoUsingSKU:(NSString* _Nonnull)sku withCompletionHandler:(void (^_Nullable)(NSDictionary* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

@end
