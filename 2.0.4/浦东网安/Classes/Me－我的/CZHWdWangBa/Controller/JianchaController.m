//
//  JianchaController.m
//  浦东网安
//
//  Created by Chun on 16/5/16.
//  Copyright © 2016年 PengYue. All rights reserved.
//
#define maxTextLength 150

#import "JianchaController.h"

#import "UserInfo.h"
#import "UserInfoTool.h"
#import "MJExtension.h"

#import <ImageIO/ImageIO.h>
#import "UIView+Extension.h"

#import "ChooseGroupList.h"
#import "RegionViewController.h"
#import "KxMenu.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "WangBaInfo.h"
#import "KeychainItemWrapper.h"
#import "jian.h"

@interface JianchaController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>

@property (nonatomic,strong) UIImage *image;//图片
@property (weak, nonatomic) IBOutlet UIButton *tijiaobtttn;//提交按钮属性
@property (weak, nonatomic) IBOutlet UITextView *jianchaxinxi;//检查信息
@property (weak, nonatomic) IBOutlet UIButton *choosebtn;


- (IBAction)pictures:(id)sender;
- (IBAction)tijiaobtn:(id)sender;
@end

@implementation JianchaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tijiaobtttn.layer.cornerRadius = 5.0;
    self.jianchaxinxi.layer.borderWidth = 1.3;
    self.jianchaxinxi.layer.borderColor = [UIColor blackColor].CGColor;
    self.jianchaxinxi.layer.cornerRadius =5.0;
    self.navigationItem.title = @"现场检查";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.jianchaxinxi becomeFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)pictures:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",nil];
    [sheet showInView:self.view];
}

- (IBAction)tijiaobtn:(id)sender {
    //2015-05-21 防止base64 中包含特殊字符
    NSData *data = UIImageJPEGRepresentation(self.image, 0.3f);
    NSString *baseStr = [data base64EncodedStringWithOptions:0];
    NSString *bStr =(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR("+"),kCFStringEncodingUTF8);
    
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    
    //NSLog(@"*********%@",username);
    
    KeychainItemWrapper * Netba = [[KeychainItemWrapper alloc]initWithIdentifier:@"NETaaa" accessGroup:nil];
    NSString *loginusername = [Netba objectForKey:(__bridge id)kSecAttrAccount];
    
    if (self.jianchaxinxi.text.length) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"checkman"] = username;//检查人
        params[@"checkinfo"] = self.jianchaxinxi.text;//检查信息
        params[@"netBarID"] = loginusername;//网吧合格证号
        params[@"pic1"] = self.image?bStr:@"";
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/addNetBarCheck" ] params:params success:^(NSData *data) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            jian *user = [jian objectWithKeyValues:dic[@"return"]];
            
            [self.view endEditing:YES];
            [MBProgressHUD showSuccess:user.message];
            [self.navigationController popViewControllerAnimated:YES];
        } failed:^{
            [MBProgressHUD showError:@"发布失败!请检查网络!"];
        }];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews){
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            if ([button.titleLabel.text isEqualToString:@"取消"]) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        //获得图片大小（KB）
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        NSUInteger length = [data length]/1000;
        if (length>1000) {
            UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"警告！" message:@"图片大小超过限制！请重新选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alart show];
            image = nil;
        }
        self.choosebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.choosebtn.imageView clipsToBounds];
        [self.choosebtn setImage:image?image:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
        
        self.image = image;
    }
}

@end
