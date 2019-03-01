//
//  baseModel.h
//  微码出入库
//
//  Created by ZJ on 16/9/27.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baseModel : NSObject

@property (nonatomic, copy) NSString *ClientCode;//客户编号

@property (nonatomic, copy) NSString *ClientName;//客户姓名

@property (nonatomic, copy) NSString *Type;//用户类型

@property (nonatomic, copy) NSString *UserID;//用户id

@property (nonatomic, copy) NSString *GoodsCode;//商品编码

@property (nonatomic, copy) NSString *GoodsName;//商品名字

@property (nonatomic, copy) NSString *StrBatch;//商品批次号

@property (nonatomic, copy) NSString *ScanCode;//扫描的物流码

//@property (nonatomic, copy) NSString *Tag;//是否上传0未上传1已上传

@property (nonatomic, copy) NSString *OrderCode;//订单编号

@property (nonatomic, copy) NSString *UserName;//登录用户名

@property (nonatomic, copy) NSString *UserPwd;//登录密码


@end
