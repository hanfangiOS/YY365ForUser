//
//  MyMemberViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyMemberViewController.h"
#import "MyMemberCell.h"

@interface MyMemberViewController ()

@property (nonatomic,strong)    MyMemberListModel  * listModel;

@end

@implementation MyMemberViewController

- (id)initWithPageName:(NSString *)pageName listModel:(MyMemberListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    if (self) {
        
    }
    
    return self;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"myAccountBigButtonImage"] action:@selector(addMemberAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的成员";
}

- (void)addMemberAction{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyMemberCell defaultCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyMemberCell"];
    if (!cell) {
        cell = [[MyMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyMemberCell"];
    }
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
