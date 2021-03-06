//
//  checkInController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/7.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "checkInController.h"

#import "batchModel.h"

#import "inModel.h"

@interface checkInController ()
<UITextFieldDelegate, ScanCodeDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZJSearchViewController *searchView1;
@property (nonatomic, strong) ZJSearchViewController *searchView2;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UITextField *productField;

@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIButton *batchButton;

@property (nonatomic, strong) UITextField *scanField;

@property (nonatomic, strong) UILabel *numLabel;

//@property (nonatomic, strong) ZJButton *btn1;
//@property (nonatomic, strong) ZJButton *btn2;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation checkInController
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
    
    [self createNavigationBarRightBtnTitle:@"查询" RightBtnImage:nil action:^{
        [weakSelf getDetails];
    }];
    self.navTitle.text = @"入库查询";
    
    _resultArray = [NSMutableArray new];
    [self customUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resultString:) name:@"resultString" object:nil];
}

- (void)getDetails
{
    [_productField resignFirstResponder];
    [_scanField resignFirstResponder];

    inModel *model = [inModel new];
    model.GoodsCode = [_productField.text componentsSeparatedByString:@"-"][0];
    model.ScanCode = _scanField.text;
    
    if (_batchButton.currentTitle.length == 0) {
        model.StrBatch = @"";
    } else {
        model.StrBatch = _batchButton.currentTitle;
    }
    
//    if (_btn1.selected == YES) {
//        model.Tag = @"0";
//    } else {
//        model.Tag = @"1";
//    }
    model.UserID = GET_DEFAULT(@"UserID");
        
    _resultArray = [[ZJDataBase sharedDataBase] getDataByParam:model];
    if (_resultArray.count == 0) {
        [WToast showWithText:@"暂无数据"];
    }
    _numLabel.text = [NSString stringWithFormat:@"%d",_resultArray.count];
    [_tableView reloadData];
    
}

- (void)resultString:(NSNotification *)notification
{
    NSString *str = notification.userInfo[@"type"];
    
    if ([str isEqualToString:@"product"]) {
        _productField.text = notification.userInfo[@"result"];
        [self setSearchControllerHidden:YES];
        [self setClickControllerHidden:YES];
        [_productField resignFirstResponder];
        
        NSMutableArray *batchArray = [NSMutableArray new];
        batchModel *model = [batchModel new];
        model.UserID = GET_DEFAULT(@"UserID");
        NSString *goodsCode = [_productField.text componentsSeparatedByString:@"-"][0];
        NSArray *array = [[ZJDataBase sharedDataBase] getDataByUserID:model];
        for (batchModel *tmpModel in array) {
            if ([goodsCode isEqualToString:tmpModel.GoodsCode]) {
                [batchArray addObject:[NSString stringWithFormat:@"%@",tmpModel.StrBatch]];
            }
        }
        if (batchArray.count != 0) {
            [_batchButton setTitle:batchArray[0] forState:UIControlStateNormal];
        }
    }
    if ([str isEqualToString:@"batch"])
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
    titleLabel2.text = @"批次号:";
    [_secondImageView addSubview:titleLabel2];
    
    _batchButton = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel2.right, 5, kScreenWidth - 20 - titleLabel2.width, 40)];
    _batchButton.tag = 101;
    [_batchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_batchButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondImageView addSubview:_batchButton];
    
    _searchView2 = [[ZJSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [_searchView2.view setFrame:CGRectMake(_batchButton.left, _secondImageView.bottom, _batchButton.width, 0)];
 
    UIImageView *thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _secondImageView.bottom + 5, kScreenWidth, 50)];
    thirdImageView.backgroundColor = [UIColor whiteColor];
    thirdImageView.userInteractionEnabled = YES;
    [self.view addSubview:thirdImageView];
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel3.text = @"扫描条码:";
    [thirdImageView addSubview:titleLabel3];
    
    _scanField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 5, kScreenWidth - 20 - 40 - 80 - 10, 40)];
    _scanField.placeholder = @"请输入或直接扫描";
    _scanField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [thirdImageView addSubview:_scanField];
    
    UIButton *scanButton2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    scanButton2.tag = 102;
    [scanButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton2 setBackgroundImage:[UIImage imageNamed:@"sm.png"] forState:UIControlStateNormal];
    [thirdImageView addSubview:scanButton2];
    
    UIImageView *fourthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, thirdImageView.bottom + 5, kScreenWidth, 50)];
    fourthImageView.backgroundColor = [UIColor whiteColor];
    fourthImageView.userInteractionEnabled = YES;
    [self.view addSubview:fourthImageView];
    
    //数量
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    titleLabel4.text = @"数量:";
    [fourthImageView addSubview:titleLabel4];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel4.right, 5, (fourthImageView.width - 20)/3.0-titleLabel4.width, 40)];
    _numLabel.text = @"0";
    _numLabel.textAlignment = NSTextAlignmentLeft;
    _numLabel.textColor = [UIColor redColor];
    [fourthImageView addSubview:_numLabel];
    
