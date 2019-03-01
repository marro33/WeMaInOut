//
//  requestManager.m
//  微码出入库
//
//  Created by ZJ on 16/10/12.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "requestManager.h"
static requestManager *_sharedManager = nil;
@implementation requestManager

+ (AFHTTPSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [requestManager manager];
        _sharedManager.requestSerializer.timeoutInterval = 60;
        [_sharedManager.requestSerializer  setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    });
    return _sharedManager;
}



@end
