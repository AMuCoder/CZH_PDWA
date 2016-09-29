//
//  ShoucangController.m
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "ShoucangController.h"
#import "AllTableViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "CZHTableController.h"
#import "WangBaInfoCell.h"
#import "WangBaInfo.h"
#import "KeychainItemWrapper.h"
@interface ShoucangController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray *Shouarray;
@property(strong,nonatomic)NSMutableDictionary *heights;
@end

@implementation ShoucangController
- (NSMutableDictionary *)heights{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
//数组
-(NSMutableArray *)Shouarray{
    if (!_Shouarray) {
        self.Shouarray = [NSMutableArray array];
    }
    return _Shouarray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self setupcell];
    [self.tableView reloadData];// 刷新tableView列表
}

-(void)viewDidAppear:(BOOL)animated{
    [self setupDownRefresh];
    [self.tableView reloadData];// 刷新tableView列表
}
-(void)setupDownRefresh{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupcell)];
    [self.tableView.header beginRefreshing];
}

-(void)setupcell{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@%@",CZHURL,@"/getCollectNetBarInfoByname"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.Shouarray = (NSMutableArray *)[WangBaInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

#pragma mark - Table view data source
////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.Shouarray.count < 10);
    return self.Shouarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WangBaInfoCell *cell = [WangBaInfoCell cellWithTableView:tableView];
    cell.wangBaInfo = self.Shouarray[indexPath.row];
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.alllheight);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZHTableController *vc = [[CZHTableController alloc] init];
    WangBaInfo *wangbainfo = self.Shouarray[indexPath.row];
    vc.wangBaInfo = wangbainfo;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[@(indexPath.row)] doubleValue];
}
////////////////////////////////////////////////////////////
@end
