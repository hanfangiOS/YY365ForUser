//
//  AddMemberViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AddMemberViewController.h"
#import "CUPickerView.h"
#import "AddMemberCell.h"
#import "AddMemberPickerCell.h"
#import "AddMemberBtnCell.h"
#import "AddMemberLabelCell.h"

@interface AddMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong,nonatomic)UITableView     * tableView;
@property (strong,nonatomic)CUPickerView    * pickerView;
@property (strong,nonatomic)UIButton        * tmpBtn;

@property (strong,nonatomic)NSArray         * sexArray;
@property (assign,nonatomic)NSInteger         selectedIndex;

@end

@implementation AddMemberViewController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加成员";
    
    [self initData];
    [self initSubViews];
}

- (void)initData{
    self.sexArray = @[@"男",@"女"];
    self.selectedIndex = 0;
}

- (void)initSubViews{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.contentView addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
}

- (void)endEdit{
    [self.contentView endEditing:YES];
}

#pragma mark tableViewDelegate

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
                //20000 20002 20003
                cell.textField.tag = [[NSString stringWithFormat:@"200%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
                switch (cell.textField.tag) {
                    case 20000:
                    {
                        cell.Label.text = @"姓名";
                        cell.icon.image = [UIImage imageNamed:@"myAccountBigButtonImage"];
                    }
                        break;
                    case 20002:
                    {
                        cell.Label.text = @"年龄";
                        cell.icon.image = [UIImage imageNamed:@"myAccountBigButtonImage"];
                    }
                        break;
                    case 20003:
                    {
                        cell.Label.text = @"电话";
                        cell.icon.image = [UIImage imageNamed:@"myAccountBigButtonImage"];
                    }
                        break;
                    default:
                        break;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.row == 1){
                AddMemberPickerCell * cell = [[AddMemberPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberPickerCell"];
                cell.Label.text = @"性别";
                cell.icon.image = [UIImage imageNamed:@"myAccountBigButtonImage"];
                [cell.btn addTarget:self action:@selector(chooseSexAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn setTitle:[self.sexArray objectAtIndexSafely:self.selectedIndex] forState:UIControlStateNormal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                UITableViewCell * cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 1:
        {
            AddMemberBtnCell * cell = [[AddMemberBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberBtnCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            AddMemberLabelCell * cell = [[AddMemberLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberLabelCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self postRequest];
    }else{
        
    }
}

- (void)postRequest{
    [self.slideNavigationController popViewControllerAnimated:YES];
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

#pragma mark - Picker

- (void)showPickerIfNeed
{
    [self.contentView endEditing:YES];
    if (self.sexArray.count == 0) {
        return;
    }
    
    if (self.pickerView == nil) {
        self.pickerView = [[CUPickerView alloc] initWithFrame:self.view.bounds];
        self.pickerView.delegate = (id)self;
    }
    
    self.pickerView.selectedIndex = self.selectedIndex;
    [self.view addSubview:self.pickerView];
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.confirmBlock = ^(NSInteger index) {
        weakSelf.selectedIndex = index;
        [weakSelf.tableView reloadData];
    };
    
    [self.pickerView update];
    [self.pickerView display];
}

- (NSInteger)numberOfRows
{
    return self.sexArray.count;
}

- (NSString *)titleForRowAtIndex:(NSInteger)index
{
    NSString * sex = [self.sexArray objectAtIndexSafely:index];
    return sex;
}

- (void)chooseSexAction{
    [self showPickerIfNeed];
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
