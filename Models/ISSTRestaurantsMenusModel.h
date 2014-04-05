//
//  ISSTRestaurantsMenusModel.h
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTRestaurantsMenusModel : NSObject
@property (nonatomic,strong)NSString*       name;
@property (nonatomic,strong)NSString*       picture;
@property (nonatomic,strong)NSString*       description;
@property (nonatomic,assign)float           price;
@end
