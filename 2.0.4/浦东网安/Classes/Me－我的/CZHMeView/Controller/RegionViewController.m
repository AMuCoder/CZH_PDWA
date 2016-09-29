//
//  RegionViewController.m
//  浦东网安
//
//  Created by jyc on 15/7/11.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "RegionViewController.h"


#import "MJExtension.h"
#import "UIView+Extension.h"


@interface RegionViewController ()
@property(nonatomic,strong)NSArray *regionArr;
@end

@implementation RegionViewController
-(NSArray *)regionArr
{
    if (!_regionArr) {
        self.regionArr = [NSArray array];
        self.regionArr = @[@"全部辖区",@"花木辖区",@"张江辖区",@"南码头辖区",@"周浦辖区",@"六灶辖区"];
    }
    return _regionArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
   // [self setRegion];
}

-(void)setRegion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
[[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@,%@",CZHURL,@"/GetPopedom"] params:params success:^(NSData *data) {
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dic);
} failed:^{
    
}];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

       return self.regionArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
       cell.textLabel.text = self.regionArr[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (indexPath.row == 0) {
            userInfo[@"selectedRegion"] = @"0";
        }
        else{
            userInfo[@"selectedRegion"] = self.regionArr[indexPath.row];
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedRegion" object:nil userInfo:userInfo];
    }];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
