//
//  ISSTSameCityFriendViewController.m
//  ISST
//
//  Created by lixu on 14/12/8.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTSameCityFriendViewController.h"
#import "ISSTLoginApi.h"
#import "ISSTContactsParse.h"

@interface ISSTSameCityFriendViewController ()
@property (strong,nonatomic) ISSTUserModel *userModel;
@property (strong,nonatomic) ISSTLoginApi *userApi;

@property(strong,nonatomic)ISSTUserModel *addressBookModel;
@property(strong,nonatomic)ISSTUserModel *userInfo;
@property(strong,nonatomic)ISSTContactsApi *addressBookApi;
@property (copy, nonatomic) UITableView *addressBookTableView;
@property(strong,nonatomic)NSMutableArray *addressBookArray;
@property (strong,nonatomic) NSArray *filteredArray;
@property(strong,nonatomic)ISSTSelectFactorsViewController *selectFactorsViewController;
@property(strong,nonatomic)ISSTAddressBookDetailViewController* addressBookDetailView;
@property(strong,nonatomic)NSMutableArray *namesArray;
@property(strong,nonatomic)NSMutableArray *searchArray;

@property(strong,nonatomic) UISearchDisplayController *searchController;
@end

@implementation ISSTSameCityFriendViewController
@synthesize searchController;
@synthesize addressBookModel;
@synthesize addressBookArray;
@synthesize filteredArray;
@synthesize selectFactorsViewController;
@synthesize addressBookDetailView;
@synthesize userInfo;
@synthesize namesArray;
@synthesize searchArray;

static NSString *CellIdentifier=@"ContactCell";
const static int        CONTACTSLISTS       = 1;
const static  int       CONTACTDETAIL       = 2;
int method;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"同城校友";
    method=CONTACTSLISTS;

    self.addressBookApi = [[ISSTContactsApi alloc]init];
    self.addressBookApi.webApiDelegate =self;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"条件筛选" style:UIBarButtonSystemItemEdit target:self action:@selector(clickSelect)];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.view.backgroundColor = [UIColor lightGrayColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    addressBookModel=[[ISSTUserModel alloc]init];
    userInfo=[[ISSTUserModel alloc]init];
    userInfo=[AppCache getCache];
    addressBookModel.cityId = userInfo.cityId;
    addressBookModel.cityName = userInfo.cityName;
    addressBookModel.className=@"";
    
    [self.myActivityIndicator startAnimating];
    [self.view bringSubviewToFront:self.myActivityIndicator];
    [self friendRequestForData];
    //_friendTableView.bounces=CGRectMake(0, 40, 320, 464);
    _friendTableView.delegate=self;
    _friendTableView.dataSource=self;
//    [self.myActivityIndicator stopAnimating];
    _friendSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f, 320.0f, 44.0f)];
    _friendTableView.tableHeaderView=_friendSearchBar;
    searchController=[[UISearchDisplayController alloc]initWithSearchBar:_friendSearchBar contentsController:self];
    searchController.searchResultsDelegate=self;
    searchController.searchResultsDataSource=self;
}


-(void)friendLabelShow
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
    _conditionLabel.text=tempString;
    
}
-(void)friendRequestForData
{
    [self.myActivityIndicator startAnimating];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //第一：读取documents路径的方法：
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ; //得到documents的路径，为当前应用程序独享
    NSString *documentD = [paths objectAtIndex:0];
    NSString *configFile = [documentD stringByAppendingPathComponent:@"contacts.plist"]; //得到documents目录下dujw.plist配置文件的路径
    if (![fileManager fileExistsAtPath:configFile]) {
         [self.addressBookApi requestSameCityContactsLists:0 name:addressBookModel.name gender:addressBookModel.gender grade:0 classId:addressBookModel.classId className:addressBookModel.className majorId:addressBookModel.majorId majorName:addressBookModel.majorName cityId:0 cityName:addressBookModel.cityName company:nil];
    }else{
        NSData *datas=[NSData dataWithContentsOfFile:configFile];
        ISSTContactsParse *contactsParse=[[ISSTContactsParse alloc]init];
        NSDictionary *dics   = [contactsParse infoSerialization:datas];
        if (dics&&[dics count]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            namesArray=[[NSMutableArray alloc] init];
            NSMutableArray *addressBookArrayTmp=[[NSMutableArray alloc] init];
            addressBookArrayTmp = (NSMutableArray *)[contactsParse contactsInfoParse];//将数据传给临时数组，对临时数组进行排序
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
            dispatch_async(dispatch_get_main_queue(), ^{
            for (NSMutableArray *singleSectionArray in sectionsArray){
                NSArray *sortedSection=[indexedCollation sortedArrayFromArray:singleSectionArray collationStringSelector:@selector(name)];
//                dispatch_async(dispatch_get_main_queue(), ^{
                [addressBookArray addObject:sortedSection];
            
            }
                [_friendTableView reloadData];
                });
                        
            });
                
        }
    }
     [self.myActivityIndicator stopAnimating];
}


#pragma mark
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_friendTableView) {
        return [addressBookArray count];
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_friendTableView)
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
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name beginswith[c] %@",_friendSearchBar.text];//构造谓词语句进行筛选
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
    if(tableView==_friendTableView ){
        ISSTUserModel *addressBook=[[addressBookArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        cell.textLabel.text=  addressBook.name;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
    
        ISSTUserModel *addressBook=[filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text=addressBook.name;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
   
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([[addressBookArray objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

//返回索引
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==_friendTableView) {
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
    if (tableView==_friendTableView){
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
            [self.navigationController pushViewController:self.addressBookDetailView animated: YES];
            break;
        default:
            break;
    }
    
    [_friendTableView reloadData];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

-(void) updateUserLogin{
    self.userApi=[[ISSTLoginApi alloc] init];
    _userModel=[[ISSTUserModel alloc] init ];
    _userModel=[AppCache getCache];
    if (_userModel) {
        [self.userApi updateLoginUserId:[NSString stringWithFormat:@"%d",_userModel.userId] andPassword:_userModel.password];
        [self viewDidLoad];
        
        
    }
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
    [self friendRequestForData];
     _conditionLabel.text=@"";
    [_friendTableView reloadData];
    
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
    addressBookModel.cityId = userInfo.cityId;
    addressBookModel.name=selectFactorsViewController.name.text;
    addressBookModel.gender=selectFactorsViewController.GENDERID;
    addressBookModel.className=selectFactorsViewController.className;
    addressBookModel.majorName=selectFactorsViewController.majorName;
    [self friendRequestForData];
    [self friendLabelShow];
    [_friendTableView reloadData];
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
