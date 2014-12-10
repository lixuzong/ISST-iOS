//
//  ISSTServiceViewController.m
//  ISST
//
//  Created by zhukang on 14-4-5.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTServiceViewController.h"
#import "ISSTRestaurantsViewController.h"
#import "RESideMenu.h"

@interface ISSTServiceViewController ()
@property IBOutlet UITableView *serviceTableView;
@property ISSTRestaurantsViewController *restaurantsView;
@end

@implementation ISSTServiceViewController
@synthesize serviceTableView;
@synthesize restaurantsView;
static NSString *CellWithIdentifier=@"Cell";
NSArray *serviceArray;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"user.png"];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    self.title = @"便捷服务";
    
    [super viewDidLoad];
    
    serviceArray=@[@"美食外卖"];
    // Do any additional setup after loading the view from its nib.
    //UITableView *tableView=(id)[self.view viewWithTag:4];
//    UINib *nib=[UINib nibWithNibName:@"Cell" bundle:nil];
//    [serviceTableView registerNib:nib forCellReuseIdentifier:CellWithIdentifier];
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
    return [serviceArray count];
 //   return studyArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }

    cell.textLabel.text=[serviceArray objectAtIndex:indexPath.section+indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.restaurantsView=[[ISSTRestaurantsViewController alloc]initWithNibName:@"ISSTRestaurantsViewController" bundle:nil];
    self.restaurantsView.navigationItem.title=@"美食外卖";
    [self.navigationController pushViewController:self.restaurantsView animated: NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
