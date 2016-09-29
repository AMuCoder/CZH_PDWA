//
//  BDViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/7.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "BDViewController.h"



#import "MJExtension.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "Bang.h"
@interface BDViewController ()< UITableViewDelegate,UIAlertViewDelegate,UIAdaptivePresentationControllerDelegate,UIAccelerometerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hegeNum;
@property (weak, nonatomic) IBOutlet UIButton *bangbtn;
@property (weak, nonatomic) IBOutlet UITextField *phone;

- (IBAction)bangDing:(id)sender;
@end

@implementation BDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.bangbtn.layer.cornerRadius = 5.0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"android_title_bg"]];
    self.hegeNum.delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
}
- (IBAction)bangDing:(id)sender {
    UserInfo *info = [UserInfoTool info];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"netBarID"] = _hegeNum.text;
    params[@"userName"]  = info.UserName;
    params[@"zcsjh"]  = _phone.text;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@%@",CZHURL,@"/netBarID_add"] params:params success:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        Bang *user = [Bang objectWithKeyValues:dic[@"return"]];
        [MBProgressHUD showSuccess:user.message];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }failed:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showError:@"网络错误，请检查网络!"];
        }];
    }];
}
@end
