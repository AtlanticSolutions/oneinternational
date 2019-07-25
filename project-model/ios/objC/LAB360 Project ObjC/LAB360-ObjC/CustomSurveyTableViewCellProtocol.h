//
//  CustomSurveyTableViewCellProtocol.h
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ConstantsManager.h"
#import "UIImageView+AFNetworking.h"
#import "CustomSurveyCollectionElement.h"
#import "AsyncImageDownloader.h"

#define SURVEY_COLOR_GRAY [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1]
#define SURVEY_COLOR_LIGHTGRAY [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1]
//
#define SURVEY_COLOR_BLUE [UIColor colorWithRed:25.0/255.0 green:96.0/255.0 blue:225.0/255.0 alpha:1]
#define SURVEY_COLOR_LIGHTBLUE [UIColor colorWithRed:121.0/255.0 green:160.0/255.0 blue:225.0/255.0 alpha:1]

//******************************************************************************

@protocol CustomSurveyTableViewCellProtocol <NSObject>

@required
- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end

//******************************************************************************

@protocol EditableComponentTableViewCellProtocol <NSObject>

@required
- (void)didEndEditingComponentAtSection:(NSInteger)section row:(NSInteger)row withValue:(NSString*)textValue;
- (void)didEndEditingComponentAtSection:(NSInteger)section row:(NSInteger)row withValidationErrorMessage:(NSString*)errorMessage;

@optional
- (void)didBeginEditingTextInRect:(CGRect)textRect;

@end

//******************************************************************************

@protocol EditableItemComponentTableViewCellProtocol <NSObject>

@required
- (void)didEndEditingItemComponentAtSection:(NSInteger)section row:(NSInteger)row collectionIndex:(NSInteger)collectionIndex withValue:(NSString*)textValue;
- (void)didEndEditingItemComponentAtSection:(NSInteger)section row:(NSInteger)row collectionIndex:(NSInteger)collectionIndex withValidationErrorMessage:(NSString*)errorMessage;

@end

//******************************************************************************

@protocol SelectableComponentTableViewCellProtocol <NSObject>

@required
- (void)didEndSelectingComponentAtSection:(NSInteger)section row:(NSInteger)row collectionIndex:(NSInteger)collectionIndex withImage:(UIImage*)image;

@end

//******************************************************************************

@protocol OptionsComponentTableViewCellProtocol <NSObject>

@required
- (void)requireOptionsListForComponentAtSection:(NSInteger)section row:(NSInteger)row;

@end
