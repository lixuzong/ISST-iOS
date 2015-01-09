//
//  ISSTPushModel.h
//  ISST
//
//  Created by apple on 15/1/9.
//  Copyright (c) 2015年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTPushModel : NSObject

@property (nonatomic,assign)int Id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString* updatedAt;
@property (nonatomic,copy) NSString *content;

@end
