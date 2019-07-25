//
//  RotationalImageViewer.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RotationalImageViewerScrollDirectionHorizontal = 1,
    RotationalImageViewerScrollDirectionVertical = 2
} RotationalImageViewerScrollDirection;

typedef enum {
    RotationalImageViewerZoomButtonPositionTopLeft = 1,
    RotationalImageViewerZoomButtonPositionTopRight = 2,
    RotationalImageViewerZoomButtonPositionBottomLeft = 3,
    RotationalImageViewerZoomButtonPositionBottomRight = 4,
    RotationalImageViewerZoomButtonPositionHidden = 5
} RotationalImageViewerZoomButtonPosition;

typedef enum {
    RotationalImageViewerScrollSensibilityWeak = 1,
    RotationalImageViewerScrollSensibilityNormal = 2,
    RotationalImageViewerScrollSensibilityStrong = 3
} RotationalImageViewerScrollSensibility;

@class RotationalImageViewer;

@protocol RotationalImageViewerDelegate <NSObject>
@required

/**
 @brief     Método obrigatório de implementação para do protocolo RotationalImageViewerDelegate.
 @discussion    Deve retornar o número de items (imagens) para o viewer parâmetro.
 @param     viewer      Componente para qual o número de itens está sendo solicitado.
 @return    Número de itens para exibição no componente.
 */
- (int)rotationalImageViewerNumberOfItems:(RotationalImageViewer* _Nonnull)viewer;

/**
 @brief     Método obrigatório de implementação para do protocolo RotationalImageViewerDelegate.
 @discussion    Deve retornar o número de camadas para o viewer parâmetro. Este método apenas será chamado quando o sentido de rotação do componente estiver definido como 'RotationalImageViewerScrollDirectionHorizontal'.
 @param     viewer      Componente para qual o número de camadas está sendo solicitado.
 @return    Número de camadas para exibição no componente.
 */
- (int)rotationalImageViewerNumberOfLayers:(RotationalImageViewer* _Nonnull)viewer;

/**
 @brief     Método obrigatório de implementação para do protocolo RotationalImageViewerDelegate.
 @discussion    Deve retornar a imagem para o viewer parâmetro, para uma posição específica.
 @param     viewer      Componente para qual o número de itens está sendo solicitado.
 @param     index       Índice para referência da imagem.
 @param     layer       Camada para referência da imagem. Considere seu valor apenas quando o sentido de rotação do componente estiver definido como 'RotationalImageViewerScrollDirectionHorizontal'.
 @return    Imagem para exibição na posição especificada.
 */
- (UIImage* _Nonnull)rotationalImageViewer:(RotationalImageViewer* _Nonnull)viewer imageForItem:(int)index atLayer:(int)layer;

@optional

/**
 @brief     Método opcional de implementação para do protocolo RotationalImageViewerDelegate.
 @discussion    Informa o delegate do componente sobre a atualização do respectivo item.
 @param     viewer      Componente que sofreu a atualização.
 @param     newIndex       Índice do item atualizado.
 @param     layer       Camada do item atualizado. Considere seu valor apenas quando o sentido de rotação do componente estiver definido como 'RotationalImageViewerScrollDirectionHorizontal'.
 */
- (void)rotationalImageViewer:(RotationalImageViewer* _Nonnull)viewer updatedIndex:(int)newIndex atLayer:(int)layer;

/**
 @brief     Método opcional de implementação para do protocolo RotationalImageViewerDelegate.
 @discussion    Informa o delegate do componente sobre a seleção de um determinado item no componente.
 @param     viewer      Componente que informa a seleção.
 @param     index       Índice do item selecionado.
 @param     layer       Camada do item selecionado. Considere seu valor apenas quando o sentido de rotação do componente estiver definido como 'RotationalImageViewerScrollDirectionHorizontal'.
 */
- (void)rotationalImageViewer:(RotationalImageViewer* _Nonnull)viewer selectedIndex:(int)index atLayer:(int)layer;

@end

@interface RotationalImageViewer : UIView

/** @brief Cria e retorna uma instância do componente 'RotationalImageViewer', tendo um frame e um delegate como parâmetros. */
- (RotationalImageViewer* _Nullable)initWithFrame:(CGRect)frame andDelegate:(id<RotationalImageViewerDelegate> _Nonnull)viewerDelegate;

/** @brief Força o componente a atualizar seu conteúdo. Por padrão, o item selecionado será o primeiro. */
- (void)reloadData;

/** @brief Retorna o índice do item selecionado no momento. */
- (int)currentIndex;

/** @brief Retorna a camada do item selecionado no momento. Quando o componente estiver no sentido de rotação 'RotationalImageViewerScrollDirectionVertical' seu valor será indefinido. */
- (int)currentLayer;

/** @brief Modifica o sentido de rotação do componente. O padrão é 'RotationalImageViewerScrollDirectionHorizontal'. Para o sentido 'RotationalImageViewerScrollDirectionVertical' o componente não irá considerar camadas. Este método não chama 'reloadData' inplicitamente. */
- (void)setRotationDirection:(RotationalImageViewerScrollDirection)newDirection;

/** @brief Determina a sensibilidade do componente durante a rotação. O padrão é 'RotationalImageViewerScrollSensibilityNormal'. */
- (void)setMovementSensibility:(RotationalImageViewerScrollSensibility)sensibility;

/** @brief Habilita ou bloqueia a troca de camadas. O padrão é 'NO'. Somente tem efeito quando o componente estiver no sentido de rotação 'RotationalImageViewerScrollDirectionHorizontal'. */
- (void)setEnableLayerChange:(BOOL)enable;

/** @brief Modifica o aspecto da imagem para exibição. O padrão é 'UIViewContentModeScaleAspectFit'. */
- (void)setImageAspect:(UIViewContentMode)mode;

/** @brief Altera a cor de fundo do componente. */
- (void)setViewerBackgroundColor:(UIColor* _Nonnull)bColor;

/** @brief Força que o componente exiba o item no índice especificado, quando existir. O delegate é informado pelo método 'rotationalImageViewer:updatedIndex:atLayer:', quando implementado. */
- (void)setCurrentIndex:(int)index;

/** @brief Força que o componente exiba o item para a camada especificada, quando existir. Somente tem efeito quando o componente estiver no sentido de rotação 'RotationalImageViewerScrollDirectionHorizontal'. O delegate é informado pelo método 'rotationalImageViewer:updatedIndex:atLayer:', quando implementado. */
- (void)setCurrentLayer:(int)layerIndex;

/** @brief Define a posição do botão de zoom sobre o componente. O padrão é 'RotationalImageViewerZoomButtonPositionBottomLeft'. A opção 'RotationalImageViewerZoomButtonPositionHidden' permite esconder o botão. */
- (void)setZoomButtonPosition:(RotationalImageViewerZoomButtonPosition)position;

/** @brief Método auxiliar para automaticamente inserir constraints no componente, tendo uma parentView como referência. Não é necessário já ter o componente inserido dentro da parentView (ele será inserido automaticamente). */
- (void)autoCreateConstraintsToParent:(UIView*)view;

@end
