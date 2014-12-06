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
#import "RESideMenu.h"
@interface ISSTAddressBookViewController ()

@property(strong,nonatomic)NSMutableArray *namesArray;
@property(strong,nonatomic)NSMutableArray *searchArray;
@property(strong,nonatomic)NSMutableArray *addressBookArray;
@property(strong,nonatomic)NSDictionary *sortedNamesDictionary;

@property (copy, nonatomic) UITableView *addressBookTableView;
@property (weak, nonatomic) IBOutlet UILabel *selectedFactorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *factorTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property(strong,nonatomic)ISSTSelectFactorsViewController *selectFactorsViewController;

@property(strong,nonatomic) UISearchDisplayController *searchController;
@property(strong,nonatomic)ISSTAddressBookDetailViewController* addressBookDetailView;

@property (strong,nonatomic) NSArray *filteredArray;
- (IBAction)clearSelectedFactors:(id)sender;
-(void)clickSelect;

@end

@implementation ISSTAddressBookViewController
@synthesize addressBookApi;
@synthesize addressBookModel;
@synthesize addressBookTableView;
@synthesize addressBookArray;
@synthesize selectFactorsViewController;
@synthesize sortedNamesDictionary;
@synthesize searchController;
@synthesize searchArray;
@synthesize namesArray;
@synthesize selectedFactorsLabel;
@synthesize addressBookDetailView;
@synthesize userInfo;
@synthesize sameCitySwitch;

@synthesize searchBar;
@synthesize filteredArray;
static NSString *CellIdentifier=@"ContactCell";

