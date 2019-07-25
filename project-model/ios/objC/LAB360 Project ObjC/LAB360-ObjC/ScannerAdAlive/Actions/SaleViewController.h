//
//  SaleViewController.h
//  AdAlive
//
//  Created by Monique Trevisan on 11/7/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) NSDictionary *dicProduct;
@property(nonatomic, strong) UIImage *image;
-(IBAction)clickCancelButton:(id)sender;

@end
