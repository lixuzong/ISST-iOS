//
//  ISSTSelectFactorsViewController.h
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTPushedViewController.h"
#import "AJComboBox.h"
#import "ISSTAddressBookDelegate.h"
#import "ISSTClassModel.h"
#import "ISSTMajorModel.h"
@interface ISSTSelectFactorsViewController : ISSTPushedViewController<UIAlertViewDelegate,AJComboBoxDelegate,ISSTAddressBookDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property(strong,nonatomic)NSMutableArray *gradeModelArray;
@property(strong,nonatomic)NSMutableArray *majorsModelArray;
@property(strong,nonatomic)ISSTClassModel* classModel;
@property(strong,nonatomic)ISSTMajorModel* majorModel;
@property(strong,nonatomic)NSArray *genderArray;
@property(strong,nonatomic)NSMutableArray *gradeArray;
@property(strong,nonatomic)NSMutableArray *majorsArray;
@property (nonatomic, assign)id<ISSTAddressBookDelegate> selectedDelegate;
- (IBAction)submit:(id)sender;
@property(nonatomic,assign) int  GENDERID;
@property(nonatomic,assign) int GRADEID;
@property(nonatomic,assign) int MAJORID;

@end
