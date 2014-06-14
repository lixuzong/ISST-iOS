//
//  ISSTUserModel.h
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef   enum Gender
{
    MALE   = 1 ,
    FAMALE = 2
}Gender;

@interface ISSTUserModel : NSObject<NSCoding>

@property (nonatomic,assign) int         userId;
@property (nonatomic,copy) NSString      *userName;
@property (nonatomic,copy) NSString      *name;
@property (nonatomic,assign) Gender      gender;
@property (nonatomic,assign) int         grade;
@property (nonatomic,assign) int         classId;
@property (nonatomic,assign) int         majorId;
@property (nonatomic,assign) int         cityId;
@property (nonatomic,strong) NSString    *phone;
@property (nonatomic,strong) NSString    *email;
@property (nonatomic,strong) NSString    *qq;
@property (nonatomic,strong) NSString    *company;
@property (nonatomic,strong) NSString    *position;
@property (nonatomic,strong) NSString    *signature;
@property (nonatomic,assign) BOOL        cityPrincipal;
@property (nonatomic,assign) BOOL        privateQQ;
@property (nonatomic,assign) BOOL        privateEmail;
@property (nonatomic,assign) BOOL        privatePhone;
@property (nonatomic,assign) BOOL        privateCompany;
@property (nonatomic,assign) BOOL        privatePosition;

// add by zhaoxs 20140614
@property (nonatomic,copy)  NSString    *cityName;
@property (nonatomic,copy)  NSString    *className;
@property (nonatomic,copy)  NSString    *majorName;

@end
