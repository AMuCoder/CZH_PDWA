//
//  CZHCheckController.m
//  浦东网安
//
//  Created by Chun on 16/5/14.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "CZHCheckController.h"
#import "Detail2Cell.h"
#import "CheckInfo.h"
#import "CZHTableController.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "KeychainItemWrapper.h"

#import "UIImageView+WebCache.h"

@interface CZHCheckController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *dic3;
@property(nonatomic,strong)NSMutableArray *checkArray;
@property (strong, nonatomic)NSMutableDictionary *heights;
@end

@implementation CZHCheckController
- (NSMutableDictionary *)heights
{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
-(NSMutableArray *)checkArray
{
    if (!_checkArray) {
        self.checkArray = [NSMutableArray array];
    }
    return _checkArray;
}
-(NSDictionary *)dic3
{
    if (!_dic3) {
        self.dic3 = [NSDictionary dictionary];
    }
    return _dic3;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检查详情";
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
    NSString *loginusername = [Netba objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"netBarID"] = loginusername;
    params[@"collectName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic3 = dic[@"result"];
        NSArray *checkarrs  = [CheckInfo objectArrayWithKeyValuesArray:dic3[@"checkInfo"]];
        _checkArray       = (NSMutableArray *)[[checkarrs reverseObjectEnumerator] allObjects];
        
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
    NSString *loginusername = [Netba objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    CheckInfo *lastInfo = [self.checkArray lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.checkID;/////////带插入
    }
    params[@"netBarID"] = loginusername;
    params[@"collectName"] = username;
    
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic3 = dic[@"result"];
        
        NSArray *checkarrs  = [CheckInfo objectArrayWithKeyValuesArray:dic3[@"checkInfo"]];
        //_checkArray       = (NSMutableArray *)[[checkarrs reverseObjectEnumerator] allObjects];
        NSMutableArray *array       = (NSMutableArray *)[[checkarrs reverseObjectEnumerator] allObjects];
        [_checkArray addObject:array];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
*/
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heights[@(indexPath.row)] doubleValue];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.checkArray.count < 10);
    return _checkArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Detail2Cell *cell = [Detail2Cell cellWithTableView:tableView];
    cell.checkInfo = self.checkArray[indexPath.row];
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.checkcellheight);
    [cell.morebtn setHidden:YES];
    return cell;
}

@end
