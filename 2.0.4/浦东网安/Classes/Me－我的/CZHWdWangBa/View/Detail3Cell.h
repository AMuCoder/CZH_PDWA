//
//  Detail3Cell.h
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangeInfo;
@interface Detail3Cell : UITableViewCell

@property(nonatomic,strong)ChangeInfo *changeInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *mjnamelable;
@property (weak, nonatomic) IBOutlet UIImageView *mjimage;
@property (weak, nonatomic) IBOutlet UILabel *taillable;
@property (weak, nonatomic) IBOutlet UILabel *timelable;
@property (weak, nonatomic) IBOutlet UIButton *morebtn;

-(CGFloat)changecellheight;

@end
