//
//  ISSTMyRecommendViewController.h
//  ISST
//
//  Created by lixu on 14/12/23.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSTMyRecommendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *comanyField;
@property (weak, nonatomic) IBOutlet UITextField *positionField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property  int typeId;
@property int cityId;
- (IBAction)selectCity:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (strong,nonatomic) NSString *titleString;
@property (strong,nonatomic) NSString *companyString;
@property (strong,nonatomic) NSString *positionString;
@property (strong,nonatomic) NSString *contentString;
- (IBAction)backgroundTap:(id)sender;

@end
