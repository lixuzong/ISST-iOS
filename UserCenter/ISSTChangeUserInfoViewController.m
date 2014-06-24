//
//  ISSTChangeUserInfoViewController.m
//  ISST
//
//  Created by zhaoxs on 6/16/14.
//  Copyright (c) 2014 MSE.ZJU. All rights reserved.
//

#import "ISSTChangeUserInfoViewController.h"
#import "UserImputCell.h"
#import "AppCache.h"
#import "ISSTUserModel.h"
#import "ISSTUserCenterApi.h"
#import "AJComboBox.h"
#import "CheckBox.h"

@interface ISSTChangeUserInfoViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ISSTWebApiDelegate,AJComboBoxDelegate>
{
    NSMutableDictionary *_listData;
    ISSTUserCenterApi *_userCenterApi;
    
    UIScrollView    *_scrollView;
    
    UITextField     *_nameTextField;
    UITextField     *_qqTextField;
    UITextField     *_emailTextField;
    UITextField     *_phoneTextField;
   // UITextField     *_cityTextField;
    UITextField     *_companyTextField;
    UITextField     *_positionTextField;
    UITextField     *_signatureTextField;
    
    //城市选择
    AJComboBox      *_citySelectBox;
  //  CheckBox        *_privatePhoneBox;
    
    
    
    CheckBox *_privatePhoneBox;
    CheckBox *_privateQqBox;
    CheckBox *_privateCityBox;
    CheckBox *_privateCompanyBox;
    CheckBox *_privatePositionBox;
    
    //无法修改的项目
    UITextField *_sexField;
    UITextField *_majorField;
    UITextField *_classField;
}
@end

@implementation ISSTChangeUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _userCenterApi = [[ISSTUserCenterApi alloc] init];
        _userCenterApi.webApiDelegate = self;
    }
    return self;
}

-(void)saveInfo:(id)sender
{
    [self hiddenKeyBoard];
    [_listData setValue:_signatureTextField.text forKey:@"signature"];
    [_listData setValue:_positionTextField.text forKey:@"position"];
    [_listData setValue:_emailTextField.text forKey:@"email"];
    [_listData setValue:_qqTextField.text forKey:@"qq"];
    [_listData setValue:_phoneTextField.text forKey:@"phone"];
     [_listData setValue:_companyTextField.text forKey:@"company"];
    [_listData setValue:[NSNumber numberWithBool:_privateCompanyBox.isHook] forKey:@"privateCompany"];
    [_listData setValue:[NSNumber numberWithBool:_privatePhoneBox.isHook] forKey:@"privatePhone"];
    [_listData setValue:[NSNumber numberWithBool:_privatePositionBox.isHook] forKey:@"privatePosition"];
    [_listData setValue:[NSNumber numberWithBool:_privateQqBox.isHook] forKey:@"privateQQ"];
    
    if ([_privatePhoneBox isHook]) {
        NSLog(@"hook");
    }
    else
        NSLog(@"not hook");
    
    [_userCenterApi requestChangeUserInfo:_listData];
}


-(void)viewWillAppear:(BOOL)animated
{
 [self initialUIData];
}


-(void)initialUI
{
    self.navigationItem.title =@"修改信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveInfo:)];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake( 0, 0, 320, self.view.bounds.size.height)];
  
    [self.view addSubview:_scrollView];
    
    int height= 0;
    UIImageView *partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    
    
    //姓名行
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"姓名:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight] ;
    //   label.textAlignment = UITextAlignmentRight;
    [_scrollView addSubview:label];
    
    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    //  _nameTextField.backgroundColor = [UIColor brownColor];
    _nameTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _nameTextField.delegate = self;
    [_scrollView addSubview:_nameTextField];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    //性别
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"性别:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    
    UILabel    *genderLabel= [[UILabel alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    genderLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    genderLabel.layer.cornerRadius = 2;

    NSString *genderString =[_listData valueForKey:@"gender"];
    if ([genderString isEqualToString:@"1"])
    {
            genderLabel.text = @"男";
    }
    else
    {
          genderLabel.text = @"女";
    }
    genderLabel.layer.borderWidth = 1;
    [_scrollView addSubview:genderLabel];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    //年级
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"年级:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    
    UILabel    *gradeLabel= [[UILabel alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    gradeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    gradeLabel.layer.cornerRadius = 2;
    gradeLabel.layer.borderWidth = 1;
    gradeLabel.text =  [_listData valueForKey:@"className"];
    [_scrollView addSubview:gradeLabel];
    
    
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];

    //年级
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"专业方向:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    
    UILabel    *majorLabel= [[UILabel alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    majorLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    majorLabel.layer.cornerRadius = 2;
    majorLabel.font = [UIFont systemFontOfSize:11];
    majorLabel.layer.borderWidth = 1;
    majorLabel.text =  [_listData valueForKey:@"majorName"];
    [_scrollView addSubview:majorLabel];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    
    
    //电子邮箱行
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"电子邮箱:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    _emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    //  _nameTextField.backgroundColor = [UIColor brownColor];
    _emailTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _emailTextField.delegate = self;
    [_scrollView addSubview:_emailTextField];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    //phone
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"电话:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    _phoneTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _phoneTextField.delegate = self;
    [_scrollView addSubview:_phoneTextField];
    _privatePhoneBox  = [[CheckBox alloc]initWithFrame:CGRectMake(260, height+10, 20, 18)];
    _privatePhoneBox.isHook = YES;
    [_scrollView addSubview:_privatePhoneBox];
    UILabel   *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, height+8, 35, 20)];
    rightLabel.text = @"公开";
    rightLabel.textColor = [UIColor orangeColor];
    // rightLabel.backgroundColor = [UIColor orangeColor];
    rightLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:rightLabel];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    //qq
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"q q:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    _qqTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    _qqTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _qqTextField.delegate = self;
    [_scrollView addSubview:_qqTextField];
    _privateQqBox = [[CheckBox alloc]initWithFrame:CGRectMake(260, height+10, 20, 18)];
    _privateQqBox.isHook = NO;
     [_scrollView addSubview:_privateQqBox];
   rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, height+8, 35, 20)];
    rightLabel.text = @"公开";
    rightLabel.textColor = [UIColor orangeColor];
    // rightLabel.backgroundColor = [UIColor orangeColor];
    rightLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:rightLabel];

    
