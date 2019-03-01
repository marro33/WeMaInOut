//
//  ZJDataBase.m
//  bbb
//
//  Created by ZJ on 16/9/27.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "ZJDataBase.h"

#import "userModel.h"

#import "clientModel.h"
#import "productModel.h"
#import "batchModel.h"

#import "inModel.h"
#import "outModel.h"
#import "backModel.h"


@implementation ZJDataBase
{
    FMDatabase * _dataBase;
//    FMDatabaseQueue *fmQueue;
}

//构造方法
- (id)init {
    if (self = [super init]) {
        //创建数据库，打开数据库，创建表单
        NSString * dataBasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/info2.db"];
        _dataBase = [FMDatabase databaseWithPath:dataBasePath];
        NSLog(@"%@",dataBasePath);
        BOOL ret = [_dataBase open];
        if (ret == NO) {
            NSLog(@"数据库创建失败");
            exit(-1);
        }
        //创建目标客户表单
        NSString * userInfoSql = @"CREATE TABLE IF NOT EXISTS tb_userinfo(ID integer primary key autoincrement, username VARCHAR(128), userpwd VARCHAR(1024), type VARCHAR(128), userid VARCHAR(128))";
        [_dataBase executeUpdate:userInfoSql];
        
        //创建目标客户表单
        NSString * clientInfoSql = @"CREATE TABLE IF NOT EXISTS tb_clientinfo(ID integer primary key autoincrement, clientcode VARCHAR(128), clientname VARCHAR(1024), type VARCHAR(128), userid VARCHAR(128))";
        [_dataBase executeUpdate:clientInfoSql];
        
        //创建产品信息表单
        NSString * productSql = @"CREATE TABLE IF NOT EXISTS tb_product(ID integer primary key autoincrement, goodscode VARCHAR(128), goodsname VARCHAR(1024), userid VARCHAR(128))";
        [_dataBase executeUpdate:productSql];
        
        //创建批次表单
        NSString * batchSql = @"CREATE TABLE IF NOT EXISTS tb_batch(ID integer primary key autoincrement, goodscode VARCHAR(128), strbatch VARCHAR(1024), userid VARCHAR(128))";
        [_dataBase executeUpdate:batchSql];
        
        //创建入库表单
        NSString * inSql = @"CREATE TABLE IF NOT EXISTS tb_in(ID integer primary key autoincrement, scancode VARCHAR(128), strbatch VARCHAR(1024), goodscode VARCHAR(1024), userid VARCHAR(128))";
        [_dataBase executeUpdate:inSql];
        
        //创建出库表单
        NSString * outSql = @"CREATE TABLE IF NOT EXISTS tb_out(ID integer primary key autoincrement, scancode VARCHAR(128), clientcode VARCHAR(1024), ordercode VARCHAR(1024), userid VARCHAR(128))";
        [_dataBase executeUpdate:outSql];
        
        //创建退库表单
        NSString * backSql = @"CREATE TABLE IF NOT EXISTS tb_back(ID integer primary key autoincrement, scancode VARCHAR(128), clientcode VARCHAR(1024), userid VARCHAR(128))";
        [_dataBase executeUpdate:backSql];
        
    }
    return self;
}

//单例
+ (instancetype)sharedDataBase
{
    static ZJDataBase * dataBase;
    //线程保护，表示只有前一个线程执行完这些语句，第二个线程才能开始执行
    //就像是上厕所，先进去的人会所门，后进去的人只能等先进去的人出来
    @synchronized(self){
        if (dataBase == nil) {
            dataBase = [[ZJDataBase alloc] init];
        }
    }
    return dataBase;
}

