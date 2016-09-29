//
//  LoginViewController.m
//  浦东网安
//
//  Created by jyc on 15/6/28.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "LoginViewController.h"



#import "User.h"
#import "MJExtension.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "MeViewController.h"
#import "HomeViewController.h"
#import "JYCTabBar.h"
#import "NSString+Hash.h"
#import "GesturePasswordController.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "SFHFKeychainUtils.h"
#import "RegisterViewController.h"
@interface LoginViewController ()< UITableViewDelegate,UIAlertViewDelegate,UIAdaptivePresentationControllerDelegate,UIAccelerometerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UINavigationBar *loginBar;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (nonatomic,strong) JYCTabBar *JYCBar;
@property (nonatomic,strong)UIAlertView *alertView;

- (IBAction)back:(id)sender;
- (IBAction)btnClick:(UIButton *)sender;
- (IBAction)regis:(UIButton *)sender;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.layer.cornerRadius = 5.0;
    [_loginBar setBarTintColor:CZHRGBColor(49, 174, 215)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"android_title_bg"]];
    self.name.delegate = self;
    self.pwd.delegate = self;
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *loginusername = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    [self.name setText:loginusername];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnClick:(UIButton *)sender {
    UserInfo *info = [UserInfoTool info];
    GesturePasswordController *vc = [[GesturePasswordController alloc] init];
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    KeychainItemWrapper * CZHToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"IOSTOKEN" accessGroup:nil];
    NSString *tokenValue = [CZHToken objectForKey:(__bridge id)kSecAttrAccount];
    if (info && [vc exist]) {
        [CZHkeychin resetKeychainItem];
        [keychin resetKeychainItem];
    }
    
    NSString *stringwithvendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *identifierforvendor = [stringwithvendor stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = _name.text;
    params[@"loginPwd"]  = _pwd.text;
    params[@"equipmentInfo"] = identifierforvendor;
    params[@"iostoken"] = tokenValue;
    
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/user_Login"] params:params success:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        User *user = [User objectWithKeyValues:dic[@"return"]];
        NSArray *usrArr = [UserInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        if (usrArr) {
            for (UserInfo *info in usrArr) {
                [UserInfoTool saveInfo:info];
            }
            
            [self.view endEditing:YES];
            [MBProgressHUD showSuccess:user.message];
        }else{
            [MBProgressHUD showError:user.message];
        }
        if ([user.code isEqualToString:@"0"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }failed:^{
        [MBProgressHUD showError:@"登录错误，请检查网络!"];
    }];
//    [Rolid setObject:user forKey:(__bridge id)kSecAttrService];
    [CZHkeychin setObject:@"PY.WangAn" forKey:(__bridge id)kSecAttrService];
    [CZHkeychin setObject:_pwd.text forKey:(__bridge id)kSecValueData];
    if (![vc exist] && !info) {
        [self performSelector:@selector(btnGesture) withObject:nil afterDelay:0.0];
        //            [self g2back];
    }else if([vc exist] && !info){
        [self g2back];
    }else if(![vc exist] && info){
        [self performSelector:@selector(btnGesture) withObject:nil afterDelay:0.0];
        //            [self g2back];
    }else{
        [self g1back];
    }
    
}

- (IBAction)regis:(UIButton *)sender {
    RegisterViewController *vvc = [[RegisterViewController alloc] init];
    [self presentViewController:vvc animated:YES completion:nil];
}

- (void)btnGesture{
    
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *name = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    GesturePasswordController *vc = [[GesturePasswordController alloc]init];
    if ([name isEqualToString:_name.text]==NO && [vc exist] ==NO )
    {
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if(buttonIndex == 1) {
        GesturePasswordController *vc = [[GesturePasswordController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)g1back{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)g2back{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -108);
    }];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
/*
 //        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
 //        if (_LoginuccessBlock) {
 //            _LoginuccessBlock();
 //            }
 //        }];
 
 
 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"是否需要设置手势密码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 [alertView show];
 */