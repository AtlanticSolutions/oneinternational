//
//  AdAliveVideoEffects.h
//  AdAliveSDK
//
//  Created by Erico GT on 09/11/18.
//  Copyright © 2018 atlantic. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class  AdAliveVideoEffects
 @brief
    Esta classe fornece parâmetros de feito para a exibição do videoAR em textura (sobre a imageTarget).
 @discussion
    Com relação
 */

@interface AdAliveVideoEffects : NSObject

/*!
 @property  isTransparentVideo
 @brief
    Indica para o player de video AR que o vídeo terá uma máscara de transparência.
    O padrão é NO.
 @discussion
    A técnica de transparência padrão será a que utiliza a metade inferior do vídeo como máscara (pixel preto equivale a transparência e branco opacidade).
    Caso o vídeo não contenha a máscara embutida a exibição resultante será ruim, pois o player tentará aplicar o efeito mesmo assim.
 */
@property (nonatomic, assign) BOOL isTransparentVideo;

/*!
 @property  useChromaKeyMask
 @brief
    Indica para o player de video AR que o efeito de transparência deve utilizar a técnica de ChromaKey.
    O padrão é NO.
 @discussion
    Esta propriedade apenas tem efeito quando 'isTransparentVideo' for YES.
    Durante a exibição do vídeo, uma faixa de cor verde será automaticamente utilizada como transparência.
    Para saber mais sobre o algorítimo utilizado para cálculo do ChromaKey acesse: <https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect?language=objc>.
 */
@property (nonatomic, assign) BOOL useChromaKeyMask;

/*!
 @property  isPlayableFullscreen
 @brief
    Quando o vídeo está tocando e o imageTarget é perdido, pode-se através desta propriedade determinar que o vídeo deve tocar em fullscreen ao invés de parar.
    Por padrão é YES.
 @discussion
    Quando em tela cheia é possível tocar sobre o vídeo para que controles flutuantes apareçam sobre o vídeo, permitindo parar, pausar e mutar o vídeo em execução.
 */
@property (nonatomic, assign) BOOL isPlayableFullscreen;

/*!
 @property  isDoubleSided
 @brief
    Determina se a textura do videoAR poderá ser vista pelos dois lados (frente e verso).
    Por padrão é NO.
 @discussion
    Este parâmetro é indicado para vídeos rotacionados, onde realmente é possível movimentar a imageTarget e ver a imagem do vídeo por outro ângulo.
    Por exemplo: Efeito holograma, onde uma pessoa fala num vídeo transparente, rotacionado 90º no eixo X, e se deseja permitir a visualição pela frente e por trás.
 */
@property (nonatomic, assign) BOOL isDoubleSided;

/*!
 @property  muteOnStart
 @brief
    O vídeo pode ou não iniciar sem volume.
    Por padrão é NO.
 @discussion
    Mesmo iniciando sem volume será possível mudar posteriormente, já com o vídeo em execução.
 */
@property (nonatomic, assign) BOOL muteOnStart;

#pragma mark - Video Rotation Over Target

/*!
 @property  rotationX
 @brief
    Gira a imagem do videoAR sobre a imageTarget no eixo X.
    O valor padrão é 0.0f.
 @discussion
    A unidade parâmetro é GRAU.
    Valores positivos seguem o sentido antí-horário de rotação.
 */
@property (nonatomic, assign) float rotationX;

/*!
 @property  rotationY
 @brief
    Gira a imagem do videoAR sobre a imageTarget no eixo Y.
    O valor padrão é 0.0f.
 @discussion
    A unidade parâmetro é GRAU.
    Valores positivos seguem o sentido antí-horário de rotação.
 */
@property (nonatomic, assign) float rotationY;

/*!
 @property  rotationZ
 @brief
    Gira a imagem do videoAR sobre a imageTarget no eixo Z.
    O valor padrão é 0.0f.
 @discussion
    A unidade parâmetro é GRAU.
    Valores positivos seguem o sentido antí-horário de rotação.
 */
@property (nonatomic, assign) float rotationZ;

#pragma mark - Video Translation Over Target

/*!
 @property  translationX
 @brief
    Desloca a imagem do videoAR sobre a imageTarget horizontalmente.
    O valor padrão é 0.0f.
 @discussion
    Valores positivos de X deslocam o vídeo para a direita. Valores negativos para a esquerda.
    A unidade de deslocamento equivale ao tamanho da dimensão (largura do vídeo) local. Por exemplo: 0.5 equivale a deslocar-se 50% da largura do vídeo para a direita em relação ao centro da imageTarget.
 */
@property (nonatomic, assign) float translationX;

/*!
 @property  translationY
 @brief
    Desloca a imagem do videoAR sobre a imageTarget verticalmente.
    O valor padrão é 0.0f.
 @discussion
    Valores positivos de Y deslocam o vídeo para cima. Valores negativos para baixo.
    A unidade de deslocamento equivale ao tamanho da dimensão (altura do vídeo) local. Por exemplo: -0.4 equivale a deslocar-se 40% da altura do vídeo para baixo em relação ao centro da imageTarget.
 */
@property (nonatomic, assign) float translationY;

/*!
 @property  rotationZ
 @brief
    Desloca a imagem do videoAR sobre a imageTarget no eixo z, aumentando ou diminuindo a distância do plano original do imageTarget.
    O valor padrão é 0.0f.
 @discussion
    Valores positivos de Z aumentam a distância sobre o imageTarget, enquanto valores negativos aumentam a distância sob.
    A unidade de deslocamento equivale ao tamanho da dimensão (menor valor entre largura e altura do vídeo) local. Por exemplo: 0.2 equivale a deslocar-se 20% da altura ou altura (será utilizado o menor valor) do vídeo para cima do plano da imageTarget.
 */
@property (nonatomic, assign) float translationZ;

#pragma mark - Video Scale Over Target

/*!
 @property  scaleInTarget
 @brief
    Modifica o tamanho do videoAR sobre a imageTarget.
    O valor padrão é 1.0f.
 @discussion
    A escala modifica todas as dimensões do vídeo igualmente.
 */
@property (nonatomic, assign) float scaleInTarget;

#pragma mark - Methods

/*!
 @method    copyEffects
 @abstract
    Copia um conjunto de efeitos instanciados.
 @result
    O retorno é uma nova instância do objeto AdAliveVideoEffects, com os mesmos valores de propriedades.
 @discussion
    A cópia não guarda nenhuma referência do objeto original (executa um 'deep copy').
 */
- (AdAliveVideoEffects*)copyEffects;

@end
