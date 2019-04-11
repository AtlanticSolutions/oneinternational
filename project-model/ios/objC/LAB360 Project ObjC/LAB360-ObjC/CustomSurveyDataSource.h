//
//  CustomSurveyDataSource.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceResponse.h"
#import "CustomSurvey.h"

@interface CustomSurveyDataSource : NSObject

/** Busca dados mockados no site "https://www.mockable.io". */
- (void)getCustomSurveyFromMockableioWithCompletionHandler:(void (^_Nullable)(CustomSurvey* _Nullable survey, DataSourceResponse* _Nonnull response)) handler;

/** Busca dados mockados no S3 (arquivo JSON). */
- (void)getCustomSurveyFromS3ForSample:(long)sampleID withCompletionHandler:(void (^_Nullable)(CustomSurvey* _Nullable survey, DataSourceResponse* _Nonnull response)) handler;

@end
