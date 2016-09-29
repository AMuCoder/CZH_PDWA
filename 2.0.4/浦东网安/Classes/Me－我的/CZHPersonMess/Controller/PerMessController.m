//
//  PerMessController.m
//  浦东网安
//
//  Created by Chun on 16/5/19.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "PerMessController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "KeychainItemWrapper.h"
#import "PersonInfo.h"
#import "PensonMessageCell.h"
#import "PersController.h"
@interface PerMessController ()
@property(nonatomic,strong)NSMutableArray *personarr;

@property (strong, nonatomic)NSMutableDictionary *heights;
@end

@implementation PerMessController

- (NSMutableDictionary *)heights
{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
//数组
-(NSMutableArray *)personarr
{
    if (!_personarr) {
        self.personarr = [NSMutableArray array];
    }
    return _personarr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    [self.tableView reloadData];// 刷新tableView列表
    [self setupUpRefresh];
    [self setupDownRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupDownRefresh];
    [self.tableView reloadData];// 刷新tableView列表
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
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getMessageLogs"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.personarr = (NSMutableArray *)[PersonInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        
        //NSLog(@"allWBarray-----%lu",(unsigned long)_personarr.count);
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
    
    // 设置文字
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
    PersonInfo *lastInfo = [self.personarr lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.ID;
    }
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfoByname"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *aaa = [PersonInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [_personarr addObjectsFromArray:aaa];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.personarr.count < 10);
    return self.personarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PensonMessageCell *cell = [PensonMessageCell cellWithTableView:tableView];
    PersonInfo *personInfo = self.personarr[indexPath.row];
    cell.personInfo = personInfo;
    if ([personInfo.readType isEqualToString:@"1"]) {
        cell.txxt.text = @"已阅";
        [cell.txxt setTextColor:CZHRGBColor(49, 178, 211)];
    }
    if (personInfo.userName == nil) {
        [cell.txxt setHidden:YES];
    }
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.heights);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonInfo *personInfo = self.personarr[indexPath.row];
    if (personInfo.userName != nil) {
        PersController *vc = [[PersController alloc] init];
        PersonInfo *person = self.personarr[indexPath.row];
        vc.personInfo = person;
        vc.selectIndex = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[@(indexPath.row)] doubleValue];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
