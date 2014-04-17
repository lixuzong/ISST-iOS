//
//  ISSTSelectFactorsViewController.m
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSelectFactorsViewController.h"
@interface ISSTSelectFactorsViewController ()
@property(nonatomic,retain)AJComboBox *gender;
@property(nonatomic,retain)AJComboBox *grade;
@property(nonatomic,retain)AJComboBox *major;
- (IBAction)backgroundTap:(id)sender;
@end

@implementation ISSTSelectFactorsViewController
@synthesize name,gender,grade,major,majorsModelArray,gradeModelArray,classModel,majorModel,gradeArray,majorsArray,genderArray;

@synthesize selectedDelegate;

@synthesize GRADEID;
@synthesize GENDERID;
@synthesize MAJORID;

int static METHOD;

int static gradeid;
int static majorid;
int static genderid;

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
    gradeArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[gradeModelArray count];i++)
    {
        classModel=[[ISSTClassModel alloc]init];
        classModel=[gradeModelArray objectAtIndex:i];
        [gradeArray addObject:classModel.name];
    }
    majorsArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[majorsModelArray count];i++)
    {
        majorModel=[[ISSTMajorModel alloc]init];
        majorModel=[majorsModelArray objectAtIndex:i];
        [majorsArray addObject:majorModel.name];
    }
    genderArray=@[@"男",@"女"];
    
    gender=[[AJComboBox alloc]initWithFrame:CGRectMake(76 , 146, 224, 21)];
    grade=[[AJComboBox alloc]initWithFrame:CGRectMake(76, 216, 224, 21)];
    major=[[AJComboBox alloc]initWithFrame:CGRectMake(110, 291, 190, 21)];
 
    [gender setLabelText:@"-SELECT-"];
    [grade setLabelText:@"-SELECT-"];
    [major setLabelText:@"-SELECT-"];
    
    [gender setDelegate:self];
    [grade setDelegate:self];
    [major setDelegate:self];
    
    [gender setTag:1];
    [grade  setTag:2];
    [major  setTag:3];
    
    [gender setArrayData:genderArray];
    [grade setArrayData:gradeArray];
    [major setArrayData:majorsArray];
    
    [self.view addSubview:gender];
    [self.view addSubview:grade ];
    [self.view addSubview:major];

}
-(void)viewDidDisappear:(BOOL)animated
{
        GRADEID=GENDERID=MAJORID=-1;
    name.text=nil;
    [gender setLabelText:@"-SELECT-"];
    [grade setLabelText:@"-SELECT-"];
    [major setLabelText:@"-SELECT-"];
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
        classModel=[gradeModelArray objectAtIndex:GRADEID];
    else
        classModel.classId=GRADEID+1;
    
    if (MAJORID>=0)
        majorModel=[majorsModelArray objectAtIndex:MAJORID];
    else
        majorModel.majorId=MAJORID+1;
    
    [selectedDelegate selectedReloadData];
    name.text=nil;
    GRADEID=GENDERID=MAJORID=-1;
    
    [gender setLabelText:@"-SELECT-"];
    [grade setLabelText:@"-SELECT-"];
    [major setLabelText:@"-SELECT-"];
    
    [self.navigationController popViewControllerAnimated:self];
    
}
- (IBAction)backgroundTap:(id)sender {
    [self.name resignFirstResponder];
}
@end
