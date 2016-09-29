//
//  DetailCell.h
//  浦东网安
//
//  Created by Chun on 16/5/10.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoDetailCell;
@interface DetailCell : UITableViewCell
@property(nonatomic,strong)InfoDetailCell *infoDetailCell;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(CGFloat)yzheight;

@property (weak, nonatomic) IBOutlet UIImageView *wbimage;//头像
@property (weak, nonatomic) IBOutlet UIImageView *wbpjimage;//等级星图片
@property (weak, nonatomic) IBOutlet UILabel *yyzk;//网吧营业状况
@property (weak, nonatomic) IBOutlet UILabel *xiaofangnum;//消防次数
@property (weak, nonatomic) IBOutlet UILabel *huanjing;//环境次数
@property (weak, nonatomic) IBOutlet UILabel *fuwu;//服务次数
@end
