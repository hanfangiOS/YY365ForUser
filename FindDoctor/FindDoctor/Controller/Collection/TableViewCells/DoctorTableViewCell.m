//
//  DoctorTableViewCell.m
//  FindDoctor
//
//  Created by Tom Zhang on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorTableViewCell.h"
#import "MiscFiveStarsState.h"
#import "CollectionVCConstants.h"

//#define outputBounds(a,b,c,d) NSLog(@"bounds: x=%f,y=%f,w=%f,h=%f",(a),(b),(c),(d))
//#define outputFrame(a,b,c,d) NSLog(@"frame: x=%f,y=%f,w=%f,h=%f",(a),(b),(c),(d))
//#define outpuCenter(a,b) NSLog(@"center: x=%f,y=%f",(a),(b))


@interface DoctorTableViewCell()

@property (nonatomic, retain) UIImageView *portrait;
@property (nonatomic, retain) MiscFiveStarsState *evaluation;
@property (nonatomic, retain) UILabel *name, *technicalTitle, *teachingTitle, *profile;

@end

@implementation DoctorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    // Initialization code
        
        _portrait = [[UIImageView alloc] initWithFrame:CGRectMake(4*kSpaceLength, kSpaceLength, 10*kSpaceLength, 10*kSpaceLength)];
        _portrait.layer.cornerRadius = _portrait.frameHeight / 2;
        _portrait.layer.masksToBounds = YES;
        _portrait.layer.borderWidth = 0;
        [self addSubview:_portrait];
        
        CGFloat evaluationHeight = 2*kSpaceLength;
        _evaluation = [[MiscFiveStarsState alloc] initWithFrame:CGRectMake(_portrait.frameX-2*kSpaceLength, _portrait.frameY+_portrait.frameHeight+kSpaceLength, 7*evaluationHeight, evaluationHeight)];
        [self addSubview:_evaluation];
        
        CGFloat nameHeight = evaluationHeight;
        _name = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width+_portrait.frameX+_portrait.frameWidth-(3+1.5*2*3)*nameHeight)/2, _portrait.frameY, 3*nameHeight, nameHeight)];
        [_name setFont:[UIFont systemFontOfSize:_name.frameHeight]];
        _name.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_name];
        
        _technicalTitle = [[UILabel alloc] initWithFrame:CGRectMake(_name.frameX+_name.frameWidth+kSpaceLength, _name.frameY, 1.5*_name.frameWidth, _name.frameHeight)];
        [_technicalTitle setFont:[UIFont systemFontOfSize:_technicalTitle.frameHeight]];
        _technicalTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_technicalTitle];
        
        _teachingTitle = [[UILabel alloc] initWithFrame:CGRectMake(_technicalTitle.frameX+_technicalTitle.frameWidth+kSpaceLength, _technicalTitle.frameY, _technicalTitle.frameWidth, _technicalTitle.frameHeight)];
        [_teachingTitle setFont:[UIFont systemFontOfSize:_teachingTitle.frameHeight]];
        _teachingTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_teachingTitle];
        
        CGFloat profileX = _portrait.frameX+_portrait.frameWidth+4*kSpaceLength;
        CGFloat profileY = _name.frameY+_name.frameHeight+kSpaceLength;
        _profile = [[UILabel alloc] initWithFrame:CGRectMake(profileX, profileY, [UIScreen mainScreen].bounds.size.width-profileX-kSpaceLength, kTableViewCellHeight-profileY-kSpaceLength)];
        _profile.numberOfLines = 0;
        [_profile setFont:[UIFont systemFontOfSize:10]];
        _profile.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_profile];
    }
    return self;
}

- (void)setDoctorPortrait:(NSString*)imageName {
    _portrait.image = [UIImage imageNamed:imageName];
}

- (void)setDoctorName:(NSString*)name technicalTitle:(NSString*)technicalTitle teachingTitle:(NSString*)teachingTitle {
    _name.text = name;
    _technicalTitle.text = technicalTitle;
    _teachingTitle.text = teachingTitle;
}

- (void)setDoctorProfile:(NSString*)profile {
    _profile.text = profile;
//    [_profile sizeToFit];
}

- (void)setEvaluationScore:(float)score {
    [_evaluation setScore:score];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
