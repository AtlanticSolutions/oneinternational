//
//  CS_QuestionWebContent_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"
#import <WebKit/WebKit.h>

@interface CS_QuestionWebContent_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *lblHint;
@property (nonatomic, weak) IBOutlet UIButton *btnControl;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) WKWebView *webView;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
