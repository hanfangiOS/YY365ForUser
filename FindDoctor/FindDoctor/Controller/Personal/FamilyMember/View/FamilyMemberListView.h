//
//  FamilyMemberListView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUUser.h"

typedef void(^FamilyMemberDeleteAction)(NSInteger index);

@interface FamilyMemberListView : UIView

@property (nonatomic, copy) CUCommomButtonAction addMemberBlock;
@property (nonatomic, copy) FamilyMemberDeleteAction deleteMemberBlock;

+ (CGFloat)defaultHeight;

- (void)reloadData:(NSArray *)dataArray;

@end
