//
//  TVC_SponsorsCollection.h
//  AHK-100anos
//
//  Created by Erico GT on 11/3/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVC_SponsorLogo.h"

@interface TVC_SponsorsCollection : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionViewMenu;
@property (nonatomic, weak) IBOutlet UILabel* lblTitulo;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;

-(void) updateLayoutForItens:(NSArray<NSString*>*)itens;

@end
