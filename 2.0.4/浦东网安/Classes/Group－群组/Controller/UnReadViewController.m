//
//  UnReadViewController.m
//  浦东网安
//
//  Created by jyc on 15/7/3.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "UnReadViewController.h"



#import "UserInfoTool.h"
#import "MJExtension.h"
#import "UnRead.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "GroupInfo.h"
#import "Gruop.h"


@interface UnReadViewController ()
@property(nonatomic,strong)NSArray *unReadArr;
@end

@implementation UnReadViewController

-(NSArray *)unReadArr
{
    if (!_unReadArr) {
        self.unReadArr = [NSArray array];
    }
    return _unReadArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"未阅列表";
    
    [self setupUnRead];
    
}


-(void)setupUnRead
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"GroupID"] = self.group.GroupID;
    params[@"GroupInfoID"] = self.groupInfo.ID;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/noRead"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.unReadArr = [UnRead objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.tableView reloadData];
        
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
    
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.unReadArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UnRead *unR = self.unReadArr[indexPath.row];
    cell.textLabel.text = unR.UserName;
    return cell;
}

@end
