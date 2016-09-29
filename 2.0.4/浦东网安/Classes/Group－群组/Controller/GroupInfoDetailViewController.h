//
//  GroupInfoDetailViewController.h
//  浦东网安
//
//  Created by jyc on 15/7/8.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupInfo,Gruop;
@interface GroupInfoDetailViewController : UIViewController
@property(nonatomic,weak)GroupInfo *gropuInfo;
@property(nonatomic,strong)Gruop *group;
@property(nonatomic,strong)UIButton *haveReadBtn;
@property(nonatomic,assign)NSInteger selectIndex;
@end
