//
//  downController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "downController.h"

#import "clientModel.h"
#import "productModel.h"
#import "batchModel.h"

@interface downController ()


@property (nonatomic, strong) NSMutableArray *downArray;

@property (nonatomic, strong) NSMutableArray *clientInfoArray;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) NSMutableArray *batchArray;



@end

@implementation downController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navTitle.text = @"数据下载";
    
    _downArray = [NSMutableArray new];
    
    _clientInfoArray = [NSMutableArray new];
    _productArray = [NSMutableArray new];
    _batchArray = [NSMutableArray new];
    
    [self customUI];
}

- (void)customUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height + 10, kScreenWidth, 50)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    label.text = @"请选择要下载的数据:";
    label.font =Font_Sys_18;
    [imageView addSubview:label];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.bottom + 5, kScreenWidth, 50)];
    imageView1.backgroundColor = [UIColor whiteColor];
    imageView1.userInteractionEnabled = YES;
    [self.view addSubview:imageView1];
    
    ZJButton *selectBtn1 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn1 setTitle:@"下载目标客户信息" forState:UIControlStateNormal];
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
    [selectBtn2 setTitle:@"下载产品信息" forState:UIControlStateNormal];
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
    [selectBtn3 setTitle:@"下载批次信息" forState:UIControlStateNormal];
    [selectBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn3.tag = 103;
    [selectBtn3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView3 addSubview:selectBtn3];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(5, imageView3.bottom + 40, kScreenWidth-10, 40);
    [downBtn setBackgroundImage:[UIImage imageNamed:@"denglubutton"] forState:UIControlStateNormal];
    downBtn.layer.cornerRadius = 10.0;
    downBtn.layer.masksToBounds = YES;
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
}

- (void)selectBtn:(UIButton *)selectBtn
{
    if (selectBtn.selected == YES) {
        [_downArray removeObject:selectBtn.currentTitle];
        selectBtn.selected = NO;
        
    } else
    {
        [_downArray addObject:selectBtn.currentTitle];
        selectBtn.selected = YES;
    }
}

//下载数据
- (void)downBtn
{
    if (_downArray.count != 0) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[requestManager sharedManager].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [WToast showWithText:@"请连接网络"];
            } else {
                if (_downArray.count != 0) {
                    if (_downArray.count == 1) {
                        [self downloadData:_downArray[0]];
                    } else
                    {
                        for (int i = 0; i<_downArray.count; i++) {
                        [self downloadData:_downArray[i]];
                        }
                    }
                }
            }
        }];
    } else
    {
        [WToast showWithText:@"请先选择类型"];
    }
}

