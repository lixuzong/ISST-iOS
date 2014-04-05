//
//  ISSTRestaurantsModel.h
//  ISST
//
//  Created by XSZHAO on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTRestaurantsModel : NSObject
@property (nonatomic,assign)int         restaurantsId;
@property (nonatomic,strong)NSString*   name;
@property (nonatomic,strong)NSString*   picture;
@property (nonatomic,strong)NSString*   address;
@property (nonatomic,strong)NSString*   hotline;
@property (nonatomic,strong)NSString*   businessHours;
@property (nonatomic,strong)NSString*   description;
@property (nonatomic,strong)NSString*   content;
@end
