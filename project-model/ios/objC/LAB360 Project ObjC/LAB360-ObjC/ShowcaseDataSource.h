//
//  ShowcaseDataSource.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceResponse.h"
//
#import "VirtualShowcaseGallery.h"
#import "VirtualShowcaseCategory.h"
#import "VirtualShowcaseProduct.h"
#import "VirtualShowcasePhoto.h"

#pragma mark - Constants
#define SHOWCASE_LOCAL_DATA_DIRECTORY @"ShowcaseData"
#define SHOWCASE_USER_COLLECTION_DATA_DIRECTORY @"UserCollection"

#pragma mark - Class
@interface ShowcaseDataSource : NSObject

/**
 @brief     Busca no servidor os dados para a vitrine virtual.
 @note     Mesmo com uma resposta válida do servidor (sucesso) pode ocorrer que o campo 'data' fique nulo (caso o app não possua nenhuma vitrine cadastrada).
 */
- (void)getVirtualShowcaseFromServerWithCompletionHandler:(void (^_Nullable)(VirtualShowcaseGallery* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

#pragma mark - Photos Control
//Controle das fotos do usuário (imagens montadas por ele usando as máscaras).
- (void)loadSavedPhotosForUser:(long)userID withCompletionHandler:(void (^ _Nullable)(NSArray<VirtualShowcasePhoto*>* _Nullable photos, NSError* _Nullable error)) handler;
- (BOOL)savePhoto:(UIImage* _Nonnull)photo forUser:(long)userID;
- (BOOL)deletePhoto:(NSString* _Nonnull)photoName forUser:(long)userID;

@end
