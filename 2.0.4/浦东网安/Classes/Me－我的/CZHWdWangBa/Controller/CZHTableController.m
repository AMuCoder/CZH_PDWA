//
//  CZHTableController.m
//  浦东网安
//
//  Created by Chun on 16/5/14.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import "CZHTableController.h"
#import "InfoDetailCell.h"
#import "CheckInfo.h"
#import "ChangeInfo.h"
#import "PunishInfo.h"
#import "DetailCell.h"
#import "Detail2Cell.h"
#import "Detail3Cell.h"
#import "SignCell.h"
#import "SignInfo.h"
#import "ChuFaCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WangBaInfoCell.h"
#import "WangBaInfo.h"
#import "KeychainItemWrapper.h"
#import "HYCalendarView.h"
#import "CZHChangController.h"
#import "CZHCheckController.h"
#import "CZHChufaController.h"
#import "CtrlCodeScan.h"
#import "CalendarViewController.h"
#import "SafeOfficerCell.h"
#import "SafeOfficer.h"
#import "JianchaController.h"
#import "UserInfo.h"
#import "UserInfoTool.h"
#import "SafecellController.h"
#import "Tianjia.h"

@interface CZHTableController ()<UITableViewDataSource, UITableViewDelegate,UITabBarDelegate>
@property(nonatomic,copy)NSString *telNum;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@property (strong, nonatomic) NSMutableDictionary *checkheight;

@property (strong, nonatomic) NSMutableDictionary *changeheight;

@property (strong, nonatomic) NSMutableDictionary *chufaheight;

@property (strong, nonatomic) NSMutableDictionary *yezhuheight;

@property(nonatomic,copy)NSString *str;

@property(nonatomic,strong)UserInfo *info;

@end

@implementation CZHTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tabbar.delegate =self;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    [self setupcell];
    [self.tableview reloadData];// 刷新tableView列表
    [_tabbar setDelegate:self];
    self.tableview.tableFooterView = _tabbar;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    UserInfo *usersss = [UserInfoTool info];
    self.info = usersss;
    NSString *stringsss = @"19";
    if ([usersss.RoleID isEqualToString:stringsss]) {
        [self.tabbar setHidden:YES];
        self.tableview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        [self.tabbar setHidden:NO];
    }
    [self jianchasc];
}
-(void)jianchasc{
        if ([self.infoDetailCell.iscollect isEqualToString:@"1"]) {
            [[_tabbar.items objectAtIndex:0]setTitle:@"取消收藏"];
        }else{
            [[_tabbar.items objectAtIndex:0]setTitle:@"添加收藏"];
        }
}
-(NSDictionary *)SIGNdic//签到记录
{
    if (!_SIGNdic) {
        self.SIGNdic = [NSDictionary dictionary];
    }
    return _SIGNdic;
}

-(NSArray *)fficerarr//offer纪录
{
    if (!_fficerarr) {
        self.fficerarr = [NSArray array];
    }
    return _fficerarr;
}

-(NSMutableDictionary *)checkheight
{
    if (!_checkheight) {
        self.checkheight = [NSMutableDictionary dictionary];
    }
    return _checkheight;
}

-(NSMutableDictionary *)changeheight
{
    if (!_changeheight) {
        self.changeheight = [NSMutableDictionary dictionary];
    }
    return _changeheight;
}

-(NSMutableDictionary *)chufaheight
{
    if (!_chufaheight) {
        self.chufaheight = [NSMutableDictionary dictionary];
    }
    return _chufaheight;
}

-(NSMutableDictionary *)yezhuheight
{
    if (!_yezhuheight) {
        self.yezhuheight = [NSMutableDictionary dictionary];
    }
    return _yezhuheight;
}

-(NSDictionary *)dic2
{
    if (!_dic2) {
        self.dic2 = [NSDictionary dictionary];
    }
    return _dic2;
}

-(NSArray *)OfficerArray
{
    if (!_OfficerArray) {
        self.OfficerArray = [NSArray array];
    }
    return _OfficerArray;
}

-(NSArray *)checkInfoArray
{
    if (!_checkInfoArray) {
        self.checkInfoArray = [NSArray array];
    }
    return _checkInfoArray;
}

-(NSArray *)changeInfoArray
{
    if (!_changeInfoArray) {
        self.changeInfoArray = [NSArray array];
    }
    return _changeInfoArray;
}

