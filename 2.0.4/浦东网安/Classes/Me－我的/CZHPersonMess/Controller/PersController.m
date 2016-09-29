//
//  PersController.m
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "PersController.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"


#import "UserInfoTool.h"
#import "UserInfo.h"
#import "NSString+Extension.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "KeychainItemWrapper.h"
#import "PersonInfo.h"
#import "perssss.h"
#import "btnss.h"
@interface PersController ()
- (IBAction)haveread:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *barbar;
- (IBAction)back:(id)sender;

@end

@implementation PersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_barbar setBarTintColor:CZHRGBColor(49, 174, 215)];
    [self setupHaveRead];
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setupHaveRead
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Id"] =self.personInfo.id;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getMessageById"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        perssss *user = [perssss objectWithKeyValues:dic[@"result"]];
        _lables.text = user.message;
        _lables.numberOfLines = 0;
        if ([user.readType isEqualToString:@"1"]) {
            self.buttons.enabled = NO;
        }else{
            self.buttons.enabled = YES;
        }
        [self.buttons setTitle:@"已阅" forState:UIControlStateDisabled];
        [self.buttons setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateDisabled];
        [self.buttons setTitle:@"签阅" forState:UIControlStateNormal];
        
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
    
    
}
- (IBAction)haveread:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Id"] =self.personInfo.id;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"messageRead"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        btnss *user = [btnss objectWithKeyValues:dic[@"return"]];
        if ([user.message isEqualToString:@"成功"]) {
            self.buttons.enabled = NO;
        }else{
            self.buttons.enabled = YES;
        }
        [self.buttons setTitle:@"已阅" forState:UIControlStateDisabled];
        [self.buttons setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateDisabled];
        [self.buttons setTitle:@"签阅" forState:UIControlStateNormal];
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
@end
