//
//  ResultViewController.h
//  AdAlive
//
//  Created by Monique Trevisan on 9/26/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (JRAdditions)
- (NSDictionary *)dictionaryByReplacingNullsWithStrings;
@end

@protocol ProductViewControllerDelegate<NSObject>
@required
- (void)registerProductAction:(NSDictionary*)dicAction;
@end

@interface ProductViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UITextFieldDelegate>

@property(nonatomic, strong) NSDictionary *dicProductData;
@property(nonatomic, strong) NSString *targetName;
@property(nonatomic, assign) BOOL showBackButton;
@property(nonatomic, assign) BOOL executeAutoLaunch;
//
@property(nonatomic, weak) id<ProductViewControllerDelegate> vcDelegate;

@end
