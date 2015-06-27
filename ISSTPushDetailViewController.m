//
//  ISSTPushDetailViewController.m
//  ISST
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushDetailViewController.h"

@interface ISSTPushDetailViewController ()

@end

@implementation ISSTPushDetailViewController
@synthesize content;
@synthesize tit;
@synthesize updateAt;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showWebview];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showWebview
{
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<meta id='viewport' name='viewport' content='initial-scale=1.0; maximum-scale=1.0;'>\n"
                          //                          "<style type=\"text/css\"> \n"
                          
                          "<style type=\"text/css\"> \n"
                          "img{max-width:100%%; width:auto; height:auto;} "
                         
                          "</style> \n"
                          "<h3 align='center'style='color:#262626,margin:2px'; >%@</h3>"
//                          "<title> %@"
//                          "</title>\n"
                          "</head> \n"
                          "<body >\n"
                          
                          "<h5 align='center'>"
                          "<font color='#9C9C9C'; size='1';>&nbsp%@</font>"
                          "</h5>"
                          "<hr align='center'; style=' height:1px;border:none;border-top:1px  solid #EBEBEB ;' />"
                          "</hr>"
                          
                          "%@</body> \n"
                          
                          
                          "</html>",tit,updateAt,content];
    
    [_webview loadHTMLString:jsString baseURL:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
