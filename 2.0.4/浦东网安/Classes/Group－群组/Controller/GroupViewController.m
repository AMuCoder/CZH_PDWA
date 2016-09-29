//
//  GroupViewController.m
//  浦东网安
//
//  Created by jyc on 15/6/21.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "GroupViewController.h"

#import "MJExtension.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "Gruop.h"
#import "GroupInfoViewController.h"

#import "UIImageView+WebCache.h"


@interface GroupViewController ()
@property(nonatomic,strong)NSArray *groupArr;
@end

@implementation GroupViewController
-(void)viewWillAppear:(BOOL)animated
{
    UserInfo *info = [UserInfoTool info];
    //title图片
    if (!info) {
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView_1"]];
        //导航栏背景颜色
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg_1"]]];
    }
    else{
        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
        //导航栏背景颜色
        [self.navigationController.navigationBar setBarTintColor:CZHRGBColor(49, 174, 215)];
    }
    //添加用户显示
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((2*self.view.frame.size.width/3), 7, (self.navigationController.view.frame.size.width/3), 31)];
    lable.text = info.UserName;
    lable.backgroundColor = CZHRGBColor(49, 174, 215);
    lable.font = [UIFont fontWithName:@"Helvetica" size:14];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:lable];
    [super viewWillAppear:animated];
}
-(NSArray *)groupArr
{
    if (!_groupArr) {
        self.groupArr = [NSArray array];
    }
    return _groupArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupGroup];
    
}



-(void)setupGroup
{
        UserInfo *info = [UserInfoTool info];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        if ([info.AuthorityTag isEqualToString:@"_Browse;"]) {
//            params[@"GroupID"] = info.GroupID;
//        }
//        else {
            params[@"userID"] = info.UserID;
//     };
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"GetGroup"] params:params success:^(NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
            self.groupArr = [Gruop objectArrayWithKeyValuesArray:dic[@"result"]];
        
            [self.tableView reloadData];
        } failed:^{
            [MBProgressHUD showError:@"网络错误!"];
        }];
    
}

//[NSString stringWithFormat:@"%@/%@",CZHURL,@"/GetGroup"]
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Gruop *group = self.groupArr[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",group.GroupName];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:group.GroupPhoto] placeholderImage:[UIImage imageNamed:@"ic_launcher"]];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 6.0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfoViewController *groupInfo = [[GroupInfoViewController alloc]init];
    Gruop *group = self.groupArr[indexPath.row];
    groupInfo.group = group;
    [self.navigationController pushViewController:groupInfo animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end
