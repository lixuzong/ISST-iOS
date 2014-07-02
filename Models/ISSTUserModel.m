//
//  ISSTUserModel.m
//  ISST
//
//  Created by XSZHAO on 14-3-25.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTUserModel.h"

@implementation ISSTUserModel

@synthesize userId,userName,name,gender,grade,classId,majorId,cityId,phone,email,qq,signature,position, company,cityPrincipal,privateCompany,privateEmail,privatePhone,privatePosition,privateQQ;

@synthesize  className,majorName,cityName;

-(void)setQq:(NSString *)q
{
    [q retain];
    [qq release];
    if (q && ![q isMemberOfClass:[NSNull class]])
    {
        qq = q;
    }
    else
    {
        qq = @"";
    }
}

-(void)setCityName:(NSString *)c
{
    [c retain];
    [cityName release];
    if (c &&! [c isMemberOfClass:[NSNull class]] )
    {
        cityName = c;
    }
    else
    {
        cityName = @"";
    }
    
}

-(void)setmajorName:(NSString *)m
{
    [m retain];
    [majorName release];
    if (m && ![m isMemberOfClass:[NSNull class]])
    {
        majorName = m;
    }
    else
    {
        majorName = @"";
    }
}

-(void)setClassName:(NSString *)c
{
    [c retain];
    [className release];
    if (c && ![c isMemberOfClass:[NSNull class]])
    {
        className = c;
    }
    else
    {
        className = @"";
    }
}

-(void)setSignature:(NSString *)s
{
    [s retain];
    [signature release];
    if (s && ![s isMemberOfClass:[NSNull class]])
    {
        signature = s;
    }
    else
    {
        signature = @"";
    }
}

-(void)setCompany:(NSString *)c
{
    [c retain];
    [company release];
    if (c && ![c isMemberOfClass:[NSNull class]])
    {
        company = c;
    }
    else
    {
        company = @"";
    }
}

-(void)setPosition:(NSString *)p
{
    [p retain];
    [position release];
    if (p && ![p isMemberOfClass:[NSNull class]])
    {
        position = p;
    }
    else
    {
        position = @"";
    }
}


- (id)init
{
    self = [super init];
    if(self){
        userId      = 0;
        name        = nil;
        userName    = nil;
        gender      = 0;
        grade       = 0;
        classId     = 0;
        majorId    =  0;
        cityId     =  0;
        phone      = nil;
        email       = nil;
        qq          = nil;
        signature   = nil;
        position    = nil;
        company     = nil;
        cityPrincipal=NO;
        privateCompany=NO;
        privateEmail=NO;
        privatePhone=NO;
        privatePosition=NO;
        privateQQ=NO;
        
        cityName = nil;
        className = nil;
        majorName = nil;
        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        userId      = ((NSNumber*)[decoder decodeObjectForKey:@"userId"]).intValue  ;
        name        = [[decoder decodeObjectForKey:@"name"] retain];
        userName    = [[decoder decodeObjectForKey:@"userName"] retain];
        gender      = ((NSNumber*)[decoder decodeObjectForKey:@"gender"]).intValue==1?MALE:FAMALE;
        grade       = ((NSNumber*)[decoder decodeObjectForKey:@"gradeId"]).intValue ;
        classId     = ((NSNumber*)[decoder decodeObjectForKey:@"classId"]).intValue ;
        majorId    = ((NSNumber*)[decoder decodeObjectForKey:@"majorId"]).intValue ;
        cityId     = ((NSNumber*)[decoder decodeObjectForKey:@"cityId"]).intValue ;
        phone      = [[decoder decodeObjectForKey:@"phone"] retain];
        email       = [[decoder decodeObjectForKey:@"email"] retain];
        qq          = [[decoder decodeObjectForKey:@"qq"] retain];
        signature   = [[decoder decodeObjectForKey:@"signature"] retain];
        position    = [[decoder decodeObjectForKey:@"position"] retain];
        company     = [[decoder decodeObjectForKey:@"company"] retain];
        cityPrincipal=((NSNumber*)[decoder decodeObjectForKey:@"cityPrincipal"]).boolValue;
        privateCompany=((NSNumber*)[decoder decodeObjectForKey:@"privateCompany"]).boolValue;
        privateEmail=((NSNumber*)[decoder decodeObjectForKey:@"privateEmail"]).boolValue;
        privatePhone=((NSNumber*)[decoder decodeObjectForKey:@"privatePhone"]).boolValue;
        privatePosition=((NSNumber*)[decoder decodeObjectForKey:@"privatePosition"]).boolValue;
        privateQQ=((NSNumber*)[decoder decodeObjectForKey:@"privateQQ"]).boolValue;
        
        className        = [[decoder decodeObjectForKey:@"className"] retain];
        majorName    = [[decoder decodeObjectForKey:@"majorName"] retain];
        cityName    = [[decoder decodeObjectForKey:@"cityName"] retain];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:self.userId]  forKey:@"userId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:[NSNumber numberWithInt:(self.gender==MALE?1:2)] forKey:@"gender"];
    [encoder encodeObject:[NSNumber numberWithInt:self.grade] forKey:@"gradeId"];
    [encoder encodeObject:[NSNumber numberWithInt:self.classId] forKey:@"classId"];
    [encoder encodeObject:[NSNumber numberWithInt:self.majorId] forKey:@"majorId"];
    [encoder encodeObject:[NSNumber numberWithInt:self.cityId] forKey:@"cityId"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:qq forKey:@"qq"];
    [encoder encodeObject:self.signature forKey:@"signature"];
    [encoder encodeObject:self.position forKey:@"position"];
    [encoder encodeObject:self.company forKey:@"company"];
    [encoder encodeObject:[NSNumber numberWithBool:self.cityPrincipal] forKey:@"cityPrincipal"];
    [encoder encodeObject:[NSNumber numberWithBool:self.privateCompany] forKey:@"privateCompany"];
    [encoder encodeObject:[NSNumber numberWithBool:self.privateEmail] forKey:@"privateEmail"];
    [encoder encodeObject:[NSNumber numberWithBool:self.privatePhone] forKey:@"privatePhone"];
    [encoder encodeObject:[NSNumber numberWithBool:self.privatePosition] forKey:@"privatePosition"];
    [encoder encodeObject:[NSNumber numberWithBool:privateQQ] forKey:@"privateQQ"];
    
    [encoder encodeObject:cityName forKey:@"cityName"];
    [encoder encodeObject:self.majorName forKey:@"majorName"];
    [encoder encodeObject:self.className forKey:@"className"];
    
}
/////////////////http://blog.csdn.net/wbw1985/article/details/19989709
//////////////////////

- (void)dealloc
{
    [userName release];
    // userName = nil;
    [name release];
    name = nil;
    [phone release];
    phone = nil;
    [email release];
    email = nil;
    [qq release];
    qq = nil;
    [signature release];
    signature = nil;
    [position release];
    position = nil;
    [company release];
    company = nil;
    
    [className release];
    className= nil;
    
    [cityName release];
    cityName = nil;
    
    [majorName release];
    majorName = nil;
    
    [super dealloc];
}


@end