- (void)downloadData:(NSString *)titleName
{
    
    NSArray *configArray = GET_DEFAULT(@"config");
    NSString *userID = GET_DEFAULT(@"UserID");
    NSString *userType = GET_DEFAULT(@"UserType");
    SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"LogisticsApi"];
    SoapService *soaprequest=[[SoapService alloc] init];
    soaprequest.PostUrl=configArray[2][1];
    
    if ([titleName isEqualToString:@"下载目标客户信息"]) {
        [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在下载"];
        NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{\"UserID\":\"%@\"}}}",configArray[0][0],configArray[0][1],configArray[0][2],userID];
        NSDictionary *parasDic = @{@"Json":jsonString};
        
        NSString *methodName=@"Down_infoCustoms";
        NSString *postData=[soaputility BuildSoapwithMethodName:@"Down_infoCustoms" withParas:parasDic];
        
        soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
        [soaprequest PostAsync:postData Success:^(NSString *response) {
            parseData *info = [[parseData alloc] initWithData:response withName:@"Down_infoCustomsResult"];
            NSDictionary *responseDic = info.resultDic[@"Response"];
            NSDictionary *header = responseDic[@"Header"];
            NSString *errorCode = header[@"ErrorCode"];
            NSArray *bodyArray = responseDic[@"Body"];
            
            if ([errorCode isEqualToString:@"00"]) {
                clientModel *tmpModel = [[clientModel alloc] init];
                tmpModel.UserID = GET_DEFAULT(@"UserID");
                [[ZJDataBase sharedDataBase] deleteAllDataByUserID:tmpModel];
                for (int i = 0; i<bodyArray.count; i++) {
                    clientModel *model = [[clientModel alloc] init];
                    
                    model.ClientCode = bodyArray[i][@"ClientCode"];
                    model.ClientName = bodyArray[i][@"ClientName"];
                    model.Type = userType;
                    model.UserID = userID;
                    [_clientInfoArray addObject:model];
                    [[ZJDataBase sharedDataBase] addData:model];
                }
//                for (clientModel *model in _clientInfoArray) {
//                    NSLog(@"%@==%@==%@==%@",model.ClientCode,model.ClientName,model.Type,model.UserID);
//                }
                [WToast showWithText:@"下载成功"];
                [LCProgressHUD hide];
            } else {
                [WToast showWithText:header[@"ErrorMsg"]];
                [LCProgressHUD hide];
            }
        } falure:^(NSError *response) {
            [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"请检查网络"];
        }];
    }
    
    if ([titleName isEqualToString:@"下载产品信息"]) {
        [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在下载"];
        NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{}}}",configArray[0][0],configArray[0][1],configArray[0][2]];
        
        NSDictionary *parasDic = @{@"Json":jsonString};
        
        NSString *methodName=@"Down_infoGoods";
        NSString *postData=[soaputility BuildSoapwithMethodName:@"Down_infoGoods" withParas:parasDic];
        
        soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
        [soaprequest PostAsync:postData Success:^(NSString *response) {
            parseData *info = [[parseData alloc] initWithData:response withName:@"Down_infoGoodsResult"];
            
            NSDictionary *responseDic = info.resultDic[@"Response"];
            NSDictionary *header = responseDic[@"Header"];
            NSString *errorCode = header[@"ErrorCode"];
            NSArray *bodyArray = responseDic[@"Body"];
            
            if ([errorCode isEqualToString:@"00"]) {
                productModel *tmpModel = [[productModel alloc] init];
                tmpModel.UserID = userID;
                [[ZJDataBase sharedDataBase] deleteAllDataByUserID:tmpModel];
                for (int i = 0; i<bodyArray.count; i++) {
                    productModel *model = [[productModel alloc] init];
                    
                    model.GoodsCode = bodyArray[i][@"GoodsCode"];
                    model.GoodsName = bodyArray[i][@"GoodsName"];
                    model.UserID = userID;
                    [_productArray addObject:model];
                    [[ZJDataBase sharedDataBase] addData:model];
                }
//                for (productModel *model in _productArray) {
//                    NSLog(@"%@==%@==%@",model.GoodsCode,model.GoodsName,model.UserID);
//                }
                [WToast showWithText:@"下载成功"];
                [LCProgressHUD hide];
            } else {
                
                [WToast showWithText:header[@"ErrorMsg"]];
                [LCProgressHUD hide];
            }
        } falure:^(NSError *response) {
            [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"请检查网络"];
        }];
        
    }
    
    if ([titleName isEqualToString:@"下载批次信息"]) {
        [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在下载"];
        NSString *jsonString = [NSString stringWithFormat:@"{\"Request\":{\"Header\":{\"CorpCode\":\"%@\",\"Account\":\"%@\",\"Pwd\":\"%@\"},\"Body\":{}}}",configArray[0][0],configArray[0][1],configArray[0][2]];
        
        NSDictionary *parasDic = @{@"Json":jsonString};
        
        NSString *methodName=@"Down_infoBatch";
        NSString *postData=[soaputility BuildSoapwithMethodName:@"Down_infoBatch" withParas:parasDic];
        
        soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
        [soaprequest PostAsync:postData Success:^(NSString *response) {
            parseData *info = [[parseData alloc] initWithData:response withName:@"Down_infoBatchResult"];
            
            NSDictionary *responseDic = info.resultDic[@"Response"];
            NSDictionary *header = responseDic[@"Header"];
            NSString *errorCode = header[@"ErrorCode"];
            NSArray *bodyArray = responseDic[@"Body"];
            
            if ([errorCode isEqualToString:@"00"]) {
                batchModel *tmpModel = [[batchModel alloc] init];
                tmpModel.UserID = userID;
                [[ZJDataBase sharedDataBase] deleteAllDataByUserID:tmpModel];
                for (int i = 0; i<bodyArray.count; i++) {
                    batchModel *model = [[batchModel alloc] init];
                    
                    model.GoodsCode = bodyArray[i][@"GoodsCode"];
                    model.StrBatch = bodyArray[i][@"StrBatch"];
                    model.UserID = userID;
                    [_batchArray addObject:model];
                    [[ZJDataBase sharedDataBase] addData:model];
                }
//                for (batchModel *model in _batchArray) {
//                    NSLog(@"%@==%@==%@",model.GoodsCode,model.StrBatch,model.UserID);
//                }
                [WToast showWithText:@"下载成功"];
                [LCProgressHUD hide];
            } else {
                
                [WToast showWithText:header[@"ErrorMsg"]];
                [LCProgressHUD hide];
            }
        } falure:^(NSError *response) {
            [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"请检查网络"];
        }];
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
