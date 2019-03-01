//
//  QRCodeScanVC.h
//  微码出入库
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaseViewController.h"


@protocol ScanCodeDelegate <NSObject>

- (void)getScanCode:(NSMutableArray *)codeArray;

@end

@interface QRCodeScanVC : UIViewController<ScanCodeDelegate>

@property (nonatomic, strong)  NSMutableArray *scanSendArray;//存储码

//@property (nonatomic, strong) UILabel *showScanLab;//显示扫描的结果动画

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *scanFor;


@property (nonatomic, strong) NSString *scanCode;
@property (nonatomic, strong) NSString *strBatch;
@property (nonatomic, strong) NSString *goodsCode;
@property (nonatomic, strong) NSString *clientCode;
@property (nonatomic, strong) NSString *orderCode;


@property (nonatomic,assign) id<ScanCodeDelegate>delegate;
@end
