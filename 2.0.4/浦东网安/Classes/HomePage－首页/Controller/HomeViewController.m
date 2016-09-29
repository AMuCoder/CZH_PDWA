//
//  HomeViewController.m
//  浦东网安
//
//  Created by jiji on 15/12/24.
//  Copyright © 2015年 PengYue. All rights reserved.
//

#import "HomeViewController.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "LoginViewController.h"
#import "FankuiViewController.h"
#import "RemindViewController.h"
#import "AdViewController.h"
#import "WeatherReportViewController.h"
#import "News.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "Weather.h"
#import "UIImageView+WebCache.h"
#import "GesturePasswordController.h"
#import "SFHFKeychainUtils.h"
#import "KeychainItemWrapper.h"
#import "PersonController.h"
#import "HYCalendarViewController.h"

@interface HomeViewController ()<CLLocationManagerDelegate>
- (IBAction)TqybClick:(UIButton *)sender;
- (IBAction)askClick:(UIButton *)sender;
- (IBAction)WjtsClick:(UIButton *)sender;
- (IBAction)GyggClick:(UIButton *)sender;
//@property (weak, nonatomic) IBOutlet UILabel *lastTitle;
@property (weak, nonatomic) UILabel *lastTitle;
- (IBAction)ZxdtClick:(UIButton *)sender;
@property(nonatomic,strong)NSArray *news;
@property(nonatomic,strong)NSMutableArray *recentNewses;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeImageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;
@property(nonatomic,assign)int index;
@property(nonatomic,strong)CLLocationManager *mgr;
@property(nonatomic,strong)UserInfo *aaa;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property (weak, nonatomic) IBOutlet UIButton *weatherBtn;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) IBOutlet UILabel *wenDuLabel;
@property (weak, nonatomic) IBOutlet UILabel *tianQiQingKuangLabel;
@property (weak, nonatomic) IBOutlet UILabel *fengXIangLabel;
@property(nonatomic,strong)UserInfo *info;
@end

@implementation HomeViewController
- (void)viewDidAppear:(BOOL)animated{
    UserInfo *info = [UserInfoTool info];
    //title图片
    if (!info) {
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView_1"]];
        //导航栏背景颜色
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]]];
        //用户信息显示框背景
        UIImageView *lable = [[UIImageView alloc] initWithFrame:CGRectMake((2*self.view.frame.size.width/3), 7, (self.navigationController.view.frame.size.width/3), 31)];
        lable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]];
        [self.navigationController.navigationBar addSubview:lable];
    }
    else{
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
        //导航栏背景颜色
        [self.navigationController.navigationBar setBarTintColor:CZHRGBColor(49, 174, 215)];
        //添加用户显示
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((2*self.view.frame.size.width/3), 7, (self.navigationController.view.frame.size.width/3), 31)];
        if(![info.RoleID isEqualToString:@"19"]){
            lable.text = info.UnitName;
        }else{
            lable.text = info.UserName;
        }
        lable.backgroundColor = CZHRGBColor(49, 174, 215);
        lable.font = [UIFont fontWithName:@"Helvetica" size:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:lable];
        
        KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
        [CZHkeychin setObject:info.UserName forKey:(__bridge id)kSecAttrAccount];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self loadLastNews];
    UserInfo *info = [UserInfoTool info];
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        self.homeImageH.constant = 200;
        self.btnH.constant = 100;
    }
    _tianQiQingKuangLabel.hidden = _wenDuLabel.hidden = _fengXIangLabel.hidden = YES;
    self.index = 1;
    [self setupLocation];
    GesturePasswordController *vc = [[GesturePasswordController alloc] init];
    if (info && [vc exist] == YES) {
        [self presentViewController:vc animated:YES completion:nil];
    }
    _lastTitle.frame = CGRectMake(0, self.homeImageH.constant-23, self.view.frame.size.width, 23);
    _lastTitle.backgroundColor = [UIColor blackColor];
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
-(void)setupLocation
{
    _mgr = [[CLLocationManager alloc]init];
    _mgr.delegate = self;
    _mgr.desiredAccuracy = kCLLocationAccuracyBest;
    _mgr.distanceFilter = kCLDistanceFilterNone;
    [_mgr requestWhenInUseAuthorization];
    [_mgr startUpdatingLocation];
}

