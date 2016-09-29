//
//  WeatherReportViewController.m
//  浦东网安
//
//  Created by jiji on 15/12/24.
//  Copyright © 2015年 PengYue. All rights reserved.
//

#import "WeatherReportViewController.h"
#import "UIView+Extension.h"


@interface WeatherReportViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak)UIActivityIndicatorView *act;
@property(nonatomic,weak)UIWebView *webView;
@end

@implementation WeatherReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"天气预报";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baidu.weather.com.cn/mweather/101020100.shtml"]]];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
}

@end
