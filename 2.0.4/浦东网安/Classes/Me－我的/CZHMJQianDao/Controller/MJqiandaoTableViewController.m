//
//  MJqiandaoTableViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/22.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "MJqiandaoTableViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "KeychainItemWrapper.h"
#import "MJqiandaoInfo.h"
#import "MJqiandaoTableViewCell.h"


@interface MJqiandaoTableViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSArray *mjqiandaoarr;

@property (strong, nonatomic)NSMutableDictionary *heights;

@end

@implementation MJqiandaoTableViewController

- (NSMutableDictionary *)heights
{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
//数组
-(NSArray *)mjqiandaoarr
{
    if (!_mjqiandaoarr) {
        self.mjqiandaoarr = [NSArray array];
    }
    return _mjqiandaoarr;
}
-(void)viewWillAppear:(BOOL)animated{
    [self setupDownRefresh];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    [self.tableView reloadData];
    [self setupUpRefresh];
    [self setupDownRefresh];
}
///////////////////////////////////////////////////////////
-(void)setupDownRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupcell)];
    
    [self.tableView.header beginRefreshing];
}
-(void)setupcell{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getPoliceqiandaos"] params:params success:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.mjqiandaoarr = [MJqiandaoInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        
        //NSLog(@"mjqiandaoarr-----%lu",(unsigned long)_mjqiandaoarr.count);
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
-(void)setupUpRefresh{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    // 设置footer
    self.tableView.footer = footer;
    
}
-(void)loadMore
{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    MJqiandaoInfo *lastInfo = [self.mjqiandaoarr lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.id;
    }
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getPoliceqiandaos"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *aaa = [MJqiandaoInfo objectArrayWithKeyValuesArray:dic[@"result"]];
//        [_mjqiandaoarr addObjectsFromArray:aaa];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.mjqiandaoarr.count < 10);
    return self.mjqiandaoarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJqiandaoTableViewCell *cell = [MJqiandaoTableViewCell cellWithTableView:tableView];
    cell.mJqiandaoInfo = self.mjqiandaoarr[indexPath.row];
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.heights);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[@(indexPath.row)] doubleValue];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
