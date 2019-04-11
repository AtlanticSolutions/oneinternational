//
//  Category.m
//  CozinhaTudo
//
//  Created by lucas on 12/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "DocVidCategory.h"

#define CLASS_CATEGORY_ID @"id"
#define CLASS_CATEGORY_NAME @"name"
#define CLASS_CATEGORY_URL @"image_url"
#define CLASS_CATEGORY_SUBCATEGORIES @"subcategories"

@implementation DocVidCategory

@synthesize idCategory, name, imageUrl, subcategoryArray, imgCategory, type, selected;

- (id)init
{
    self = [super init];
    if (self)
    {
        idCategory = DOMP_OPD_INT;
        name = DOMP_OPD_STRING;
        imageUrl = DOMP_OPD_STRING;
        subcategoryArray = [[NSMutableArray alloc] init];
        imgCategory = DOMP_OPD_IMAGE;
        type = DOMP_OPD_INT;
        selected = DOMP_OPD_BOOLEAN;
    }
    return self;
}

+(DocVidCategory*)createObjectFromDictionary:(NSDictionary*)dicData {
    
    DocVidCategory* newCategory;
    
    NSArray* keysList = [dicData allKeys];
    
    if (keysList.count > 0)
    {
        newCategory = [DocVidCategory new];
        //
        newCategory.idCategory = [keysList containsObject:CLASS_CATEGORY_ID] ? [[dicData valueForKey:CLASS_CATEGORY_ID] integerValue] : 0;
        //
        newCategory.imageUrl = [keysList containsObject:CLASS_CATEGORY_URL] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:CLASS_CATEGORY_URL]] : @"";
        //
        newCategory.name = [keysList containsObject:CLASS_CATEGORY_NAME] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:CLASS_CATEGORY_NAME]] : @"";
        //
        if([keysList containsObject:CLASS_CATEGORY_SUBCATEGORIES]) {
            
            NSArray *arr = [[NSMutableArray alloc] initWithArray:[dicData valueForKey:CLASS_CATEGORY_SUBCATEGORIES]];
            for (NSDictionary *dic in arr) {
                [newCategory.subcategoryArray addObject:[DocVidCategory createObjectFromDictionary:dic]];
            }
        }
    }
    
    return newCategory;
}

@end
