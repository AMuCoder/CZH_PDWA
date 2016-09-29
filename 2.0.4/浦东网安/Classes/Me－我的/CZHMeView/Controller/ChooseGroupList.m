//
//  ChooseGroupList.m
//  浦东网安
//
//  Created by jiji on 15/7/10.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "ChooseGroupList.h"


#import "MJExtension.h"
#import "Gruop.h"
#import "UIView+Extension.h"
#import "UserInfo.h"
#import "UserInfoTool.h"

@interface ChooseGroupList ()
@property(nonatomic,strong)NSArray *groupArr;
@property(nonatomic,strong)NSMutableDictionary *groupDic;
@end

@implementation ChooseGroupList
-(NSArray *)groupArr
{
    if (!_groupArr) {
        self.groupArr = [NSArray array];
    }
    return _groupArr;
}

-(NSMutableDictionary *)groupDic
{
    if (!_groupDic) {
        self.groupDic = [NSMutableDictionary dictionary];
    }
    return _groupDic;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self setupGroup];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES];
    
}

-(void)setupGroup
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userID"] = @"";
    
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/GetGroup"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.groupArr = [Gruop objectArrayWithKeyValuesArray:dic[@"result"]];
        [self.tableView reloadData];
    } failed:^{
        
    }];
    
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
//        return 1;
//    }else  {
        return self.groupArr.count + 1;
//   }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    if (indexPath.section == 0) {
//            cell.textLabel.text = @"全部群组";
//    }
//    else if (indexPath.section == 1){
        if (indexPath.row == self.groupArr.count) {
            static NSString *cellID = @"all";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
        
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height-1)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:@"确 定" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            return cell;
        }
        Gruop *group = self.groupArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",group.GroupName];
//        }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        for (int row=0; row<self.groupArr.count; row++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }
//    }
//    if (indexPath.section == 1) {
        Gruop *group = self.groupArr[indexPath.row];
         self.groupDic[indexPath] = group.GroupID;;
//        }
   
 }

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
        [self.groupDic removeObjectForKey:indexPath];
//    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//点击确定
-(void)back:(UIButton *)btn
{
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.groupDic allValues].count) {
                NSString *groupStr = [self.groupDic allValues][0];
                for (int i = 1; i<[self.groupDic allValues].count; i++) {
                    groupStr = [NSString stringWithFormat:@"%@,%@",groupStr,[self.groupDic allValues][i]];
                    
                }
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                
                userInfo[@"selectedIndex"] = groupStr;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedIndex" object:nil userInfo:userInfo];

              
            }
    
    }];

}


@end
