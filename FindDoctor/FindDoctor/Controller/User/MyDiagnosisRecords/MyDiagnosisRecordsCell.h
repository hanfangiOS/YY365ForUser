//
//  YueZhenRecordTableViewCell.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface MyDiagnosisRecordsCell : UITableViewCell

@property (nonatomic, strong) CUOrder *data;

+ (CGFloat)defaultHeight;

@end
