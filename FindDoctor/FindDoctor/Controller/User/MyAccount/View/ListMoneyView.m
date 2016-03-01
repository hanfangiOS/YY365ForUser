//
//  ListMoneyView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "ListMoneyView.h"
#import "ListMoneyTableViewCell.h"
@interface ListMoneyView(){
    UIButton *costButton;
    UIButton *incomeButton;
}
@end
@implementation ListMoneyView
@synthesize incomeTableView;
@synthesize costTableView;
@synthesize contenScrollView;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self initTitle];
}

- (void)initTitle{
    NSString *title1 = @"现金支出";
    NSString *title2 = @"诊金券支出";
    CGSize size1 = [self sizeWithString:title1 font:[UIFont systemFontOfSize:12] lableWith:self.frameWidth];
    CGSize size2 = [self sizeWithString:title2 font:[UIFont systemFontOfSize:12] lableWith:self.frameWidth];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, size1.height/2 - 0.5, self.frameWidth, 1)];
    lineView.backgroundColor = UIColorFromHex(Color_Hex_Text_gray);
    [self addSubview:lineView];
    
    costButton = [[UIButton alloc]initWithFrame:CGRectMake((self.frameWidth/2-size1.width)/2 -5, 0, size1.width+10, size1.height)];
    costButton.layer.backgroundColor = self.backgroundColor.CGColor;
    [costButton setTitle:title1 forState:UIControlStateNormal];
    costButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [costButton setTitleColor:UIColorFromHex(Color_Hex_Text_gray) forState:UIControlStateNormal];
    [costButton setTitleColor:UIColorFromHex(Color_Hex_Text_Selected) forState:UIControlStateSelected];
    [costButton setSelected:YES];
    [costButton addTarget:self action:@selector(costButtonAction) forControlEvents:UIControlEventTouchUpInside  ];
    [self addSubview:costButton];
    
    incomeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frameWidth/2 + (self.frameWidth/2-size2.width)/2 -5 , 0, size2.width+10, size2.height)];
    incomeButton.layer.backgroundColor = self.backgroundColor.CGColor;
    [incomeButton setTitle:title2 forState:UIControlStateNormal];
    incomeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [incomeButton setTitleColor:UIColorFromHex(Color_Hex_Text_gray) forState:UIControlStateNormal];
    [incomeButton setTitleColor:UIColorFromHex(Color_Hex_Text_Selected) forState:UIControlStateSelected];
    [incomeButton addTarget:self action:@selector(incomeButtonAction) forControlEvents:UIControlEventTouchUpInside  ];
    [self addSubview:incomeButton];
    
    contenScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(incomeButton.frame)+5, self.frameWidth, self.frameHeight - CGRectGetMaxY(incomeButton.frame) - 5)];
    contenScrollView.contentSize = CGSizeMake(contenScrollView.frameWidth*2, contenScrollView.frameHeight);
    contenScrollView.pagingEnabled = YES;
    contenScrollView.showsVerticalScrollIndicator = NO;
    contenScrollView.showsHorizontalScrollIndicator = NO;
    contenScrollView.delegate = self;
    [self addSubview:contenScrollView];
    
    costTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, contenScrollView.frameWidth, contenScrollView.frameHeight)];
    costTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    costTableView.delegate = self;
    costTableView.dataSource = self;
    [contenScrollView addSubview:costTableView];
    
    incomeTableView = [[UITableView alloc]initWithFrame:CGRectMake(contenScrollView.frameWidth, 0, contenScrollView.frameWidth, contenScrollView.frameHeight)];
    incomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    incomeTableView.delegate = self;
    incomeTableView.dataSource =self;
    [contenScrollView addSubview:incomeTableView];
}

- (void)costButtonAction{
    [contenScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)costButtonAttrive{
    [costButton setSelected:YES];
    [incomeButton setSelected:NO];
}


- (void)incomeButtonAction{
    [contenScrollView setContentOffset:CGPointMake(contenScrollView.frameWidth, 0) animated:YES];
}

- (void)incomeButtonAttrive{
    [costButton setSelected:NO];
    [incomeButton setSelected:YES];
}

- (void)setData:(MyAccount *)data{
    _data = data;
}

#pragma mark -  scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    int page = floor((scrollView.contentOffset.x - scrollView.frameWidth/2)/scrollView.frameWidth) + 1;
    NSLog(@"%D",page);
    switch (page) {
        case 0:{
            [self costButtonAttrive];
            break;}
        case 1:{
            [self incomeButtonAttrive];
            break;
        }
        default:
            break;
    }
}

#pragma mark ------------------ tableView Delegate --------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == costTableView) {
        return self.data.costDetailList.count;
    }
    else{
        return self.data.incomeDetailList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == costTableView) {
        ListMoneyTableViewCell *cell =  [[ListMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.massage = [self.data.costDetailList[indexPath.row] massage];
        return [cell CellHeight];
    }
    else{
        ListMoneyTableViewCell *cell =  [[ListMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.massage = [self.data.incomeDetailList[indexPath.row] massage];
        return [cell CellHeight];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == costTableView) {
        static NSString *cellIdentifier = @"costListMoneyCell";
        
        ListMoneyTableViewCell *cell = (ListMoneyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell =  [[ListMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.massage = [self.data.costDetailList[indexPath.row] massage];
        cell.mark = @"+";
        cell.fee = [self.data.costDetailList[indexPath.row] fee];
        cell.timestamp = [self.data.costDetailList[indexPath.row] timeStamp];

        return cell;
    }
    else{
        static NSString *cellIdentifier = @"IncomeListMoneyCell";
        
        ListMoneyTableViewCell *cell = (ListMoneyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell =  [[ListMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.massage = [self.data.incomeDetailList[indexPath.row] massage];
        cell.mark = @"+";
        cell.fee = [self.data.incomeDetailList[indexPath.row] fee];
        cell.timestamp = [self.data.incomeDetailList[indexPath.row] timeStamp];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
@end
