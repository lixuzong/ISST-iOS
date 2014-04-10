//
//  ISSTRestaurantDetailViewController.m
//  ISST
//
//  Created by zhukang on 14-4-6.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRestaurantDetailViewController.h"
#import "ISSTRestaurantsApi.h"
#import "ISSTRestaurantsModel.h"
#import "ISSTRestaurantsMenusModel.h"

@interface ISSTRestaurantDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *businessHours;
@property (weak, nonatomic) IBOutlet UILabel *hotline;
- (IBAction)clickTel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *menusTableView;
@property (nonatomic,strong)ISSTRestaurantsApi  *restaurantsApi;
@property(nonatomic,strong)ISSTRestaurantsApi *restaurantsMenusApi;
@property (nonatomic,strong) ISSTRestaurantsModel  *restaurantsModel;
@property (nonatomic,strong) ISSTRestaurantsMenusModel  *restaurantsMenusModel;

//@property(nonatomic,strong)ISSTNewsDetailViewController *newsDetailView;

@property (strong, nonatomic) NSMutableArray *restaurantsArray;
@property(strong,nonatomic)NSMutableArray *restaurantsMenusArray;
@end

@implementation ISSTRestaurantDetailViewController
@synthesize picture;
@synthesize name;
@synthesize address;
@synthesize businessHours;
@synthesize hotline;
@synthesize menusTableView;
@synthesize restaurantsModel;
@synthesize restaurantsApi;
@synthesize restaurantsArray;
@synthesize restaurantsMenusArray;
@synthesize restaurantsMenusModel;
@synthesize restaurantsId;
static NSString *CellIdentifier=@"menusCell";
const static int RESTAURANTS =1;
const    static  int   DETAILS   = 2;
const    static  int   MENUS   = 3;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.restaurantsApi = [[ISSTRestaurantsApi alloc]init];
    self.restaurantsApi.webApiDelegate = self;
    [self.restaurantsApi requestDetailInfoWithId:restaurantsId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    

    
//    UITableView *tableView=(id)[self.view viewWithTag:7];
//    tableView.rowHeight=120;
//    UINib *nib=[UINib nibWithNibName:@"ISSTRestaurantsTableViewCell" bundle:nil];
//    [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    
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
    return restaurantsMenusArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    restaurantsMenusModel =[[ISSTRestaurantsMenusModel alloc]init];
    restaurantsMenusModel = [restaurantsMenusArray objectAtIndex:indexPath.row];
    UITableViewCell *cell=(UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UIImage *menusPicture;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:restaurantsMenusModel.picture]];
    menusPicture=[UIImage imageWithData:data];
    NSString *price=[NSString stringWithFormat:@"%f",restaurantsMenusModel.price];
    cell.imageView.image=menusPicture;
    cell.textLabel.text=restaurantsMenusModel.name;
    cell.detailTextLabel.text=price;
    return cell;
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    switch(restaurantsApi.methodId){
        case DETAILS:
        {
            if (restaurantsModel==nil) {
                restaurantsModel=[[ISSTRestaurantsModel alloc]init];
            }
           restaurantsModel= (ISSTRestaurantsModel *)backToControllerData;
            NSLog(@"restaurantsModel =%@",restaurantsModel);
            UIImage *restaurantsPicture;
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:restaurantsModel.picture]];
            restaurantsPicture=[UIImage imageWithData:data];
            picture.image=restaurantsPicture;
            name.text=restaurantsModel.name;
            hotline.text=restaurantsModel.hotline;
            address.text=restaurantsModel.address;
            businessHours.text=restaurantsModel.businessHours;
            [self.restaurantsApi requestMenusListsWithId:restaurantsId];
        }
            
            break;
            
        case MENUS:
        {
            if ([restaurantsMenusArray count]) {
                restaurantsMenusArray= [[NSMutableArray alloc]init];
            }
            restaurantsMenusArray = (NSMutableArray *)backToControllerData;
            NSLog(@"[restaurantsMenusArray count]=%d",[restaurantsMenusArray count]);
            [menusTableView reloadData];
        }
            
            break;
    }
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickTel:(id)sender {
    NSString *telNumber=[NSString stringWithFormat:@"tel://%@",hotline.text];
    NSLog(@"telNumber=%@",telNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}
@end
