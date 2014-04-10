//
//  ISSTSelectFactorsViewController.h
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "AJComboBox.h"
@interface ISSTSelectFactorsViewController : ISSTPushedViewController<AJComboBoxDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;

@property(strong,nonatomic)NSMutableArray *gradeModelArray;
@property(strong,nonatomic)NSMutableArray *majorsModelArray;
- (IBAction)submit:(id)sender;

@end
