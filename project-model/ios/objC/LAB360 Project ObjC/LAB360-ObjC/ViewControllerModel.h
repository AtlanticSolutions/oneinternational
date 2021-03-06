//
//  ViewControllerModel.h
//  AHK-100anos
//
//  Created by Erico GT on 10/27/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

//typedef enum {
//    NavigationControllerTransitionAnimationDefault      = 0,
//    NavigationControllerTransitionAnimationFade         = 1
//} NavigationControllerTransitionAnimation;

#pragma mark - • PROTOCOLS
@protocol ViewControllerModelDelegate<NSObject>
@required
- (void)setupLayout:(NSString*)screenName;
- (void)pop:(NSUInteger)indexesToReturn;
- (void)push:(NSString*)segue backButton:(NSString*)bTitle sender:(id)sender;
- (void)keyboardWillAppearAlert;
- (void)keyboardWillHideAlert;
@end

#pragma mark - • INTERFACE
@interface ViewControllerModel : UIViewController<ViewControllerModelDelegate> //UINavigationControllerDelegate

#pragma mark - • PUBLIC PROPERTIES
//Layout:
@property(nonatomic, weak) IBOutlet UIScrollView *scrollViewBackground;
//Data:
@property(nonatomic, assign) BOOL setupOnceInViewWillAppear;
@property(nonatomic, assign) BOOL showAppMenu;
@property(nonatomic, assign) BOOL animatedTransitions;
//@property(nonatomic, assign) NavigationControllerTransitionAnimation pushAnimation;
//@property(nonatomic, assign) NavigationControllerTransitionAnimation popAnimation;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS
- (void)showActivityIndicatorView;
- (void)hideActivityIndicatorView;

@end
