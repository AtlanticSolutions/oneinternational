//
//  MediaTransferVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

typedef NS_ENUM(NSInteger, TransferMediaType) {
    TransferMediaTypeNone           = 0,
    TransferMediaTypeDocument       = 1,
    TransferMediaTypeImage          = 2,
    TransferMediaTypeVideo          = 3
};

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface MediaTransferVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
