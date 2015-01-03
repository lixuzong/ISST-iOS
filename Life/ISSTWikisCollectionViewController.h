//
//  ISSTWikisCollectionViewController.h
//  ISST
//
//  Created by rth on 15/1/3.
//  Copyright (c) 2015年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTWebApiDelegate.h"
#import "ISSTBaseViewController.h"
@interface ISSTWikisCollectionViewController : ISSTBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,ISSTWebApiDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@end
