//
//  MemberCell.m
//  浦东网安
//
//  Created by jiji on 15/7/2.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "MemberCell.h"
#import "GroupMember.h"
@interface MemberCell()
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage;

@end
@implementation MemberCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setMember:(GroupMember *)member
{
    _member = member;
    _memberName.text = member.PerName;
    _memberImage.layer.masksToBounds = YES;
    _memberImage.layer.cornerRadius = 3.0;
}
@end
