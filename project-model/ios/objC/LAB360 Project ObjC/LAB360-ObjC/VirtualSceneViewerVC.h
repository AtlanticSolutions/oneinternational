//
//  VirtualSceneViewerVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "VirtualObjectProperties.h"

#pragma mark - • FRAMEWORK HEADERS
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

@class VirtualSceneViewerVC;
@class VirtualSceneNodeParameters;

typedef enum {
    VirtualSceneViewerInstructionStyleHide          = 0,
    VirtualSceneViewerInstructionStyleMinimal       = 1,
    VirtualSceneViewerInstructionStyleNormal        = 2,
    VirtualSceneViewerInstructionStyleExtended      = 3
} VirtualSceneViewerInstructionStyle;

typedef enum {
    VirtualSceneViewerRotationModeNone       = 0,
    VirtualSceneViewerRotationModeFree       = 1,
    VirtualSceneViewerRotationModeYAxis      = 2,
    VirtualSceneViewerRotationModeXAxis      = 3,
    VirtualSceneViewerRotationModeLimited    = 4
} VirtualSceneViewerRotationMode;

typedef enum {
    VirtualSceneViewerBackgroundStyleSolidColor     = 1,
    VirtualSceneViewerBackgroundStyleImage          = 2,
    VirtualSceneViewerBackgroundStyleFrontCamera    = 3,
    VirtualSceneViewerBackgroundStyleBackCamera     = 4,
    VirtualSceneViewerBackgroundStyleEnviroment     = 5
} VirtualSceneViewerBackgroundStyle;

typedef enum {
    Virtual3DViewerSceneQualityLow         = 1,
    Virtual3DViewerSceneQualityMedium      = 2,
    Virtual3DViewerSceneQualityHigh        = 3,
    Virtual3DViewerSceneQualityUltra       = 4,
} Virtual3DViewerSceneQuality;

typedef enum {
    VirtualSceneViewerHDRStateOFF                       = 1,
    VirtualSceneViewerHDRStateON                        = 2,
    VirtualSceneViewerHDRStateUsingExposureAdaptation   = 3
} VirtualSceneViewerHDRState;

#pragma mark - • PROTOCOLS

@protocol VirtualSceneViewerDelegate

@required

/** URL local para o arquivo OBJ do modelo 3D que se deseja visualizar. */
- (NSURL*)virtualSceneViewerLocalURLFor3DModel:(VirtualSceneViewerVC*)sceneViewer;

/** Quando um erro ocorrer o delegate será informado com uma mensagem explicativa. */
- (void)virtualSceneViewer:(VirtualSceneViewerVC*)sceneViewer errorWithMessage:(NSString*)errorMessage;

/** Permite ou não escalar o objeto 3D. O padrão é 'YES'. */
//- (BOOL)virtualSceneViewerScaleObjectAllowed:(VirtualSceneViewerVC*)sceneViewer;

/** Permite ou não transladar (mover) o objeto 3D. O padrão é 'YES'. */
//- (BOOL)virtualSceneViewerTranslateObjectAllowed:(VirtualSceneViewerVC*)sceneViewer;

/** Modifica o tipo de rotação permitida. O padrão é 'VirtualSceneViewerRotationModeFree'. A opção 'VirtualSceneViewerRotationModeLimited' somente está disponível no iOS 11 e superior. */
- (VirtualSceneViewerRotationMode)virtualSceneViewerRotationMode:(VirtualSceneViewerVC*)sceneViewer;

/** Define como será o background da cena. Para cor sólida ou imagem será necessário implementar métodos opcionais do protocolo. O uso da camera depende da disponibilidade. */
- (VirtualSceneViewerBackgroundStyle)virtualSceneViewerBackgroundStyle:(VirtualSceneViewerVC*)sceneViewer;

@optional

/** Título do NavigationBar, quando exibido por push. O padrão é 'Visualizador 3D'. */
- (NSString*)virtualSceneViewerNavigationBarTitle:(VirtualSceneViewerVC*)sceneViewer;

/** Através do estilo a visibilidade do rodapé pode ser modificada. O padrão é 'VirtualSceneViewerInstructionStyleNormal'. */
- (VirtualSceneViewerInstructionStyle)virtualSceneViewerStyleForInstructionMessage:(VirtualSceneViewerVC*)sceneViewer;

