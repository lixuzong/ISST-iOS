//
//  ISSTUpdateLogin.h
//  ISST
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSTUserModel.h"

@interface ISSTUpdateLogin : NSObject

@property (nonatomic,strong)ISSTUserModel  *userModel;
-(void)update;
@end
