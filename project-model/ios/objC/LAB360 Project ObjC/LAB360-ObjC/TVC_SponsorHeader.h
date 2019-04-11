//
//  TVC_SponsorHeader.h
//  GS&MD
//
//  Created by Lab360 on 01/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVC_SponsorHeader : UICollectionReusableView

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

-(void) updateLayout;

@end
