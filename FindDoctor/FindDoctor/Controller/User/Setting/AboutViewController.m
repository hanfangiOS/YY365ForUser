//
//  AboutViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *headerView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel     *versionLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
}

- (void)loadContentView {
    int imageViewWidth = 100;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - imageViewWidth)/2, 20, imageViewWidth, imageViewWidth)];
    imageView.image = [UIImage imageNamed:@"Icon"];
    imageView.contentMode = 1;
    
    _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY + 10, kScreenWidth, 14)];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.text = [NSString stringWithFormat:@"优医365 V2.0.1"];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _versionLabel.maxY +20)];
    [headerView addSubview:imageView];
    [headerView addSubview:_versionLabel];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = self.contentView.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [UIView new];
    [self.contentView addSubview:self.tableView];
}

#pragma mark tableViewDelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AboutCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"检查更新";
            break;
        case 1:
            cell.textLabel.text = @"用户协议";
            break;
        case 2:
            cell.textLabel.text = @"为我的方便点赞";
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
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
