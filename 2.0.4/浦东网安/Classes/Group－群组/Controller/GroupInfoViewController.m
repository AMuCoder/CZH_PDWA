//
//  GroupInfoViewController.m
//  浦东网安
//
//  Created by jiji on 15/6/30.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "GroupInfoViewController.h"

#import "GroupInfo.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "GroupInfoDetailViewController.h"
#import "MJRefresh.h"

#import "MemberViewController.h"
#import "GroupInfoCell.h"
#import "HaveReadViewController.h"
#import "UnReadViewController.h"


#import "Gruop.h"


@interface GroupInfoViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSMutableArray *groupInfos;
@end

@implementation GroupInfoViewController
-(NSMutableArray *)groupInfos
{
    if (!_groupInfos) {
        self.groupInfos = [NSMutableArray array];
    }
    return _groupInfos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readClick:) name:@"haveReadClick" object:nil];
    self.title = self.group.GroupName;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(checkGroupMembers) image:@"qzq" highImage:nil];
    [self setupDownRefresh];
    [self setupUpRefresh];
}

-(void)setupUpRefresh
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    // 设置文字
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置footer
    self.tableView.footer = footer;
    
}

-(void)loadMore
{
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    GroupInfo *lastInfo = [self.groupInfos lastObject];
    if (lastInfo) {
        params[@"GropuInfoID"] = lastInfo.ID;
    }
    params[@"GropuID"] = self.group.GroupID;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"GetGroupInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *moreNews = [GroupInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.groupInfos addObjectsFromArray:moreNews];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failed:^{
        [self.tableView.footer endRefreshing];
         [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(void)checkGroupMembers
{
    MemberViewController *member = [[MemberViewController alloc]init];
    member.group = self.group;
    [self.navigationController pushViewController:member animated:YES];
};

-(void)setupDownRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getGroupInfo)];
    
    [self.tableView.header beginRefreshing];
}

-(void)getGroupInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   // UserInfo *info = [UserInfoTool info];
    params[@"GropuID"] = self.group.GroupID;
    params[@"GropuInfoID"] = @"";
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"GetGroupInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.groupInfos = (NSMutableArray *)[GroupInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
    } failed:^{
        [self.tableView.header endRefreshing];
         [MBProgressHUD showError:@"网络错误!"];
    }];

}

-(void)haveReadClick:(UIButton *)btn
{
    HaveReadViewController *haveRead = [[HaveReadViewController alloc]init];
    //判断按钮所在行数
    UITableViewCell *cell = (UITableViewCell *)[[btn superview]superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    haveRead.groupInfo = self.groupInfos[indexPath.row];
    haveRead.group = self.group;
    [self.navigationController pushViewController:haveRead animated:YES];
}

-(void)unReadClick:(UIButton *)btn
{
    UITableViewCell *cell = (UITableViewCell *)[[btn superview]superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UnReadViewController *unR = [[UnReadViewController alloc]init];
    unR.group = self.group;
    unR.groupInfo = self.groupInfos[indexPath.row];
    [self.navigationController pushViewController:unR animated:YES  ];
}

-(void)readClick:(NSNotification *)not
{
    
    NSUInteger row = [not.userInfo[@"tag"] integerValue];
    //刷新某一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - tabaleViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.footer.hidden = (self.groupInfos.count < 10);
    return self.groupInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    GroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupInfoCell" owner:nil options:nil]lastObject];
    }
    GroupInfo *groupInfo = self.groupInfos[indexPath.row];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new"]];
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.accessoryView = img;
    }
    else{
        cell.accessoryView = nil;
    }
    cell.groupInfo = groupInfo;
    UserInfo *user = [UserInfoTool info];
    if ([user.AuthorityTag isEqual:@"_Browse;"]) {
        cell.haveRead.hidden = cell.unRead.hidden = YES;
    }
    
    [cell.haveRead addTarget:self action:@selector(haveReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.unRead addTarget:self action:@selector(unReadClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfoDetailViewController *detail = [[GroupInfoDetailViewController alloc]init];
    GroupInfo *info = self.groupInfos[indexPath.row];
    detail.gropuInfo = info;
    detail.group = self.group;
    //detail.selectIndex=[info.ID integerValue];
    detail.selectIndex = indexPath.row;
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
