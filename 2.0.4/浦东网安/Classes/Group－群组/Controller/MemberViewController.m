//
//  MemberViewController.m
//  浦东网安
//
//  Created by jiji on 15/7/2.
//  Copyright (c) 2015年 PengYue. All rights reserved.
//

#import "MemberViewController.h"
#import "MJExtension.h"

#import "GroupMember.h"
#import "MemberCell.h"

#import "Gruop.h"
@interface MemberViewController ()
@property(nonatomic,strong)NSArray *memberArr;
@end

@implementation MemberViewController

static NSString * const reuseIdentifier = @"Cell";
-(NSArray *)memberArr
{
    if (!_memberArr) {
        self.memberArr = [NSArray array];
    }
           NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"GroupID"] = self.group.GroupID;
        
        [[HttpRequestManager sharedManager]POST:[NSString stringWithFormat:@"%@/%@",CZHURL,@"/GroupUser"] params:params success:^(NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.memberArr = [GroupMember objectArrayWithKeyValuesArray:dic[@"result"]];
        
            [self.collectionView reloadData];
        } failed:^{
            
        }];
    
    
    return _memberArr;
}

static NSString *ID = @"member";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组成员";
  
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    UINib *xib = [UINib nibWithNibName:@"MemberCell" bundle:nil];
   
    [self.collectionView registerNib:xib forCellWithReuseIdentifier:ID];
}


- (id)init
{
    
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 每一个cell的尺寸
    layout.itemSize = CGSizeMake(80, 80);
    
    // 垂直间距
    layout.minimumLineSpacing = 10;
    
    // 水平间距
    layout.minimumInteritemSpacing = 0;
    
    // 内边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    return [super initWithCollectionViewLayout:layout];
    
   
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.memberArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
   // cell.contentView
    GroupMember *member = self.memberArr[indexPath.row];
    cell.member = member;
    return cell;
}




@end
