//
//  ISSTSelectFactorsViewController.m
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSelectFactorsViewController.h"
#import "ISSTClassModel.h"
#import "ISSTMajorModel.h"
@interface ISSTSelectFactorsViewController ()
@property(nonatomic,retain)AJComboBox *gender;
@property(nonatomic,retain)AJComboBox *grade;
@property(nonatomic,retain)AJComboBox *major;
@property(strong,nonatomic)ISSTClassModel* classModel;
@property(strong,nonatomic)ISSTMajorModel* majorModel;
@property(strong,nonatomic)NSArray *genderArray;
@property(strong,nonatomic)NSMutableArray *gradeArray;
@property(strong,nonatomic)NSMutableArray *majorsArray;
- (IBAction)backgroundTap:(id)sender;
@end

@implementation ISSTSelectFactorsViewController
@synthesize name,gender,grade,major,majorsModelArray,gradeModelArray,classModel,majorModel,gradeArray,majorsArray,genderArray;

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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Selected Value: %@", [genderArray  objectAtIndex:selectedIndex]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Selected Value: %@", [gradeArray  objectAtIndex:selectedIndex]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case 3:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Selected Value: %@", [majorsArray  objectAtIndex:selectedIndex]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

- (IBAction)submit:(id)sender {
}
- (IBAction)backgroundTap:(id)sender {
    [self.name resignFirstResponder];
}
@end
