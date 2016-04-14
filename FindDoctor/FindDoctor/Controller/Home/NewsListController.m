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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息列表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.listModel.items.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"NewsListCell";
    NewsListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    return cell;
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
