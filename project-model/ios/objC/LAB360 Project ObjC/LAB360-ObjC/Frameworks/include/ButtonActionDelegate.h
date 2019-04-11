//
//  ButtonActionDelegate.h
//  testingLib
//
//  Created by Monique Trevisan on 30/09/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#ifndef ButtonActionDelegate_h
#define ButtonActionDelegate_h

@protocol ButtonActionDelegate <NSObject>

@required

/**
 *  Quando um botão for acionado, o delegate é avisado com os dados relacionados ao mesmo.
 */
-(void)clickedButtonWithData:(NSDictionary *)dicData;

@optional

/**
 *  O delegate é avisado quando os botões forem ficar visíveis ao usuário.
 */
-(void)actionButtonsWillAppear;

/**
 *  O delegate é avisado quando os botões forem desaparecer da visão do usuário.
 */
-(void)actionButtonsWillDisappear;

@end

#endif /* ButtonActionDelegate_h */
