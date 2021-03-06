//
//  ISSTRecommendDetailViewController.m
//  ISST
//
//  Created by XSZHAO on 14-4-19.
//  Copyright (c) 2014年 MSE.ZJU. All rights reserved.
//

#import "ISSTRecommendDetailViewController.h"
#import "ISSTJobsApi.h"
#import "ISSTJobsDetailModel.h"
#import "ISSTUserModel.h"
#import "ISSTCLMoreTableViewCell.h"
#import "ISSTCLTableViewCell.h"
#import "ISSTCommentsModel.h"
#import "ISSTCommentsMoreViewController.h"

#import "ISSTAddressBookDetailViewController.h"
@interface ISSTRecommendDetailViewController ()

{
    NSString *title;
    NSString *time;
    NSString *publisher;
}
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
- (IBAction)userInfoButton:(id)sender;

@property (nonatomic,strong)ISSTJobsApi  *recommendApi;
@property (nonatomic,strong)ISSTJobsDetailModel *detailModel;

@property (nonatomic,assign)int  method;

@property (nonatomic,strong)NSMutableArray *commentsArray;

@end

@implementation ISSTRecommendDetailViewController

static NSString *CellTableIdentifier=@"ISSTCLTableViewCell";
const static int  DETAILS  = 1;
const static int  COMMENTS = 2;


@synthesize jobId;

@synthesize detailWebView;
@synthesize recommendApi,detailModel;

@synthesize method;

@synthesize commentsArray;
@synthesize commentsTableView;


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
    
    
    
    recommendApi = [[ISSTJobsApi alloc]init];
    recommendApi.webApiDelegate = self;
    
    self.method = DETAILS;
    [recommendApi requestDetailInfoWithId:jobId];
    
     detailWebView.scalesPageToFit = YES;
     detailWebView.delegate = self;
    UINib *nib=[UINib nibWithNibName:CellTableIdentifier bundle:nil];
    [commentsTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    commentsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero]; //去除多余横线
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    recommendApi.webApiDelegate =nil;
}

#pragma mark -
#pragma mark - ISSTMoreButtonDelegate Method;
- (void)go2CommentsMoreTableViewController
{
    ISSTCommentsMoreViewController   *commentsMoreVC=[[ISSTCommentsMoreViewController alloc]initWithNibName:@"ISSTCommentsMoreViewController" bundle:nil];
    commentsMoreVC.jobId = self.jobId;
    commentsMoreVC.navigationItem.title =@"评论列表";
    [self.navigationController pushViewController:commentsMoreVC animated:YES];
}



#pragma mark -
#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        return 30.0f;
    }
    return 66.0f;
}


#pragma mark -
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count]+1;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return  1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell * cell;
    NSLog(@"section=%d row= %d",indexPath.section,indexPath.row);
    if (!indexPath.row) {
        //不可重用
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ISSTCLMoreTableViewCell" owner:self options:nil];
        
        ISSTCLMoreTableViewCell     *cell = (ISSTCLMoreTableViewCell*)[nib objectAtIndex:0];
        // commentMoreCell.userNameLabel.text = userModel.name;
        // userCell.userDescriptionLabel.text = userModel.description;
        cell.moreButtonDelegate = self;
        return cell;
    }
    else
    {
        ISSTCLTableViewCell *cell=(ISSTCLTableViewCell  *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil) {
            cell = (ISSTCLTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
        }
        if (commentsArray) {
            ISSTCommentsModel*   cModel =  (ISSTCommentsModel*)[commentsArray objectAtIndex:(indexPath.row-1)];
            cell.nameLabel.text = cModel.userModel.name;
            cell.contentLabel.text=cModel.content;
            cell.timeLabel.text = cModel.createdAt;
        }
       
        return cell;
    }
}






#pragma mark -
#pragma mark  WebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // [activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

#pragma mark -
#pragma mark - Private Method
-(IBAction)userInfoButton:(id)sender {
    ISSTAddressBookDetailViewController *addressBookDVC = [[ISSTAddressBookDetailViewController alloc]initWithNibName:@"ISSTAddressBookDetailViewController" bundle:nil];
    addressBookDVC.navigationItem.title = @"联系人详情";
    [self.navigationController pushViewController:addressBookDVC animated:YES];
}


#pragma mark -
#pragma mark  ISSTWebApiDelegate Methods
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if (method == DETAILS) {
        detailModel = (ISSTJobsDetailModel*)backToControllerData;
        
       title=detailModel.title;
        time=detailModel.updatedAt;
        
        int userId=detailModel.userModel.userId;
        if(userId!=0)
        {
            NSString *userName=detailModel.userModel.userName;
            publisher=[NSString stringWithFormat:@"发布者：%d %@",userId,userName];
        }
        else
            publisher=@"发布者：管理员";
        
        float fontSize=50;
        NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<meta id='viewport' name='viewport' content='initial-scale=1.0; maximum-scale=1.0;'>\n"
                              //                          "<style type=\"text/css\"> \n"
                              
                              "<style type=\"text/css\"> \n"
                              "img{max-width:100%%; width:auto; height:auto;} "
                              //                          "body {color:#9C9C9C}"
                              //                          "body {font-size:40;}"
                              "</style> \n"
                              
                              "</head> \n"
                              "<body >\n"
                              "<h3 align='center'style='color:#262626'>%@</h3>"
                              "<h5 align='center'>"
                              "<font color='#9C9C9C'; size='1';>%@&nbsp&nbsp&nbsp&nbsp&nbsp%@</font>"
                              "</h5>"
                              "<hr align='center'; style=' height:1px;border:none;border-top:1px  solid #EBEBEB ;' />"
                              "</hr>"
                              
                              "%@</body> \n"
                              "</html>", title,time,publisher,detailModel.content];
        
        
        [detailWebView loadHTMLString:jsString baseURL:nil];//加载html源代码
        method = COMMENTS;
         [recommendApi requestRCLists:1 andPageSize:3 andJobId:self.jobId];
    }
    else if(COMMENTS == method)
    {
        commentsArray = (NSMutableArray*)backToControllerData;
       // NSLog(@"%@",commentsArray[0]);
        [commentsTableView reloadData];
        
    }
  }

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}




@end
