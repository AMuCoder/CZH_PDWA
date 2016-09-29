//
//  CZHTableViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/10.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "CZHTableViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"


#import "WangBaInfoCell.h"
#import "WangBaInfo.h"


#import "KeychainItemWrapper.h"
#import "CZHTableController.h"
@interface CZHTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property(strong, nonatomic) UISearchController *searchController;
@property(nonatomic,strong)NSMutableArray *allWBarray;
@property (strong, nonatomic)NSMutableDictionary *heights;
@end

@implementation CZHTableViewController
- (NSMutableDictionary *)heights
{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
//数组
-(NSMutableArray *)allWBarray
{
    if (!_allWBarray) {
        self.allWBarray = [NSMutableArray array];
    }
    return _allWBarray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    [self.tableView reloadData];// 刷新tableView列表
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
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfoByname"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.allWBarray = (NSMutableArray *)[WangBaInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        
        //NSLog(@"allWBarray-----%lu",(unsigned long)_allWBarray.count);
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
-(void)setupUpRefresh
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    self.tableView.footer = footer;
    
}
-(void)loadMore
{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WangBaInfo *lastInfo = [self.allWBarray lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.ID;
    }
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfoByname"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *moreNews = [WangBaInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.allWBarray addObjectsFromArray:moreNews];
        
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

////////////////////////////////////////////////////////////

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.allWBarray.count < 10);
    return self.allWBarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WangBaInfoCell *cell = [WangBaInfoCell cellWithTableView:tableView];
    WangBaInfo *wangBaInfo = self.allWBarray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.wangBaInfo = wangBaInfo;
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.alllheight);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //CZHDetailController *vc = [[CZHDetailController alloc] init];
    CZHTableController *vc = [[CZHTableController alloc] init];
    WangBaInfo *wangbainfo = self.allWBarray[indexPath.row];
    vc.wangBaInfo = wangbainfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[@(indexPath.row)] doubleValue];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
