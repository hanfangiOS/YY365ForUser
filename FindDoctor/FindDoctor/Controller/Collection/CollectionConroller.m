//
//  CollectionConroller.m
//  FindDoctor
//
//  Created by Tom Zhang on 15/8/12.
//  Copyright (c) 2015年 li na. All rights reserved.
//
#import "CollectionVCConstants.h"

#import "CollectionConroller.h"
#import "UIColor+SNExtension.h"
#import "CUUIContant.h"
#import "DoctorTableViewCell.h"

@interface CollectionConroller ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *cellIdentifier;

@end

@implementation CollectionConroller
@synthesize tableView, cellIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    cellIdentifier = @[@"DoctorTableViewCell", @"ArticleTableViewCell"];
    [tableView registerClass:[DoctorTableViewCell class] forCellReuseIdentifier:[cellIdentifier objectAtIndex:0]];
    // Do any additional setup after loading the view.
}

- (void)loadNavigationBar {
    [self addLeftBackButtonItemWithImage];
    [self addRightButtonItem];
}

- (void)addRightButtonItem {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(manageAction)];
    rightButton.tintColor = UIColorFromHex(Color_Hex_NavText_Normal);
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)manageAction {
   //show delete button on tableviewcell
}

- (void)loadContentView {
    [self addTableView];
    [self addSegementBelowNavBar];
}

- (void)addTableView {
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSegmentedControlOffsetY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.navigationBarHeight-kSegmentedControlOffsetY)];
    tableView.rowHeight = kTableViewCellHeight;
    tableView.allowsSelection = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.contentView addSubview:tableView];
}

- (void)addSegementBelowNavBar {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"我的医生",@"我的文章"]];
    segment.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-80, 5, 160, 20);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(tableSwitch) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:segment];
}

- (void)tableSwitch {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[cellIdentifier objectAtIndex:0]];
    [cell setEvaluationScore:2.4];
    [cell setDoctorPortrait:@"DoctorPortrait@2x"];
    [cell setDoctorName:@"张仲景" technicalTitle:@"主任医师" teachingTitle:@"副教授"];
    [cell setDoctorProfile:@"1960年1月出生，成都市名中医。现任成都中医药大学附属研究院主任医生，博士生导师。\n擅长内科、儿科，咳嗽、疑难杂症等病的治疗。"];
    return cell;
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
