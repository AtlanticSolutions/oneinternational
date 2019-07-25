//
//  Category.h
//  CozinhaTudo
//
//  Created by lucas on 12/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ToolBox.h"

typedef enum{
    eCategoryType_Undefined = -1,
    eCategoryType_Document = 0,
    eCategoryType_Product = 1,
    eCategoryType_Video = 2

} enumCategoryType;

@interface DocVidCategory : NSObject

@property (nonatomic, assign) long idCategory;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) UIImage *imgCategory;
@property (nonatomic, strong) NSMutableArray<DocVidCategory*> *subcategoryArray;
@property (nonatomic, assign) enumCategoryType type;
@property(nonatomic, assign) BOOL selected;

+(DocVidCategory*)createObjectFromDictionary:(NSDictionary*)dicData;

@end
