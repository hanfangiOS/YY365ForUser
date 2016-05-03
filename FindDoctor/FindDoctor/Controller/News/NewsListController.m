//
//  NewsListController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "NewsListController.h"
#import "NewsListModel.h"
#import "NewsListCell.h"
#import "TipMessageData.h"

@interface NewsListController (){
    NSInteger _cellHeight;
}

@property (nonatomic,strong)    NewsListModel  * listModel;

@end

@implementation NewsListController

- (id)initWithPageName:(NSString *)pageName listModel:(NewsListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    _cellHeight = 0;
    if (self) {
        
    }
    
    return self;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息列表";
}

- (void)loadContentView{
    self.contentTableView.backgroundColor = kCommonBackgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listModel.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TipMessageData * data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    NSString * str = data.title;
    CGSize size = [self sizeForString:str font:[UIFont systemFontOfSize:17] limitSize:CGSizeMake(kScreenWidth - (40 + 15 + 25), 0)];
    return (size.height + 15 + 12);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"NewsListCell";
    NewsListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    return cell;
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
