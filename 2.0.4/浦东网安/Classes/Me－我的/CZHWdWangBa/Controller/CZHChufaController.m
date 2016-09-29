//
//  CZHChufaController.m
//  浦东网安
//
//  Created by Chun on 16/5/14.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "CZHChufaController.h"
#import "CZHTableController.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "KeychainItemWrapper.h"
#import "ChufaCell.h"
#import "PunishInfo.h"

@interface CZHChufaController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *dic5;
@property(nonatomic,strong)NSMutableArray *chufaArray;

@property (strong, nonatomic) NSMutableDictionary *heights;

@end

@implementation CZHChufaController
- (NSMutableDictionary *)heights
{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
-(NSMutableArray *)changeArray
{
    if (!_chufaArray) {
        self.chufaArray = [NSMutableArray array];
    }
    return _chufaArray;
}
-(NSDictionary *)dic5
{
    if (!_dic5) {
        self.dic5 = [NSDictionary dictionary];
    }
    return _dic5;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处罚详情";
    [self setupDownRefresh];
    //[self setupUpRefresh];
}
-(void)setupDownRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupcell)];
    
    [self.tableView.header beginRefreshing];
}
-(void)setupcell{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    KeychainItemWrapper * Netba = [[KeychainItemWrapper alloc]initWithIdentifier:@"NETaaa" accessGroup:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *loginusername = [Netba objectForKey:(__bridge id)kSecAttrAccount];
    params[@"netBarID"] = loginusername;
    params[@"collectName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic4 = dic[@"result"];
        NSArray *chufaarrs = [PunishInfo objectArrayWithKeyValuesArray:dic4[@"punishInfo"]];
        _chufaArray       = (NSMutableArray *)[[chufaarrs reverseObjectEnumerator] allObjects];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{

        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
/*
-(void)setupUpRefresh
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //设置文字
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    // 设置footer
    self.tableView.footer = footer;
}
-(void)loadMore{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    KeychainItemWrapper * Netba = [[KeychainItemWrapper alloc]initWithIdentifier:@"NETaaa" accessGroup:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *loginusername = [Netba objectForKey:(__bridge id)kSecAttrAccount];
    PunishInfo *lastInfo = [self.chufaArray lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.punishID;/////////带插入
    }
    params[@"netBarID"] = loginusername;
    params[@"collectName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic4 = dic[@"result"];
        NSArray *chufaarrs = [PunishInfo objectArrayWithKeyValuesArray:dic4[@"punishInfo"]];
        _chufaArray       = (NSMutableArray *)[[chufaarrs reverseObjectEnumerator] allObjects];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
*/

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChufaCell *cell = [ChufaCell cellWithTableView:tableView];
    cell.punishInfo = self.chufaArray[indexPath.row];
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.chufacellheight);
    [cell.gengduobtn setHidden:YES];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heights[@(indexPath.row)] doubleValue];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.chufaArray.count < 10);
    return _chufaArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
