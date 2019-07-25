//
//  FloatingPickerView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingPickerElement.h"

@class FloatingPickerView;

#pragma mark - Protocol

@protocol FloatingPickerViewDelegate

@required

//Data (Lista de elementos):
- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView* _Nonnull)pickerView;

//Appearence (Textos fixos do componente):
- (NSString* _Nonnull)floatingPickerViewTextForCancelButton:(FloatingPickerView* _Nonnull)pickerView;
- (NSString* _Nonnull)floatingPickerViewTextForConfirmButton:(FloatingPickerView* _Nonnull)pickerView;
- (NSString* _Nonnull)floatingPickerViewTitle:(FloatingPickerView* _Nonnull)pickerView;
- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView;

//Control (Adição e remoção do componente):
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements;
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements;
- (void)floatingPickerViewDidShow:(FloatingPickerView* _Nonnull)pickerView;
- (void)floatingPickerViewDidHide:(FloatingPickerView* _Nonnull)pickerView;

@optional

//Appearence (aconselha-se ao trocar o background fazer também a troca da cor do texto):
- (UIColor* _Nonnull)floatingPickerViewBackgroundColorCancelButton:(FloatingPickerView* _Nonnull)pickerView;
- (UIColor* _Nonnull)floatingPickerViewTextColorCancelButton:(FloatingPickerView* _Nonnull)pickerView;
- (UIColor* _Nonnull)floatingPickerViewBackgroundColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView;
- (UIColor* _Nonnull)floatingPickerViewTextColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView;
- (UIColor* _Nonnull)floatingPickerViewSelectedBackgroundColor:(FloatingPickerView* _Nonnull)pickerView;

@end

#pragma mark - Class

@interface FloatingPickerView : UIViewController

typedef enum {
    FloatingPickerViewContentStyleAuto         = 0,
    FloatingPickerViewContentStyle100          = 1,
    FloatingPickerViewContentStyle75           = 2,
    FloatingPickerViewContentStyle50           = 3
} FloatingPickerViewContentStyle;

#pragma mark - Properties
/** Deixar a propriedade abaixo descomentada se for necessário acessar os elementos enquanto o componente ainda está na tela. */
//@property(nonatomic, strong, readonly) NSArray<FloatingPickerElement*>* _Nullable pickerElements;

/** Propriedade conveniente para auxiliar o reuso do componente (idem propriedade de uma UIView). */
@property(nonatomic, assign) NSInteger tag;

/** Permite que o usuário selecione vários itens na lista. O padrão é 'NO'. */
@property(nonatomic, assign) BOOL multiSelection;

/** Exibe um background com blur abaixo do picker. O padrão é 'NO', exibindo uma view escura (65% black). */
@property(nonatomic, assign) BOOL blurEffectBackground;

/** Permite que o usuário cancele o componente ao tocar no background. O padrão é 'NO'. */
@property(nonatomic, assign) BOOL backgroundTouchForceCancel;

/** Define a altura do componente na tela. O padrão é 'FloatingPickerViewContentStyleAuto'. */
@property(nonatomic, assign) FloatingPickerViewContentStyle contentStyle;

#pragma mark - Methods

/** Cria um novo picker a partir do storyboard. */
+ (FloatingPickerView* _Nonnull)newFloatingPickerView;

/** Exibe o componente sobre o ViewController parâmetro (obrigatório). O picker é sempre exibido na forma modal. */
- (void)showFloatingPickerViewWithDelegate:(UIViewController<FloatingPickerViewDelegate>* _Nonnull)vcDelegate;

/** Remove o componente exibido anteriormente, forçando um fechamento sem interação do usuário. */
- (void)hideFloatingPickerView;

@end
