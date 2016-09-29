//
//  SafecellController.m
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "SafecellController.h"
#import "CZHTableController.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "KeychainItemWrapper.h"
#import "SafeOfficerCell.h"
#import "SafeOfficer.h"

@interface SafecellController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *dic6;
@property(nonatomic,strong)NSMutableArray *Safferarr;
@end

@implementation SafecellController
-(NSMutableArray *)Safferarr
{
    if (!_Safferarr) {
        self.Safferarr = [NSMutableArray array];
    }
    return _Safferarr;
}
-(NSDictionary *)dic6
{
    if (!_dic6) {
        self.dic6 = [NSDictionary dictionary];
    }
    return _dic6;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"安全员信息";
    [self setupDownRefresh];
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
        NSDictionary *dic6 = dic[@"result"];
        NSArray *safferarr = [SafeOfficer objectArrayWithKeyValuesArray:dic6[@"netBarSafeOfficer"]];
        _Safferarr       = (NSMutableArray *)[[safferarr reverseObjectEnumerator] allObjects];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SafeOfficerCell *cell = [SafeOfficerCell cellWithTableView:tableView];
    cell.safeOfficer = self.Safferarr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _Safferarr.count;
}
@end
