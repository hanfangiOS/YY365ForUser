//
//  AddFamilyMemberViewController.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"

@interface messageInputView : UIView

@property UILabel *titleLabel;
@property UITextField *contentTextField;

- (instancetype)initWithFrame:(CGRect)frame;

@end

@interface SexChooseView : UIView{
    UIImage *imageActivated;
    UIImage *imageDisactivated;
    UIButton *buttonMale;
    UIButton *buttonFamale;
}

@property NSInteger sex;

@end

typedef void(^BackBlock)(NSInteger userId);

@interface AddFamilyMemberViewController : CUViewController

@property long long diagnosisID;

@property (nonatomic, strong)   messageInputView *nameView;
@property (nonatomic, strong)   SexChooseView *sexChooseView;
@property (nonatomic, strong)   messageInputView *ageView;
@property (nonatomic, strong)   messageInputView *phoneView;

@property (nonatomic, copy) BackBlock backBlock;


@end


