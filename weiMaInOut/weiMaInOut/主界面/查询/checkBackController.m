//
//  checkBackController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/7.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "checkBackController.h"

#import "backModel.h"

@interface checkBackController ()
<UITextFieldDelegate,ScanCodeDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) ZJSearchViewController *searchView1;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UITextField *clientField;

@property (nonatomic, strong)UITextField *scanField;

@property (nonatomic, strong) UILabel *numLabel;

//@property (nonatomic, strong) ZJButton *btn1;
//@property (nonatomic, strong) ZJButton *btn2;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation checkBackController
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
    self.navTitle.text = @"退货查询";
    
    _resultArray = [NSMutableArray new];
    [self customUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resultString:) name:@"resultString" object:nil];
}

- (void)getDetails
{
    [_clientField resignFirstResponder];
    [_scanField resignFirstResponder];
    
    backModel *model = [backModel new];
    model.ClientCode = [_clientField.text componentsSeparatedByString:@"-"][0];
    
    model.ScanCode = _scanField.text;
    
    
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
    titleLabel1.text = @"退货经销:";
    [_firstImageView addSubview:titleLabel1];
    
    _clientField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 5, kScreenWidth - 20 - 40 - 80 - 10, 40)];
    _clientField.placeholder = @"请输入或直接扫描";
    _clientField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _clientField.delegate = self;
    [_clientField addTarget:self action:@selector(clientFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_firstImageView addSubview:_clientField];
    
    _searchView1 = [[ZJSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [_searchView1.view setFrame:CGRectMake(_clientField.left, _firstImageView.bottom, _clientField.width, 0)];
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    scanButton.tag = 100;
    [scanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"sm.png"] forState:UIControlStateNormal];
    [_firstImageView addSubview:scanButton];
    
    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _firstImageView.bottom + 5, kScreenWidth, 50)];
    secondImageView.backgroundColor = [UIColor whiteColor];
    secondImageView.userInteractionEnabled = YES;
    [self.view addSubview:secondImageView];
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel3.text = @"扫描条码:";
    [secondImageView addSubview:titleLabel3];
    
    _scanField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 5, kScreenWidth - 20 - 40 - 80 - 10, 40)];
    _scanField.placeholder = @"请输入或直接扫描";
    _scanField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [secondImageView addSubview:_scanField];
    
    UIButton *scanButton3 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    scanButton3.tag = 102;
    [scanButton3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton3 setBackgroundImage:[UIImage imageNamed:@"sm.png"] forState:UIControlStateNormal];
    [secondImageView addSubview:scanButton3];
    
    UIImageView *thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, secondImageView.bottom + 5, kScreenWidth, 50)];
    thirdImageView.backgroundColor = [UIColor whiteColor];
    thirdImageView.userInteractionEnabled = YES;
    [self.view addSubview:thirdImageView];
    
    //数量
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    titleLabel4.text = @"数量:";
    [thirdImageView addSubview:titleLabel4];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel4.right, 5, (thirdImageView.width - 20)/3.0-titleLabel4.width, 40)];
    _numLabel.text = @"0";
    _numLabel.textAlignment = NSTextAlignmentLeft;
    _numLabel.textColor = [UIColor redColor];
    [thirdImageView addSubview:_numLabel];
    
//    //未上传
//    _btn1 = [ZJButton buttonWithType:UIButtonTypeCustom];
//    _btn1.frame = CGRectMake(_numLabel.right, 5, (thirdImageView.width - 20)/3.0, 40);
//    [_btn1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
//    _btn1.selected = YES;
//    [_btn1 setTitle:@"未上传" forState:UIControlStateNormal];
//    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn1 setImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
//    [_btn1 setImage:[UIImage imageNamed:@"check_circle_ok"] forState:UIControlStateSelected];
//    [thirdImageView addSubview:_btn1];
//    
//    //已上传
//    _btn2 = [ZJButton buttonWithType:UIButtonTypeCustom];
//    _btn2.frame = CGRectMake(_btn1.right, 5, (thirdImageView.width - 20)/3.0, 40);
//    [_btn2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
//    [_btn2 setTitle:@"已上传" forState:UIControlStateNormal];
//    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn2 setImage:[UIImage imageNamed:@"check_circle"] forState:UIControlStateNormal];
//    [_btn2 setImage:[UIImage imageNamed:@"check_circle_ok"] forState:UIControlStateSelected];
//    [thirdImageView addSubview:_btn2];
    
    UIImageView *fourthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, thirdImageView.bottom + 5, kScreenWidth, 50)];
    fourthImageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:fourthImageView];
    
    UILabel *wuliumaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (fourthImageView.width - 10)/2.0, 50)];
    wuliumaLabel.text =  @"物流码";
    wuliumaLabel.textAlignment = NSTextAlignmentCenter;
    [fourthImageView addSubview:wuliumaLabel];
    
    UILabel *piciLabel = [[UILabel alloc] initWithFrame:CGRectMake(wuliumaLabel.right, 0, (fourthImageView.width - 10)/2.0, 50)];
    piciLabel.text =  @"客户编号";
    piciLabel.textAlignment = NSTextAlignmentCenter;
    [fourthImageView addSubview:piciLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, fourthImageView.bottom, kScreenWidth, kScreenHeight - thirdImageView.bottom) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    [self.view addSubview:_searchView1.view];
}
/*
//选择上传按钮
-(void)selectButton:(ZJButton *)sender{
    if (sender == _btn1) {
        _btn1.selected = YES;
        _btn2.selected = NO;
    }else if (sender == _btn2){
        _btn1.selected = NO;
        _btn2.selected = YES;
    }
}
*/
- (void)getScanCode:(NSMutableArray *)codeArray
{
    NSLog(@"codeArray===%@",codeArray);
    if ([tip isEqualToString:@"1"]) {
        _clientField.text = codeArray[0];
        [_clientField becomeFirstResponder];
        [self clientFieldDidChange:_clientField];
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
    if (sender.tag == 102) {
        tip = @"2";
        QRCodeScanVC *qRCodeScanVC = [[QRCodeScanVC alloc]init];
        qRCodeScanVC.delegate = self;
        qRCodeScanVC.type = @"3";
        [self.navigationController pushViewController:qRCodeScanVC animated:YES];
        
    }
}

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

- (void)setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (kScreenHeight - self.navView.height)*0.4;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_searchView1.view setFrame:CGRectMake(_clientField.left, _firstImageView.bottom, _clientField.width, height)];
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_clientField resignFirstResponder];
    [self setSearchControllerHidden:YES];
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
    backModel *model = _resultArray[indexPath.row];
    cell.leftLabel.text = model.ScanCode;
    cell.rightLabel.text = model.ClientCode;
    
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