//增加信息
- (void)addData:(baseModel *)item {
    //增加用户
    if ([item isMemberOfClass:[userModel class]]) {
        NSString * sql = @"INSERT INTO tb_userinfo(username, userpwd, type, userid) VALUES(?, ?, ?, ?)";
        @synchronized(self){
            [_dataBase executeUpdate:sql, item.UserName, item.UserPwd, item.Type, item.UserID];
        }
    }
    
    //增加客户
    if ([item isMemberOfClass:[clientModel class]]) {
        NSString * sql = @"INSERT INTO tb_clientinfo(clientcode, clientname, type, userid) VALUES(?, ?, ?, ?)";
        @synchronized(self){
            [_dataBase executeUpdate:sql, item.ClientCode, item.ClientName, item.Type, item.UserID];
        }
    }
    //增加产品
    if ([item isMemberOfClass:[productModel class]]) {
        NSString * sql = @"INSERT INTO tb_product(goodscode, goodsname, userid) VALUES(?, ?, ?)";
        //将不是字符串的数据，转成字符串，因为通配符需要用字符串来填充
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:sql, item.GoodsCode, item.GoodsName, item.UserID];
        }
    }
    //增加批次
    if ([item isMemberOfClass:[batchModel class]]) {
        NSString * sql = @"INSERT INTO tb_batch(goodscode, strbatch, userid) VALUES(?, ?, ?)";
        //将不是字符串的数据，转成字符串，因为通配符需要用字符串来填充
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:sql, item.GoodsCode, item.StrBatch, item.UserID];
        }
    }
    
    //增加入库
    if ([item isMemberOfClass:[inModel class]]) {
            
        NSString * sql = @"INSERT INTO tb_in(scancode, strbatch, goodscode, userid) VALUES(?, ?, ?, ?)";
        //将不是字符串的数据，转成字符串，因为通配符需要用字符串来填充
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:sql, item.ScanCode, item.StrBatch, item.GoodsCode, item.UserID];
        }
    }
    
    //增加出库
    if ([item isMemberOfClass:[outModel class]]) {
        NSString * sql = @"INSERT INTO tb_out(scancode, clientcode, ordercode, userid) VALUES(?, ?, ?, ?)";
        //将不是字符串的数据，转成字符串，因为通配符需要用字符串来填充
        @synchronized(self){
        //调用SQL，保存数据到表单
        [_dataBase executeUpdate:sql, item.ScanCode, item.ClientCode, item.OrderCode, item.UserID];
        }
    }
    
    //增加退库
    if ([item isMemberOfClass:[backModel class]]) {
        NSString * sql = @"INSERT INTO tb_back(scancode, clientcode, userid) VALUES(?, ?, ?)";
        //将不是字符串的数据，转成字符串，因为通配符需要用字符串来填充
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:sql, item.ScanCode, item.ClientCode, item.UserID];
        }
    }
}

