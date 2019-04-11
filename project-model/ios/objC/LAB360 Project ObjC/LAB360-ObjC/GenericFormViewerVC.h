//
//  VehicleDetailVC.h
//  Siga
//
//  Created by Erico GT on 29/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "FormParameterReference.h"
#import "FloatingPickerView.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

@class GenericFormViewerVC;

#pragma mark - • PROTOCOLS

@protocol GenericFormViewerDelegate<NSObject>

@required

//NOTE: Quando o delegate (tela que controla o formulário) precisar exibir um alerta para o usuário, lembre-se que ele será responsável por este alerta, mesmo que o formulário esteja por cima no NavigationController. A tela de formulário nunca exibe alertas para o usuário por si só.

/** Este método é chamado antes que a tela formulário feche. O delegate pode avaliar os dados e determinar se a tela pode ou não ser dispensada. */
- (BOOL)genericFormViewer:(GenericFormViewerVC*)vc canCancelScreenWithData:(NSDictionary*)data;

/** Este método é chamado quando o usuário toca no botão SALVAR. O delegate pode avaliar os dados e determinar obrigatoriedades. */
- (BOOL)genericFormViewer:(GenericFormViewerVC*)vc canConfirmScreenWithData:(NSDictionary*)data;

/** O reporte de erro será chamada apenas quando o tela não tiver dados suficientes para funcionar. A mensagem de erro é técnica e não deve ser exibida diretamente para o usuário. Aconselha-se dispensar a tela quando um erro deste tipo for reportado. */
- (void)genericFormViewer:(GenericFormViewerVC*)vc errorReportWithMessage:(NSString*)errorMessage;

/** Quando um parâmetro for do tipo 'ParameterReferenceValueTypeOption' (enumerador) use este método para retornar a lista de opções para que o usuário possa selecionar. */
- (NSArray<FloatingPickerElement*>*)genericFormViewer:(GenericFormViewerVC*)vc optionsForKey:(NSString*)key currentValue:(NSInteger)value;

/** Título do componente de opções, para um dado parâmetro (identifica pela key). */
- (NSString*)genericFormViewer:(GenericFormViewerVC*)vc titleForOptionsWithParameterKeyIdentifier:(NSString*)key;

@end

#pragma mark - • INTERFACE
@interface GenericFormViewerVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES

/** Delegate para a tela. */
@property (nonatomic, weak) id<GenericFormViewerDelegate> delegate;

/** Texto para o título do NavigationController. */
@property (nonatomic, strong) NSString* screenName;

/** Dicionário que representa o objeto (entidade) que está sendo editada. As chaves fornecidas no campo 'parametersConfiguration' devem existir neste dicionário. */
@property (nonatomic, strong) NSDictionary *objectData;

/** Lista com os parâmetros e configurações de cada campo, incluindo regras, tipo etc. Somente os campos expostos nesta lista serão exibidos ao usuário. */
@property (nonatomic, strong) NSArray<FormParameterReference*> *parametersConfiguration;

/** Texto que aparece no topo do formulário, informativo ao usuário. Use para indicar campos obrigatórios e demais instruções. */
@property (nonatomic, strong) NSString* instructionHeaderText;

/** Quando a tela delegate possuir a necessidade de controlar mais de um GenericFormViewer, use esta propriedade como auxiliar de identificação. */
@property (nonatomic, assign) NSInteger auxTag;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

/** Permite que a tela delegate force o fechamento do formulário. */
- (void)forceNavigationReturn;

/** Permite que o delegate atualize uma dada propriedade após a tela formulário já ter sido exibida ao usuário. Por exemplo, imagine o caso onde o usuário iniciou a edição dos dados mas um parâmetro tipo imagem ainda estava em estado de download. Com este método a imagem pode ser reportada posteriormente, quando estiver disponível. */
- (BOOL)updateParameterObjectData:(id)parameterValue forKey:(NSString*)keyName;

@end


