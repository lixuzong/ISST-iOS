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
@interface ISSTSelectFactorsViewController : ISSTPushedViewController<UIAlertViewDelegate,AJComboBoxDelegate,ISSTAddressBookDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property(strong,nonatomic)NSMutableArray* classNameArray;
@property(strong,nonatomic)NSMutableArray* majorNameArray;
@property(strong,nonatomic)NSArray *genderArray;
@property(copy,nonatomic)NSString *className;
@property(copy,nonatomic)NSString *majorName;
@property(copy,nonatomic)NSString *genderName;
@property (nonatomic, assign)id<ISSTAddressBookDelegate> selectedDelegate;
- (IBAction)submit:(id)sender;
@property(nonatomic,assign) int  GENDERID;
@property(nonatomic,assign) int GRADEID;
@property(nonatomic,assign) int MAJORID;

@end
