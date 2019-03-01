//
//  requestManager.h
//  微码出入库
//
//  Created by ZJ on 16/10/12.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface requestManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedManager;
@end
