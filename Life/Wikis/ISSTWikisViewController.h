//
//  ISSTWikisViewController.h
//  ISST
//
//  Created by zhukang on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTWebApiDelegate.h"
#import "ISSTBaseViewController.h"
@interface ISSTWikisViewController : ISSTBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,ISSTWebApiDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@end
