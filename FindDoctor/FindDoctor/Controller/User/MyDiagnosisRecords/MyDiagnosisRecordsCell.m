//
//  YueZhenRecordTableViewCell.m
//  
//
//  Created by Guo on 15/10/6.
//
//



#import "MyDiagnosisRecordsCell.h"
#import "UIImageView+WebCache.h"

#define kMyDiagnosisRecordsCellHeight (155.0 + 35)
#define KTableViewCellLeftDistence 0

@interface MyDiagnosisRecordsCell()
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;
    
    UIImageView *_stateImageView;
}

@end

@implementation MyDiagnosisRecordsCell

+ (CGFloat)defaultHeight
{
    return kMyDiagnosisRecordsCellHeight ;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    int leftpadding = 16;
    int intervalY = 20;
    
    self.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(KTableViewCellLeftDistence, 7.5, kScreenWidth-KTableViewCellLeftDistence*2,kMyDiagnosisRecordsCellHeight - 15)];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.borderWidth = 0.5;
    baseView.layer.borderColor = [UIColorFromHex(0xCCCCCC)CGColor];
    [self.contentView addSubview:baseView];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, 20, baseView.frameWidth - leftpadding*2, 12)];
    label1.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label1.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label2.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label2];
    
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label2.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label3.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label3];
    
    label4 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label3.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label4.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label4];
    
    label5 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label4.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label5.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label5];
    
    _stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(baseView.frameWidth - 65, 0, 65, 65)];
    _stateImageView.contentMode = 1;
    [baseView addSubview:_stateImageView];

}

- (void)setData:(CUOrder *)data
{
    _data = data;

    label1.text = [NSString stringWithFormat:@"单   号: %lld",_data.diagnosisID];
    
    label2.text = [NSString stringWithFormat:@"约诊医生: %@ %@",_data.service.doctor.name,_data.service.doctor.levelDesc];
    
    label3.text = [NSString stringWithFormat:@"约诊人: %@，%@，%d岁，诊金￥%.2lf",_data.service.patience.name,(_data.service.patience.gender == 0 ? @"女":@"男"),_data.service.patience.age,_data.dealPrice/100.f];
    
    
    label4.text = [NSString stringWithFormat:@"下单时间: %@",[[NSDate dateWithTimeIntervalSince1970:_data.submitTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    
    label5.text = [NSString stringWithFormat:@"约诊地点: %@",_data.service.doctor.address];
    
    
    switch (_data.state) {
        case 1:
        {
            _stateImageView.image = [UIImage imageNamed:@"pay_no"];
        }break;
        case 2:
        {
            _stateImageView.image = [UIImage imageNamed:@"icon_unfinish"];
        }break;
        case 3:
        {
            _stateImageView.image = [UIImage imageNamed:@"icon_unfinish"];
        }break;
        case 4:{
            _stateImageView.image = [UIImage imageNamed:@"icon_finish"];
        }break;
        default:
            
            break;
    }
    
    [self setNeedsDisplay];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
