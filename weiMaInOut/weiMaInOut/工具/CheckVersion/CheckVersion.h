//
//  CheckVersion.h
//  微码出入库
//
//  Created by ZJ on 16/10/20.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckVersion : NSObject

+ (NSString *)check_LocalApp_Version;

+ (void )check_APP_UPDATE_WITH_APPID:(NSString *)appid;

@end