/** Mensagem ou instrução para o rodapé. O padrão é um texto informativo. */
- (NSString*)virtualSceneViewerMessageForInstructionMessage:(VirtualSceneViewerVC*)sceneViewer;

/** Exibe ou esconde o botão de compartilhamento. Por padrão o botão é visível e permite o compartilhamento da cena atual. */
- (BOOL)virtualSceneViewerShowShareButton:(VirtualSceneViewerVC*)sceneViewer;

/** Permite utilizar ou não HDR na cena exibida. */
- (VirtualSceneViewerHDRState)virtualSceneViewerHDRState:(VirtualSceneViewerVC*)sceneViewer;

/** Define a rotação e escala do modelo ao ser carregado. A cor é ignorada. */
- (VirtualSceneNodeParameters*)virtualSceneViewerModelInitialStateParameters:(VirtualSceneViewerVC*)sceneViewer;

/** Define luzes personalizadas para a cena. Utilize apenas nodes com a propriedade light configurada. Quando não implementado um conjunto automático de luzes será criado (autoenablesDefaultLighting = YES). */
- (NSArray<SCNNode*>*)virtualSceneViewerCustomLightNodes:(VirtualSceneViewerVC*)sceneViewer;

/** Imagem para o fundo da cena. O background sempre utilizará o modo 'UIViewContentModeScaleAspectFill'. O padrão é a cena não possuir fundo. */
- (UIImage*)virtualSceneViewerBackgroundImageForScene:(VirtualSceneViewerVC*)sceneViewer;

/** Cor para o fundo da cena. O padrão é 'black'. */
- (UIColor*)virtualSceneViewerBackgroundColorForScene:(VirtualSceneViewerVC*)sceneViewer;

/** Imagens para o ambiente de fundo (cubo). O index da cena indica qual cena está sendo referenciada. O index 0 (zero) será utilizado para cenas únicas. */
- (NSArray<UIImage*>*)virtualSceneViewer:(VirtualSceneViewerVC*)sceneViewer enviromentImagesForScene:(NSInteger)sceneIndex;

/** Quando o estilo do background for 'VirtualSceneViewerBackgroundStyleEnviroment' e se desejar ter mais de uma cena disponível, implemente este método com a lista de nomes para as cenas (o index do nome será utilizado no futuro quando o usuário quiser trocar a cena). */
- (NSArray<NSString*>*)virtualSceneViewerEnviromentSceneNames:(VirtualSceneViewerVC*)sceneViewer;

@end

#pragma mark - • INTERFACE
@interface VirtualSceneViewerVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES

/** Delegate para o controle da tela. Para que um modelo 3D seja carregado é preciso ter um delegate válido. */
@property(nonatomic, weak) id<VirtualSceneViewerDelegate> delegate;

/** Identificador conveniente para ajudar no callback dos métodos do protocolo. Ex.: Uma tela (UIViewController) pode ter um 'viewer' apenas que funciona com parâmetros diferentes dependendo do modelo que se deseja exibir. Esta tag ajuda na identificação destas variações. */
@property(nonatomic, assign) NSInteger tagID;

/** Define o zoom máximo permitido ao interagir com o objeto. O padrão é 10,0 e somente tem efeito quando o tipo de rotação permitida for diferente de 'VirtualSceneViewerRotationModeFree'. */
@property(nonatomic, assign) CGFloat maxZoomAlowed;

/** Determina a qualidade geral da renderização. O padrão é 'Virtual3DViewerSceneQualityUltra' (melhor disponível no device). */
@property(nonatomic, assign) Virtual3DViewerSceneQuality sceneQuality;

/** Contém o tamanho do box do objeto carregado para exibição. Valores zerados indicam que o objeto não foi carregado corretamente. */
@property(nonatomic, assign) ObjectBoxSize objectBoxSize;

/** Habilita ou não a auto-iluminação do modelo, quando configurado no arquivo MTL. O padrão é 'NO'.*/
@property(nonatomic, assign) BOOL enableMaterialAutoIlumination;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end

#pragma mark - Support Class

@interface VirtualSceneNodeParameters : NSObject

@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) float posZ;
@property (nonatomic, assign) float posW;
@property (nonatomic, assign) float scale;
@property (nonatomic, strong) UIColor *color;

@end
