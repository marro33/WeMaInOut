//
//  backNextController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/4.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "backNextController.h"

#import "mainController.h"

#import "backModel.h"

@interface backNextController ()
<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)UILabel *jianNumLabel;//件数
@property (nonatomic, strong)UILabel *xiangNumLabel;//箱数
@property (nonatomic, strong)UILabel *tuoNumLabel;//托数

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UITextField *scanField;

@property (nonatomic, strong)NSMutableArray *resultArray;


@end

@implementation backNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self createNavigationBarRightBtnTitle:@"完成" RightBtnImage:nil action:^{
        
        NSArray *vcs= self.navigationController.viewControllers;
        for (UIViewController *vc in vcs) {
            if([vc isKindOfClass:[mainController class]]){
                [weakSelf.navigationController popToViewController:vc animated:YES];
                
            }
        }
    }];

    self.navTitle.text = @"退货扫描";
    
    [self customUI];
    
    backModel *model = [backModel new];
    model.ClientCode = _clientCode;
    model.UserID = GET_DEFAULT(@"UserID");
    _resultArray = [[ZJDataBase sharedDataBase] getExactDataByParam:model];
    [_tableView reloadData];
    
    [self showNum];

}

- (void)customUI
{
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height + 20, kScreenWidth, 50)];
    firstImageView.backgroundColor = [UIColor whiteColor];
    firstImageView.userInteractionEnabled = YES;
    [self.view addSubview:firstImageView];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
    titleLabel1.text = @"扫描条码:";
    [firstImageView addSubview:titleLabel1];
    
    _scanField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel1.right, 5, kScreenWidth - 20 - 40 - 80 - 10, 40)];
    _scanField.placeholder = @"请输入或直接扫描";
    _scanField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [firstImageView addSubview:_scanField];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 40, 5, 40, 40)];
    addButton.tag = 100;
    [addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.backgroundColor = [UIColor orangeColor];
    [addButton setTitle:@"确定" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [firstImageView addSubview:addButton];
    
    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, firstImageView.bottom + 10, kScreenWidth, 50)];
    secondImageView.backgroundColor = [UIColor whiteColor];
    secondImageView.userInteractionEnabled = YES;
    [self.view addSubview:secondImageView];
    
    UILabel *jianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    jianLabel.text = @"件:";
    [secondImageView addSubview:jianLabel];
    
    _jianNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(jianLabel.right, 5, (secondImageView.width - 20 - 120)/3.0, 40)];
    _jianNumLabel.text = @"0";
    _jianNumLabel.textColor = [UIColor redColor];
    [secondImageView addSubview:_jianNumLabel];
    
    UILabel *xiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(_jianNumLabel.right, 5, 40, 40)];
    xiangLabel.text = @"箱:";
    [secondImageView addSubview:xiangLabel];
    
    _xiangNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(xiangLabel.right, 5, (secondImageView.width - 20 - 120)/3.0, 40)];
    _xiangNumLabel.text = @"0";
    _xiangNumLabel.textColor = [UIColor redColor];
    [secondImageView addSubview:_xiangNumLabel];
    
    UILabel *tuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xiangNumLabel.right, 5, 40, 40)];
    tuoLabel.text = @"托:";
    [secondImageView addSubview:tuoLabel];
    
    _tuoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(tuoLabel.right, 5, (secondImageView.width - 20 - 120)/3.0, 40)];
    _tuoNumLabel.text = @"0";
    _tuoNumLabel.textColor = [UIColor redColor];
    [secondImageView addSubview:_tuoNumLabel];
    
    UIImageView *thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, secondImageView.bottom + 10, kScreenWidth, 50)];
    thirdImageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:thirdImageView];
    
    UILabel *wuliumaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (thirdImageView.width - 10)/2.0, 50)];
    wuliumaLabel.text =  @"物流码";
    wuliumaLabel.textAlignment = NSTextAlignmentCenter;
    [thirdImageView addSubview:wuliumaLabel];
    
    UILabel *kehuLabel = [[UILabel alloc] initWithFrame:CGRectMake(wuliumaLabel.right, 0, (thirdImageView.width - 10)/2.0, 50)];
    kehuLabel.text =  @"客户编号";
    kehuLabel.textAlignment = NSTextAlignmentCenter;
    [thirdImageView addSubview:kehuLabel];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, thirdImageView.bottom, kScreenWidth, kScreenHeight - thirdImageView.bottom) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

- (void)buttonClick
{
    if (_scanField.text.length != 8 &&_scanField.text.length != 10 &&_scanField.text.length != 12) {
        [LCProgressHUD showText:@"条码位数不正确"];
        return;
    }
    [_scanField resignFirstResponder];
    backModel *model = [[backModel alloc] init];
    model.ClientCode = _clientCode;
    model.UserID = GET_DEFAULT(@"UserID");
    model.ScanCode = _scanField.text;
    if([_resultArray containsObject:_scanField.text]||[[ZJDataBase sharedDataBase] dataIsExist:model]){
        [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"已存在或已被扫描"];
        return;
    }
    else{
        [_resultArray addObject:_scanField.text];
        [[ZJDataBase sharedDataBase] addData:model];
        [self showNum];
        [self.tableView reloadData];
    }
    _scanField.text = @"";
    [_scanField resignFirstResponder];
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
    
    cell.leftLabel.text = _resultArray[indexPath.row];
    cell.rightLabel.text = _clientCode;
    
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
            
            backModel *model = [[backModel alloc] init];
            model.ScanCode = _resultArray[selectIndex.row];
            model.ClientCode = _clientCode;
            model.UserID = GET_DEFAULT(@"UserID");
//            model.Tag = @"0";
            [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
            
            [_resultArray removeObjectAtIndex:selectIndex.row];
            //删除行
            [_tableView deleteRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationLeft];
            [self showNum];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}


//件箱托数字
- (void)showNum
{
    int a = 0;
    int b = 0;
    int c = 0;
    
    for (NSString *resultString in _resultArray) {
        if (resultString.length == 8) {
            a++;
        }
        if (resultString.length == 10) {
            b++;
        }
        if (resultString.length == 12) {
            c++;
        }
    }
    
    _jianNumLabel.text = [NSString stringWithFormat:@"%d",c];
    _xiangNumLabel.text = [NSString stringWithFormat:@"%d",b];
    _tuoNumLabel.text = [NSString stringWithFormat:@"%d",a];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_scanField resignFirstResponder];
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
