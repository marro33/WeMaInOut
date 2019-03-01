//
//  checkController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "checkController.h"

#import "checkInController.h"
#import "checkOutController.h"
#import "checkBackController.h"

@interface checkController ()
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation checkController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navTitle.text = @"数据查询";
    
    _imageArray = @[@"icon1",@"icon2",@"icon3"];
    [self customUI];
}

- (void)customUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height+10, kScreenWidth, (kScreenWidth-60)/3.0 + 40)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    int index = 100;
    for (int i =0 ; i< 3; i++) {
        UIButton *menuItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuItemBtn.frame = CGRectMake(20 + ((kScreenWidth-60)/3.0 + 10)*i , 20, (kScreenWidth-60)/3.0, (kScreenWidth-60)/3.0);
        menuItemBtn.tag = index++;
        [menuItemBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_imageArray[i]]] forState:UIControlStateNormal];
        [menuItemBtn addTarget:self action:@selector(selectMenuItem:) forControlEvents:UIControlEventTouchUpInside];
            
        [imageView addSubview:menuItemBtn];
    }
}

- (void)selectMenuItem:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [self.navigationController pushViewController:[checkInController new] animated:YES];
            break;
        case 101:
            [self.navigationController pushViewController:[checkOutController new] animated:YES];
            break;
        case 102:
            [self.navigationController pushViewController:[checkBackController new] animated:YES];
            break;
        default:
            break;
    }
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