//    //未上传
//    _btn1 = [ZJButton buttonWithType:UIButtonTypeCustom];
//    _btn1.frame = CGRectMake(_numLabel.right, 5, (fourthImageView.width - 20)/3.0, 40);
//    [_btn1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
//    _btn1.selected = YES;
//    [_btn1 setTitle:@"未上传" forState:UIControlStateNormal];
//    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn1 setImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
//    [_btn1 setImage:[UIImage imageNamed:@"check_circle_ok"] forState:UIControlStateSelected];
//    [fourthImageView addSubview:_btn1];
//    
//    //已上传
//    _btn2 = [ZJButton buttonWithType:UIButtonTypeCustom];
//    _btn2.frame = CGRectMake(_btn1.right, 5, (fourthImageView.width - 20)/3.0, 40);
//    [_btn2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
//    [_btn2 setTitle:@"已上传" forState:UIControlStateNormal];
//    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn2 setImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
//    [_btn2 setImage:[UIImage imageNamed:@"check_circle_ok"] forState:UIControlStateSelected];
//    [fourthImageView addSubview:_btn2];

    UIImageView *fifthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, fourthImageView.bottom + 5, kScreenWidth, 50)];
    fifthImageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:fifthImageView];
    
    UILabel *wuliumaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (fifthImageView.width - 10)/2.0, 50)];
    wuliumaLabel.text =  @"物流码";
    wuliumaLabel.textAlignment = NSTextAlignmentCenter;
    [fifthImageView addSubview:wuliumaLabel];
    
//    UILabel *piciLabel = [[UILabel alloc] initWithFrame:CGRectMake(wuliumaLabel.right, 0, (fifthImageView.width - 10)/3.0-15, 50)];
//    piciLabel.text =  @"批次";
//    piciLabel.textAlignment = NSTextAlignmentCenter;
//    [fifthImageView addSubview:piciLabel];
    
    UILabel *chanpinLabel = [[UILabel alloc] initWithFrame:CGRectMake(wuliumaLabel.right, 0, (fifthImageView.width - 10)/2.0, 50)];
    chanpinLabel.text =  @"产品编号";
    chanpinLabel.textAlignment = NSTextAlignmentCenter;
    [fifthImageView addSubview:chanpinLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, fifthImageView.bottom, kScreenWidth, kScreenHeight - fifthImageView.bottom) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    [self.view addSubview:_searchView1.view];
    [self.view addSubview:_searchView2.view];
}

////选择上传按钮
//-(void)selectButton:(ZJButton *)sender{
//    if (sender == _btn1) {
//        _btn1.selected = YES;
//        _btn2.selected = NO;
//    }else if (sender == _btn2){
//        _btn1.selected = NO;
//        _btn2.selected = YES;
//    }
//}

- (void)getScanCode:(NSMutableArray *)codeArray
{
    if ([tip isEqualToString:@"1"]) {
        _productField.text = codeArray[0];
        [_productField becomeFirstResponder];
        [self productFieldDidChange:_productField];
    }
    if ([tip isEqualToString:@"2"]) {
        _scanField.text = codeArray[0];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        tip = @"1";
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"1";
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
    }
    if (sender.tag == 101) {
        [self setSearchControllerHidden:YES];
        [self setClickControllerHidden:NO];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:_productField.text forKey:@"data"];
        [dic setObject:@"batch" forKey:@"type"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"batch" object:nil userInfo:dic];
    }
    if (sender.tag == 102) {
        tip = @"2";
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"3";
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setClickControllerHidden:YES];
}

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

- (void)setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (kScreenHeight - self.navView.height)*0.4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_searchView1.view setFrame:CGRectMake(_productField.left, _firstImageView.bottom, _productField.width, height)];
    [UIView commitAnimations];
}

- (void)setClickControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (kScreenHeight - self.navView.height)*0.4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_searchView2.view setFrame:CGRectMake(_batchButton.left, _secondImageView.bottom, _batchButton.width, height)];
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_productField resignFirstResponder];
    [_scanField resignFirstResponder];
    [self setSearchControllerHidden:YES];
    [self setClickControllerHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"Cell";
    tableCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell==nil){
        cell = [[tableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    inModel *model = _resultArray[indexPath.row];
    cell.leftLabel.text = model.ScanCode;
    cell.rightLabel.text = model.GoodsCode;
//    cell.label3.text = model.GoodsCode;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_handle:)];
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

- (void)longPress_handle:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"longPress");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //根据手势获得触摸的点位置
        CGPoint point = [gesture locationInView:_tableView];
        NSIndexPath *selectIndex = [_tableView indexPathForRowAtPoint:point];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZJDataBase sharedDataBase] deleteSingleDataByParam:_resultArray[selectIndex.row]];
            [_resultArray removeObjectAtIndex:selectIndex.row];
            //删除行
            [_tableView deleteRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationLeft];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
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
