//
//  loginController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "loginController.h"

#import "configController.h"

#import "mainController.h"

#import "userModel.h"

@interface loginController ()
@property (nonatomic, strong)UITextField *nameField;
@property (nonatomic, strong)UITextField *passwordField;
@end

@implementation loginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.navView.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self customUI];

    NSArray *arr = GET_DEFAULT(@"config");

    if (!arr) {

        NSArray *array = @[@[@"1334",@"YOUYI",@"YOUYI"],@[@"8,10,12",@"={1}\\d{8,12}"],@[@"1",@"http://siia.veiwa.com/WebService/LogisticsApi.asmx"]];

        //        @"http://stest.veiwa.com/WebService/LogisticsApi.asmx"];
        SET_DEFAULT(array, @"config");
    }
}

- (void)customUI
{

    //logo图片
    UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(100,64,kScreenWidth-200, 80)];
    logoImg.image = [UIImage imageNamed:@"logo.png"];
    logoImg.contentMode = UIViewContentModeBottom;
    [self.view addSubview:logoImg];

    //物流码采集label
    UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.left-10, logoImg.bottom+10, logoImg.width+20,20)];
    versionLab.text = @"物流码采集";
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.textColor = [UIColor lightGrayColor];
    versionLab.font = Font_Sys_14;
    [self.view addSubview:versionLab];

    //姓名
    UIImageView *nameView = [[UIImageView alloc] initWithFrame:CGRectMake(5, versionLab.bottom+50, kScreenWidth-10, 30)];
    nameView.userInteractionEnabled = YES;
    [self.view addSubview:nameView];

    UIImageView *nameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    nameIcon.image = [UIImage imageNamed:@"login1"];
    nameIcon.contentMode = UIViewContentModeScaleAspectFit;
    [nameView addSubview:nameIcon];

    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(nameIcon.right+20, 5, nameView.width-nameIcon.width-25, 20)];
    _nameField.placeholder = @"请输入登录用户名";
    _nameField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    _nameField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameView addSubview:_nameField];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, nameView.bottom+5, nameView.width, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:lineView];

    //密码
    UIImageView *passwordView = [[UIImageView alloc] initWithFrame:CGRectMake(5, lineView.bottom+10, kScreenWidth-10, 30)];
    passwordView.userInteractionEnabled = YES;
    [self.view addSubview:passwordView];

    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    passwordIcon.image = [UIImage imageNamed:@"logo2"];
    passwordIcon.contentMode = UIViewContentModeScaleAspectFit;
    [passwordView addSubview:passwordIcon];

    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(passwordIcon.right+20, 5, passwordView.width-passwordIcon.width-25, 20)];
    _passwordField.placeholder = @"输入密码";
    _passwordField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    _passwordField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    [passwordView addSubview:_passwordField];

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(5, passwordView.bottom+5, passwordView.width, 1)];
    lineView1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:lineView1];

    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(5, lineView1.bottom+20, passwordView.width, 40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"denglubutton"] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 10.0;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 20)];
    label.text = @"Copyrights © 2016-2019 上海驰亚智能科技有限公司";
    label.font = Font_Sys_12;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

}

// 临时入口 （gj-12/20）
- (void)btnClick1{
    [self.navigationController pushViewController:[mainController new] animated:YES];
}

- (void)btnClick
{
    if (_nameField.text.length == 0) {
        [WToast showWithText:@"请输入用户名"];
        return;
    }
    if (_passwordField.text.length == 0) {
        [WToast showWithText:@"请输入密码"];
        return;
    }
    if ([_nameField.text isEqualToString: @"siia"] && [_passwordField.text isEqualToString: @"siia"]) {
        _nameField.text = @"";
        _passwordField.text = @"";
        [self.navigationController pushViewController:[configController new] animated:YES];
    } else
    {
        NSArray *configArray = GET_DEFAULT(@"config");
        NSString *tmpStr = configArray[2][0];

        if ([tmpStr isEqualToString:@"0"]) {
            [WToast showWithText:@"请检查配置"];
            return;
        }
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];

        [[requestManager sharedManager].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在登录"];
                userModel *tmpModel = [[userModel alloc] init];
                tmpModel.UserName = _nameField.text;
                tmpModel.UserPwd = _passwordField.text;
                NSMutableArray *array = [[ZJDataBase sharedDataBase] getDataByParam:tmpModel];
                if (array.count != 0) {
                    userModel *model = array[0];
                    if ([_nameField.text isEqualToString:model.UserName] && [_passwordField.text isEqualToString:model.UserPwd]) {
                        SET_DEFAULT(model.UserID, @"UserID");
                        SET_DEFAULT(model.Type, @"UserType");
                        _nameField.text = @"";
                        _passwordField.text = @"";
                        [self.navigationController pushViewController:[mainController new] animated:YES];
                    }
                } else
                {
                    [WToast showWithText:@"暂无该用户"];
                }
                [LCProgressHUD hide];
            } else
            {
                [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在登录"];

                NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{\"UserName\":\"%@\",\"Password\":\"%@\"}}}",configArray[0][0],configArray[0][1],configArray[0][2],_nameField.text,_passwordField.text];
                NSDictionary *parasDic = @{@"Json":jsonString};

                NSString *methodName=@"Down_infoUsersLogin";
                SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"LogisticsApi"];
                NSString *postData=[soaputility BuildSoapwithMethodName:@"Down_infoUsersLogin" withParas:parasDic];

                SoapService *soaprequest=[[SoapService alloc] init];
                soaprequest.PostUrl = configArray [2][1];
                soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];

                [soaprequest PostAsync:postData Success:^(NSString *response) {
                    //                    NSLog(@"%@",response);

                    parseData *info = [[parseData alloc] initWithData:response withName:@"Down_infoUsersLoginResult"];
                    //                    NSLog(@"%@",info.resultDic);

                    NSDictionary *responseDic = info.resultDic[@"Response"];
                    NSDictionary *header = responseDic[@"Header"];
                    NSString *errorCode = header[@"ErrorCode"];

                    if ([errorCode isEqualToString:@"00"]) {
                        NSArray *body = responseDic[@"Body"];
                        NSDictionary *bodyDic = body[0];
                        NSString *userID = bodyDic[@"UserID"];
                        NSString *userType = bodyDic[@"UserType"];

                        SET_DEFAULT(userID, @"UserID");
                        SET_DEFAULT(userType, @"UserType");

                        userModel *tmpModel = [[userModel alloc] init];
                        tmpModel.UserID = userID;
                        [[ZJDataBase sharedDataBase] deleteAllDataByUserID:tmpModel];

                        tmpModel.Type = userType;
                        tmpModel.UserName = _nameField.text;
                        tmpModel.UserPwd = _passwordField.text;
                        [[ZJDataBase sharedDataBase] addData:tmpModel];

                        _nameField.text = @"";
                        _passwordField.text = @"";

                        [self.navigationController pushViewController:[mainController new] animated:YES];
                    } else
                    {
                        _nameField.text = @"";
                        _passwordField.text = @"";
                        [WToast showWithText:header[@"ErrorMsg"]];
                    }
                    [LCProgressHUD hide];
                } falure:^(NSError *response) {
                    [WToast showWithText:response.description];
                    [LCProgressHUD hide];
                }];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navView.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_nameField resignFirstResponder];
    [_passwordField resignFirstResponder];
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
