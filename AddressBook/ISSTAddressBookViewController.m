//
//  ISSTAddressBookViewController.m
//  ISST
//
//  Created by zhukang on 14-4-9.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTAddressBookViewController.h"
#import "ISSTSelectFactorsViewController.h"
#import "ISSTAddressBookDetailViewController.h"
#import "AppCache.h"
@interface ISSTAddressBookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *addressBookTableView;
@property(strong,nonatomic)NSMutableArray *addressBookArray;
@property(strong,nonatomic)ISSTSelectFactorsViewController *selectFactors;
@property(strong,nonatomic)NSDictionary *sortedNamesDictionary;
@property(strong,nonatomic) UISearchDisplayController *searchController;
@property(strong,nonatomic)NSMutableArray *namesArray;
@property(strong,nonatomic)NSMutableArray *searchArray;
@property (weak, nonatomic) IBOutlet UILabel *selectedFactorsLabel;
@property(strong,nonatomic)ISSTAddressBookDetailViewController* addressBookDetailView;

- (IBAction)clearSelectedFactors:(id)sender;
-(void)clickSelect;
@end

@implementation ISSTAddressBookViewController
@synthesize addressBookApi;
@synthesize addressBookModel;
@synthesize addressBookTableView;
@synthesize addressBookArray;
@synthesize selectFactors;
@synthesize sortedNamesDictionary;
@synthesize searchController;
@synthesize searchArray;
@synthesize namesArray;
@synthesize selectedFactorsLabel;
@synthesize addressBookDetailView;
@synthesize userInfo;

static NSString *CellIdentifier=@"ContactCell";

const static int        CONTACTSLISTS       = 1;
const static  int       CONTACTDETAIL       = 2;
const static int        CLASSESLISTS        = 3;
const static int        MAJORSLISTS         = 4;
int method;
int STATUS=0;


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
    addressBookModel=[[ISSTUserModel alloc]init];
    userInfo=[[ISSTUserModel alloc]init];
    
    userInfo=[AppCache getCache];
    
    self.selectFactors=[[ISSTSelectFactorsViewController alloc]init];
    
    self.selectFactors.navigationItem.title=@"筛选条件";
    
    method=CONTACTSLISTS;
    
    self.addressBookApi = [[ISSTContactsApi alloc]init];
    self.addressBookApi.webApiDelegate =self;
    
    addressBookModel.classId=userInfo.classId;
    addressBookModel.majorId=userInfo.majorId;
    
    [self requestForData];
    
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 50, 320, 44)];
    addressBookTableView.tableHeaderView=searchBar;
    searchController=[[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchController.delegate=self;
    searchController.searchResultsTableView.delegate=self;
    searchController.searchResultsDataSource=self;
    
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"条件筛选" style:UIBarButtonSystemItemEdit target:self action:@selector(clickSelect)];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    

    
}


