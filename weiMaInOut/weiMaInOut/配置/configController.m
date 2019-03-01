//
//  configController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "configController.h"

@interface configController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *subTitleArray;

@property (nonatomic, strong)NSMutableArray *configArray;

@property (nonatomic, strong)UITableViewCell *cell;

@end

@implementation configController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitle.text = @"参数配置";
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        NSArray *array = [[NSArray alloc] initWithArray:_configArray];
        SET_DEFAULT(array, @"config");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    _titleArr = @[@"企业信息",@"条码管理",@"远程服务"];
    _subTitleArray = @[@[@"企业代号",@"Account",@"Pwd"],@[@"物流码长度",@"物流码正则表达式"],@[@"是否启用数据通讯地址",@"数据通讯地址"]];
    
    _configArray = [NSMutableArray new];
    [self getData];
    [self customUI];

}

- (void)getData
{
//    NSMutableArray *array1 = [[NSMutableArray alloc] init];
//    [array1 addObject:@"企业代号"];
//    [array1 addObject:@"Account"];
//    [array1 addObject:@"Pwd"];
//    NSMutableArray *array2 = [[NSMutableArray alloc] init];
//    [array2 addObject:@"物流码长度"];
//    [array2 addObject:@"物流码正则表达式"];
//    NSMutableArray *array3 = [[NSMutableArray alloc] init];
//    [array3 addObject:@"是否启用数据通讯地址"];
//    [array3 addObject:@"数据通讯地址"];
//    
//    [_subTitleArray addObject:array1];
//    [_subTitleArray addObject:array2];
//    [_subTitleArray addObject:array3];
//    NSLog(@"_subTitleArray====%@",_subTitleArray);
    


    
    NSArray *array = GET_DEFAULT(@"config");
    NSLog(@"%@",array);
    if (array) {
        _configArray = [[NSMutableArray alloc] initWithArray:array];
    }
    
    NSLog(@"_configArray====%@",_configArray);
}


- (void)customUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navView.height, kScreenWidth, kScreenHeight-self.navView.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _titleArr[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"Cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(_cell==nil){
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    NSMutableArray *array = _subTitleArray[indexPath.section];
    _cell.textLabel.text = array[indexPath.row];
    
    NSMutableArray *array1 = _configArray[indexPath.section];
    _cell.detailTextLabel.text = array1[indexPath.row];
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        _cell.detailTextLabel.text = @"";
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        NSString *str = [array1 objectAtIndex:indexPath.row-1];
        NSLog(@"str===%@",str);
        if ([str isEqualToString:@"0"])
        {
            _cell.textLabel.textColor = [UIColor lightGrayColor];
            _cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            _cell.userInteractionEnabled = NO;
        } else
        {
            _cell.textLabel.textColor = [UIColor blackColor];
            _cell.detailTextLabel.textColor = [UIColor blackColor];
            _cell.userInteractionEnabled = YES;
        }
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.textLabel.text);
    
    NSMutableArray *array = _configArray[indexPath.section];
    NSLog(@"%@",array);
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([[array objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
            [arr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            [_configArray replaceObjectAtIndex:indexPath.section withObject:arr];
//            NSLog(@"_configArray====%@",_configArray);
            [tableView reloadData];
        } else
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
            [arr replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [_configArray replaceObjectAtIndex:indexPath.section withObject:arr];
//            NSLog(@"_configArray====%@",_configArray);
            [tableView reloadData];
        }
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",cell.textLabel.text] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.text = cell.detailTextLabel.text;
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * field = textfields[0];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
            [arr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@",field.text]];
            [_configArray replaceObjectAtIndex:indexPath.section withObject:arr];
//            NSLog(@"_configArray====%@",_configArray);
            [tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        if (indexPath.section == 1 && indexPath.row == 0) {
            alertController.message = @"如有多种，请以逗号隔开";
        }
        
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
