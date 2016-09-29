//
//  FankuiViewController.m
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "FankuiViewController.h"
#import "PooCodeView.h"


#import "UserInfo.h"
#import "UserInfoTool.h"

#import "UIView+Extension.h"

#define maxTextLength 150

@interface FankuiViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fankuiTextLength;
@property (weak, nonatomic) IBOutlet HMTextView *fankuiTextView;

@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet PooCodeView *codeView;
@property (assign,nonatomic) BOOL btnStatus;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
- (IBAction)tijiaoClick:(UIButton *)sender;

@end

@implementation FankuiViewController
@synthesize input = _input;
@synthesize codeView = _codeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
   // _tijiaoBtn.enabled = NO;
    if ([[UIDevice currentDevice].systemVersion doubleValue]<8.0) {
        
    }
    self.title = @"意见反馈";
   
    self.fankuiTextView.layer.borderWidth = 2;
    self.fankuiTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _fankuiTextView.layer.cornerRadius =5.0;
    
    self.input.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.input.layer.borderWidth = 2.0;
    self.input.layer.cornerRadius = 5.0;
    self.input.font            = [UIFont systemFontOfSize:21];
    self.input.placeholder     = @"请输入验证码!";
    self.input.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.input.backgroundColor = [UIColor clearColor];
    self.input.textAlignment   = NSTextAlignmentCenter;
    self.input.returnKeyType   = UIReturnKeyDone;
    self.input.delegate        = self;
    
    [self.codeView change];
   
    self.tijiaoBtn.backgroundColor = CZHRGBColor(123, 200, 120);
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.fankuiTextView becomeFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.input)
    {
        if ([toBeString length] > 4) {
            self.input.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, - 60);
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
}
#pragma mark - UITextViewDelegate
- (IBAction)tijiaoClick:(UIButton *)sender {
    
    if ([self.input.text.uppercaseString isEqualToString:self.codeView.changeString.uppercaseString]&&[self.fankuiTextView hasText]) {
        
        UserInfo *userInfo = [UserInfoTool info];
       
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"Contents"] = self.fankuiTextView.text;
        params[@"UeserName"] = userInfo.UserName;
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/SubmitFeedback"]params:params success:^(NSData *data) {
           
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"您的意见已经提交，感谢您对我们工作的大力支持" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alview show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } failed:^{
            [MBProgressHUD showError:@"网络出错!"];
        }];
        
    }
    else
    {
        if (_fankuiTextView.text.length == 0) {
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"反馈信息不得为空！" message:@"请输入反馈信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alview show];
            return;
        }
        
        if (self.input.text.length == 0){
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"验证码不得为空！" message:@"请输入验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alview show];
            return;
        }
        
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"验证码错误！" message:@"请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
        
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[alertView textFieldAtIndex:0]resignFirstResponder];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSUInteger length = [textView.text length];
    if (length < maxTextLength) {
        self.fankuiTextLength.textColor = [UIColor lightGrayColor];
        self.fankuiTextLength.text = [NSString stringWithFormat:@"%@/%@",@(length).description,@(maxTextLength - length).description];
    }else{
        self.fankuiTextLength.text = [NSString stringWithFormat:@"%d/0",maxTextLength];
        self.fankuiTextLength.textColor = [UIColor redColor];
        //排除中文输入法BUG
        if (textView.markedTextRange) {
            return;
        }else{
            [textView setText:[textView.text substringToIndex:maxTextLength]];
        }
    }
}

@end
