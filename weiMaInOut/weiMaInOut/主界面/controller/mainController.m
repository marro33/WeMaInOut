//
//  mainController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "mainController.h"

#import "inController.h"
#import "outController.h"
#import "backController.h"
#import "checkController.h"
#import "upController.h"
#import "downController.h"
#import "delController.h"

#import "configController.h"

#import "weiMaInOut-Swift.h"
#import <UIKit/UIKit.h>

@interface mainController ()
@property (nonatomic, strong)NSArray *imageArray;
@end

@implementation mainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"退出" LeftBtnImage:nil action:^{

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alertController animated:YES completion:nil];

    }];

    self.navTitle.text = @"主界面";

    _imageArray = @[@[@"icon1",@"icon2"],@[@"icon3",@"icon4"],@[@"icon5",@"icon6"],@[@"icon7",@"icon8"],@[@"icon9",@""]];



    [self customUI];

}

- (void)customUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"bg.jpg"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];

    int index = 100;
    for (int i = 0; i< 5; i++) {
        for (int j = 0; j<2; j++) {
            UIButton *menuItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            menuItemBtn.frame = CGRectMake(50 + ((kScreenWidth-150)/2.0+50)*j, 20 + ((kScreenWidth-150)/2.0+10)*i, (kScreenWidth-150)/2.0, (kScreenWidth-150)/2.0);

            int width = (kScreenHeight - 120) / 5;
            int orgx = (kScreenWidth - width*2) / 3;

            menuItemBtn.frame = CGRectMake(orgx + (width + orgx) *  j, 10 + (width+10)*i, width,width);
// 改写上面这句话就好了

            menuItemBtn.tag = index++;
            [menuItemBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_imageArray[i][j]]] forState:UIControlStateNormal];
            [menuItemBtn addTarget:self action:@selector(selectMenuItem:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 4 && j == 1) {
                menuItemBtn.hidden = YES;
            }

            [imageView addSubview:menuItemBtn];
        }
    }
}

- (void)selectMenuItem:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [self.navigationController pushViewController:[inController new] animated:YES];
            break;
        case 101:
            [self.navigationController pushViewController:[outController new] animated:YES];
            break;
        case 102:
            [self.navigationController pushViewController:[backController new] animated:YES];
            break;
        case 103:
            [self.navigationController pushViewController:[checkController new] animated:YES];
            break;
        case 104:
            [self.navigationController pushViewController:[upController new] animated:YES];
            break;
        case 105:
            [self.navigationController pushViewController:[downController new] animated:YES];
            break;
        case 106:
            [self.navigationController pushViewController:[delController new] animated:YES];
            break;
            // 微码微鉴别入口
        case 107:{
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Scan" bundle:nil];
                        UIViewController *vc = [story instantiateInitialViewController];
                        [self.navigationController pushViewController: vc animated:YES];
//            [self.navigationController pushViewController: [QRScanViewController new] animated:YES];

            break;
        }
        case 108:
            [self.navigationController pushViewController:[configController new] animated:YES];
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
