//
//  HaveReadViewController.m
//  浦东网安
//
//  Created by jiji on 15/7/2.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "HaveReadViewController.h"



#import "UserInfoTool.h"
#import "MJExtension.h"
#import "HaveRead.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "GroupInfo.h"
#import "Gruop.h"

@interface HaveReadViewController ()
@property(nonatomic,strong)NSArray *haveReadArr;
@end


@implementation HaveReadViewController
-(NSArray *)haveReadArr
{
    if (!_haveReadArr) {
        self.haveReadArr = [NSArray array];
   
    }
    return _haveReadArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已阅列表";
   
    [self setupHaveRead];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)setupHaveRead
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"GroupID"] = self.group.GroupID;
    params[@"GroupInfoID"] = self.groupInfo.ID;
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/yesRead"] params:params success:^(NSData *data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    self.haveReadArr = [HaveRead objectArrayWithKeyValuesArray:dic[@"result"]];
                    [self.tableView reloadData];
        } failed:^{
             [MBProgressHUD showError:@"网络错误!"];
        }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.haveReadArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    HaveRead *haveR = self.haveReadArr[indexPath.row];
    cell.textLabel.text = haveR.UserName;
    return cell;
}
@end
