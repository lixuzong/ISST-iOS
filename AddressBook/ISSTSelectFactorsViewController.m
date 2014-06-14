//
//  ISSTSelectFactorsViewController.m
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSelectFactorsViewController.h"
#import "AppCache.h"
@interface ISSTSelectFactorsViewController ()
@property(nonatomic,retain)AJComboBox *genderBox;
@property(nonatomic,retain)AJComboBox *classBox;
@property(nonatomic,retain)AJComboBox *majorBox;
- (IBAction)backgroundTap:(id)sender;
@end

@implementation ISSTSelectFactorsViewController
@synthesize name,classBox,genderBox,classNameArray,majorBox,majorNameArray,genderArray,className,majorName,genderName;

@synthesize selectedDelegate;

@synthesize GRADEID;
@synthesize GENDERID;
@synthesize MAJORID;

int static METHOD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    GRADEID = GENDERID = MAJORID =-1;
    classNameArray = [AppCache getClassListsCache];
    majorNameArray = [AppCache getMajorListsCache];
    genderArray=@[@"男",@"女"];
    
    genderBox=[[AJComboBox alloc]initWithFrame:CGRectMake(76 , 146, 224, 21)];
    classBox=[[AJComboBox alloc]initWithFrame:CGRectMake(76, 216, 224, 21)];
    majorBox=[[AJComboBox alloc]initWithFrame:CGRectMake(110, 291, 190, 21)];
 
    [genderBox setLabelText:@"-SELECT-"];
    [classBox setLabelText:@"-SELECT-"];
    [majorBox setLabelText:@"-SELECT-"];
    
    [genderBox setDelegate:self];
    [classBox setDelegate:self];
    [majorBox setDelegate:self];
    
    [genderBox setTag:1];
    [classBox  setTag:2];
    [majorBox  setTag:3];
    
    [genderBox setArrayData:genderArray];
    [classBox setArrayData:classNameArray];
    [majorBox setArrayData:majorNameArray];
    
    [self.view addSubview:genderBox];
    [self.view addSubview:classBox];
    [self.view addSubview:majorBox];

}
-(void)viewDidDisappear:(BOOL)animated
{
        GRADEID=GENDERID=MAJORID=-1;
    name.text=nil;
    [genderBox setLabelText:@"-SELECT-"];
    [classBox setLabelText:@"-SELECT-"];
    [majorBox setLabelText:@"-SELECT-"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark AJComboBoxDelegate

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    switch (comboBox.tag) {
        case 1:
        {
            METHOD=1;
            GENDERID=selectedIndex;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"性别: %@", [genderArray  objectAtIndex:selectedIndex]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
        }
            break;
        case 2:
        {
            METHOD=2;
            GRADEID=selectedIndex;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"年级: %@", [gradeArray  objectAtIndex:selectedIndex]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
        }
            break;
        case 3:
        {
            METHOD=3;
            MAJORID=selectedIndex;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"专业方向: %@", [majorsArray  objectAtIndex:selectedIndex]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
        }
            break;
        default:
            METHOD=0;
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
     switch (METHOD) {
         case 1:
             NSLog(@"%d",GENDERID);
             break;
         case 2:
             NSLog(@"%d",GRADEID);
             break;
         case 3:
             NSLog(@"%d",MAJORID);
             break;
             
         default:
             break;
     }
 }

- (IBAction)submit:(id)sender {
    
    GENDERID++;
    if(GRADEID>=0)
        className = [classNameArray objectAtIndex:GRADEID];
    if (MAJORID>=0)
        majorName = [majorNameArray objectAtIndex:MAJORID];
    [selectedDelegate selectedReloadData];
    name.text=nil;
    GRADEID=GENDERID=MAJORID=-1;
    
    [genderBox setLabelText:@"-SELECT-"];
    [classBox setLabelText:@"-SELECT-"];
    [majorBox setLabelText:@"-SELECT-"];
    
    [self.navigationController popViewControllerAnimated:self];
    
}
- (IBAction)backgroundTap:(id)sender {
    [self.name resignFirstResponder];
}
@end
