//
//  inController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "inController.h"

#import "batchModel.h"
#import "inNextController.h"

@interface inController ()
<UITextFieldDelegate, ScanCodeDelegate>


@property (nonatomic, strong) ZJSearchViewController *searchView1;
@property (nonatomic, strong) ZJSearchViewController *searchView2;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UITextField *productField;

@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIButton *batchButton;
@end

@implementation inController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navTitle.text = @"入库扫描";
    
    [self customUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resultString:) name:@"resultString" object:nil];
}

#pragma mark - 查询结果点击
- (void)resultString:(NSNotification *)notification
{
    NSString *str = notification.userInfo[@"type"];
    
    if ([str isEqualToString:@"product"]) {
        _productField.text = notification.userInfo[@"result"];
        [self setSearchControllerHidden:YES];
        [self setClickControllerHidden:YES];
        [_productField resignFirstResponder];
        //选定产品直接关联出批次号
        NSMutableArray *batchArray = [NSMutableArray new];
        batchModel *model = [batchModel new];
        model.UserID = GET_DEFAULT(@"UserID");
        NSString *goodsCode = [_productField.text componentsSeparatedByString:@"-"][0];
        NSArray *dataArray = [[ZJDataBase sharedDataBase] getDataByUserID:model];//根据产品码和用户id返回该产品码下的批次号数组
        for (batchModel *tmpModel in dataArray) {
            if ([goodsCode isEqualToString:tmpModel.GoodsCode]) {
                [batchArray addObject:[NSString stringWithFormat:@"%@",tmpModel.StrBatch]];
            }
        }
        if (batchArray.count != 0) {
            [_batchButton setTitle:batchArray[0] forState:UIControlStateNormal];
        }
    } else if ([str isEqualToString:@"batch"])
    {
        [_batchButton setTitle:notification.userInfo[@"result"] forState:UIControlStateNormal];
        [self setSearchControllerHidden:YES];
        [self setClickControllerHidden:YES];
    }
}

- (void)customUI
{
    _firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height + 10, kScreenWidth, 50)];
    _firstImageView.backgroundColor = [UIColor whiteColor];
    _firstImageView.userInteractionEnabled = YES;
    [self.view addSubview:_firstImageView];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel1.text = @"入库产品:";
    [_firstImageView addSubview:titleLabel1];
    
    _productField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 5, kScreenWidth - 20 - 40 - 80 - 10, 40)];
    _productField.placeholder = @"请输入或直接扫描";
    _productField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _productField.delegate = self;
    [_productField addTarget:self action:@selector(productFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_firstImageView addSubview:_productField];
    
    _searchView1 = [[ZJSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [_searchView1.view setFrame:CGRectMake(_productField.left, _firstImageView.bottom, _productField.width, 0)];
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    scanButton.tag = 100;
    [scanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"sm.png"] forState:UIControlStateNormal];
    [_firstImageView addSubview:scanButton];
    
    _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _firstImageView.bottom + 5, kScreenWidth, 50)];
    _secondImageView.backgroundColor = [UIColor whiteColor];
    _secondImageView.userInteractionEnabled = YES;
    [self.view addSubview:_secondImageView];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel2.text = @"批次号:";
    [_secondImageView addSubview:titleLabel2];
    
    _batchButton = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel2.right, 5, kScreenWidth - 20 - titleLabel2.width, 40)];
    _batchButton.tag = 101;
    [_batchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_batchButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondImageView addSubview:_batchButton];
    
    _searchView2 = [[ZJSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [_searchView2.view setFrame:CGRectMake(_batchButton.left, _secondImageView.bottom, _batchButton.width, 0)];
    
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
    [self.view addSubview:_searchView2.view];
}

#pragma mark - 扫码返回的数据
- (void)getScanCode:(NSMutableArray *)codeArray
{
    _productField.text = codeArray[0];
    [_productField becomeFirstResponder];
    [self productFieldDidChange:_productField];
    
}

#pragma mark - 按钮响应事件
- (void)buttonClick:(UIButton *)sender
{
    [_productField resignFirstResponder];
    if (sender.tag == 100) {//入库产品扫描按钮
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"1";
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
    }
    if (sender.tag == 101) {//批次号按钮
        [self setSearchControllerHidden:YES];
        if (_productField.text.length == 0) {
            [LCProgressHUD showText:@"请选择入库产品"];
            return;
        }
        [self setClickControllerHidden:NO];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:_productField.text forKey:@"data"];
        [dic setObject:@"batch" forKey:@"type"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"batch" object:nil userInfo:dic];
    }
    if (sender.tag == 102) {//下一步按钮
        if (_productField.text.length == 0) {
            [LCProgressHUD showText:@"请选择入库产品"];
            return;
        }
        
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"2";
        qRCodeScanVC.scanFor = @"in";
        qRCodeScanVC.goodsCode = [_productField.text componentsSeparatedByString:@"-"][0];
        qRCodeScanVC.strBatch = _batchButton.currentTitle;
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setClickControllerHidden:YES];
}

#pragma mark - 入库产品textfield输入内容改变
- (void)productFieldDidChange:(UITextField *)textField
{
    [_batchButton setTitle:@"" forState:UIControlStateNormal];
    if (_productField.text.length == 0) {
        [self setSearchControllerHidden:YES];
    } else
    {
        [self setSearchControllerHidden:NO];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:textField.text forKey:@"data"];
        [dic setObject:@"product" forKey:@"type"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"product" object:nil userInfo:dic];
    }
}

#pragma mark - 入库产品下拉控制
- (void)setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (kScreenHeight - self.navView.height)*0.4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [_searchView1.view setFrame:CGRectMake(_productField.left, _firstImageView.bottom, _productField.width, height)];
    [UIView commitAnimations];
}

#pragma mark - 批次号下拉控制
- (void)setClickControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (kScreenHeight - self.navView.height)*0.4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [_searchView2.view setFrame:CGRectMake(_batchButton.left, _secondImageView.bottom, _batchButton.width, height)];
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_productField resignFirstResponder];
    [self setSearchControllerHidden:YES];
    [self setClickControllerHidden:YES];
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
