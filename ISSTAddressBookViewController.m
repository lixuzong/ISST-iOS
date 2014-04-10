//
//  ISSTAddressBookViewController.m
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTAddressBookViewController.h"
#import "ISSTUserModel.h"
#import "ISSTContactsApi.h"
#import "ISSTSelectFactorsViewController.h"
@interface ISSTAddressBookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *addressBookTableView;
@property(strong,nonatomic)ISSTUserModel *addressBookModel;
@property(strong,nonatomic)ISSTContactsApi *addressBookApi;
@property(strong,nonatomic)NSMutableArray *addressBookArray;
@property(strong,nonatomic)ISSTSelectFactorsViewController *selectFactors;
-(void)clickSelect;
@end

@implementation ISSTAddressBookViewController
@synthesize addressBookApi;
@synthesize addressBookModel;
@synthesize addressBookTableView;
@synthesize addressBookArray;
@synthesize selectFactors;
static NSString *CellIdentifier=@"ContactCell";
const static int        CONTACTSLISTS       = 1;
const static  int       CONTACTDETAIL       = 2;
const static int        CLASSESLISTS        = 3;
const static int        MAJORSLISTS         = 4;
int method;

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
    self.selectFactors=[[ISSTSelectFactorsViewController alloc]initWithNibName:@"ISSTSelectFactorsViewController" bundle:nil];
    self.selectFactors.navigationItem.title=@"筛选条件";
    method=CONTACTSLISTS;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(clickSelect)];
    self.addressBookApi = [[ISSTContactsApi alloc]init];
    self.addressBookApi.webApiDelegate =self;
    [self.addressBookApi requestContactsLists:-1 name:nil gender:1 grade:2013 classId:15 majorId:10 cityId:-1 company:nil];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

}

#pragma mark
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [addressBookArray count];
    //   return studyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    addressBookModel=[addressBookArray objectAtIndex:indexPath.row];
    cell.textLabel.text=addressBookModel.name;
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.restaurantsView=[[ISSTRestaurantsViewController alloc]initWithNibName:@"ISSTRestaurantsViewController" bundle:nil];
//    self.restaurantsView.navigationItem.title=@"美食外卖";
//    [self.navigationController pushViewController:self.restaurantsView animated: NO];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    switch (method) {
            
        case CONTACTSLISTS:
            if ([addressBookArray count]) {
                addressBookArray = [[NSMutableArray alloc]init];
            }
            addressBookArray = (NSMutableArray *)backToControllerData;
            NSLog(@"count =%d ,addressBookArray = %@",[addressBookArray count],addressBookArray);
            method=CLASSESLISTS;
            [self.addressBookApi requestClassesLists];
            break;
        case CLASSESLISTS:
            if ([selectFactors.gradeModelArray count]) {
                selectFactors.gradeModelArray = [[NSMutableArray alloc]init];
            }
            selectFactors.gradeModelArray = (NSMutableArray *)backToControllerData;
            NSLog(@"count =%d ,selectFactors.gradeModelArray = %@",[selectFactors.gradeModelArray count],selectFactors.gradeModelArray);
            method=MAJORSLISTS;
            [self.addressBookApi requestMajorsLists];
            break;
        case MAJORSLISTS:
            if ([selectFactors.majorsModelArray count]) {
                selectFactors.majorsModelArray = [[NSMutableArray alloc]init];
            }
            selectFactors.majorsModelArray = (NSMutableArray *)backToControllerData;
            NSLog(@"count =%d ,selectFactors.majorsModelArray = %@",[selectFactors.majorsModelArray count],selectFactors.majorsModelArray);
            method=CONTACTSLISTS;
            break;
        default:
            break;
    }
    [addressBookTableView reloadData];
    
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)clickSelect
{
    [self.navigationController pushViewController:selectFactors animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