const static int        CONTACTSLISTS       = 1;
const static  int       CONTACTDETAIL       = 2;
const static int        CLASSESLISTS        = 3;
const static int        MAJORSLISTS         = 4;
int method;
int STATUS=0;
sameCitySwitch = false;


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
    
    self.title = @"通讯录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"user.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];

    [super viewDidLoad];
    
    
    addressBookModel=[[ISSTUserModel alloc]init];
    userInfo=[[ISSTUserModel alloc]init];
    
    userInfo=[AppCache getCache];
    
    method=CONTACTSLISTS;
    
    addressBookTableView = (UITableView *)([self.view viewWithTag:10]);
    addressBookTableView.delegate = self;
    addressBookTableView.dataSource = self;
    
    self.addressBookApi = [[ISSTContactsApi alloc]init];
    self.addressBookApi.webApiDelegate =self;
    
    if(!sameCitySwitch)
    {
        addressBookModel.className=userInfo.className;
    }
    else
    {
        addressBookModel.cityId = userInfo.cityId;
        addressBookModel.cityName = userInfo.cityName;
    }
    [self requestForData];
    if (!sameCitySwitch) {
        [self labelShow];
    }
    
    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f, 320.0f, 44.0f)];
    addressBookTableView.tableHeaderView=searchBar;
    searchController=[[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
//    searchController.delegate=self;
    searchController.searchResultsDelegate=self;
    searchController.searchResultsDataSource=self;
    
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"条件筛选" style:UIBarButtonSystemItemEdit target:self action:@selector(clickSelect)];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view.backgroundColor = [UIColor lightGrayColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
}

////////////////////////////////////////////////////////////////////
//                   show the select factor  in list page
////////////////////////////////////////////////////////////////////
-(void)labelShow
{
    NSMutableString *tempString=[[NSMutableString alloc]init];
    if(selectFactorsViewController.name.text.length!= 0)
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
    if(addressBookModel.className)
        [tempString appendString:[NSString stringWithFormat:@" 班级：%@",addressBookModel.className]];
    if(addressBookModel.grade)
        [tempString appendString:[NSString stringWithFormat:@" 年级：%@",addressBookModel.className]];
    if(addressBookModel.majorName)
        [tempString appendString:[NSString stringWithFormat:@" 专业：%@",addressBookModel.majorName]];
    selectedFactorsLabel.text=tempString;
    
}
-(void)requestForData
{
    [self.addressBookApi requestContactsLists:0 name:addressBookModel.name gender:addressBookModel.gender grade:0 classId:addressBookModel.classId className:addressBookModel.className majorId:addressBookModel.majorId majorName:addressBookModel.majorName cityId:0 cityName:addressBookModel.cityName company:nil];
}


#pragma mark
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==addressBookTableView) {
        return [addressBookArray count];
    }else{
    return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==addressBookTableView)
    {
        return [[addressBookArray objectAtIndex:section] count];
    }
    else{
        
    NSMutableArray *flattenedArray=[[NSMutableArray alloc] initWithCapacity:1];
    for(NSMutableArray *theArray in addressBookArray){
        for (int i=0; i<[theArray count]; ++i) {
            [flattenedArray addObject:[theArray objectAtIndex:i]];
        }
    }
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name beginswith[c] %@",searchBar.text];//构造谓词语句进行筛选
        filteredArray=[flattenedArray filteredArrayUsingPredicate:predicate];
        return filteredArray.count;
    }
    //   return studyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if(tableView==addressBookTableView ){
                ISSTUserModel *addressBook=[[addressBookArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        cell.textLabel.text=  addressBook.name;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }else{
    
    ISSTUserModel *addressBook=[filteredArray objectAtIndex:indexPath.row];
    cell.textLabel.text=addressBook.name;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
    }
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([[addressBookArray objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

//返回索引
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==addressBookTableView) {
        return  [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }else {
        return nil;
    }
}


-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index  {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addressBookDetailView=[[ISSTAddressBookDetailViewController alloc]initWithNibName:@"ISSTAddressBookDetailViewController" bundle:nil];
    self.addressBookDetailView.navigationItem.title=@"联系人详情";
    if (tableView==addressBookTableView){
        addressBookModel=[[addressBookArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        addressBookModel=[filteredArray objectAtIndex:indexPath.row];
    }
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
        {
            if ([addressBookArray count])
            {
                addressBookArray = [[NSMutableArray alloc]init];
            }
            
            namesArray=[[NSMutableArray alloc] init];
            NSMutableArray *addressBookArrayTmp=[[NSMutableArray alloc] init];
            addressBookArrayTmp = (NSMutableArray *)backToControllerData;//将数据传给临时数组，对临时数组进行排序
            //*************增加排序和索引**************8*
            addressBookArray=[NSMutableArray arrayWithCapacity:1];
            UILocalizedIndexedCollation *indexedCollation=[UILocalizedIndexedCollation currentCollation];
            for (ISSTUserModel *theAdressBookModel in addressBookArrayTmp) {
                NSInteger section=[indexedCollation sectionForObject:theAdressBookModel collationStringSelector:@selector(name)];
                theAdressBookModel.section=section;
            }
            NSInteger sectionCount=[[indexedCollation sectionTitles] count];
            NSMutableArray *sectionsArray=[NSMutableArray arrayWithCapacity:sectionCount];
            for (int i=0; i<=sectionCount; ++i) {
                NSMutableArray *singleSectionArray=[NSMutableArray arrayWithCapacity:1];
                [sectionsArray addObject:singleSectionArray];
            }
            for(ISSTUserModel *theAdressBookModel in addressBookArrayTmp){
                [(NSMutableArray *) [sectionsArray objectAtIndex:theAdressBookModel.section] addObject:theAdressBookModel];
            }
            
            for (NSMutableArray *singleSectionArray in sectionsArray){
                NSArray *sortedSection=[indexedCollation sortedArrayFromArray:singleSectionArray collationStringSelector:@selector(name)];
                [addressBookArray addObject:sortedSection];
            }
            
            //*********增加排序和索引**********
            
            //            for(int i=0;i<addressBookArray.count;i++)
            //            {
            //                addressBookModel=[addressBookArrayTmp objectAtIndex:i];
            //                [namesArray addObject:addressBookModel.name];
            //            }
        }
            break;
        case CONTACTDETAIL:
            if(addressBookDetailView.userDetailInfo!= nil)
            {
                addressBookDetailView.userDetailInfo=[[ISSTUserModel alloc] init];
            }
            addressBookDetailView.userDetailInfo=(ISSTUserModel *)backToControllerData;
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
    addressBookModel.className = nil;
    addressBookModel.majorName = nil;
    addressBookModel.cityName = nil;
    addressBookModel.cityId = 0;
    addressBookModel.cityName = nil;
    addressBookModel.cityId = 0;
    [self requestForData];
    [self labelShow];
    [addressBookTableView reloadData];
    
}

-(void)clickSelect
{
    self.selectFactorsViewController=[[ISSTSelectFactorsViewController alloc]init];
    self.selectFactorsViewController.navigationItem.title=@"筛选条件";
    self.selectFactorsViewController.selectedDelegate=self;
    [self.navigationController pushViewController:self.selectFactorsViewController animated:NO];
}
-(void)selectedReloadData
{
    if (sameCitySwitch)
        addressBookModel.cityId = userInfo.cityId;
    addressBookModel.name=selectFactorsViewController.name.text;
    addressBookModel.gender=selectFactorsViewController.GENDERID;
    addressBookModel.className=selectFactorsViewController.className;
    addressBookModel.majorName=selectFactorsViewController.majorName;
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
