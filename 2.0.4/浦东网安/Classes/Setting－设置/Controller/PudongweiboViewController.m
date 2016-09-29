//
//  PudongweiboViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/23.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "PudongweiboViewController.h"
#import "UIView+Extension.h"

@interface PudongweiboViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak)UIActivityIndicatorView *act;
@property(nonatomic,weak)UIWebView *webView;
@end

@implementation PudongweiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"官方微博";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://weibo.com/pudongwj?refer_flag=1005055014_&is_hot=1"]]];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
}

@end
