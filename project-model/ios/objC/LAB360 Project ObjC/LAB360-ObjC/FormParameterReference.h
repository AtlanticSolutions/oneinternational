//
//  FormParameterReference.h
//  Siga
//
//  Created by Erico GT on 29/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /** O tipo genérico é tratado como texto simples, sem máscara, formato, tamanho máximo ou qualquer outro tipo de validação. */
    ParameterReferenceValueTypeGeneric       = 0,
    /** Sempre será considerado um decimal. Para representar inteiros fornecer um formato compatível. */
    ParameterReferenceValueTypeNumber        = 1,
    /** O valor é textual, sujeiro a limitação de caracteres e formato específico. OBS: o formato específico é aplicado ao se atualizar o objeto e não visível ao se editar a caixa de texto. */
    ParameterReferenceValueTypeText          = 2,
    /** Representa valores de uma lista (enum). As opções serão fornecidas ao usuário por meio de um picker. */
    ParameterReferenceValueTypeOption        = 3,
    /** Utilize para representar datas (dia, mês, ano). O formato do dado definirá como o mesmo será apresentado ao usuário. */
    ParameterReferenceValueTypeDate          = 4,
    /** Específico para campos de imagem (não há edição textual, apenas possibilidade de utilizar imagens da camera ou da biblioteca de imagens do dispositivo. */
    ParameterReferenceValueTypeImage         = 5
}ParameterReferenceValueType;

@interface FormParameterReference : NSObject

/** Nome da chave no dicionário que representa o objeto. Lembre-se que esta chave PRECISA existir no referido dicionário. */
@property (nonatomic, strong) NSString *keyName;

/** Nome do parâmetro visível ao usuário. Quando necessário, forneça o valor localizado. */
@property (nonatomic, strong) NSString *parameterName;

/** Quando fornecido, será exibido à esquerda do nome do parâmetro. */
@property (nonatomic, strong) UIImage *parameterIcon;

/** Para campos editáveis com caixa de texto, informa o placeholder do componente. */
@property (nonatomic, strong) NSString *placeholder;

/** Forneça uma máscara para campos numéricos (ParameterReferenceValueTypeNumber). Através da propriedade 'autoClearMask' você pode definir se a máscara será removida ou não antes de atualizar o dicionário do objeto. */
@property (nonatomic, strong) NSString *textMask;

/** Esta propriedade é utilizada na formatação da datas. */
@property (nonatomic, strong) NSString *textFormat;

/** Permite modificar o tipo de teclado. Utilize conforme o tipo do parâmetro em questão. O padrão é 'UIKeyboardTypeDefault'. */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/** Para campos textuais é possível modificar a capitalição automática do texto. O padrão é 'UITextAutocapitalizationTypeNone'. */
@property (nonatomic, assign) UITextAutocapitalizationType capitalizationType;

/** Informa ao formulário o tipo do valor do parâmetro correspondente. Atenção, a tela formulário não converte entre tipos, portanto, forneça sempre o tipo correto. */
@property (nonatomic, assign) ParameterReferenceValueType valueType;

/** Determina o máximo de caracteres permito para o campo. Por padrão é 0 (sem limite determinado). */
@property (nonatomic, assign) int maxSize;

/** Marca o parâmetro como requerido. Quando ativo, o usuário não consegue remover o foco da caixa de texto enquanto não inserir um conteúdo. Esta propriedade só tem efeito para parâmetros digitáveis na edição (que usem caixa de texto). */
@property (nonatomic, assign) BOOL required;

/** Limpa automaticamente a máscara de um campo antes de atualizar o objeto de edição. */
@property (nonatomic, assign) BOOL autoClearMask;

/** Bloqueia um campo para edição. O usuário pode ver o conteúdo, mas não editar. */
@property (nonatomic, assign) BOOL readyOnly;

/** Controla a data mínima válida para o controle DatePicker. Esta propriedade apenas tem efeito quando o tipo de dado é definido como 'ParameterReferenceValueTypeDate'. */
@property (nonatomic, strong) NSDate *minDate;

/** Controla a data máxima válida para o controle DatePicker. Esta propriedade apenas tem efeito quando o tipo de dado é definido como 'ParameterReferenceValueTypeDate'. */
@property (nonatomic, strong) NSDate *maxDate;

/** Executa uma verificação no valor do campo quando este acaba de ser aditado. Caso o texto não corresponda ao regex fornecido ele ficará em destaque vermelho, indicando conteúdo inválido. */
@property (nonatomic, strong) NSString *highlightingRegex;

@end


