//
//  ZJSearchViewController.m
//  微码出入库
//
//  Created by ZJ on 16/9/24.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "ZJSearchViewController.h"

#import "productModel.h"
#import "batchModel.h"
#import "clientModel.h"

@interface ZJSearchViewController ()
@property (nonatomic, strong)NSMutableArray *resultArray;

@property (nonatomic, strong)NSMutableArray *productArray;
@property (nonatomic, strong)NSMutableArray *batchArray;
@property (nonatomic, strong)NSMutableArray *clientInfoArray;

@property (nonatomic, strong)NSString *passString;
@property (nonatomic, strong)NSString *passType;

@end

@implementation ZJSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _resultArray = [[NSMutableArray alloc] init];
        _productArray = [[NSMutableArray alloc] init];
        _batchArray = [[NSMutableArray alloc] init];
        _clientInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productData:) name:@"product" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(batchData:) name:@"batch" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clientData:) name:@"client" object:nil];
    
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)productData:(NSNotification *)notification
{
    [_productArray removeAllObjects];
    productModel *tmpModel = [productModel new];
    tmpModel.UserID = GET_DEFAULT(@"UserID");
    NSArray *array = [[ZJDataBase sharedDataBase] getDataByUserID:tmpModel];
    for (productModel *model in array) {
        [_productArray addObject:[NSString stringWithFormat:@"%@-%@",model.GoodsCode,model.GoodsName]];
    }

    _passString = notification.userInfo[@"data"];
    _passType = notification.userInfo[@"type"];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", _passString];
    
    if (_resultArray!= nil) {
        [_resultArray removeAllObjects];
    }
    //过滤数据
    _resultArray= [NSMutableArray arrayWithArray:[_productArray filteredArrayUsingPredicate:preicate]];
    
    [self.tableView reloadData];
}


- (void)batchData:(NSNotification *)notification
{
    [_batchArray removeAllObjects];
    _passString = notification.userInfo[@"data"];
    _passType = notification.userInfo[@"type"];
    NSString *str = [_passString componentsSeparatedByString:@"-"][0];
    
    batchModel *tmpModel = [batchModel new];
    tmpModel.UserID = GET_DEFAULT(@"UserID");
    NSArray *array = [[ZJDataBase sharedDataBase] getDataByUserID:tmpModel];
    for (batchModel *model in array) {
        if ([str isEqualToString:model.GoodsCode]) {
            [_batchArray addObject:[NSString stringWithFormat:@"%@",model.StrBatch]];
        }
    }
    _resultArray = [NSMutableArray arrayWithArray:_batchArray];
    [self.tableView reloadData];
}

- (void)clientData:(NSNotification *)notification
{
    [_clientInfoArray removeAllObjects];
    clientModel *tmpModel = [clientModel new];
    tmpModel.UserID = GET_DEFAULT(@"UserID");
    NSArray *array = [[ZJDataBase sharedDataBase] getDataByUserID:tmpModel];
    for (clientModel *model in array) {
        [_clientInfoArray addObject:[NSString stringWithFormat:@"%@-%@",model.ClientCode,model.ClientName]];
    }
    _passString = notification.userInfo[@"data"];
    _passType = notification.userInfo[@"type"];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", _passString];
    
    if (_resultArray!= nil) {
        [_resultArray removeAllObjects];
    }
    //过滤数据
    _resultArray= [NSMutableArray arrayWithArray:[_clientInfoArray filteredArrayUsingPredicate:preicate]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.textLabel.text = _resultArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *resultString = _resultArray[indexPath.row];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:resultString forKey:@"result"];

    if ([_passType isEqualToString:@"product"])
    {
        [dic setObject:@"product" forKey:@"type"];
    }
    if ([_passType isEqualToString:@"batch"])
    {
        [dic setObject:@"batch" forKey:@"type"];
    }
    if ([_passType isEqualToString:@"client"])
    {
        [dic setObject:@"client" forKey:@"type"];
    }
    NSLog(@"%@",dic);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resultString" object:nil userInfo:dic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
