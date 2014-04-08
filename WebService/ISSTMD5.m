//
//  ISSTMD5.m
//  ISST
//
//  Created by XSZHAO on 14-3-31.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTMD5.h"
#import "CommonCrypto/CommonDigest.h"


@implementation ISSTMD5

const static NSString *MD5_SECTET = @"vq8ukG8MKrNC7XqsbIbd7PxvX81ufNz9";

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:
            // @"xxxxxxxxxxxxxxxx",
            // @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x",
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
        /*    result[16], result[17],result[18], result[19],
            result[20], result[21],result[22], result[23],
            result[24], result[25],result[26], result[27],
            result[28], result[29],result[30], result[31]];*/
}


+ (long long) getTimestamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    return dTime;
}

+ (NSString *) tokenWithDic:(NSDictionary *)md5Dic andTimestamp:(long long)timestamp;
{
    NSArray *temparray = [md5Dic allKeys];
//    NSArray *sortArray = [temparray sortedArrayUsingComparator:
//                          ^(id tem1,id tem2)
//                          {
//                              NSComparisonResult result =[tem1 compare:tem2];
//                              return result;
//                          }
//                          ];
    NSMutableString *mutableString  = [[NSMutableString alloc]init];
    for (NSString *sortKey in temparray) {
        [mutableString appendString:[NSString stringWithFormat:@"%@",[md5Dic objectForKey:sortKey]] ];
    }
    NSString *tokenString = [NSString stringWithFormat:@"%@%@%llu",MD5_SECTET,mutableString,timestamp];
    return [self md5:tokenString];
}

@end
