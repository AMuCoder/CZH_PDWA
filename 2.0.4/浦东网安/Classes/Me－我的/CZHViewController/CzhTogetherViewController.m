//
//  CzhTogetherViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/5.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "CzhTogetherViewController.h"
#import "HYCalendarViewController.h"
#import "KeychainItemWrapper.h"


#import "UserInfoTool.h"
#import "MJExtension.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "PoliceView.h"
#import "UIView+Extension.h"

#import "CtrlCodeScan.h"
#import "BDViewController.h"
#import "CZHTableViewController.h"
#import "AllTableViewController.h"
#import "LoginViewController.h"
#import "ResetPwdViewController.h"
#import "FaBuViewController.h"
#import "GesturePasswordController.h"
#import "Gesture1PasswordController.h"
#import "ShoucangController.h"
//#import "PerMessController.h"
#import "PersonController.h"
#import "MJqiandaoTableViewController.h"
@interface CzhTogetherViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button11;
@property (weak, nonatomic) IBOutlet UIButton *button22;
@property (weak, nonatomic) IBOutlet UIButton *button33;
@property (weak, nonatomic) IBOutlet UIButton *button44;
@property (weak, nonatomic) IBOutlet UIButton *button55;
@property (weak, nonatomic) IBOutlet UIButton *button66;
@property (weak, nonatomic) IBOutlet UIButton *button77;
@property (weak, nonatomic) IBOutlet UIButton *button88;
@property (weak, nonatomic) IBOutlet UIButton *button99;

@property (weak, nonatomic) IBOutlet UILabel *lable11;
@property (weak, nonatomic) IBOutlet UILabel *lable22;
@property (weak, nonatomic) IBOutlet UILabel *lable33;
@property (weak, nonatomic) IBOutlet UILabel *lable44;
@property (weak, nonatomic) IBOutlet UILabel *lable55;
@property (weak, nonatomic) IBOutlet UILabel *lable66;
@property (weak, nonatomic) IBOutlet UILabel *lable77;
@property (weak, nonatomic) IBOutlet UILabel *lable88;
@property (weak, nonatomic) IBOutlet UILabel *lable99;

- (IBAction)sectionbtn1:(id)sender;
- (IBAction)sectionbtn2:(id)sender;
- (IBAction)sectionbtn3:(id)sender;
- (IBAction)sectionbtn4:(id)sender;
- (IBAction)sectionbtn5:(id)sender;
- (IBAction)sectionbtn6:(id)sender;
- (IBAction)sectionbtn7:(id)sender;
- (IBAction)sectionbtn8:(id)sender;
- (IBAction)sectionbtn9:(id)sender;

@end

@implementation CzhTogetherViewController

