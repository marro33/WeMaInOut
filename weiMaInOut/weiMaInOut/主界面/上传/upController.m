//
//  upController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "upController.h"

#import "inModel.h"
#import "outModel.h"
#import "backModel.h"

@interface upController ()

@property (nonatomic, strong) NSMutableArray *upArray;

@end

@implementation upController
{
    int flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navTitle.text = @"数据上传";
    
    _upArray = [[NSMutableArray alloc] init];
    
    flag = 0;
    [self customUI];
}

- (void)customUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height + 10, kScreenWidth, 50)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    label.text = @"请选择要上传的数据:";
    label.font =Font_Sys_18;
    [imageView addSubview:label];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.bottom + 5, kScreenWidth, 50)];
    imageView1.backgroundColor = [UIColor whiteColor];
    imageView1.userInteractionEnabled = YES;
    [self.view addSubview:imageView1];
    
    ZJButton *selectBtn1 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn1 setTitle:@"上传入库数据" forState:UIControlStateNormal];
    [selectBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn1 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn1 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn1.tag = 101;
    [selectBtn1 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView1 addSubview:selectBtn1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView1.bottom + 5, kScreenWidth, 50)];
    imageView2.backgroundColor = [UIColor whiteColor];
    imageView2.userInteractionEnabled = YES;
    [self.view addSubview:imageView2];
    
    ZJButton *selectBtn2 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn2 setTitle:@"上传出库数据" forState:UIControlStateNormal];
    [selectBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn2 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn2 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn2.tag = 102;
    [selectBtn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:selectBtn2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView2.bottom + 5, kScreenWidth, 50)];
    imageView3.backgroundColor = [UIColor whiteColor];
    imageView3.userInteractionEnabled = YES;
    [self.view addSubview:imageView3];
    
    ZJButton *selectBtn3 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn3 setTitle:@"上传退库数据" forState:UIControlStateNormal];
    [selectBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn3.tag = 103;
    [selectBtn3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView3 addSubview:selectBtn3];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(5, imageView3.bottom + 40, kScreenWidth-10, 40);
    [upBtn setBackgroundImage:[UIImage imageNamed:@"denglubutton"] forState:UIControlStateNormal];
    upBtn.layer.cornerRadius = 10.0;
    upBtn.layer.masksToBounds = YES;
    [upBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(upBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
    
}

- (void)selectBtn:(UIButton *)selectBtn
{
    if (selectBtn.selected == YES) {
        [_upArray removeObject:selectBtn.currentTitle];
        selectBtn.selected = NO;
        
    } else
    {
        [_upArray addObject:selectBtn.currentTitle];
        selectBtn.selected = YES;
    }
}

- (void)upBtn
{
    if (_upArray.count != 0) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [[requestManager sharedManager].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [WToast showWithText:@"请连接网络"];
            } else {
                flag = 0;
                
                if (_upArray.count == 1) {
                    [self uploadData:_upArray[0]];
                    
                } else
                {
                    for (int i = 0; i<_upArray.count; i++) {
                        [self uploadData:_upArray[i]];
                    }
                }
            }
        }];
    } else
    {
        [WToast showWithText:@"请先选择类型"];
    }
}

