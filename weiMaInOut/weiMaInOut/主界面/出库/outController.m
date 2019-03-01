//
//  outController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "outController.h"

#import "outNextController.h"

@interface outController ()
<UITextFieldDelegate,ScanCodeDelegate>

@property (nonatomic, strong) ZJSearchViewController *searchView1;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UITextField *orderField;

@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UITextField *clientField;
@end

@implementation outController
{
    NSString *tip;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navTitle.text = @"出库扫描";
    
    [self customUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resultString:) name:@"resultString" object:nil];
}

#pragma mark - 查询结果点击
- (void)resultString:(NSNotification *)notification
{
    NSString *str = notification.userInfo[@"type"];
    
    if ([str isEqualToString:@"client"]) {
        _clientField.text = notification.userInfo[@"result"];
        [self setSearchControllerHidden:YES];
        [_clientField resignFirstResponder];
    }
}

- (void)customUI
{
    _firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height + 10, kScreenWidth, 50)];
    _firstImageView.backgroundColor = [UIColor whiteColor];
    _firstImageView.userInteractionEnabled = YES;
    [self.view addSubview:_firstImageView];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel1.text = @"出库订单:";
    [_firstImageView addSubview:titleLabel1];
    
    _orderField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 5, kScreenWidth - 20 - 40 - 80 - 10, 40)];
    _orderField.placeholder = @"请输入或直接扫描";
    _orderField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _orderField.delegate = self;
    [_firstImageView addSubview:_orderField];
    
    UIButton *scanButton1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    scanButton1.tag = 100;
    [scanButton1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton1 setBackgroundImage:[UIImage imageNamed:@"sm.png"] forState:UIControlStateNormal];
    [_firstImageView addSubview:scanButton1];
    
    _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _firstImageView.bottom + 5, kScreenWidth, 50)];
    _secondImageView.backgroundColor = [UIColor whiteColor];
    _secondImageView.userInteractionEnabled = YES;
    [self.view addSubview:_secondImageView];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel2.text = @"收货经销:";
    [_secondImageView addSubview:titleLabel2];
    
    _clientField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel2.right, 5, kScreenWidth - 20 - titleLabel2.width, 40)];
    _clientField.placeholder = @"请输入或直接扫描";
    _clientField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _clientField.delegate = self;
    [_clientField addTarget:self action:@selector(clientFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_secondImageView addSubview:_clientField];
    
    UIButton *scanButton2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    scanButton2.tag = 101;
    [scanButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton2 setBackgroundImage:[UIImage imageNamed:@"sm.png"] forState:UIControlStateNormal];
    [_secondImageView addSubview:scanButton2];
    
    _searchView1 = [[ZJSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [_searchView1.view setFrame:CGRectMake(_clientField.left, _secondImageView.bottom, _clientField.width, 0)];

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(5, _secondImageView.bottom + 40, kScreenWidth-10, 40);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"denglubutton"] forState:UIControlStateNormal];
    nextBtn.tag = 102;
    nextBtn.layer.cornerRadius = 10.0;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [self.view addSubview:_searchView1.view];
}

#pragma mark - 扫码返回的数据
- (void)getScanCode:(NSMutableArray *)codeArray
{
    if ([tip isEqualToString:@"1"]) {
        _orderField.text = codeArray[0];
    }
    if ([tip isEqualToString:@"2"]) {
        _clientField.text = codeArray[0];
        [_clientField becomeFirstResponder];
        [self clientFieldDidChange:_clientField];
    }
}

#pragma mark - 按钮响应事件
- (void)buttonClick:(UIButton *)sender
{
    [_orderField resignFirstResponder];
    [_clientField resignFirstResponder];
    if (sender.tag == 100) {//出库订单扫描按钮
        tip = @"1";
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"1";
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
    }
    if (sender.tag == 101) {//收货经销扫描按钮
        tip = @"2";
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"1";
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
    }
    if (sender.tag == 102) {//下一步按钮
        if (_orderField.text.length == 0) {
            [LCProgressHUD showText:@"请输入出库订单号"];
            return;
        }
        if (_clientField.text.length == 0) {
            [LCProgressHUD showText:@"请选择收货经销商"];
            return;
        }
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"2";
        qRCodeScanVC.scanFor = @"out";
        qRCodeScanVC.clientCode = [_clientField.text componentsSeparatedByString:@"-"][0];
        qRCodeScanVC.orderCode = _orderField.text;
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _orderField) {
        [self setSearchControllerHidden:YES];
    }
}

#pragma mark - 收货经销textfield输入内容改变
- (void)clientFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self setSearchControllerHidden:YES];
    } else
    {
        [self setSearchControllerHidden:NO];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:textField.text forKey:@"data"];
        [dic setObject:@"client" forKey:@"type"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"client" object:nil userInfo:dic];
    }
}

#pragma mark - 收货经销下拉控制
- (void)setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (kScreenHeight - self.navView.height)*0.4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_searchView1.view setFrame:CGRectMake(_clientField.left, _secondImageView.bottom, _clientField.width, height)];
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_orderField resignFirstResponder];
    [_clientField resignFirstResponder];
    [self setSearchControllerHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
