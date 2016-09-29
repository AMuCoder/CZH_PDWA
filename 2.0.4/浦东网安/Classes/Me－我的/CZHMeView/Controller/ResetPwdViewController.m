//
//  ResetPwdViewController.m
//  浦东网安
//
//  Created by jiji on 15/6/30.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "ResetPwdViewController.h"



#import "UserInfoTool.h"
#import "UserInfo.h"

@interface ResetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *resetPwd;
@property (weak, nonatomic) IBOutlet UITextField *resetPwdAgain;
- (IBAction)tiJiao:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *tiJiao;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)back2:(id)sender;


@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.backgroundColor = CZHRGBColor(74, 144, 226);
    [self.navBar setBarTintColor:CZHRGBColor(49, 174, 215)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"android_title_bg"]];
    self.tiJiao.backgroundColor = CZHRGBColor(247, 203, 65);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)tiJiao:(UIButton *)sender {
    if (self.resetPwd.text.length && self.resetPwdAgain.text.length) {
        if ([self.resetPwd.text isEqual:self.resetPwdAgain.text]) {
            UserInfo *info = [UserInfoTool info];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"id"] = info.UserID;
            params[@"pwd"] = self.resetPwd.text;
            [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/ChangePassword"] params:params success:^(NSData *data) {
                
                //           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self.view endEditing: YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showSuccess:@"您的密码重置成功!"];
                
            } failed:^{
                [MBProgressHUD showError:@"网络出错!"];
            }];
        }else{
        
        [MBProgressHUD showError:@"修改失败！请检查！"];
        }
    }
    else{
        [MBProgressHUD showError:@"修改失败！请检查！"];
    }
}

- (IBAction)back2:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
