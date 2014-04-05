//
//  NetworkReachability.m
//  ISST
//
//  Created by XSZHAO on 14-4-1.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "NetworkReachability.h"
#import "Reachability.h"

@implementation NetworkReachability

 +(BOOL) isConnectionAvailable{
        
        BOOL isExistenceNetwork = YES;
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        switch ([reach currentReachabilityStatus]) {
            case NotReachable:
                isExistenceNetwork = NO;
                //NSLog(@"notReachable");
                break;
            case ReachableViaWiFi:
                isExistenceNetwork = YES;
                //NSLog(@"WIFI");
                break;
            case ReachableViaWWAN:
                isExistenceNetwork = YES;
                //NSLog(@"3G");
                break;
        }
        
        if (!isExistenceNetwork) {
          //  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
          //  hud.removeFromSuperViewOnHide =YES;
         //   hud.mode = MBProgressHUDModeText;
         ////   hud.labelText = NSLocalizedString(INFO_NetNoReachable, nil);
          ////  hud.minSize = CGSizeMake(132.f, 108.0f);
          //  [hud hide:YES afterDelay:3];
            return NO;
        }
        
        return isExistenceNetwork;
    }



@end
