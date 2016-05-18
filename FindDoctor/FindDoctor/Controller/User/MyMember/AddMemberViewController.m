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
#import "CUUsermanager.h"
#import "MyMemberViewController.h"
#import "OrderCreateController.h"



@interface AddMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong,nonatomic)UITableView     * tableView;
@property (strong,nonatomic)CUPickerView    * pickerView;
@property (strong,nonatomic)UIButton        * tmpBtn;

@property (strong,nonatomic)NSArray         * sexArray;
@property (assign,nonatomic)NSInteger         selectedIndex;

@property (strong,nonatomic)CUUser          * user;

@end

@implementation AddMemberViewController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
    
    self.title = @"新增成员";
    
    [self initSubViews];
}

- (void)initData{
    self.user = [[CUUser alloc] init];
    
    self.sexArray = @[@"女",@"男"];
    self.selectedIndex = 0;
}

- (void)initSubViews{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.contentView addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kCommonBackgroundColor;
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
        //姓名～电话
        if (indexPath.row != 4) {
            return 54;
        }
        //那点白色块
        return 22;
    }
    if (indexPath.section == 1) {
        //按钮
        return 85;
    }
    if (indexPath.section == 2) {
        //添加新的成员，可以使用XXXXXX
        return 54;
    }
    //从未用到
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        //姓名～电话
        case 0:
        {
            if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
                AddMemberCell * cell = [[AddMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberCell"];
                //20000 20002 20003
                cell.textField.tag = [[NSString stringWithFormat:@"200%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
                cell.textField.delegate = self;
                switch (cell.textField.tag) {
                    //姓名
                    case 20000:
                    {
                        cell.textField.text = self.user.name;
                        cell.Label.text = @"姓名";
                        cell.icon.image = [UIImage imageNamed:@"member_icon_name"];
                    }
                        break;
                    //年龄
                    case 20002:
                    {
                        if (self.user.age != 0) {
                            cell.textField.text = [NSString stringWithFormat:@"%ld",(long)self.user.age];
                        }
                        cell.Label.text = @"年龄";
                        cell.icon.image = [UIImage imageNamed:@"member_icon_age"];
                        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    //电话
                    case 20003:
                    {
                        cell.textField.text = self.user.cellPhone;
                        cell.Label.text = @"电话";
                        cell.icon.image = [UIImage imageNamed:@"member_icon_phone"];
                        cell.textField.keyboardType = UIKeyboardTypePhonePad;
                    }
                        break;
                    default:
                        break;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            //性别
            }else if (indexPath.row == 1){
                AddMemberPickerCell * cell = [[AddMemberPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberPickerCell"];
                cell.Label.text = @"性别";
                cell.icon.image = [UIImage imageNamed:@"member_icon_sex"];
                [cell.btn addTarget:self action:@selector(chooseSexAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn setTitle:[self.sexArray objectAtIndexSafely:self.selectedIndex] forState:UIControlStateNormal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                //最下面那点空白
                UITableViewCell * cell = [[UITableViewCell alloc] init];
                UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 22 - 1, kScreenWidth, 1)];
                bottomLine.backgroundColor = kblueLineColor;
                [cell addSubview:bottomLine];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        //按钮
        case 1:
        {

            AddMemberBtnCell * cell = [[AddMemberBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberBtnCell"];
            [cell.btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kCommonBackgroundColor;
            return cell;
        }
            break;
        //添加新的成员，可以使用XXXXXX
        case 2:
        {
            AddMemberLabelCell * cell = [[AddMemberLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMemberLabelCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kCommonBackgroundColor;
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

#pragma mark textFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldChange:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self textFieldChange:textField];
    [self.contentView endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 电话
    if (textField.tag == 20003) {
        NSMutableString * text = [textField.text mutableCopy];
        [text replaceCharactersInRange:range withString:string];
        if ([text length] >= 11) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldChange:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    switch (textField.tag) {
        //姓名
        case 20000:
        {
            self.user.name = textField.text;
        }
            break;
        //年龄
        case 20002:
        {
             self.user.age = [textField.text integerValue];
        }
            break;
        //电话
        case 20003:
        {
             self.user.cellPhone = textField.text;
        }
            break;
            
        default:
            break;
    }
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
        weakSelf.user.gender = (weakSelf.selectedIndex == 0?CUUserGenderFemale:CUUserGenderMale);
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

#pragma mark PostRequest

- (void)postRequestInsertMember{
    
    [self progressView];
    UserFilter * filter = [[UserFilter alloc] init];
    for (UIViewController * vc in self.slideNavigationController.viewControllers) {
        if ([vc isKindOfClass:[OrderCreateController class]]) {
            filter.pageSrc = 0;
        }
        if ([vc isKindOfClass:[MyMemberViewController class]]) {
            filter.pageSrc = 1;
        }
    }
    filter.user = self.user;
    [[CUUserManager sharedInstance] InsertMemberWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [self hideProgressView];
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                NSDictionary * data = [result.responseObject objectForKeySafely:@"data"];
                self.user.memberId = [data integerForKeySafely:@"memberId"];
                if (self.backWithUserBlock) {
                    self.backWithUserBlock(self.user);
                }
                
                [self.slideNavigationController popViewControllerAnimated:YES];
            }
        }
    } pageName:@"AddMemberViewController"];
}

#pragma mark Action

- (void)chooseSexAction{
    [self showPickerIfNeed];
}

- (void)saveAction{
    
    [self.contentView endEditing:YES];
    
    if (self.user.name == nil || [self.user.name isEqualToString:@""]) {
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    if (self.user.age <= 0) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请正确输入年龄" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    if (self.user.cellPhone == nil || [self.user.cellPhone isEqualToString:@""] ) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    if ([self.user.cellPhone length] != 11) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请正确输入手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    [self postRequestInsertMember];

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