//上传服务器
- (void)uploadData:(NSString *)titleName
{
    NSArray *configArray = GET_DEFAULT(@"config");
    NSString *userID = GET_DEFAULT(@"UserID");
    SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"LogisticsApi"];
    SoapService *soaprequest=[[SoapService alloc] init];
    soaprequest.PostUrl=configArray[2][1];
    
    if ([titleName isEqualToString:@"上传入库数据"]) {
        [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在上传"];
        if (flag == 1) {
            return;
        }
        inModel *model = [[inModel alloc] init];
        model.UserID = userID;
//        model.Tag = @"0";
        model.ScanCode = @"";
        model.StrBatch = @"";
        model.GoodsCode = @"";
        NSMutableArray *dataArray = [[ZJDataBase sharedDataBase] getDataByParam:model];//所有未上传的数据
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (inModel *tmpModel in dataArray) {
            NSMutableArray *batchArr = [NSMutableArray new];
            
            for (inModel *tmpModel1 in dataArray) {
                if ([tmpModel.GoodsCode isEqualToString:tmpModel1.GoodsCode]) {
                    [batchArr addObject:tmpModel1.StrBatch];
                }
            }
            batchArr = [[NSMutableArray alloc] initWithArray:[[NSSet setWithArray:batchArr] allObjects]];
            [dic setObject:batchArr forKey:tmpModel.GoodsCode];
        }
        NSLog(@"%@",dic);//一个字典key＝产品编号 value＝批次号数组
        
        NSArray *goodsCodeArray = [dic allKeys];
        if (goodsCodeArray.count == 0) {
            [WToast showWithText:@"暂无可上传数据"];
            [LCProgressHUD hide];
            return;
        }
        for (NSString *goodsCodeStr in goodsCodeArray) {
            NSArray *arr = [dic objectForKey:goodsCodeStr];
            for (NSString *batchStr in arr) {
                NSMutableArray *scanCodeArray = [NSMutableArray new];
                for (inModel *tmpModel in dataArray) {
                    if ([goodsCodeStr isEqualToString:tmpModel.GoodsCode] && [batchStr isEqualToString:tmpModel.StrBatch]) {
                        [scanCodeArray addObject:tmpModel.ScanCode];
                    }
                }
//                NSLog(@"scanCodeArray=%@",scanCodeArray);//同一个产品编号＋批次号下的物流码数组
                NSString *jsonStr = @"[";
                for (NSInteger i = 0; i < scanCodeArray.count; ++i) {
                    if (i != 0) {
                        jsonStr = [jsonStr stringByAppendingString:@","];
                    }
                    jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"\'%@\'",scanCodeArray[i]]];
                }
                jsonStr = [jsonStr stringByAppendingString:@"]"];
                
                NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{\"UserID\":\"%@\",\"StrBatch\":\"%@\",\"strJSONData\":%@,\"GoodsCode\":\"%@\"}}}",configArray[0][0],configArray[0][1],configArray[0][2],userID,batchStr,jsonStr,goodsCodeStr];
                
                NSDictionary *parasDic = @{@"Json":jsonString};
                NSString *methodName=@"Up_DataIn";
                NSString *postData=[soaputility BuildSoapwithMethodName:@"Up_DataIn" withParas:parasDic];
                
                soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
                
                ResponseData *result= [soaprequest PostSync:postData];
                NSLog(@"result.Content=%@",result.Content);
                
                parseData *info = [[parseData alloc] initWithData:result.Content withName:@"Up_DataInResult"];
                
                NSDictionary *responseDic = info.resultDic[@"Response"];
                NSDictionary *header = responseDic[@"Header"];
                NSString *errorCode = header[@"ErrorCode"];
                
                if ([errorCode isEqualToString:@"00"]) {
                    
                    for (int i = 0; i < scanCodeArray.count; i++) {
                        inModel *model = [inModel new];
                        model.UserID = userID;
                        model.ScanCode = scanCodeArray[i];
                        model.StrBatch = batchStr;
                        model.GoodsCode = goodsCodeStr;
//                        [[ZJDataBase sharedDataBase] updataInfo:model];
                        [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
                    }
                    [WToast showWithText:@"上传成功"];
                    [LCProgressHUD hide];
                } else {
                    [WToast showWithText:header[@"ErrorMsg"]];
                    flag = 1;
                    [LCProgressHUD hide];
                    break;
                }
            }
            if (flag == 1) {
                break;
            }
        }
        
    }
    if ([titleName isEqualToString:@"上传出库数据"]) {
        [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在上传"];
        if (flag == 1) {
            return;
        }
        outModel *model = [outModel new];
        model.UserID = userID;
//        model.Tag = @"0";
        model.ScanCode = @"";
        model.ClientCode = @"";
        model.OrderCode = @"";
        NSMutableArray *dataArray = [[ZJDataBase sharedDataBase] getDataByParam:model];//所有未上传的数据
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (outModel *tmpModel in dataArray) {
            NSMutableArray *scanCodeArr = [NSMutableArray new];
            
            for (outModel *tmpModel1 in dataArray) {
                if ([tmpModel.ClientCode isEqualToString:tmpModel1.ClientCode]) {
                    [scanCodeArr addObject:tmpModel1.OrderCode];
                }
            }
            scanCodeArr = [[NSMutableArray alloc] initWithArray:[[NSSet setWithArray:scanCodeArr] allObjects]];
            [dic setObject:scanCodeArr forKey:tmpModel.ClientCode];
        }
//        NSLog(@"%@",dic);//一个字典key＝客户编号 value＝物流码数组
        
        NSArray *clientCodeArray = [dic allKeys];
        if (clientCodeArray.count == 0) {
            [WToast showWithText:@"暂无可上传数据"];
            [LCProgressHUD hide];
            return;
        }
        for (NSString *clientCodeStr in clientCodeArray) {
            NSArray *arr = [dic objectForKey:clientCodeStr];
            for (NSString *orderStr in arr) {
                NSMutableArray *scanCodeArray = [NSMutableArray new];
                for (outModel *tmpModel in dataArray) {
//                    NSLog(@"%@=%@",tmpModel.ClientCode,tmpModel.OrderCode);
                    if ([clientCodeStr isEqualToString:tmpModel.ClientCode] && [orderStr isEqualToString:tmpModel.OrderCode]) {
                        [scanCodeArray addObject:tmpModel.ScanCode];
                    }
                }
//                NSLog(@"scanCodeArray=%@",scanCodeArray);//同一个产品编号＋批次号下的物流码数组
                NSString *jsonStr = @"[";
                for (NSInteger i = 0; i < scanCodeArray.count; ++i) {
                    if (i != 0) {
                        jsonStr = [jsonStr stringByAppendingString:@","];
                    }
                    jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"\'%@\'",scanCodeArray[i]]];
                }
                jsonStr = [jsonStr stringByAppendingString:@"]"];
                
                NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{\"UserID\":\"%@\",\"ClientCode\":\"%@\",\"strJSONData\":%@,\"Nos\":\"%@\"}}}",configArray[0][0],configArray[0][1],configArray[0][2],userID,clientCodeStr,jsonStr,orderStr];
                
                NSDictionary *parasDic = @{@"Json":jsonString};
                NSString *methodName=@"Up_DataOut";
                NSString *postData=[soaputility BuildSoapwithMethodName:@"Up_DataOut" withParas:parasDic];
                
                soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
                
                ResponseData *result= [soaprequest PostSync:postData];
                NSLog(@"result.Content=%@",result.Content);
                parseData *info = [[parseData alloc] initWithData:result.Content withName:@"Up_DataOutResult"];
                
                NSDictionary *responseDic = info.resultDic[@"Response"];
                NSDictionary *header = responseDic[@"Header"];
                NSString *errorCode = header[@"ErrorCode"];
                
                if ([errorCode isEqualToString:@"00"]) {
                    
                    for (int i = 0; i < scanCodeArray.count; i++) {
                        outModel *model = [outModel new];
                        model.UserID = userID;
                        model.ScanCode = scanCodeArray[i];
                        model.ClientCode = clientCodeStr;
                        model.OrderCode = orderStr;
//                        [[ZJDataBase sharedDataBase] updataInfo:model];
                        [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
                    }
                    [WToast showWithText:@"上传成功"];
                    [LCProgressHUD hide];
                } else {
                    [WToast showWithText:header[@"ErrorMsg"]];
                    flag = 1;
                    [LCProgressHUD hide];
                    break;
                }
            }
            if (flag == 1) {
                break;
            }
        }
        
    }
    if ([titleName isEqualToString:@"上传退库数据"]) {
        [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在上传"];
        if (flag == 1) {
            return;
        }
        backModel *model = [backModel new];
        model.UserID = userID;
//        model.Tag = @"0";
        model.ScanCode = @"";
        model.ClientCode = @"";
        NSMutableArray *dataArray = [[ZJDataBase sharedDataBase] getDataByParam:model];//所有未上传的数据
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (backModel *tmpModel in dataArray) {
            NSMutableArray *scanCodeArr = [NSMutableArray new];
            
            for (backModel *tmpModel1 in dataArray) {
                if ([tmpModel.ClientCode isEqualToString:tmpModel1.ClientCode]) {
                    [scanCodeArr addObject:tmpModel1.ScanCode];
                }
            }
            scanCodeArr = [[NSMutableArray alloc] initWithArray:[[NSSet setWithArray:scanCodeArr] allObjects]];
            [dic setObject:scanCodeArr forKey:tmpModel.ClientCode];
        }
//        NSLog(@"%@",dic);//一个字典key＝客户编号 value＝物流码数组
        
        NSArray *clientCodeArray = [dic allKeys];
        if (clientCodeArray.count == 0) {
            [WToast showWithText:@"暂无可上传数据"];
            [LCProgressHUD hide];
            return;
        }
        for (NSString *clientCodeStr in clientCodeArray) {
            NSArray *scanCodeArray = [dic objectForKey:clientCodeStr];
            NSString *jsonStr = @"[";
            for (NSInteger i = 0; i < scanCodeArray.count; ++i) {
                if (i != 0) {
                    jsonStr = [jsonStr stringByAppendingString:@","];
                }
                jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"\'%@\'",scanCodeArray[i]]];
            }
            jsonStr = [jsonStr stringByAppendingString:@"]"];
            
            NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{\"UserID\":\"%@\",\"ClientCode\":\"%@\",\"strJSONData\":%@}}}",configArray[0][0],configArray[0][1],configArray[0][2],userID,clientCodeStr,jsonStr];
            
            NSDictionary *parasDic = @{@"Json":jsonString};
            NSString *methodName=@"Up_DataBack";
            NSString *postData=[soaputility BuildSoapwithMethodName:@"Up_DataBack" withParas:parasDic];
            
            soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
            
            ResponseData *result= [soaprequest PostSync:postData];
            NSLog(@"result.Content=%@",result.Content);
            parseData *info = [[parseData alloc] initWithData:result.Content withName:@"Up_DataBackResult"];
            
            NSDictionary *responseDic = info.resultDic[@"Response"];
            NSDictionary *header = responseDic[@"Header"];
            NSString *errorCode = header[@"ErrorCode"];
            
            if ([errorCode isEqualToString:@"00"]) {
                
                for (int i = 0; i < scanCodeArray.count; i++) {
                    backModel *model = [backModel new];
                    model.UserID = userID;
                    model.ScanCode = scanCodeArray[i];
                    model.ClientCode = clientCodeStr;
//                    [[ZJDataBase sharedDataBase] updataInfo:model];
                    [[ZJDataBase sharedDataBase] deleteSingleDataByParam:model];
                }
                [WToast showWithText:@"上传成功"];
                [LCProgressHUD hide];
            } else {
                [WToast showWithText:header[@"ErrorMsg"]];
                flag = 1;
                [LCProgressHUD hide];
                break;
            }
        }
        if (flag == 1) {
            return;
        }
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
