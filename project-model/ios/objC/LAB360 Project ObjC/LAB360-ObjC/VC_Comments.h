//
//  VC_Comments.h
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 18/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "TVC_Comment.h"
#import "ToolBox.h"
#import "Post.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_Comments : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) Post *selectedPost;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
