//
//  MyInfoViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoAvatarCell.h"
#import "MyInfoCell.h"
#import "CUUserManager.h"
#import "CUUser.h"


@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong,nonatomic)UITableView     * tableView;

@property (assign,nonatomic)BOOL              isEditing;
@property (assign,nonatomic)NSString        * editStatus;

@property (strong,nonatomic)CUUser          * tempData;//不能直接传user 要传属性

@end

@implementation MyInfoViewController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    [self addRightButtonItemWithTitle:self.editStatus action:@selector(edit)];
}

- (void)edit{
    self.isEditing = !self.isEditing;
    if (self.isEditing == YES) {
        self.editStatus = @"编辑";
    }else{
        self.editStatus = @"保存";
    }
    
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [self initData];
    
    [super viewDidLoad];
    
    self.title = @"我的信息";
    
    [self initSubViews];

}

- (void)initData{
    self.editStatus = @"编辑";
    
    self.tempData = [[CUUser alloc] init];
    self.tempData.icon = [CUUserManager sharedInstance].user.icon.copy;
    self.tempData.userId = [CUUserManager sharedInstance].user.userId;
    self.tempData.nickName = [CUUserManager sharedInstance].user.nickName.copy;
    self.tempData.name = [CUUserManager sharedInstance].user.name.copy;
    self.tempData.gender = [CUUserManager sharedInstance].user.gender;
    self.tempData.age = [CUUserManager sharedInstance].user.age;
    self.tempData.cellPhone = [CUUserManager sharedInstance].user.token.copy;
}

- (void)initSubViews{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.contentView addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];
}

- (void)endEdit{
    [self.view endEditing:YES];
}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 4;
        }
            break;
            
        default:{
            return 1;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MyInfoAvatarCell cellDefaultHeight];
    }else{
        return [MyInfoCell cellDefaultHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyInfoAvatarCell * cell = [[MyInfoAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyInfoAvatarCell"];
        cell.label.text = @"头像";
        return cell;
    }else{
        MyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%d%d",indexPath.section,indexPath.row]];
        if (!cell) {
            cell = [[MyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%d%d",indexPath.section,indexPath.row]];
        }
        //10010 10011
        //10020 10021 10022 10023
        cell.textField.tag = [[NSString stringWithFormat:@"100%d%d",indexPath.section,indexPath.row] integerValue];
        cell.textField.delegate = self;
        if (self.isEditing == YES) {
            cell.textField.backgroundColor = [UIColor redColor];
            cell.textField.userInteractionEnabled = YES;
        }else{
            cell.textField.backgroundColor = [UIColor clearColor];
            cell.textField.userInteractionEnabled = NO;
        }
        
        switch (cell.textField.tag) {
            case 10010:
            {
                cell.label.text = @"优医ID";
                cell.textField.text = [NSString stringWithFormat:@"%d",[CUUserManager sharedInstance].user.userId];
            }
                break;
            case 10011:
            {
                cell.label.text = @"昵称";
                cell.textField.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.nickName];
            }
                break;
            case 10020:
            {
                cell.label.text = @"姓名";
                cell.textField.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.name];
            }
                break;
            case 10021:
            {
                cell.label.text = @"性别";
                if ([CUUserManager sharedInstance].user.gender == CUUserGenderMale) {
                    cell.textField.text = @"男";
                }else{
                    cell.textField.text = @"女";
                }
            }
                break;
            case 10022:
            {
                cell.label.text = @"年龄";
                cell.textField.text = [NSString stringWithFormat:@"%d",[CUUserManager sharedInstance].user.age];
            }
                break;
            case 10023:
            {
                cell.label.text = @"电话";
                cell.textField.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.cellPhone];
            }
                break;
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark textFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldChange:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self textFieldChange:textField];
    return YES;
}

- (void)textFieldChange:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - postRequest

- (void)postRequestGetUserInfo{
    [[CUUserManager sharedInstance] getUserInfo:[CUUserManager sharedInstance].user.token resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
    }];
}

//- (void)postRequestUpdateyUserInfo{
//    [[CUUserManager sharedInstance] updateUserInfo:<#(CUUser *)#> resultBlock:<#^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)resultBlock#> pageName:<#(NSString *)#>]
//}


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
