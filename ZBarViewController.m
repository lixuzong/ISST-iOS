//
//  ZBarViewController.m
//  ISST
//
//  Created by lixu on 15/1/12.
//  Copyright (c) 2015年 MSE.ZJU. All rights reserved.
//

#import "ZBarViewController.h"
#import "ZBarSDK.h"

@interface ZBarViewController ()<ZBarReaderDelegate>
@property (strong, nonatomic) IBOutlet ZBarReaderView *readerView;
@end

@implementation ZBarViewController
@synthesize readerView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [ZBarReaderView class];
    readerView.readerDelegate = self;
    if(TARGET_IPHONE_SIMULATOR){
        ZBarCameraSimulator *cameraSim = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSim.readerView = readerView;
    }
}
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{
    for(ZBarSymbol *sym in symbols) {
        NSLog(@"%@",sym.data);
        break;
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [readerView start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
