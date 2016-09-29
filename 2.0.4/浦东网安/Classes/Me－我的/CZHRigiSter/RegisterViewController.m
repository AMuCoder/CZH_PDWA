//
//  RegisterViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/6.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "RegisterViewController.h"



#import "User.h"
#import "MJExtension.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "MeViewController.h"
#import "HomeViewController.h"
#import "JYCTabBar.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "Register.h"
#import "GesturePasswordController.h"
@interface RegisterViewController ()< UITableViewDelegate,UIAlertViewDelegate,UIAdaptivePresentationControllerDelegate,UIAccelerometerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *barNumber;
@property (weak, nonatomic) IBOutlet UITextField *telephoneNum;
@property (weak, nonatomic) IBOutlet UITextField *userNameNum;
@property (weak, nonatomic) IBOutlet UITextField *passwordNum;
@property (weak, nonatomic) IBOutlet UITextField *repassword;
@property (weak, nonatomic) IBOutlet UITextField *tecentNum;
@property (weak, nonatomic) IBOutlet UIButton *registerbtn;
@property (weak, nonatomic) IBOutlet UINavigationBar *registerbar;
- (IBAction)registerBtn:(id)sender;
- (IBAction)backbtn:(id)sender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    KeychainItemWrapper * CZHToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"IOSTOKEN" accessGroup:nil];
    NSString *tokenValue = [CZHToken objectForKey:(__bridge id)kSecAttrAccount];
    NSLog(@"tok%@",tokenValue);
    self.registerbtn.layer.cornerRadius = 5.0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"android_title_bg"]];
    [_registerbar setBarTintColor:CZHRGBColor(49, 174, 215)];
    self.barNumber.delegate = self;
    self.telephoneNum.delegate = self;
    self.userNameNum.delegate = self;
    self.passwordNum.delegate = self;
    self.repassword.delegate = self;
    self.tecentNum.delegate = self;
}

- (IBAction)registerBtn:(id)sender {
    //取出模型
    UserInfo *info = [UserInfoTool info];
    //图形密码界面
    GesturePasswordController *vc = [[GesturePasswordController alloc] init];
    //用户名和密码
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    //请求返回值
    KeychainItemWrapper * Usercode = [[KeychainItemWrapper alloc]initWithIdentifier:@"CODE" accessGroup:nil];
    //token
    KeychainItemWrapper * CZHToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"IOSTOKEN" accessGroup:nil];
    NSString *tokenValue = [CZHToken objectForKey:(__bridge id)kSecAttrAccount];
    //手势密码
    //KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    //判断输入格式是否正确
    if(_userNameNum.text.length ==0 || _passwordNum.text.length ==0 || _repassword.text.length ==0 || _barNumber.text.length ==0) {//为空时下一步
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"请填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else {
        //1.可以进行注册第一步，不能为空。
        //下一步，手机号格式是否正确，不正确弹窗结束，否则可以注册第二步
        if (![self isValidateMobile:_telephoneNum.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"手机号码输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            //3.可以进行注册第三步，不能为空。
            //下一步，判断用户名长度和密码长度是否满足条件，不满足则弹窗结束，否则可以注册第四步
            if (_userNameNum.text.length < 4 || _passwordNum.text.length < 8) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"用户名(密码)长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            }else {
                //2.可以进行注册第二步，不能为空。
                //下一步，判断密码是否为一致，不一致弹窗结束，否则可以注册第三步
                if (![_passwordNum.text isEqualToString:_repassword.text]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }else{
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"netBarID"] = _barNumber.text;
                    params[@"zcsjh"]  = _telephoneNum.text;
                    params[@"userName"] = _userNameNum.text;
                    params[@"password"] = _passwordNum.text;
                    params[@"wxzh"] = _telephoneNum.text;
                    params[@"iostoken"] = tokenValue;//tokenValue
                    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/user_add"] params:params success:^(NSData *data) {
                        //注册成功时，清空所有用户密码和手势密码，用于后面重置手势密码做准备
                        //                  [CZHkeychin resetKeychainItem];
                        //                  [keychin resetKeychainItem];
                        //保存数据进入字典
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        Register *user = [Register objectWithKeyValues:dic[@"return"]];
                        NSArray *usrArr = [UserInfo objectArrayWithKeyValuesArray:dic[@"result"]];
                        //存返回值code,用于后面跳转判断
                        [Usercode setObject:user.code forKey:(__bridge id)kSecAttrAccount];
                        [Usercode setObject:user.message forKey:(__bridge id)kSecValueData];
                        if (usrArr) {
                            for (UserInfo *info in usrArr) {
                                [UserInfoTool saveInfo:info];
                                [self performSelector:@selector(btnGesture) withObject:nil afterDelay:0.0];
                            }
                            [self.view endEditing:YES];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:user.code message:user.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alert show];
                        }
                    }failed:^{
                        [MBProgressHUD showError:@"登录错误，请检查网络!"];
                        
                    }];
                    //NSString *cod = [Usercode objectForKey:(__bridge id)kSecAttrAccount];
                    //int intString = [cod intValue];
                    [CZHkeychin setObject:_passwordNum.text forKey:(__bridge id)kSecValueData];
                    if (!info) {
                        [self g4back];
                    }else if(info){
                        //=================
                        if ([vc exist]) {
                            [self g1back];
                        }else {
                            [self g1back];
                        }
                        //=================
                    }
                }
            }
        }
    }
}
//跳转+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)btnGesture{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *name = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    GesturePasswordController *vc = [[GesturePasswordController alloc]init];
    if ([name isEqualToString:_userNameNum.text]== NO && [vc exist] == NO)
    {
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)g1back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)g2back{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)g4back{
}
- (IBAction)backbtn:(id)sender {
    UserInfo *info = [UserInfoTool info];
    if (info) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
- (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    if(([regextestmobile evaluateWithObject:mobileNum]==YES)||
       ([regextestcm evaluateWithObject:mobileNum] ==  YES) ||
       ([regextestct evaluateWithObject:mobileNum] == YES)  ||
       ([regextestcu evaluateWithObject:mobileNum]  == YES))
    {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
@end

