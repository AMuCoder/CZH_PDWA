//
//  CZHTableController.h
//  浦东网安
//
//  Created by Chun on 16/5/14.
//  Copyright © 2016年 PengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WangBaInfo,InfoDetailCell,SafeOfficer,CheckInfo,ChangeInfo,PunishInfo,SafeOfficer,SignInfo;
@interface CZHTableController : UIViewController
@property(nonatomic,strong)WangBaInfo *wangBaInfo;
@property(nonatomic,strong)InfoDetailCell *infoDetailCell;
@property(nonatomic,strong)SafeOfficer *safeOfficer;
@property(nonatomic,strong)CheckInfo *checkInfo;
@property(nonatomic,strong)ChangeInfo *changeInfo;
@property(nonatomic,strong)PunishInfo *punishInfo;
@property(nonatomic,strong)SafeOfficer *offer;
@property(nonatomic,strong)SignInfo *signInfo;

@property(nonatomic,strong)NSDictionary *dic2;
@property(nonatomic,strong)NSArray *OfficerArray;
@property(nonatomic,strong)NSArray *checkInfoArray;
@property(nonatomic,strong)NSArray *changeInfoArray;
@property(nonatomic,strong)NSArray *punishInfoArray;
@property(strong,nonatomic)NSArray *fficerarr;
@property(strong,nonatomic)NSDictionary *SIGNdic;
@property(strong,nonatomic)NSArray *SIGNarr;
@end
