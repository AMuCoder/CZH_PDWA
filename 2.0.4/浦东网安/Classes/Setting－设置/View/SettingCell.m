//
//  SettingCell.m
//  浦东网安
//
//  Created by jiji on 15/6/16.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "SettingCell.h"
#import "SettingItem.h"
#import "SettingArrowItem.h"
#import "SettingTextItem.h"
#import "SettingPhoneCallItem.h"
#import "AFNetworking.h"
#import "MJExtension.h"



@interface SettingCell ()
@property(nonatomic,strong)UILabel *aboutLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,weak)UIView *lineView;
@end
@implementation SettingCell
-(UIView *)lineView
{
    if (!_lineView){
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.2;
        _lineView = lineView;
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

-(UILabel *)aboutLabel
{
    if (!_aboutLabel){
        _aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        _aboutLabel.text = @"2.0.4";
        _aboutLabel.textAlignment = NSTextAlignmentRight;
    }
    return _aboutLabel;
}

-(UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"GetMobile"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (![responseObject[@"result"]isEqual:[NSNull null]]) {
                _phoneLabel.text =  responseObject[@"result"][0][@"Mobile"];
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                                    userInfo[@"phoneNum"] = _phoneLabel.text;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"phonNum" object:nil userInfo:userInfo];
            }
          
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"Failed to log in: %@", operation.responseString);
        }];
        
        _phoneLabel.textColor = [UIColor blueColor];
        _phoneLabel.textAlignment = NSTextAlignmentRight;
       
    }
    return _phoneLabel;
}

-(void)setItem:(SettingItem *)item
{
    _item = item;
    [self setupData];
    [self setUpAccessoryView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 给divide设置位置
    
    CGFloat lineH = 1;
    CGFloat lineW = self.bounds.size.width;
    CGFloat lineY = self.bounds.size.height - lineH;
    self.lineView.frame = CGRectMake(0, lineY, lineW, lineH);
    
    
}
-(void)setupData
{
    self.imageView.image = [UIImage imageNamed:_item.icon];
    self.textLabel.text = _item.title;
}

-(void)setUpAccessoryView
{
    if ([_item isKindOfClass:[SettingArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if ([_item isKindOfClass:[SettingTextItem class]]){
        self.accessoryView = self.aboutLabel;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([_item isKindOfClass:[SettingPhoneCallItem class]]){
        self.accessoryView = self.phoneLabel;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