-(void)viewDidAppear:(BOOL)animated{
    [self labletitle];
    UserInfo *info = [UserInfoTool info];
    if(![info.RoleID isEqualToString:@"19"]){
        [self lableAndbutton2];
    }else{
        [self lableAndbutton1];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    UserInfo *info = [UserInfoTool info];
    if(![info.RoleID isEqualToString:@"19"]){
        [self lableAndbutton2];
    }else{
        [self lableAndbutton1];
    }
}

- (void)lableAndbutton1{
        GesturePasswordController *cc = [[GesturePasswordController alloc] init];
        self.lable11.text=@"业主签到";
        [self.button11 setBackgroundImage:[UIImage imageNamed:@"home_button_qiandao"] forState:UIControlStateNormal];
        
        self.lable22.text=@"绑定网吧号";
        [self.button22 setBackgroundImage:[UIImage imageNamed:@"home_button_more"] forState:UIControlStateNormal];
        
        self.lable33.text=@"我的网吧";
        [self.button33 setBackgroundImage:[UIImage imageNamed:@"home_button_myzone"] forState:UIControlStateNormal];
        
        self.lable44.text=@"个人消息";
        [self.button44 setBackgroundImage:[UIImage imageNamed:@"home_button_myzone"] forState:UIControlStateNormal];
        
        if ([cc exist]) {
            self.lable55.text = @"修改手势密码";
        }else{
            self.lable55.text = @"设置手势密码";
        }
        [self.button55 setBackgroundImage:[UIImage imageNamed:@"home_button_local"] forState:UIControlStateNormal];
        
        self.lable66.text=@"修改密码";
        [self.button66 setBackgroundImage:[UIImage imageNamed:@"home_button_xiugaimima"] forState:UIControlStateNormal];
    
        self.lable77.text=@"注销";
        [self.button77 setBackgroundImage:[UIImage imageNamed:@"home_button_zhuxiao"] forState:UIControlStateNormal];
    
        [self.button88 setHidden:YES];
        [self.lable88 setHidden:YES];
        [self.button99 setHidden:YES];
        [self.lable99 setHidden:YES];
}
- (void)lableAndbutton2{
    GesturePasswordController *cc = [[GesturePasswordController alloc] init];
    self.lable11.text=@"民警签到";
    [self.button11 setBackgroundImage:[UIImage imageNamed:@"home_button_qiandao"] forState:UIControlStateNormal];
    
    self.lable22.text=@"收藏夹";
    [self.button22 setBackgroundImage:[UIImage imageNamed:@"home_button_shoucang"] forState:UIControlStateNormal];
    
    self.lable33.text=@"网吧查询";
    [self.button33 setBackgroundImage:[UIImage imageNamed:@"home_button_sousuo"] forState:UIControlStateNormal];
    
    self.lable44.text=@"个人消息";
    [self.button44 setBackgroundImage:[UIImage imageNamed:@"home_button_myzone"] forState:UIControlStateNormal];
    
    self.lable55.text=@"信息发布";
    [self.button55 setBackgroundImage:[UIImage imageNamed:@"home_button_pubxinx"] forState:UIControlStateNormal];
    
    if ([cc exist]) {
        self.lable66.text = @"修改手势密码";
    }else{
        self.lable66.text = @"设置手势密码";
    }
    [self.button66 setBackgroundImage:[UIImage imageNamed:@"home_button_local"] forState:UIControlStateNormal];
    
    self.lable77.text=@"民警签到记录";
    [self.button77 setBackgroundImage:[UIImage imageNamed:@"home_button_checkin"] forState:UIControlStateNormal];
    
    self.lable88.text=@"修改密码";
    [self.button88 setBackgroundImage:[UIImage imageNamed:@"home_button_xiugaimima"] forState:UIControlStateNormal];
    
    self.lable99.text=@"注销";
    [self.button99 setBackgroundImage:[UIImage imageNamed:@"home_button_zhuxiao"] forState:UIControlStateNormal];
    
    [self.button88 setHidden:NO];
    [self.lable88 setHidden:NO];
    [self.button99 setHidden:NO];
    [self.lable99 setHidden:NO];
    
}
- (void)labletitle{
    UserInfo *info = [UserInfoTool info];
    //title图片
    if (!info) {
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView_1"]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]]];
    }
    else{
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
        [self.navigationController.navigationBar setBarTintColor:CZHRGBColor(49, 174, 215)];
        
    }
    //添加用户显示
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((2*self.view.frame.size.width/3), 7, (self.navigationController.view.frame.size.width/3), 31)];
    lable.text = info.UserName;
    lable.backgroundColor = CZHRGBColor(49, 174, 215);
    lable.font = [UIFont fontWithName:@"Helvetica" size:14];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:lable];
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    [CZHkeychin setObject:info.UserName forKey:(__bridge id)kSecAttrAccount];// 上面两行用来标识一个Item
}

- (void)yzqiandao{
    HYCalendarViewController *vc = [[HYCalendarViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
    //[self.navigationController pushViewController:vc animated:YES];
}

- (void)mjqiandao{
    CtrlCodeScan *vc = [[CtrlCodeScan alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bangding{
    BDViewController *vc = [[BDViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wodewangba{
    CZHTableViewController *vc = [[CZHTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wangbachaxun{
    AllTableViewController *vc = [[AllTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shoucang{
    ShoucangController *vc =[[ShoucangController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pensonMessage{
    PersonController *vc = [[PersonController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)fabuMessage{
    FaBuViewController *fabu = [[FaBuViewController alloc]init];
    [self presentViewController:fabu animated:YES completion:nil];
}

- (void)shoushiMima{
    
    Gesture1PasswordController *vc = [[Gesture1PasswordController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)xiugaiMima{
    ResetPwdViewController *reset = [[ResetPwdViewController alloc]init];
    
    [self presentViewController:reset animated:YES completion:nil];
}

- (void)qiehuanCount{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
    
}

- (void)loginOut{
    [UserInfoTool saveInfo:nil];
    [MBProgressHUD showSuccess:@"用户已注销!"];
    self.tabBarController.selectedIndex = 0;
    
}
-(void)mjqiandaoss{
    MJqiandaoTableViewController *vc =[[MJqiandaoTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sectionbtn1:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self yzqiandao];
    }else{
        [self mjqiandao];
    }
}

- (IBAction)sectionbtn2:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self bangding];
    }else{
        [self shoucang];
    }
}

- (IBAction)sectionbtn3:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self wodewangba];
    }else{
        [self wangbachaxun];
    }
}

- (IBAction)sectionbtn4:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self pensonMessage];
    }else{
        [self pensonMessage];
    }
    
}

- (IBAction)sectionbtn5:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self shoushiMima];
    }else{
        [self fabuMessage];
    }
}

- (IBAction)sectionbtn6:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self xiugaiMima];
    }else{
        [self shoushiMima];
    }
}

- (IBAction)sectionbtn7:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        //[self qiehuanCount];
        [self loginOut];
    }else{
        [self mjqiandaoss];
    }
}

- (IBAction)sectionbtn8:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if([info.RoleID isEqualToString:@"19"]){
        [self loginOut];
    }else{
        [self xiugaiMima];
    }
}

- (IBAction)sectionbtn9:(id)sender {
    [self loginOut];
    //[self qiehuanCount];
}

//- (IBAction)sectionbtn10:(id)sender {
//    [self loginOut];
//}
@end