-(void)labelShow
{
    NSMutableString *tempString=[[NSMutableString alloc]init];
    if(selectFactors.name.text.length!=0)
        [tempString appendString:[NSString stringWithFormat:@"姓名：%@",addressBookModel.name]];
    if(addressBookModel.gender)
    {
        switch (addressBookModel.gender) {
            case 1:
                [tempString appendString:[NSString stringWithFormat:@" 性别：男"]];
                break;
            case 2:
                [tempString appendString:[NSString stringWithFormat:@" 性别：女"]];
            default:
                break;
        }
        
    }
    if(addressBookModel.classId)
        [tempString appendString:[NSString stringWithFormat:@" 班级：%@",selectFactors.classModel.name]];
    if(addressBookModel.grade)
        [tempString appendString:[NSString stringWithFormat:@" 年级：%d",addressBookModel.grade]];
    if(addressBookModel.majorId)
        [tempString appendString:[NSString stringWithFormat:@" 专业：%@",selectFactors.majorModel.name]];
    selectedFactorsLabel.text=tempString;

    
}
-(void)requestForData
{
     [self.addressBookApi requestContactsLists:0 name:addressBookModel.name gender:addressBookModel.gender grade:0 classId:addressBookModel.classId majorId:addressBookModel.majorId cityId:0 company:nil];
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
    if(tableView==self.searchController.searchResultsTableView)
        return [searchArray count];
    else return [namesArray count];
    //   return studyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   if(tableView==self.searchController.searchResultsTableView)
       cell.textLabel.text=[searchArray objectAtIndex:indexPath.row];
   else
        cell.textLabel.text=[namesArray objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addressBookDetailView=[[ISSTAddressBookDetailViewController alloc]initWithNibName:@"ISSTAddressBookDetailViewController" bundle:nil];
    self.addressBookDetailView.navigationItem.title=@"联系人详情";
    addressBookModel=[addressBookArray objectAtIndex:indexPath.row];
    method= CONTACTDETAIL;
        [self.addressBookApi requestContactDetail:addressBookModel.userId];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            namesArray=[[NSMutableArray alloc]init];
            addressBookArray = (NSMutableArray *)backToControllerData;
            for(int i=0;i<addressBookArray.count;i++)
            {
                addressBookModel=[addressBookArray objectAtIndex:i];
                [namesArray addObject:addressBookModel.name];
            }
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
            if(STATUS==0)
            {
                for(int i=0;i<[selectFactors.gradeModelArray count];i++)
                {
                    selectFactors.classModel=[[ISSTClassModel alloc]init];
                    selectFactors.classModel=[selectFactors.gradeModelArray objectAtIndex:i];
                    if(selectFactors.classModel.classId==userInfo.classId)
                    break;
                }
            }
            method=MAJORSLISTS;
            [self.addressBookApi requestMajorsLists];
            break;
        case MAJORSLISTS:
            if ([selectFactors.majorsModelArray count]) {
                selectFactors.majorsModelArray = [[NSMutableArray alloc]init];
            }
            selectFactors.majorsModelArray = (NSMutableArray *)backToControllerData;
            NSLog(@"count =%d ,selectFactors.majorsModelArray = %@",[selectFactors.majorsModelArray count],selectFactors.majorsModelArray);
            if(STATUS==0)
            {
                for(int i=0;i<[selectFactors.majorsModelArray count];i++)
                {
                    selectFactors.majorModel=[[ISSTMajorModel alloc]init];
                    selectFactors.majorModel=[selectFactors.majorsModelArray objectAtIndex:i];
                    if(selectFactors.majorModel.majorId==userInfo.majorId)
                        break;
                }
                addressBookModel.classId=userInfo.classId;
                addressBookModel.majorId=userInfo.majorId;
                [self labelShow];
                STATUS=1;
            }
            method=CONTACTSLISTS;
            break;
        case CONTACTDETAIL:
            if(addressBookDetailView.userDetailInfo!=nil)
            {
                addressBookDetailView.userDetailInfo=[[ISSTUserModel alloc]init];
            }
            addressBookDetailView.userDetailInfo=(ISSTUserModel *)backToControllerData;
            for(int i=0;i<[selectFactors.gradeModelArray count];i++)
            {
                addressBookDetailView.classInfo=[[ISSTClassModel alloc]init];
                addressBookDetailView.classInfo=[selectFactors.gradeModelArray objectAtIndex:i];
                if(addressBookDetailView.classInfo.classId==addressBookDetailView.userDetailInfo.classId)
                    break;
            }
            for(int i=0;i<[selectFactors.majorsModelArray count];i++)
            {
                addressBookDetailView.majorInfo=[[ISSTMajorModel alloc]init];
                addressBookDetailView.majorInfo=[selectFactors.majorsModelArray objectAtIndex:i];
                if(addressBookDetailView.majorInfo.majorId==addressBookDetailView.userDetailInfo.majorId)
                    break;
            }

            method=CONTACTSLISTS;
            [self.navigationController pushViewController:self.addressBookDetailView animated: NO];
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
- (IBAction)clearSelectedFactors:(id)sender {
    
    addressBookModel.name=nil;
    addressBookModel.gender=0;
    addressBookModel.classId=0;
    addressBookModel.majorId=0;
    [self requestForData];
    [self labelShow];
    [addressBookTableView reloadData];

}

-(void)clickSelect
{
    self.selectFactors.selectedDelegate=self;
    [self.navigationController pushViewController:selectFactors animated:NO];
}
-(void)selectedReloadData
{
    NSLog(@"selectFactors.GENDERID=%d,selectFactors.classModel.classId=%d,selectFactors.majorModel.majorId=%d",selectFactors.GENDERID,selectFactors.classModel.classId,selectFactors.majorModel.majorId);
    addressBookModel.name=selectFactors.name.text;
    addressBookModel.gender=selectFactors.GENDERID;
    addressBookModel.classId=selectFactors.classModel.classId;
    addressBookModel.majorId=selectFactors.majorModel.majorId;
    [self requestForData];
    [self labelShow];
    [addressBookTableView reloadData];
    
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchArray = [namesArray filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark -
#pragma mark Search Display Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
