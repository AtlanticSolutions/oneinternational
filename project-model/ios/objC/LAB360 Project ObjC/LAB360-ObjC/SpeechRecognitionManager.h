//
//  SpeechRecognitionManager.h
//  MaisAmigas
//
//  Created by Erico GT on 11/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>

@class SpeechRecognitionManager;
@class SpeechRecognitionButtonConfiguration;

#pragma mark - Enums

/** Enum que representa o estado atual do manager. **/
typedef enum {
    SpeechRecognitionManagerStatusStoped    = 1,
    SpeechRecognitionManagerStatusRunning   = 2,
    SpeechRecognitionManagerStatusError     = 3
} SpeechRecognitionManagerStatus;

/** Enum para a função 'auto-stop' do manager. **/
typedef enum {
    SpeechRecognitionAutoStopTimer2seconds    = 1,
    SpeechRecognitionAutoStopTimer4seconds    = 2,
    SpeechRecognitionAutoStopTimer6seconds    = 3,
    SpeechRecognitionAutoStopTimer8seconds    = 4
} SpeechRecognitionAutoStopTimer;

#pragma mark - Protocols

@protocol SpeechRecognitionManagerDelegate
@required

/**
 * Informa ao delegate sobre os termos parciais detectados, conforme vão sendo processados. Estes valores podem variar conforme o contexto, após combinações e reanálises, por isso um texto reportado anteriormente pode ser alterado, excluído ou incrementado.
 * @param   manager    Instância do manager reportando o evento.
 * @param   text   Último termo, ou conjunto de palavras, detectadas pelo manager.
 */
- (void)speechRecognitionManager:(SpeechRecognitionManager* _Nonnull)manager didRecognizePartialText:(NSString* _Nonnull)text;

/**
 * Informa ao delegate o texto completo detectado. Este método apenas é chamado no final da execução do manager, uma única vez.
 * @param   manager    Instância do manager reportando o evento.
 * @param   text   Este valor representa o termo final detectado e não será modificado posteriomente.
 */
- (void)speechRecognitionManager:(SpeechRecognitionManager* _Nonnull)manager didRecognizeAllText:(NSString* _Nonnull)text;

/**
 * Quando o estado do manager for alterado, o delegate será informado por este método.
 * @param   manager    Instância do manager reportando o evento.
 * @param   status   Novo status do manager.
 */
- (void)speechRecognitionManager:(SpeechRecognitionManager* _Nonnull)manager didChangeStatus:(SpeechRecognitionManagerStatus)status;

@end

#pragma mark - Class Interface

@interface SpeechRecognitionManager : NSObject

#pragma mark - Properties

/** Estado da permisssão do 'Reconhecimento de Voz'. **/
@property(nonatomic, assign) SFSpeechRecognizerAuthorizationStatus speechRecognizerPermission;

/** Estado da permisssão do 'Microfone'. **/
@property(nonatomic, assign) AVAudioSessionRecordPermission micRecordPermission;

/** Cada novo estado do manager gera uma mensagem característica. Nos casos de erro, este campo conterá o detalhe do problema encontrado. **/
@property(nonatomic, strong, readonly) NSString * _Nullable statusDescription;

/** Guarda o último texto (completo) reconhecido. Esta disponível até um novo reconhecimento tenha sido iniciado. **/
@property(nonatomic, strong, readonly) NSString * _Nullable lastRecognizedText;

/** Informa ao manager que apenas números devem ser reportados. Útil para preenchimento de campos de texto númericos. O padrão é 'NO'. **/
@property(nonatomic, assign) BOOL reportOnlyNumbers;

/** Permite personalizar a linguagem do reconhecedor de voz. O padrão é 'pt_BR'. A mudança não ocorre em tempo real, durante um processo em andamento (será necessário reiniciar o reconhecimento). Para referência visite: https://gist.github.com/jacobbubu/1836273 . **/
@property(nonatomic, strong) NSString * _Nullable localeIdentifier;

/** Componente conveniente para uso junto com o reconhecedor. **/
@property(nonatomic, strong, readonly) UIButton * _Nullable embeddedMicButton;

#pragma mark - Methods

/** Cria uma novo reconhecedor de voz. **/
+ (SpeechRecognitionManager* _Nonnull)newSpeechRecognitionManagerWithDelegate:(id<SpeechRecognitionManagerDelegate> _Nullable)delegate;

/**
 * Inicia o reconhecimento de voz utilizando o microfone, caso o mesmo ainda não esteja em funcionamento.
 * @note   É necessário ter uma conexão a internet disponível para pacotes de linguagens não disponibilizadas pelo sistema offline, para esta funcionalidade.
 */
- (void)startRecognition;

/**
 * Encerra um reconhecimento anteriormente iniciado. O texto detectado será reportado pelo método de protocolo 'speechRecognitionManager:didRecognizeAllText' e também estará disponível na propriedade 'lastRecognizedText' (até um novo reconhecimento ser iniciado).
 */
- (void)stopRecognition;

/**
 * Inicia o reconhecimento de voz igual ao método 'startRecognition', sendo que após 'n' segundos de inatividade (nenhum som reconhecido) o próprio manager executará uma parada automática.
 */
- (void)startRecognitionWithAutoStop:(SpeechRecognitionAutoStopTimer)seconds;

/**
 * Permite configurar parâmetros para o botão do reconhecedor.
 */
- (void)configureEmbeddedButton:(SpeechRecognitionButtonConfiguration* _Nonnull)configuration;

@end

#pragma mark - Class Interface

@interface SpeechRecognitionButtonConfiguration : NSObject

@property(nonatomic, assign) BOOL isTypeAutoStop;
@property(nonatomic, assign) BOOL showRemainingTimeAnimation;
@property(nonatomic, assign) CGRect frame;
@property(nonatomic, strong) UIColor* _Nullable normalBackgroundColor;
@property(nonatomic, strong) UIColor* _Nullable highlightedBackgroundColor;
@property(nonatomic, strong) UIColor* _Nullable normalIconColor;
@property(nonatomic, strong) UIColor* _Nullable highlightedIconColor;
@property(nonatomic, strong) UIColor* _Nullable shadowColor;

@end
