//
//  baseViewController.h
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseViewController : UIViewController
@property (nonatomic, strong) UIButton *navLeftBtn;//导航栏左按钮
@property (nonatomic, strong) UIButton *navRightBtn;//导航栏右按钮
@property (nonatomic, strong) UIView *navView;//定义导航栏
@property (nonatomic, strong) UILabel *navTitle;//显示导航栏标题
@property (nonatomic,assign) CGFloat navHeight;//记录导航栏高度

-(void)createNavigationBarLeftBtnTitle:(NSString *)leftBtnTitle LeftBtnImage:(NSString *)leftBtnImage action:(void(^)())btnClickBlock;

-(void)createNavigationBarRightBtnTitle:(NSString *)rightBtnTitle RightBtnImage:(NSString *)rightBtnImage action:(void(^)())btnClickBlock;

@end
