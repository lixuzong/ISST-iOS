//
//  AppCache.m
//  ISST
//
//  Created by XSZHAO on 14-4-11.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache
+ (void)saveCache:(id)model
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         
                                                         NSUserDomainMask, YES);
    
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"UserModel.archive"];
   // NSArray *tmpArray = [NSArray arrayWithObject:@"archive"];
    //BOOL saveed =
     [NSKeyedArchiver archiveRootObject:model toFile:archivePath];
}


+ ( id)getCache
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  //NSCachesDirectory,
                                                         
                                                         NSUserDomainMask, YES);
    
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    
    //NSString*filePath=[AppDocuments stringByAppendingPathComponent:@"customobject.txt"];
    //    AppCache/
    NSString *archivePath = [cachesDirectory
                             
                             stringByAppendingPathComponent:@"UserModel.archive"];
    
    //    NSMutableArray *cachedItems = [NSKeyedUnarchiver
    //
    //                                   unarchiveObjectWithFile:archivePath];
    
    id  cachedItems = [NSKeyedUnarchiver
                       
                       unarchiveObjectWithFile:archivePath];
    
    NSLog(@"%@",cachedItems);
    //    //=================NSKeyedArchiver========================
    //    NSString *saveStr1 = @"我是";
    //    NSString *saveStr2 = @"数据";
    //    NSArray *array = [NSArray arrayWithObjects:saveStr1, saveStr2, nil];
    //    //----Save
    //    //这一句是将路径和文件名合成文件完整路径
    //    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *filename = [Path stringByAppendingPathComponent:@"saveDatatest"];
    //    [NSKeyedArchiver archiveRootObject:array toFile:filename];
    //    //用于测试是否已经保存了数据
    //    saveStr1 = @"hhhhhhiiii";
    //    saveStr2 =@"mmmmmmiiii";
    //    //----Load
    //    array = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    //    saveStr1 = [array objectAtIndex:0];
    //    saveStr2 = [array objectAtIndex:1];
    //   // CCLOG(@"str:%@",saveStr1);
    //    NSLog(@"str:%@",saveStr1);
    //   // CCLOG(@"astr:%@",saveStr2);
    
    if(cachedItems == nil)
        return  nil;
    //self.menuItems = [AppDelegate.engine localMenuItems];
    //       else
    //           self.menuItems = cachedItems;
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager]
                                       attributesOfItemAtPath:archivePath error:nil]
                                      fileModificationDate] timeIntervalSinceNow];
    
    if(stalenessLevel /3600 > 24)
        // self.menuItems = [AppDelegate.engine localMenuItems];
        return nil;
    
    return cachedItems;
    
}
@end
