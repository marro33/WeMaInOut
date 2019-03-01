//
//  ZJDataBase.h
//  bbb
//
//  Created by ZJ on 16/9/27.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseModel.h"

@interface ZJDataBase : NSObject
//创建单例对象
+ (instancetype)sharedDataBase;
//添加对象
- (void)addData:(baseModel *)item;
//更新数据
//- (void)updataInfo:(baseModel *)item;
//判断数据是否存在
- (BOOL)dataIsExist:(baseModel *)item;


//根据userID删除全部信息
- (void)deleteAllDataByUserID:(baseModel *)item;
//根据字段删除单条信息
- (void)deleteSingleDataByParam:(baseModel *)item;


//根据userID获取全部信息
- (NSMutableArray *)getDataByUserID:(baseModel *)item;
//根据字段获取全部信息（模糊查询）
- (NSMutableArray *)getDataByParam:(baseModel *)item;
//根据字段获取全部条码（详细查询）
- (NSMutableArray *)getExactDataByParam:(baseModel *)item;


@end
