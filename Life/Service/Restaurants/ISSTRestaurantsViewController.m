//
//  ISSTRestaurantsViewController.m
//  ISST
//
//  Created by zhukang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantsViewController.h"
#import "ISSTRestaurantsApi.h"
#import "ISSTRestaurantsModel.h"
#import "ISSTRestaurantsTableViewCell.h"
#import "ISSTRestaurantDetailViewController.h"
@interface ISSTRestaurantsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *restaurantsTableView;

@property (nonatomic,strong)ISSTRestaurantsApi  *restaurantsApi;

@property (nonatomic,strong) ISSTRestaurantsModel  *restaurantsModel;

//@property(nonatomic,strong)ISSTNewsDetailViewController *newsDetailView;

@property (strong, nonatomic) NSMutableArray *restaurantsArray;

@property (strong, nonatomic) ISSTRestaurantDetailViewController *restaurantsDetailView;
@end

@implementation ISSTRestaurantsViewController
@synthesize restaurantsApi;
@synthesize restaurantsModel;
@synthesize restaurantsTableView;
@synthesize restaurantsArray;
@synthesize restaurantsDetailView;
static NSString *CellTableIdentifier=@"ISSTRestaurantTableViewCell";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.restaurantsApi = [[ISSTRestaurantsApi alloc]init];
    self.restaurantsApi.webApiDelegate = self;
    [self.restaurantsApi requestResturantsLists:1 andPageSize:20 andKeywords:@"string"];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UITableView *tableView=(id)[self.view viewWithTag:6];
    tableView.rowHeight=120;
    UINib *nib=[UINib nibWithNibName:@"ISSTRestaurantsTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return restaurantsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    restaurantsModel =[[ISSTRestaurantsModel alloc]init];
    restaurantsModel = [restaurantsArray objectAtIndex:indexPath.row];
    
    ISSTRestaurantsTableViewCell *cell=(ISSTRestaurantsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = (ISSTRestaurantsTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    //    UIImage *restaurantsPicture;
    //    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:restaurantsModel.picture]];
    //    restaurantsPicture=[UIImage imageWithData:data];
    cell.restaurantName.text=restaurantsModel.name;
    cell.restaurantTel.text=restaurantsModel.hotline;
    // cell.picture.image=restaurantsPicture;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.restaurantsDetailView=[[ISSTRestaurantDetailViewController alloc]initWithNibName:@"ISSTRestaurantDetailViewController" bundle:nil];
    self.restaurantsDetailView.navigationItem.title =@"详细信息";
    ISSTRestaurantsModel *tempRestaurantsModel;   //=[[ISSTRestaurantsModel alloc]init];
    tempRestaurantsModel= [restaurantsArray objectAtIndex:indexPath.row];
    self.restaurantsDetailView.restaurantsId=tempRestaurantsModel.restaurantsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.restaurantsDetailView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([restaurantsArray count]) {
        restaurantsArray = [[NSMutableArray alloc]init];
    }
    restaurantsArray = (NSMutableArray *)backToControllerData;
    NSLog(@"count =%d",[restaurantsArray count]);
    [restaurantsTableView reloadData];
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


@end
