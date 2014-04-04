//
//  ISSTWikisViewController.h
//  ISST
//
//  Created by liuyang on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRootViewController.h"

@interface ISSTWikisViewController : ISSTRootViewController<UICollectionViewDataSource,UICollectionViewDelegate>  

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@end
