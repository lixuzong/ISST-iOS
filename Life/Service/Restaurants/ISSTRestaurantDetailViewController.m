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
#import "UIImageView+WebCache.h"
#import "ISSTFoodCell.h"

@interface ISSTRestaurantDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *picture;
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
static NSString *CellIdentifier=@"ISSTFoodCell";
//const static int RESTAURANTS =1;
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
    self.name.text=@"";
    self.address.text=@"";
    self.businessHours.text=@"";
    self.hotline.text=@"";
    
    // Do any additional setup after loading the view from its nib.
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    

    
    UITableView *tableView=(id)[self.view viewWithTag:7];
    UINib *nib=[UINib nibWithNibName:CellIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    
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
     ISSTFoodCell *cell=[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ISSTFoodCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSString *price=[NSString stringWithFormat:@"%.1f",restaurantsMenusModel.price]; //保留1位小数
    
    if([restaurantsMenusModel.picture isEqual:[NSNull null] ]){//如果图片为空
        cell.image.image =[UIImage imageNamed:@"meishi2.jpg"];
    }else{
        NSURL *url2=[NSURL URLWithString:restaurantsMenusModel.picture];
        [cell.image sd_setImageWithURL:url2];
    }
    cell.nameLabel.text=restaurantsMenusModel.name;
    cell.priceLabel.text=price;
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
            
            if([restaurantsModel.picture isEqual:[NSNull null]]){//如果图片为空
                picture.image =[UIImage imageNamed:@"tongyongmeishi.jpg"];
            }
            else{
                NSURL *url=[NSURL URLWithString:restaurantsModel.picture];
                [picture sd_setImageWithURL:url];
            }
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