-(NSArray *)punishInfoArray
{
    if (!_punishInfoArray) {
        self.punishInfoArray = [NSArray array];
    }
    return _punishInfoArray;
}
-(void)setupcell{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    KeychainItemWrapper * Netba = [[KeychainItemWrapper alloc]initWithIdentifier:@"NETaaa" accessGroup:nil];
    [Netba setObject:@"PY.WangAn" forKey:(__bridge id)kSecAttrService];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"collectName"] = username;
    params[@"netBarID"] = self.wangBaInfo.netBarID;
    [Netba setObject:self.wangBaInfo.netBarID forKey:(__bridge id)kSecAttrAccount];
    
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"getNetBarInfo"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.infoDetailCell = [InfoDetailCell objectWithKeyValues:dic[@"result"]];
        
        NSDictionary *dic2 = dic[@"result"];
        
        self.fficerarr = [SafeOfficer objectArrayWithKeyValuesArray:dic2[@"netBarSafeOfficer"]];
        
        NSArray *checkarr     = [CheckInfo objectArrayWithKeyValuesArray:dic2[@"checkInfo"]];
        
        NSArray *changarr     = [ChangeInfo objectArrayWithKeyValuesArray:dic2[@"changeInfo"]];
        
        NSArray *chufarr      = [PunishInfo objectArrayWithKeyValuesArray:dic2[@"punishInfo"]];
        
        _checkInfoArray       = (NSMutableArray *)[[checkarr reverseObjectEnumerator] allObjects];
        
        _changeInfoArray      = (NSMutableArray *)[[changarr reverseObjectEnumerator] allObjects];
        
        _punishInfoArray      = (NSMutableArray *)[[chufarr reverseObjectEnumerator] allObjects];
        
        _signInfo = [SignInfo objectWithKeyValues:dic2[@"signInfo"]];
        [self.tableview.header endRefreshing];
        
        [self.tableview reloadData];
        
    } failed:^{
        
        [self.tableview.header endRefreshing];
        
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //内存管理模块
    static NSString *aacellID = @"aacellID";
    UITableViewCell *aacell = [tableView dequeueReusableCellWithIdentifier:aacellID];
    if (!aacell) {
        aacell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aacellID];
        aacell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    static NSString *bbcellID = @"bbcellID";
    UITableViewCell *bbcell = [tableView dequeueReusableCellWithIdentifier:bbcellID];
    if (!bbcell) {
        bbcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bbcellID];
        [bbcell setAccessoryType:UITableViewCellAccessoryNone];
        bbcell.userInteractionEnabled = NO;
        bbcell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    SafeOfficerCell *safecell = [SafeOfficerCell cellWithTableView:tableView];
    
    DetailCell *cell   = [DetailCell cellWithTableView:tableView];
    cell.userInteractionEnabled = NO;
    
    Detail2Cell *cell2 = [Detail2Cell cellWithTableView:tableView];
    
    Detail3Cell *cell3 = [Detail3Cell cellWithTableView:tableView];
    
    SignCell *cell4 = [SignCell cellWithTableView:tableView];
    
    ChufaCell *cell5   = [ChufaCell cellWithTableView:tableView];
    
    //内容实现模块（加载xib或者加载代码）
    if (indexPath.section == 0) {//1.1基本信息
        if (indexPath.row == 0) {
            [cell layoutIfNeeded];
            return cell;
        }else if(indexPath.row == 1){//1.2
            aacell.textLabel.text = _infoDetailCell.netBarAddress;
            [aacell setAccessoryType:UITableViewCellAccessoryNone];
            return aacell;
        }else{                       //1.3
            aacell.textLabel.text = _infoDetailCell.netBarPhone;
            [aacell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return aacell;
        }
        
    } else if(indexPath.section == 1){//2安全员信息
        safecell.safeOfficer = self.fficerarr.lastObject;
        [safecell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return safecell;
        
    }else if(indexPath.section == 2){//3网吧基本信息
        NSString *str1 = @"网吧证号:";
        NSString *str2 = @"  网吧负责人:";
        NSString *str3 = @"  电脑台数:";
        NSString *str4 = @"  营业状况:";
        NSString *str11 = _infoDetailCell.netBarID;
        NSString *str22 = _infoDetailCell.netBarManager;
        NSString *str33 = _infoDetailCell.netBarComputerNum;
        NSString *str44 = _infoDetailCell.sysOnLineStatus;
        NSString *str5= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str1,str11,str2,str22,str3,str33,str4,str44];
        bbcell.textLabel.text = str5;
        bbcell.textLabel.numberOfLines = 0;
        
        KeychainItemWrapper * CZHnetBarManager = [[KeychainItemWrapper alloc]initWithIdentifier:@"CZHnetBarManager" accessGroup:nil];
        [CZHnetBarManager setObject:_infoDetailCell.userName forKey:(__bridge id)kSecAttrAccount];
        return bbcell;
        
    }else if(indexPath.section == 3){//4检查情况
        cell2.checkInfo = self.checkInfoArray.firstObject;
        // 强制布局
        [cell2 layoutIfNeeded];
        //更多按钮
        if (self.checkInfoArray.count <= 1) {
            [cell2.morebtn setHidden:YES];
        }else{
            [cell2.morebtn setHidden:NO];
            [cell2.morebtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchDown];
        }
        
        //显示行数
        if (self.checkInfoArray.count == 0) {
            [cell2 setHidden:YES];
        }
        return cell2;
        
    }else if(indexPath.section == 4){//5处罚情况
        cell5.punishInfo = self.punishInfoArray.firstObject;
        [cell5 layoutIfNeeded];
        //更多按钮
        if (self.punishInfoArray.count <= 1) {
            [cell5.gengduobtn setHidden:YES];
        }else{
            [cell5.gengduobtn setHidden:NO];
            [cell5.gengduobtn addTarget:self action:@selector(chufa) forControlEvents:UIControlEventTouchDown];
        }
        
        //显示行数
        if (self.punishInfoArray.count == 0) {
            [cell5 setHidden:YES];
        }
        return cell5;
        
    }else if(indexPath.section == 5){//6变更情况
        cell3.changeInfo = self.changeInfoArray.firstObject;
        [cell3 layoutIfNeeded];
        //更多按钮
        if (self.changeInfoArray.count <= 1) {
            [cell3.morebtn setHidden:YES];
        }else{
            [cell3.morebtn setHidden:NO];
            [cell3.morebtn addTarget:self action:@selector(chang) forControlEvents:UIControlEventTouchDown];
        }
        //显示行数
        if (self.changeInfoArray.count == 0) {
            [cell3 setHidden:YES];
        }
        return cell3;
        
    }else{
        [cell4 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell4.yzname.text = _infoDetailCell.netBarManager;
        cell4.yznum.text  = _signInfo.signCount;
        cell4.yztime.text = _signInfo.lastSign;
        if (_signInfo.signCount==nil) {
            [cell4.lablesss setHidden:YES];
        }
        return cell4;
    }
}
//自定义
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { //1
        if (indexPath.row == 0) {
            DetailCell *cell = [DetailCell cellWithTableView:tableView];
            return cell.yzheight;
        }else if(indexPath.row == 1){
            return 35;
        }else if(indexPath.row == 2){
            return 35;
        }
    }else if(indexPath.section == 1){//2
        if (_fficerarr.count == 1 ) {
            return 0;
        }else{
            return 36;
        }
    }else if(indexPath.section == 2){//3
        return 50;
    }else if(indexPath.section == 3){//4
        if (_checkInfoArray.count == 0) {
            return 0;
        }else{
            Detail2Cell *cell2 = [Detail2Cell cellWithTableView:tableView];
            cell2.checkInfo = self.checkInfoArray.firstObject;
            return cell2.checkcellheight;
        }
        
    }else if(indexPath.section == 4){//5
        if (_punishInfoArray.count == 0) {
            return 0;
        }else{
            ChufaCell *cell = [ChufaCell cellWithTableView:tableView];
            return cell.chufacellheight;
        }
        
    }else if(indexPath.section == 5){//6
        if (_changeInfoArray.count == 0) {
            return 0;
        }else{
            Detail3Cell *cell3 = [Detail3Cell cellWithTableView:tableView];
            return cell3.changecellheight;
        }
    }
    return 71;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item{
    if (tabBar == _tabbar) {
        if (Item.tag == 0) {
            if ([self.infoDetailCell.iscollect isEqualToString:@"1"]) {
                [self quxiaoshoucang];
            }else{
                [self tianjiashoucang];
            }
        }
        else if(Item.tag ==1){
            CtrlCodeScan *vc = [[CtrlCodeScan alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            JianchaController *vc = [[JianchaController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)quxiaoshoucang{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = username;
    params[@"netBarID"] = self.wangBaInfo.netBarID;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"user_qxShouc"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        Tianjia *aaa = [Tianjia objectWithKeyValues:dic[@"return"]];
        [MBProgressHUD showSuccess:aaa.message];
        [[_tabbar.items objectAtIndex:0]setTitle:@"添加收藏"];
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
}
- (void)tianjiashoucang{
    KeychainItemWrapper * CZHkeychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"PDWA" accessGroup:nil];
    NSString *username = [CZHkeychin objectForKey:(__bridge id)kSecAttrAccount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = username;
    params[@"netBarID"] = self.wangBaInfo.netBarID;
    [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"user_addShouc"] params:params success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        Tianjia *aaa = [Tianjia objectWithKeyValues:dic[@"return"]];
        [MBProgressHUD showSuccess:aaa.message];
        [[_tabbar.items objectAtIndex:0]setTitle:@"取消收藏"];
    } failed:^{
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //0基本信息//1安全员信息//2网吧基本信息//3检查情况/4处罚情况//5变更情况
    if (section == 0) {
        return 3;
    }else if(section ==1){
        return 1;
    }else if(section ==2){
        return 1;
    }else if(section ==3){
        return 1;
    }else if(section ==4){
        return 1;
    }else if(section ==5){
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 20;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        label.backgroundColor = [UIColor whiteColor];
        NSString *str1 = @" ";
        label.text=str1;
        return label ;
    }else if(section == 1){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        label.font = [UIFont fontWithName:@"Helvetica" size:14];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor brownColor];
        label.text=@" 安全员信息";
        return label ;
    }else if(section == 2){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        label.font = [UIFont fontWithName:@"Helvetica" size:14];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor brownColor];
        label.text=@" 网吧基本信息";
        return label ;
    }else if(section == 3){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        label.font = [UIFont fontWithName:@"Helvetica" size:14];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor brownColor];
        NSString *str1 = @" 检查情况(共";
        NSUInteger *inta = _checkInfoArray.count;
        NSString *str2 = [NSString stringWithFormat:@"%lu",(unsigned long)inta];
        NSString *str3 = @"条)";
        NSString *str4= [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        label.text= str4;
        return label ;
    }else if(section == 4){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        label.font = [UIFont fontWithName:@"Helvetica" size:14];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor brownColor];
        NSString *str1 = @" 处罚情况(共";
        NSUInteger *inta = _punishInfoArray.count;
        NSString *str2 = [NSString stringWithFormat:@"%lu",(unsigned long)inta];
        NSString *str3 = @"条)";
        NSString *str4= [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        label.text= str4;
        return label ;
    }else if(section == 5){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        label.font = [UIFont fontWithName:@"Helvetica" size:14];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor brownColor];
        NSString *str1 = @" 变更情况(共";
        NSUInteger *inta = _changeInfoArray.count;
        NSString *str2 = [NSString stringWithFormat:@"%lu",(unsigned long)inta];
        NSString *str3 = @"条)";
        NSString *str4= [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        label.text= str4;
        return label ;
    }else{
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        label.font = [UIFont fontWithName:@"Helvetica" size:14];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor brownColor];
        NSString *str1 = @" 业主签到记录(共";
        NSString *str2 = [[NSString alloc]init];
        if (_signInfo.signCount == nil) {
            str2 = @"0";
        }else{
            str2 = _signInfo.signCount;
        }
        NSString *str3 = @"条)";
        NSString *str4= [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        label.text= str4;
        return label ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            NSString *deviceType = [UIDevice currentDevice].model;
            if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
                //不支持
            }
            else{
                //支持打电话，在这里写打电话的方法
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_infoDetailCell.netBarPhone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }
    }else if (indexPath.section ==1) {
        SafecellController *vc = [[SafecellController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section ==6) {
        if (_signInfo.signCount==nil) {
            [MBProgressHUD showError:@"无签到记录!"];
        }else{
            CalendarViewController *vc = [[CalendarViewController alloc] init];
            //[self presentViewController:vc animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)check{
    CZHCheckController *vc = [[CZHCheckController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)chufa{
    CZHChufaController *vc = [[CZHChufaController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)chang{
    CZHChangController *vc = [[CZHChangController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSArray *)separateStringWithStr:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@","];
    return array;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