-(void)loadLastNews
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"newType"] = @"网警提示";
    params[@"newID"] = @"";
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/GetTopNews"] params:params success:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.news = (NSMutableArray *)[News objectArrayWithKeyValuesArray:dic[@"result"]];
        
        self.recentNewses = [NSMutableArray array];
        if (self.news.count<10) {
            self.recentNewses = (NSMutableArray *)self.news;
        }else{
            for (int i = 0; i<10;i++ ) {
                News *news = self.news[i];
                if (i == 0) {
                    _lastTitle.text = [NSString stringWithFormat:@"最新动态 : %@",news.Title];
                }
                [self.recentNewses addObject:news];
            }
        }
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadTitle) userInfo:nil repeats:YES];
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(void)loadTitle
{
    News *news = self.recentNewses[_index];
    _lastTitle.text = [NSString stringWithFormat:@"最新动态 : %@",news.Title];
    _index++;
    if (_index == self.recentNewses.count) {
        _index = 0;
    }
    
}

- (IBAction)TqybClick:(UIButton *)sender {
    [self.navigationController pushViewController:[[WeatherReportViewController alloc]init] animated:YES];
}

- (IBAction)askClick:(UIButton *)sender {
    [self push2ClassVc:[[FankuiViewController alloc]init]];
}

- (IBAction)WjtsClick:(id)sender {
    [self.navigationController pushViewController:[[RemindViewController alloc]init] animated:YES];
}

- (IBAction)GyggClick:(UIButton *)sender {
    [self.navigationController pushViewController:[[AdViewController alloc]init] animated:YES];
}

- (IBAction)ZxdtClick:(UIButton *)sender {
    RemindViewController *remind = [[RemindViewController alloc]init];
    remind.isRecent = YES;
    [self.navigationController pushViewController:remind animated:YES];
    
}

-(void)push2ClassVc:(UIViewController *)classVc
{
    UserInfo *user = [UserInfoTool info];
    if (!user) {
        GesturePasswordController *vc = [[GesturePasswordController alloc] init];
        if ([vc exist] == YES) {
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else{
            [self.navigationController pushViewController:classVc animated:YES];
        }
}

-(void)getWeather
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:_latitude!=0?[NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%f,%f&output=json&ak=YQWP8GKeFXCxM96euaK4TZPL&mcode=PY.WangAn",_longitude,_latitude]:@"http://api.map.baidu.com/telematics/v3/weather?location=121.585632,31.189868&output=json&ak=YQWP8GKeFXCxM96euaK4TZPL&mcode=PY.WangAn" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.weatherBtn setTitle:@"" forState:UIControlStateNormal];
        NSDictionary *dic = [responseObject[@"results"][0] objectForKey:@"weather_data"][0];
        Weather *weather = [Weather objectWithKeyValues:dic];
        _tianQiQingKuangLabel.hidden = _wenDuLabel.hidden = _fengXIangLabel.hidden = NO;
        //判断白天还是晚上
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH"];
        NSString *str = [formatter stringFromDate:[NSDate date]];
        int time = [str intValue];
        if (time>=18||time<=06) {
            [_weatherImg sd_setImageWithURL:[NSURL URLWithString:weather.nightPictureUrl]];
        }
        else{
            [_weatherImg sd_setImageWithURL:[NSURL URLWithString:weather.dayPictureUrl]];
        }
        _wenDuLabel.text = weather.temperature;
        _fengXIangLabel.text = weather.wind;
        _tianQiQingKuangLabel.text = weather.weather;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@",error);
    }];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    if (_latitude!=0 && _longitude!=0) return;
    CLLocation *location = locations.lastObject;
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
    [self getWeather];
}
@end
