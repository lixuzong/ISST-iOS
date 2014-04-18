//
//  ISSTWikisViewController.m
//  ISST
//
//  Created by zhukang on 14-4-2.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTWikisViewController.h"
#import "ISSTWikisCollectionViewCell.h"
#import "ISSTLifeApi.h"
#import "ISSTCampusNewsModel.h"
#import "ISSTWikisDetailViewController.h"
@interface ISSTWikisViewController ()
@property (nonatomic,strong)ISSTLifeApi  *newsApi;
@property (nonatomic,strong) ISSTCampusNewsModel  *WikisModel;
@property(nonatomic,strong)ISSTWikisDetailViewController *WikisDetailView;
@property (strong, nonatomic) NSMutableArray *newsArray;
@end

@implementation ISSTWikisViewController
{
@private
    RevealBlock _revealBlock;
}
@synthesize newsApi;
@synthesize WikisModel;
@synthesize newsArray;
@synthesize CollectionView;



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
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	//self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.newsApi = [[ISSTLifeApi alloc]init];
    
    
    self.view.backgroundColor = [UIColor clearColor];

    self.newsApi.webApiDelegate = self;
    self.newsArray =[[NSMutableArray alloc]init];
   [self.CollectionView registerClass:[ISSTWikisCollectionViewCell class] forCellWithReuseIdentifier:@"ISSTWikisCollectionCell"];
    
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
   [self.newsApi requestWikisLists:1 andPageSize:20 andKeywords:@"string"];
}
#pragma mark
#pragma ColectionView DataSource
//显示多少行
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [newsArray count]/2;
}
//显示多少列
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CollectionCellIdentifier=@"ISSTWikisCollectionCell";
    ISSTWikisCollectionViewCell *cell = (ISSTWikisCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ISSTWikisCollectionViewCell alloc]init];
    }
    long int position=indexPath.section*2+indexPath.row;
    WikisModel=[newsArray objectAtIndex:position];
    NSLog(@"%ld",position);
    cell.Title.text=WikisModel.title;
    cell.Content.text=WikisModel.description;
    NSLog(@"%@",WikisModel);
    return cell;
}
//选择单元格触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.WikisDetailView=[[ISSTWikisDetailViewController alloc]initWithNibName:@"ISSTWikisDetailViewController" bundle:nil];
     self.WikisDetailView.navigationItem.title =@"详细信息";
  //  ISSTCampusNewsModel *tempWikisModel=[[ISSTCampusNewsModel alloc]init];
   ISSTCampusNewsModel *   tempWikisModel=[newsArray objectAtIndex:(indexPath.section*2+indexPath.row)];//2为每行的个数

    self.WikisDetailView.WikisId=tempWikisModel.newsId;
    // [self.navigationController setNavigationBarHidden:YES];    //set system navigationbar hidden
    [self.navigationController pushViewController:self.WikisDetailView animated: YES];
}

#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if ([newsArray count]) {
        newsArray = [[NSMutableArray alloc]init];
    }
    newsArray = (NSMutableArray *)backToControllerData;
    NSLog(@"count =%d ,newsArray = %@",[newsArray count],[newsArray objectAtIndex:0]);
    [CollectionView reloadData];
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




//#pragma mark Private Methods
//- (void)pushViewController {
//    NSString *vcTitle = [self.title stringByAppendingString:@" - Pushed"];
//    UIViewController *vc = [[ISSTPushedViewController alloc] initWithTitle:vcTitle];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}

//- (void)revealSidebar {
//    _revealBlock();
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
