//
//  appSetting.h
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#ifndef appSetting_h
#define appSetting_h


#define GET_DEFAULT(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]

#define SET_DEFAULT(obj,key) \
[[NSUserDefaults standardUserDefaults] setObject:(obj) forKey:(key)];\
[[NSUserDefaults standardUserDefaults] synchronize];

#define DEL_DEFAULT(key)    \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:(key)]; \
[[NSUserDefaults standardUserDefaults] synchronize];


//屏幕宽
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height


#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define Font_Sys_12  [UIFont systemFontOfSize:12.0]
#define Font_Sys_14  [UIFont systemFontOfSize:14.0]
#define Font_Sys_15  [UIFont systemFontOfSize:15.0]
#define Font_Sys_18  [UIFont systemFontOfSize:18.0]

#define Font_Bold_15 [UIFont boldSystemFontOfSize:15.0]
#define Font_Bold_16 [UIFont boldSystemFontOfSize:16.0]




#endif /* appSetting_h */
