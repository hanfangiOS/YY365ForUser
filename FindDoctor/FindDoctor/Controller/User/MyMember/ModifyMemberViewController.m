//
//  ModifyMemberViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ModifyMemberViewController.h"
#import "AddMemberCell.h"
#import "AddMemberPickerCell.h"
#import "AddMemberBtnCell.h"
#import "AddMemberLabelCell.h"

@interface ModifyMemberViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView * tableView;



@end

@implementation ModifyMemberViewController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"myAccountBigButtonImage"] action:@selector(deleteMember)];
}

- (void)deleteMember{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该成员吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
 }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)initSubViews{
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.contentView addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row != 4) {
            return 65;
        }
        return 25;
    }
    if (indexPath.section == 1) {
        return 85;
    }
    if (indexPath.section == 2) {
        return 60;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
                AddMemberCell * cell = [[AddMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberCell"];
                return cell;
            }else if (indexPath.row == 1){
                AddMemberPickerCell * cell = [[AddMemberPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberPickerCell"];
                return cell;
            }else{
                UITableViewCell * cell = [[UITableViewCell alloc] init];
                return cell;
            }
        }
            break;
        case 1:
        {
            AddMemberBtnCell * cell = [[AddMemberBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberBtnCell"];
            return cell;
        }
            break;
        case 2:
        {
            AddMemberLabelCell * cell = [[AddMemberLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberLabelCell"];
            return cell;
        }
            break;
        default:{
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            return cell;
        }
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self postRequest];
    }else{
        
    }
 }

- (void)postRequest{
    [self.slideNavigationController popViewControllerAnimated:YES];
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