//    height +=40;
//    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
//    partView.backgroundColor = [UIColor lightGrayColor];
//    [_scrollView addSubview:partView];
//    
//    //所在城市
//    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
//    label.text = @"所在城市:";
//    label.font = [UIFont systemFontOfSize:12];
//    [label setTextAlignment:NSTextAlignmentRight];
//    [_scrollView addSubview:label];
//    _cityTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 200, 30)];
//    _cityTextField.borderStyle  = UITextBorderStyleRoundedRect;
//    _cityTextField.delegate = self;
//    [_scrollView addSubview:_cityTextField];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"所在城市:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    _citySelectBox = [[AJComboBox alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    _citySelectBox.delegate = self;
    //_citySelectBox.labelText = @"杭州";
    _citySelectBox.arrayData = [NSArray arrayWithObjects:@"北京",@"上海",@"杭州",@"宁波",@"广州",@"深圳",@"其他",nil];
    _citySelectBox.dropDownHeight = 180;
    [_scrollView addSubview:_citySelectBox];
    _privateCityBox = [[CheckBox alloc] initWithFrame:CGRectMake(260, height+10, 20, 18)];
    _privateCityBox.isHook = YES;
    [_scrollView addSubview:_privateCityBox];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, height+8, 35, 20)];
    rightLabel.text = @"公开";
    rightLabel.textColor = [UIColor orangeColor];
   // rightLabel.backgroundColor = [UIColor orangeColor];
    rightLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:rightLabel];
    
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    //工作单位
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"工作单位:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    _companyTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    _companyTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _companyTextField.delegate = self;
    [_scrollView addSubview:_companyTextField];
    _privateCompanyBox = [[CheckBox alloc] initWithFrame:CGRectMake(260, height+10, 20, 18)];
    _privateCompanyBox.isHook = NO;
    [_scrollView addSubview:_privateCompanyBox];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, height+8, 35, 20)];
    rightLabel.text = @"公开";
    rightLabel.textColor = [UIColor orangeColor];
    // rightLabel.backgroundColor = [UIColor orangeColor];
    rightLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:rightLabel];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    //工作单位
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"职位:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:label];
    _positionTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    _positionTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _positionTextField.delegate = self;
    [_scrollView addSubview:_positionTextField];
    _privatePositionBox = [[CheckBox alloc] initWithFrame:CGRectMake(260, height+10, 20, 18)];
    _privatePositionBox.isHook = NO;
    [_scrollView addSubview:_privatePositionBox];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, height+8, 35, 20)];
    rightLabel.text = @"公开";
    rightLabel.textColor = [UIColor orangeColor];
    rightLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:rightLabel];
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
//    //昵称
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 60, 40)];
    label.text = @"昵称:";
    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentRight];
    //  label.textAlignment = UITextAlignmentRight;
    [_scrollView addSubview:label];
    _signatureTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, height+5, 190, 30)];
    _signatureTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _signatureTextField.delegate = self;
    [_scrollView addSubview:_signatureTextField];
    
    
    height +=40;
    partView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, 320, 1)];
    partView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:partView];
    
    
    _scrollView.scrollEnabled= YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(320, height*1.5);
    
