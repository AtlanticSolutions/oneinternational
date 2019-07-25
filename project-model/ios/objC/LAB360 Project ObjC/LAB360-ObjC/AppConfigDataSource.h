//
//  AppConfigDataSource.h
//  LAB360-ObjC
//
//  Created by Erico GT on 29/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceResponse.h"
#import "SideMenuConfig.h"

typedef enum {
    UserAuthenticationTokenStatusUndefined     = 0,
    UserAuthenticationTokenStatusValid         = 1,
    UserAuthenticationTokenStatusInvalid       = 2
} UserAuthenticationTokenStatus;

@interface AppConfigDataSource : NSObject

/**
 @brief     Busca no servidor os dados  para o menu lateral da aplicação.
 @discussion    O menu lateral dinâmico da aplicação permite o cliente escolha exibir/ocultar certos menus, conforme a necessidade do negócio.
 @note     O handler deste método terá o campo 'data' nulo quando não for possível obter os dados necessários para criar a configuração.
 */
- (void)getSideMenuConfigurationFromServerWithCompletionHandler:(void (^_Nullable)(SideMenuConfig* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

/**
 @brief     Valida o token de login do usuário.
 @discussion    Caso o token do usuário seja inválido significa que o mesmo efetuou um login em outro dispositivo, anulando a validade do token local. Neste caso ele deve ser informado do fim da sessão e o fluxo do app deve levá-lo novamente a tela de login.
 */
- (void)validateUserAuthenticationToken:(NSString* _Nonnull)token withCompletionHandler:(void (^_Nullable)(UserAuthenticationTokenStatus tokenStatus, DataSourceResponse* _Nonnull response)) handler;

@end
