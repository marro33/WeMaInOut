//
//  QRCodeScanVC.m
//  微码出入库
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "QRCodeScanVC.h"
#import "QRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "inModel.h"
#import "outModel.h"
#import "backModel.h"

#import "inNextController.h"
#import "outNextController.h"
#import "backNextController.h"

#define contentTitleColorStr @"666666"
@interface QRCodeScanVC ()
<QRCodeReaderViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate,
AVCaptureMetadataOutputObjectsDelegate,
UIGestureRecognizerDelegate,
UITableViewDelegate,
UITableViewDataSource>
{
    QRCodeReaderView * readview;//二维码扫描对象
    NSString *codeString;

}
@property (strong, nonatomic) CIDetector *detector;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, assign) BOOL isScrollBottom;
@end

@implementation QRCodeScanVC

- (void)getScanCode:(NSMutableArray *)codeArray
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    _scanSendArray = [[NSMutableArray alloc]init];
    
    [self initQRCodeScanView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, readview.upView.height+150+50, kScreenWidth, readview.downView.height-50) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(passString:) name:@"passString" object:nil];
}

//- (void)passString:(NSNotification *)notification
//{
//    NSString *str = notification.userInfo[@"type"];
//    
//    if ([str isEqualToString:@"pass"]) {
//        NSArray *arr = notification.userInfo[@"passString"];
//        _scanSendArray = [NSMutableArray arrayWithArray:arr];
//        [_tableView reloadData];
//        readview.scanNumLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_scanSendArray.count];
//    }
//}

-(void)dealloc{
    NSLog(@"释放内存");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark 初始化扫描
- (void)initQRCodeScanView{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:2.0 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}

- (NSString *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSString *tmpString = @"";
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            tmpString = [string substringWithRange:[match rangeAtIndex:i]];
            
            tmpString = [tmpString substringWithRange:NSMakeRange(1, tmpString.length-2)];
        }
    }
    return tmpString;
}

#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result{
    
    NSLog(@"result===%@",result);
    readview.is_Anmotion = YES;
    
    if(result.length>0){

        codeString = result;
        
        NSArray *config = GET_DEFAULT(@"config");
        NSArray *configArray = [config[1][0] componentsSeparatedByString:@","];
        NSString *configString = config[1][1];
        
        //新消息提示音
        SystemSoundID soundID;
        NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
        AudioServicesPlaySystemSound(soundID);
        
        
        if([self.scanSendArray containsObject:codeString]){
            [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"已存在或已被扫描"];
            return;
        }
        else{
            if ([_type isEqualToString:@"1"]) {
                [self.scanSendArray addObject:codeString];
                [readview stop];
                if(self.delegate && [self.delegate respondsToSelector:@selector(getScanCode:)]){
                    [self.delegate getScanCode:_scanSendArray];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            if ([_type isEqualToString:@"2"]) {
                if (![configArray containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)codeString.length]])
                {
                    NSString *string = [self matchString:codeString toRegexString:configString];
                    if (string.length == 0) {
                        [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"该码不符合要求"];
                        return;
                    } else {
                        codeString = string;
                    }
                }
                if ([_scanFor isEqualToString:@"in"]) {
                    inModel *model = [[inModel alloc] init];
                    model.ScanCode = codeString;
                    model.StrBatch = _strBatch;
                    model.GoodsCode = _goodsCode;
                    model.UserID = GET_DEFAULT(@"UserID");
                    if([_scanSendArray containsObject:codeString]||[[ZJDataBase sharedDataBase] dataIsExist:model]){
                        [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"已存在或已被扫描"];
                        return;
                    }
                    else{
                        [_scanSendArray addObject:codeString];
                        NSLog(@"扫描成功");
                        readview.scanNumLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_scanSendArray.count];
                        [_tableView reloadData];
                        if (_tableView.contentSize.height > _tableView.frame.size.height){
                            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height) animated:YES];
                        }
                        [readview stop];
                        [[ZJDataBase sharedDataBase] addData:model];
                        [self performSelector:@selector(reStartScan) withObject:self afterDelay:0.5];
                    }
                }
                if ([_scanFor isEqualToString:@"out"]) {
                    outModel *model = [[outModel alloc] init];
                    model.ScanCode = codeString;
                    model.ClientCode = _clientCode;
                    model.OrderCode = _orderCode;
                    model.UserID = GET_DEFAULT(@"UserID");
                    if([_scanSendArray containsObject:codeString]||[[ZJDataBase sharedDataBase] dataIsExist:model]){
                        [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"已存在或已被扫描"];
                        return;
                    }
                    else{
                        [_scanSendArray addObject:codeString];
                        NSLog(@"扫描成功");
                        readview.scanNumLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_scanSendArray.count];
                        [_tableView reloadData];
                        if (_tableView.contentSize.height > _tableView.frame.size.height){
                            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height) animated:YES];
                        }
                        [readview stop];
                        [[ZJDataBase sharedDataBase] addData:model];
                        [self performSelector:@selector(reStartScan) withObject:self afterDelay:0.5];
                    }
                }
                if ([_scanFor isEqualToString:@"back"]) {
                    backModel *model = [[backModel alloc] init];
                    model.ScanCode = codeString;
                    model.ClientCode = _clientCode;
                    model.UserID = GET_DEFAULT(@"UserID");
                    if([_scanSendArray containsObject:codeString]||[[ZJDataBase sharedDataBase] dataIsExist:model]){
                        [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"已存在或已被扫描"];
                        return;
                    }
                    else{
                        [_scanSendArray addObject:codeString];
                        NSLog(@"扫描成功");
                        readview.scanNumLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_scanSendArray.count];
                        [_tableView reloadData];
                        if (_tableView.contentSize.height > _tableView.frame.size.height){
                            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height) animated:YES];
                        }
                        [readview stop];
                        [[ZJDataBase sharedDataBase] addData:model];
                        [self performSelector:@selector(reStartScan) withObject:self afterDelay:0.5];
                    }
                }
            }
            if ([_type isEqualToString:@"3"]) {
                if (![configArray containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)codeString.length]])
                {
                    NSString *string = [self matchString:codeString toRegexString:configString];
                    if (string.length == 0) {
                        [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"该码不符合要求"];
                        return;
                    } else {
                        codeString = string;
                    }
                }
                [self.scanSendArray addObject:codeString];
                [readview stop];
                if(self.delegate && [self.delegate respondsToSelector:@selector(getScanCode:)]){
                    [self.delegate getScanCode:_scanSendArray];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self performSelector:@selector(reStartScan) withObject:self afterDelay:0.5];
        }
    }
}