//根据userID删除全部信息
- (void)deleteAllDataByUserID:(baseModel *)item {
    
    if ([item isMemberOfClass:[userModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_userinfo where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    
    if ([item isMemberOfClass:[clientModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_clientinfo where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    
    if ([item isMemberOfClass:[productModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_product where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    
    if ([item isMemberOfClass:[batchModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_batch where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    if ([item isMemberOfClass:[inModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_in where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    if ([item isMemberOfClass:[outModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_out where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    if ([item isMemberOfClass:[backModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_back where userid = %@",item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
}

//根据字段删除单条信息
- (void)deleteSingleDataByParam:(baseModel *)item
{
    if ([item isMemberOfClass:[inModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_in where scancode = '%@' and strbatch = '%@' and goodscode = '%@' and userid = '%@'",item.ScanCode,item.StrBatch,item.GoodsCode,item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    if ([item isMemberOfClass:[outModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_out where scancode = '%@' and clientcode = '%@' and ordercode = '%@' and userid = '%@'",item.ScanCode,item.ClientCode,item.OrderCode,item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
    if ([item isMemberOfClass:[backModel class]]) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM tb_back where scancode = '%@' and clientcode = '%@' and userid = '%@'",item.ScanCode,item.ClientCode,item.UserID];
        @synchronized(self){
            //调用SQL，保存数据到表单
            [_dataBase executeUpdate:deleteSql];
        }
    }
}

//根据userID获取全部信息
- (NSMutableArray *)getDataByUserID:(baseModel *)item {
    
    if ([item isMemberOfClass:[clientModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_clientinfo WHERE userid = %@",item.UserID];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            clientModel * item = [[clientModel alloc] init];
            item.ClientCode = [set stringForColumn:@"clientcode"];
            item.ClientName = [set stringForColumn:@"clientname"];
            item.Type = [set stringForColumn:@"type"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[productModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_product WHERE userid = %@",item.UserID];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            productModel * item = [[productModel alloc] init];
            item.GoodsCode = [set stringForColumn:@"goodscode"];
            item.GoodsName = [set stringForColumn:@"goodsname"];
            item.UserID = [set stringForColumn:@"userid"];
            
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[batchModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_batch WHERE userid = %@",item.UserID];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            batchModel * item = [[batchModel alloc] init];
            item.GoodsCode = [set stringForColumn:@"goodscode"];
            item.StrBatch = [set stringForColumn:@"strbatch"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[inModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_in WHERE userid = %@",item.UserID];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            inModel * item = [[inModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            item.StrBatch = [set stringForColumn:@"strbatch"];
            item.GoodsCode = [set stringForColumn:@"goodscode"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[outModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_out WHERE userid = %@",item.UserID];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            outModel * item = [[outModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            item.ClientCode = [set stringForColumn:@"clientcode"];
            item.OrderCode = [set stringForColumn:@"ordercode"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[backModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_back WHERE userid = %@",item.UserID];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            backModel * item = [[backModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            item.ClientCode = [set stringForColumn:@"clientcode"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    return nil;
}


//模糊查询
- (NSMutableArray *)getDataByParam:(baseModel *)item
{
    if ([item isMemberOfClass:[userModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_userinfo WHERE username like '%%%@%%' and userpwd like '%%%@%%'",item.UserName,item.UserPwd];
        FMResultSet *set;
        NSMutableArray *array = [NSMutableArray new];
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next])
        {
            userModel * item = [[userModel alloc] init];
            item.UserName = [set stringForColumn:@"username"];
            item.UserPwd = [set stringForColumn:@"userpwd"];
            item.Type = [set stringForColumn:@"type"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }

    if ([item isMemberOfClass:[inModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_in WHERE scancode like '%%%@%%' and strbatch like '%%%@%%' and goodscode like '%%%@%%' and userid like '%%%@%%'",item.ScanCode,item.StrBatch,item.GoodsCode,item.UserID];
        FMResultSet *set;
        NSMutableArray *array = [NSMutableArray new];
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next])
        {
            inModel * item = [[inModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            item.StrBatch = [set stringForColumn:@"strbatch"];
            item.GoodsCode = [set stringForColumn:@"goodscode"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[outModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_out WHERE scancode like '%%%@%%' and clientcode like '%%%@%%' and ordercode like '%%%@%%' and userid like '%%%@%%'",item.ScanCode,item.ClientCode,item.OrderCode,item.UserID];
        FMResultSet *set;
        NSMutableArray *array = [NSMutableArray new];
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next]) {
            outModel * item = [[outModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            item.ClientCode = [set stringForColumn:@"clientcode"];
            item.OrderCode = [set stringForColumn:@"ordercode"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[backModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_back WHERE scancode like '%%%@%%' and clientcode like '%%%@%%' and userid like '%%%@%%'",item.ScanCode,item.ClientCode,item.UserID];
        FMResultSet *set;
        NSMutableArray *array = [NSMutableArray new];
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next]) {
            backModel * item = [[backModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            item.ClientCode = [set stringForColumn:@"clientcode"];
            item.UserID = [set stringForColumn:@"userid"];
            [array addObject:item];
        }
        return array;
    }
    return nil;
}

//根据字段获取全部条码（详细查询）
- (NSMutableArray *)getExactDataByParam:(baseModel *)item
{
    
    if ([item isMemberOfClass:[inModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_in WHERE userid = '%@' and strbatch = '%@' and goodscode = '%@'",item.UserID, item.StrBatch, item.GoodsCode];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            inModel * item = [[inModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            [array addObject:item.ScanCode];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[outModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_out WHERE userid = '%@' and clientcode = '%@' and ordercode = '%@'",item.UserID, item.ClientCode, item.OrderCode];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            outModel * item = [[outModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            [array addObject:item.ScanCode];
        }
        return array;
    }
    
    if ([item isMemberOfClass:[backModel class]]) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM tb_back WHERE userid = '%@' and clientcode = '%@'",item.UserID, item.ClientCode];
        FMResultSet * set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        NSMutableArray * array = [NSMutableArray array];
        while ([set next]) {
            backModel * item = [[backModel alloc] init];
            item.ScanCode = [set stringForColumn:@"scancode"];
            [array addObject:item.ScanCode];
        }
        return array;
    }
    return nil;

}

//判断数据是否存在
- (BOOL)dataIsExist:(baseModel *)item
{
    if ([item isMemberOfClass:[inModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_in WHERE userid = %@",item.UserID];
        FMResultSet *set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next]) {
            if ([[set stringForColumn:@"scancode"] isEqualToString:item.ScanCode]
                && [[set stringForColumn:@"strbatch"] isEqualToString:item.StrBatch]
                && [[set stringForColumn:@"goodscode"] isEqualToString:item.GoodsCode]) {
                return YES;
            }
        }
    }
    if ([item isMemberOfClass:[outModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_out WHERE userid = %@",item.UserID];
        FMResultSet *set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next]) {
            if ([[set stringForColumn:@"scancode"] isEqualToString:item.ScanCode]
                && [[set stringForColumn:@"clientcode"] isEqualToString:item.ClientCode]
                && [[set stringForColumn:@"ordercode"] isEqualToString:item.OrderCode]) {
                return YES;
            }
        }
    }
    if ([item isMemberOfClass:[backModel class]]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_back WHERE userid = %@",item.UserID];
        FMResultSet *set;
        @synchronized(self){
            set = [_dataBase executeQuery:sql];
        }
        while ([set next]) {
            if ([[set stringForColumn:@"scancode"] isEqualToString:item.ScanCode]
                && [[set stringForColumn:@"clientcode"] isEqualToString:item.ClientCode]) {
                return YES;
            }
        }
    }
    return NO;
}
/*
//修改数据
- (void)updataInfo:(baseModel *)item {

    if ([item isMemberOfClass:[inModel class]]) {
        NSString *sqlStr = [NSString stringWithFormat:@"update tb_in set tag = '%@' where scancode = '%@' and strbatch = '%@' and goodscode = '%@' and userid = '%@'", @"1",item.ScanCode, item.StrBatch, item.GoodsCode, item.UserID];
        @synchronized(self){
            [_dataBase executeUpdate:sqlStr];
        }
    }
    if ([item isMemberOfClass:[outModel class]]) {
        NSString *sqlStr = [NSString stringWithFormat:@"update tb_out set tag = '%@' where scancode = '%@' and clientcode = '%@' and ordercode = '%@' and userid = '%@'", @"1",item.ScanCode, item.ClientCode, item.OrderCode, item.UserID];
        @synchronized(self){
            [_dataBase executeUpdate:sqlStr];
        }
    }
    if ([item isMemberOfClass:[backModel class]]) {
        NSString *sqlStr = [NSString stringWithFormat:@"update tb_back set tag = '%@' where scancode = '%@' and clientcode = '%@' and userid = '%@'", @"1",item.ScanCode, item.ClientCode, item.UserID];
        @synchronized(self){
            [_dataBase executeUpdate:sqlStr];
        }
    }
}
*/

@end