//    //添加手势，点击屏幕其他区域关闭键盘的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
//    gesture.numberOfTapsRequired = 1;
//    [_scrollView addGestureRecognizer:gesture];
//   // [_scrollView setContentOffset:CGPointMake(0, 100)];
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialUserModel];
    [self initialUI];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)initialUserModel
{
    ISSTUserModel *userModel = [AppCache getCache];
    if (userModel) {
        _listData = [[NSMutableDictionary alloc] init];
        [_listData setValue:userModel.name forKey:@"name"];
        [_listData setValue:[NSString stringWithFormat:@"%d",userModel.gender]  forKey:@"gender"];
       // [_listData setValue:userModel.cityName forKey:@"cityName"];
        [_listData setValue:userModel.className forKey:@"className"];
        [_listData setValue:userModel.email forKey:@"email"];
        [_listData setValue:userModel.majorName forKey:@"majorName"];
        [_listData setValue:userModel.phone forKey:@"phone"];
        [_listData setValue:userModel.company forKey:@"company"];
        [_listData setValue:userModel.position forKey:@"position"];
        [_listData setValue:userModel.signature forKey:@"signature"];
        [_listData setValue:userModel.qq forKey:@"qq"];
        [_listData setValue:[NSString stringWithFormat:@"%d",userModel.cityId ]  forKey:@"cityId"];
        [_listData setValue:userModel.cityName forKey:@"cityName"];
        [_listData setValue:[NSNumber numberWithBool:userModel.privateQQ]  forKey:@"privateQQ"];
        [_listData setValue:[NSNumber numberWithBool:userModel.privatePhone] forKey:@"privatePhone"];
        [_listData setValue:[NSNumber numberWithBool:userModel.privatePosition] forKey:@"privatePosition"];
        [_listData setValue:[NSNumber numberWithBool:userModel.privateCompany] forKey:@"privateCompany"];
    }
    
}

-(void)initialUIData
{

    _nameTextField.text = [_listData valueForKey:@"name"];
    _qqTextField.text = [_listData valueForKey:@"qq"];
    _emailTextField.text = [_listData valueForKey:@"email"];
    _phoneTextField.text = [_listData valueForKey:@"phone"];
  //  _cityTextField.text = [_listData valueForKey:@"cityName"];
    _positionTextField.text = [_listData valueForKey:@"position"];
    _companyTextField.text = [_listData valueForKey:@"company"];
    _signatureTextField.text = [_listData valueForKey:@"signature"];
  
     _privatePhoneBox.isHook = [(NSNumber*)[_listData valueForKey:@"privatePhone"] boolValue];
      _privatePositionBox.isHook = [(NSNumber*)[_listData valueForKey:@"privatePosition"] boolValue];
      _privateQqBox.isHook = [(NSNumber*)[_listData valueForKey:@"privateQQ"] boolValue];
    _privateCompanyBox.isHook =[(NSNumber*)[_listData valueForKey:@"privateCompany"] boolValue];
    
      _citySelectBox.labelText = [_listData valueForKey:@"cityName"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{

}


-(void)hiddenKeyBoard
{
    [_nameTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
  //  [_cityTextField resignFirstResponder] ;
    [_positionTextField resignFirstResponder];
    [_signatureTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL scroll = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];

    CGPoint offset ;
    
    if ([_positionTextField isEqual:textField])
    {
        scroll = YES;
        offset = CGPointMake(0, 80);
    }
//    else if([_cityTextField isEqual:textField])
//    {
//        offset = CGPointMake(0, 30);
//        scroll = YES;
//    }
    else if([_signatureTextField isEqual:textField])
    {
        offset = CGPointMake(0, 120);
        scroll = YES;
    }
    if ([_companyTextField isEqual:textField])
    {
        scroll = YES;
        offset = CGPointMake(0, 40);
    }
    if (scroll) {
        //这里添加了一个滚动的动画
              //开始编辑的时候，让_scrollView滚到CGPointMake(0, 216);
        [_scrollView setContentOffset:offset animated:YES];
        [UIView commitAnimations];

    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if ([textField isEqual:_emailTextField] ) {
//        NSRange range = [textField.text rangeOfString:@"@"];//判断字符串是否包含
//        
//        
//        if (![textField.text hasSuffix:@".com"] || (range.location == NSNotFound)) {
//            UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"输入错误" message:@"邮箱错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//            [alert show];
//        }
//    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
  if ([textField isEqual:_emailTextField] )
 {
        NSRange range = [textField.text rangeOfString:@"@"];//判断字符串是否包含
        
        
        if (![textField.text hasSuffix:@".com"]|| (range.location == NSNotFound)) {
            UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"输入错误" message:@"邮箱错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }

//    BOOL scroll = NO;
//    if ([_positionTextField isEqual:textField])
//    {
//        scroll = YES;
//    }
//    else if([_signatureTextField isEqual:textField])
//    {
//        scroll = YES;
//    }
//    if (scroll) {
//        //这里添加了一个滚动的动画
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.15];
//        //开始编辑的时候，让_scrollView滚到CGPointMake(0, 216);
//        CGPoint offset = CGPointMake(0, -self.navigationController.navigationBar.frame.size.height-20);
//        [_scrollView setContentOffset:offset animated:YES];
//        [UIView commitAnimations];
//    }
    

    
    return YES;
}

#pragma mark  - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hiddenKeyBoard];
}



#pragma mark - ISSTWebApiDelegate
- (void)requestDataOnSuccess:(id)backToControllerData
{
    NSLog(@"%@",backToControllerData);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新成功" message:backToControllerData delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}



#pragma mark - AJComboxBox
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    [_listData setValue:[NSString stringWithFormat:@"%d",selectedIndex] forKey:@"cityId"];
}

@end
