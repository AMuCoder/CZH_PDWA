//
//  PersonController.m
//  浦东网安
//
//  Created by Mac on 16/6/8.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "PersonController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "KeychainItemWrapper.h"
#import "PersonInfo.h"
#import "PensonMessageCell.h"
#import "PersController.h"

@interface PersonController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *personarr;
@property (weak, nonatomic) IBOutlet UINavigationBar *narbars;

@property (strong, nonatomic)NSMutableDictionary *heights;
- (IBAction)back:(id)sender;

@end


@implementation PersonController

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
    //存储值用于条转
    KeychainItemWrapper * messtype = [[KeychainItemWrapper alloc]initWithIdentifier:@"messageTypes" accessGroup:nil];
    [messtype resetKeychainItem];
    //创建一个导航栏
    [_narbars setBarTintColor:CZHRGBColor(49, 174, 215)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview reloadData];
    [self setupUpRefresh];
    [self setupDownRefresh];
    
}
-(void)viewWillAppear:(BOOL)animated{
    KeychainItemWrapper * messtype = [[KeychainItemWrapper alloc]initWithIdentifier:@"messageTypes" accessGroup:nil];
    [messtype resetKeychainItem];
    [self setupDownRefresh];
    [self.tableview reloadData];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setupDownRefresh
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupcell)];
    [self.tableview.header beginRefreshing];
}
-(void)setupcell{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getMessageLogs"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.personarr = (NSMutableArray *)[PersonInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.tableview.header endRefreshing];
        [self.tableview reloadData];
    } failed:^{
        [self.tableview.header endRefreshing];
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
    self.tableview.footer = footer;
    
}
-(void)loadMore
{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PersonInfo *lastInfo = [self.personarr lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.id;
    }
    params[@"userName"] = username;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getMessageLogs"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *aaa = [PersonInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [_personarr addObjectsFromArray:aaa];
        [self.tableview.footer endRefreshing];
        [self.tableview reloadData];
    } failed:^{
        [self.tableview.footer endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableview.footer.hidden = (self.personarr.count < 10);
    return self.personarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PensonMessageCell *cell = [PensonMessageCell cellWithTableView:tableView];
    PersonInfo *personInfo = self.personarr[indexPath.row];
    cell.personInfo = personInfo;
    if ([personInfo.readType isEqualToString:@"1"]) {
        cell.txxt.text = @"已阅";
        [cell.txxt setTextColor:[UIColor blackColor]];
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
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[@(indexPath.row)] doubleValue];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
@end

