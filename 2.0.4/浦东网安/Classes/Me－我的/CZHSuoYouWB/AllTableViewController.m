//
//  TableViewController.m
//  浦东网安
//
//  Created by Chun on 16/5/17.
//  Copyright © 2016年 PengYue. All rights reserved.
//
#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]

#import "AllTableViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"




#import "CZHTableController.h"
#import "MaBi.h"
#import "WangBaInfoCell.h"
#import "WangBaInfo.h"
@interface AllTableViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray *alllWBarray;
@property(strong,nonatomic)NSMutableDictionary *heights;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *searchs;
@end

@implementation AllTableViewController


- (NSMutableDictionary *)heights{
    if (!_heights) {
        _heights = [NSMutableDictionary dictionary];
    }
    return _heights;
}
-(NSMutableArray *)alllWBarray{
    if (!_alllWBarray) {
        self.alllWBarray = [NSMutableArray array];
    }
    return _alllWBarray;
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
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self setupUpRefresh];
    [self setupDownRefresh];
    [self.tableView reloadData];
    
    _searchs = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchs.layer.cornerRadius = 5.0;
    _searchs.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 6, 3*self.view.frame.size.width/4, 30)];
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.placeholder = @"请输入网吧名";
    _textField.layer.cornerRadius = 5.0;
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-56, 6, 46, 30)];
    _btn.layer.cornerRadius = 5.0;
    [_btn setTitle:@"搜索" forState:UIControlStateNormal];
    _btn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    [_btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [_searchs addSubview:_textField];
    [_searchs addSubview:_btn];
    self.tableView.tableHeaderView = _searchs;
}



////////////////////////////////////////////////////////////
- (void)tap{
    if (self.textField.text.length == 0) {
        [self setupDownRefresh];
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        WangBaInfo *lastInfo = [self.alllWBarray lastObject];
        if (lastInfo) {
            params[@"id"] = lastInfo.ID;
        }
        params[@"netBarName"] = self.textField.text;
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@%@",CZHURL,@"/getAllNetBarInfo"] params:params success:^(NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _alllWBarray = (NSMutableArray *)[WangBaInfo objectArrayWithKeyValuesArray:dic[@"result"]];
            //[_alllWBarray addObjectsFromArray:bbb];
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            [self.view endEditing:YES];
        } failed:^{
            [self.tableView.header endRefreshing];
            [MBProgressHUD showError:@"网络错误!"];
        }];
    }
}

///////////////////////////////////////////////////////////
-(void)setupDownRefresh{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupcell)];
    
    [self.tableView.header beginRefreshing];
}

-(void)setupcell{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@""] = @"";
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@%@",CZHURL,@"/getAllNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        _alllWBarray = (NSMutableArray *)[WangBaInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
-(void)setupUpRefresh{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    // 设置文字
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    // 设置footer
    self.tableView.footer = footer;
}
-(void)loadMore{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WangBaInfo *lastInfo = [self.alllWBarray lastObject];
    if (lastInfo) {
        params[@"id"] = lastInfo.ID;
    }
    params[@""] = @"";
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@%@",CZHURL,@"/getAllNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *moreNews = [WangBaInfo objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.alllWBarray addObjectsFromArray:moreNews];
        
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failed:^{
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}


#pragma mark - Table view data source
////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.alllWBarray.count < 10);
    return self.alllWBarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WangBaInfoCell *cell = [WangBaInfoCell cellWithTableView:tableView];
    cell.wangBaInfo = self.alllWBarray[indexPath.row];
    // 强制布局
    [cell layoutIfNeeded];
    // 存储高度
    self.heights[@(indexPath.row)] = @(cell.alllheight);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZHTableController *vc = [[CZHTableController alloc] init];
    WangBaInfo *wangbainfo = self.alllWBarray[indexPath.row];
    vc.wangBaInfo = wangbainfo;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[@(indexPath.row)] doubleValue];
}
////////////////////////////////////////////////////////////
- (NSMutableArray *)separateStringWithArray:(NSArray *)array{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *str in array) {
        NSArray *strArray = [str componentsSeparatedByString:@" "];
        [dataArray addObject:strArray[0]];
        
    }
    
    return dataArray;
}
- (NSArray *)separateStringWithStr:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@","];
    return array;
}
@end