- (void)reStartScan{
    readview.is_Anmotion = NO;
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (readview) {
        [self reStartScan];
    }
    
    [_scanSendArray removeAllObjects];
    readview.scanNumLab.text = @"";
    [_tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


-(void)backVCAction{
    [_scanSendArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextVCAction{
    if ([_scanFor isEqualToString:@"in"])
    {
        inNextController *inNext = [inNextController new];
//        inNext.passArray = _scanSendArray;
        inNext.strBatch = _strBatch;
        inNext.goodsCode = _goodsCode;
        [self.navigationController pushViewController:inNext animated:YES];

    }
    if ([_scanFor isEqualToString:@"out"])
    {
        outNextController *outNext = [outNextController new];
//        outNext.resultArray = _scanSendArray;
        outNext.orderCode = _orderCode;
        outNext.clientCode = _clientCode;
        [self.navigationController pushViewController:outNext animated:YES];

    }
    if ([_scanFor isEqualToString:@"back"])
    {
        backNextController *backNext = [backNextController new];
//        backNext.resultArray = _scanSendArray;
        backNext.clientCode = _clientCode;
        [self.navigationController pushViewController:backNext animated:YES];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scanSendArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.contentView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    cell.contentView.alpha = 0.6;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _scanSendArray[indexPath.row];
    
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
            
            if ([_scanFor isEqualToString:@"in"])
            {
                inModel *model = [[inModel alloc] init];
                model.ScanCode = _scanSendArray[selectIndex.row];
                model.StrBatch = _strBatch;
                model.GoodsCode = _goodsCode;
                model.UserID = GET_DEFAULT(@"UserID");
//                model.Tag = @"0";
                [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
            }
            
            if ([_scanFor isEqualToString:@"out"])
            {
                outModel *model = [[outModel alloc] init];
                model.ScanCode = _scanSendArray[selectIndex.row];
                model.ClientCode = _clientCode;
                model.OrderCode = _orderCode;
                model.UserID = GET_DEFAULT(@"UserID");
//                model.Tag = @"0";
                [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
            }
            
            if ([_scanFor isEqualToString:@"back"])
            {
                backModel *model = [[backModel alloc] init];
                model.ScanCode = _scanSendArray[selectIndex.row];
                model.ClientCode = _clientCode;
                model.UserID = GET_DEFAULT(@"UserID");
//                model.Tag = @"0";
                [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
            }
            
            [_scanSendArray removeObjectAtIndex:selectIndex.row];
            readview.scanNumLab.text = [NSString stringWithFormat:@"%d",_scanSendArray.count];
            //删除行
            [_tableView deleteRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationLeft];
            
            
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

//获取颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
