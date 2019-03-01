//
//  baseViewController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "baseViewController.h"
#import <objc/runtime.h>

static char *btnClickAction;
@interface baseViewController ()

@end

@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //禁止滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self  createNavigationTitle];
}

-(void)createNavigationTitle{
    self.navView = [[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.navView.frame=CGRectMake(0, 0, self.view.width, 44+20);
        
        
    }else{
        self.navView.frame=CGRectMake(0, 0, self.view.width, 44);
        
    }
    self.navView.backgroundColor = RGBACOLOR(235, 99, 25, 1);
    self.navHeight = self.navView.height;
    self.navTitle = [[UILabel alloc]initWithFrame:CGRectMake(100,self.navView.height-44+7,self.navView.width-200,30)];
    self.navTitle.font=Font_Bold_16;
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    self.navTitle.textColor = [UIColor whiteColor];
    [self.navView addSubview:self.navTitle];
    [self.view addSubview:self.navView];
}

-(void)createNavigationBarLeftBtnTitle:(NSString *)leftBtnTitle LeftBtnImage:(NSString *)leftBtnImage action:(void (^)())btnClickBlock{
    //左按钮
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navLeftBtn.frame = CGRectMake(5,20+(44-30)/2.0,50,30);
    if(leftBtnImage){
        [self.navLeftBtn setImage:[UIImage imageNamed:leftBtnImage] forState:UIControlStateNormal];
        self.navLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    if(leftBtnTitle){
        self.navLeftBtn.titleLabel.font = Font_Bold_15;
        [self.navLeftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
        [self.navLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
    }
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction,btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self.navView addSubview:self.navLeftBtn];
    [self.navLeftBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createNavigationBarRightBtnTitle:(NSString *)rightBtnTitle RightBtnImage:(NSString *)rightBtnImage action:(void (^)())btnClickBlock{
    
    //右按钮
    if(rightBtnImage){
        self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.navRightBtn.frame = CGRectMake(self.navView.width-60,self.navHeight-44+7,50, 30);
        [self.navRightBtn setImage:[UIImage imageNamed:rightBtnImage] forState:UIControlStateNormal];
    }
    else{
        self.navRightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.navRightBtn.frame = CGRectMake(self.navView.width-60,self.navHeight-44+7,50, 30);
    }
    if(rightBtnTitle){
        self.navRightBtn.titleLabel.font = Font_Bold_15;
        [self.navRightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
        [self.navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
    }
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction,btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self.navView addSubview:self.navRightBtn];
    [self.navRightBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -actionBtnClick
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
    btnClickBlock();
}

-(void)showNoDataView:(NSString *)text{
    UILabel *lable = (UILabel *)[self.view viewWithTag:320];
    if(!lable){
        UILabel *noDataLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight-30)/2.0, kScreenWidth, 30)];
        noDataLab.font = Font_Sys_15;
        noDataLab.tag = 320;
        noDataLab.textAlignment = NSTextAlignmentCenter;
        noDataLab.text = text;
        noDataLab.textColor = [UIColor darkGrayColor];
        [self.view addSubview:noDataLab];
        [self.view bringSubviewToFront:noDataLab];
    }
    else{
        lable.text = text;
    }
}

-(void)hidNoDataView{
    UILabel *lable = (UILabel *)[self.view viewWithTag:320];
    [lable removeFromSuperview];
    lable = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
