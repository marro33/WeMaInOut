//
//  CheckVersion.m
//  微码出入库
//
//  Created by ZJ on 16/10/20.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "CheckVersion.h"

NSString const *iTnuesApi = @"http://itunes.apple.com/lookup";

@implementation CheckVersion
+ (instancetype)check
{
    static CheckVersion *check = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        check = [[CheckVersion alloc]init];
    });
    
    return check;
}

+ (NSString *)check_LocalApp_Version;
{
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return localVersion;
}

+ (void )check_APP_UPDATE_WITH_APPID:(NSString *)appid
{
    __block id JSON = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *dataError = nil;
        NSString *appURLAPI = [NSString stringWithFormat:@"%@?id=%@",iTnuesApi,appid];
        NSData *appData = [NSData dataWithContentsOfURL:[NSURL URLWithString:appURLAPI] options:0 error:&dataError];
        if (dataError) {
            NSLog(@"appStore app版本信息请求错误！请重新尝试");
            return ;
        }
        JSON = [NSJSONSerialization JSONObjectWithData:appData options:0 error:nil];
        NSLog(@"ddd : %@",JSON);
        
        if ([[JSON objectForKey:@"resultCount"] intValue] > 0) {
            NSString *remoteVersion = [[[JSON objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
            NSString *releaseNotes = [[[JSON objectForKey:@"results"] objectAtIndex:0] objectForKey:@"releaseNotes"];
            NSString *trackURL = [[[JSON objectForKey:@"results"] objectAtIndex:0] objectForKey:@"trackViewUrl"];
            [[NSUserDefaults standardUserDefaults] setObject:trackURL forKey:@"KK_THE_APP_UPDATE_URL"];
            NSLog(@"%@ %@ %@",remoteVersion,releaseNotes,trackURL);
            
            NSString *localVersion = [self check_LocalApp_Version];
            NSLog(@"%f",[remoteVersion floatValue]);
            NSLog(@"%f",[localVersion floatValue]);
            if ([remoteVersion floatValue] > [localVersion floatValue]) {
                [[CheckVersion check] newVersionUpdate:remoteVersion notes:releaseNotes];
            }
            else
            {
                return;
            }
        }
        else
        {
            [self showAlertWithMessage:@"appStore 无此app信息，请检查您的 app id"];
            return ;
        }
    });
}



+ (void)showAlertWithMessage:(NSString *)messages
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:messages delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
#if !__has_feature(objc_arc)
        [alert release];
#endif
    });
    
}

- (void)newVersionUpdate:(NSString *)version notes:(NSString *)releaseNotes
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发现新版本 %@",version] message:releaseNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        [alert show];
        
#if !__has_feature(objc_arc)
        [alert release];
#endif
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //NSString *apiUrl = @"https://itunes.apple.com/us/app/wei-bo/id350962117?mt=8&uo=4";
        //apiUrl = @"itms-apps://itunes.apple.com/cn/app/wei-bo/id350962117?mt=8";
        NSString *theAppURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"KK_THE_APP_UPDATE_URL"];
        NSURL *appStoreURL = [NSURL URLWithString:theAppURL];
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}


@end
