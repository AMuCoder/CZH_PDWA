//
//  Detail2Cell.h
//  浦东网安
//
//  Created by Chun on 16/5/11.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckInfo;
@interface Detail2Cell : UITableViewCell

@property(nonatomic,strong)CheckInfo *checkInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *morebtn;

@property (weak, nonatomic) IBOutlet UILabel *mjname;
@property (weak, nonatomic) IBOutlet UIImageView *wjximage;
@property (weak, nonatomic) IBOutlet UILabel *hege;
@property (weak, nonatomic) IBOutlet UILabel *detaillable;
@property (weak, nonatomic) IBOutlet UILabel *timelable;
@property (weak, nonatomic) IBOutlet UIImageView *imegeesView;


- (CGFloat)checkcellheight;
@end
