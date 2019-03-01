//
//  delController.m
//  weiMaInOut
//
//  Created by ZJ on 16/11/3.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "delController.h"

#import "userModel.h"

#import "clientModel.h"
#import "productModel.h"
#import "batchModel.h"

#import "inModel.h"
#import "outModel.h"
#import "backModel.h"

@interface delController ()

@property (nonatomic, strong) NSMutableArray *delArray;

@end

@implementation delController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    [self createNavigationBarLeftBtnTitle:@"返回" LeftBtnImage:nil action:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navTitle.text = @"数据清空";
    
    _delArray = [NSMutableArray new];
    
    [self customUI];
}

- (void)customUI
{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navView.height, kScreenWidth, kScreenHeight - self.navView.height)];
    [self.view addSubview:scrollerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    imageView.backgroundColor = [UIColor whiteColor];
    [scrollerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    label.text = @"请选择要删除的数据:";
    label.font =Font_Sys_18;
    [imageView addSubview:label];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.bottom + 5, kScreenWidth, 50)];
    imageView1.backgroundColor = [UIColor whiteColor];
    imageView1.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView1];
    
    ZJButton *selectBtn1 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn1 setTitle:@"删除用户数据" forState:UIControlStateNormal];
    [selectBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn1 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn1 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn1.tag = 101;
    [selectBtn1 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView1 addSubview:selectBtn1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView1.bottom + 5, kScreenWidth, 50)];
    imageView2.backgroundColor = [UIColor whiteColor];
    imageView2.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView2];
    
    ZJButton *selectBtn2 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn2 setTitle:@"删除产品数据" forState:UIControlStateNormal];
    [selectBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn2 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn2 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn2.tag = 102;
    [selectBtn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:selectBtn2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView2.bottom + 5, kScreenWidth, 50)];
    imageView3.backgroundColor = [UIColor whiteColor];
    imageView3.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView3];
    
    ZJButton *selectBtn3 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn3 setTitle:@"删除批次数据" forState:UIControlStateNormal];
    [selectBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn3 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn3.tag = 103;
    [selectBtn3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView3 addSubview:selectBtn3];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView3.bottom + 5, kScreenWidth, 50)];
    imageView4.backgroundColor = [UIColor whiteColor];
    imageView4.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView4];
    
    ZJButton *selectBt4 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBt4 setTitle:@"删除客户数据" forState:UIControlStateNormal];
    [selectBt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBt4 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBt4 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBt4.tag = 104;
    [selectBt4 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView4 addSubview:selectBt4];
    
    UIImageView *imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView4.bottom + 5, kScreenWidth, 50)];
    imageView5.backgroundColor = [UIColor whiteColor];
    imageView5.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView5];
    
    ZJButton *selectBtn5 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn5 setTitle:@"删除入库数据" forState:UIControlStateNormal];
    [selectBtn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn5 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn5 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn5.tag = 105;
    [selectBtn5 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView5 addSubview:selectBtn5];
    
    UIImageView *imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView5.bottom + 5, kScreenWidth, 50)];
    imageView6.backgroundColor = [UIColor whiteColor];
    imageView6.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView6];
    
    ZJButton *selectBtn6 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn6 setTitle:@"删除出库数据" forState:UIControlStateNormal];
    [selectBtn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn6 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn6 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn6.tag = 106;
    [selectBtn6 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView6 addSubview:selectBtn6];
    
    UIImageView *imageView7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView6.bottom + 5, kScreenWidth, 50)];
    imageView7.backgroundColor = [UIColor whiteColor];
    imageView7.userInteractionEnabled = YES;
    [scrollerView addSubview:imageView7];
    
    ZJButton *selectBtn7 = [[ZJButton alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
    [selectBtn7 setTitle:@"删除退货数据" forState:UIControlStateNormal];
    [selectBtn7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn7 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [selectBtn7 setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateSelected];
    selectBtn7.tag = 107;
    [selectBtn7 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView7 addSubview:selectBtn7];

    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(5, imageView7.bottom + 40, kScreenWidth-10, 40);
    [delBtn setBackgroundImage:[UIImage imageNamed:@"denglubutton"] forState:UIControlStateNormal];
    delBtn.layer.cornerRadius = 10.0;
    delBtn.layer.masksToBounds = YES;
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollerView addSubview:delBtn];
    
    scrollerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 50);
}

- (void)selectBtn:(UIButton *)selectBtn
{
    if (selectBtn.selected == YES) {
        [_delArray removeObject:selectBtn.currentTitle];
        selectBtn.selected = NO;
        
    } else
    {
        [_delArray addObject:selectBtn.currentTitle];
        selectBtn.selected = YES;
    }
}

- (void)delBtn
{
    if (_delArray.count == 0) {
        [WToast showWithText:@"请先选择类型"];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self delInfo];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)delInfo
{
    NSLog(@"%@",_delArray);
    
    [LCProgressHUD showStatus:LCProgressHUDStatusWaitting text:@"正在删除"];
    
    for (NSString *title in _delArray) {
        if ([title isEqualToString:@"删除用户数据"]) {
            userModel *model = [userModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
        if ([title isEqualToString:@"删除产品数据"]) {
            productModel *model = [productModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
        if ([title isEqualToString:@"删除批次数据"]) {
            batchModel *model = [batchModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
        
        if ([title isEqualToString:@"删除客户数据"]) {
            clientModel *model = [clientModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
        
        if ([title isEqualToString:@"删除入库数据"]) {
            inModel *model = [inModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
        
        if ([title isEqualToString:@"删除出库数据"]) {
            outModel *model = [outModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
        
        if ([title isEqualToString:@"删除退货数据"]) {
            backModel *model = [backModel new];
            model.UserID = GET_DEFAULT(@"UserID");
            [[ZJDataBase sharedDataBase] deleteAllDataByUserID:model];
        }
    }
    [WToast showWithText:@"删除成功"];
    [LCProgressHUD hide];
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
