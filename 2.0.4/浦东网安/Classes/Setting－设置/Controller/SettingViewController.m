//
//  SettingViewController.m
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "SettingArrowItem.h"
#import "SettingItem.h"
#import "SettingPhoneCallItem.h"
#import "SettingTextItem.h"
#import "FankuiViewController.h"
#import "UIView+Extension.h"
#import "AFNetworking.h"
#import "MJExtension.h"

#import "UserInfo.h"
#import "UserInfoTool.h"
#import "LoginViewController.h"
#import "GesturePasswordController.h"
#import "KeychainItemWrapper.h"
#import "PudongweiboViewController.h"
@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UIAdaptivePresentationControllerDelegate,UIAccelerometerDelegate>
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,copy)NSString *telNum;

@end
@implementation SettingViewController



-(NSArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSArray array];
        SettingTextItem *banben = [SettingTextItem itemWithIcon:nil title:@"版本"];
        
        SettingArrowItem *about = [SettingArrowItem itemWithIcon:nil title:@"关于我们" destVcClass:nil];
        
        SettingArrowItem *fankui = [SettingArrowItem itemWithIcon:nil title:@"意见反馈" destVcClass:[FankuiViewController class]];
        
        SettingArrowItem *weibo = [SettingArrowItem itemWithIcon:nil title:@"官方微博" destVcClass:[PudongweiboViewController class]];
        
        SettingPhoneCallItem *phone = [SettingPhoneCallItem itemWithIcon:nil title:@"联系我们"];
        
        _dataList = @[banben,about,fankui,weibo,phone];
        
        
        
    }
    return _dataList;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserInfo *info = [UserInfoTool info];
    //title图片
    if (!info) {
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView_1"]];
        //导航栏背景颜色
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]]];
    }
    else{
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
        [self.navigationController.navigationBar setBarTintColor:CZHRGBColor(49, 174, 215)];
    }
    /*
     
     //导航栏背景颜色
     //添加用户显示
     UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((2*self.view.frame.size.width/3), 7, (self.navigationController.view.frame.size.width/3), 31)];
     lable.text = info.UserName;
     lable.backgroundColor = CZHRGBColor(49, 174, 215);
     lable.font = [UIFont fontWithName:@"Helvetica" size:14];
     lable.textAlignment = NSTextAlignmentCenter;
     lable.textColor = [UIColor whiteColor];
     [self.navigationController.navigationBar addSubview:lable];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneNum:) name:@"phonNum" object:nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [[SettingCell class]cellWithTableView:tableView];
    SettingItem *item = self.dataList[indexPath.row];
    cell.item = item;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingItem *item = self.dataList[indexPath.row];
    if ([item isKindOfClass:[SettingArrowItem class]]) {
        SettingArrowItem *arrowItem =(SettingArrowItem *) item;
        UserInfo *user = [UserInfoTool info];
        if (indexPath.row == 2) {
            if (!user) {
                GesturePasswordController *vc = [[GesturePasswordController alloc] init];
                if ([vc exist] == YES) {
                    [self presentViewController:vc animated:YES completion:nil];
                }else{
                    LoginViewController *vc = [[LoginViewController alloc]init];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                LoginViewController *log = [[LoginViewController alloc]init];
                [self presentViewController:log animated:YES completion:nil];
            }else if (user){
                UIViewController *vc = [[arrowItem.destVcClass alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
    if ([item isKindOfClass:[SettingPhoneCallItem class]]) {
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
            //不支持
            
        }
        else{
            //支持打电话，在这里写打电话的方法
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telNum];
            
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
        }
    }
    
    if (indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"关于我们" message:[NSString stringWithFormat:@"%@\n%@",@"［服务宗旨］诚信为民，效率为公",@"[应用背景]针对浦东网安支队的信息化建设需要，在以浦东信息平台的功能基础上，设计开发浦东网安支队手机用户端"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    if (indexPath.row == 3) {
        PudongweiboViewController *vc = [[PudongweiboViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        LoginViewController *log = [[LoginViewController alloc]init];
//        [self presentViewController:log animated:YES completion:nil];
//    }
//}


-(void)phoneNum:(NSNotification *)not
{
    self.telNum = not.userInfo[@"phoneNum"];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
