//
//  CUListViewController.m
//  CollegeUnion
//
//  Created by li na on 15/3/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUListViewController.h"
#import "CUUIContant.h"
#import "TipHandler+HUD.h"
#import "UIColor+SNExtension.h"
#import "SNUISystemConstant.h"
#import "SNListEmptyView.h"
#import "UIImage+Color.h"
#import "CUUIContant.h"

#define kLoadMoreCellHeigth 55
#define kDefaultCellNormalHeight    44

@interface CUListViewController ()<SNListEmptyViewDelegate>



@end

@implementation CUListViewController

- (void)setShouldFreshControl
{
    self.hasFreshControl = YES;
}
- (void)setShouldLoadMoreControl
{
    self.hasLoadMoreControl = YES;
}
- (void)setShouldFreshWhenComing
{
    self.shouldFreshWhenComing = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
    
    
    [self setShouldHaveTab];
    [self setShouldFreshControl];
    [self setShouldLoadMoreControl];
    [self setShouldFreshWhenComing];
    
    // --------------------如果有nav则重新生成一个可视的view,跟loadContentView的顺序不可以改
    [self addContentView];

    if (self.listModel != nil)
    {
        [self loadTableView];
        if (self.hasLoadMoreControl)
        {
            [self loadLoadMoreControl];
        }
        if (self.hasFreshControl)
        {
            [self loadRefreshControl];
        }
        if (self.shouldFreshWhenComing)
        {
//            [self initalizeLoading];
            [self triggerRefresh];
        }
    }

    // --------------------子类执行以下方法
    self.navigationBar.shadowImage = [UIImage createImageWithColor:UIColorFromHex( Color_Hex_NavShadow)];
    [self loadNavigationBar];
    [self loadContentView];
}

- (void)removeContentView
{
    [self.content removeFromSuperview];
    self.content = nil;
}

- (void)addContentView
{
    self.content = [[UIView alloc] initWithFrame:[self subviewFrame]];
    [self.view addSubview:self.content];
    self.content.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
    if (self.hasTab)
    {
        self.content.frameHeight -= Height_Tabbar;
    }
}

- (UIView *)contentView
{
    if (self.content != nil)
    {
        return self.content;
    }
    return self.view;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.heightDictOfCells = [NSMutableDictionary dictionary];
    }
    return self;
}


- (instancetype)initWithPageName:(NSString *)pageName listModel:(SNBaseListModel *)listModel
{
    if (self = [super initWithPageName:pageName])
    {
        self.listModel = listModel;
        self.heightDictOfCells = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentTableView.scrollsToTop = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.contentTableView.scrollsToTop = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    // 去掉导航的阴影
//    self.navigationBar.shadowImage = [UIImage new];
}

- (void)setShouldHaveTab
{
    self.hasTab = NO;
}

- (void)removeFreshControl
{
    [self.freshControl removeFromSuperview];
    self.freshControl = nil;
}
- (void)removeLoadMoreControl
{
    self.contentTableView.tableFooterView = nil;
    self.loadMoreControl = nil;
}

- (void)loadContentView
{
    
}

- (void)loadRefreshControl
{
    //refresh header
    self.freshControl = [SNRefreshControl refreshControlWithAttachedView:self.contentTableView style:SNRefreshControlStyleArrow];
    self.freshControl.frame = CGRectOffset(self.freshControl.frame, 0, 0);
    self.freshControl.backgroundColor = [UIColor clearColor];
    [self.freshControl addTarget:self action:@selector(triggerRefresh) forControlEvents:UIControlEventValueChanged];
}
- (void)loadLoadMoreControl
{
    //load more
    self.loadMoreControl = [[SNLoadMoreControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLoadMoreCellHeigth) attachedView:self.contentTableView];
    [self.loadMoreControl addTarget:self action:@selector(triggerLoadMore) forControlEvents:UIControlEventValueChanged];
    self.loadMoreControl.backgroundColor = [UIColor clearColor];
}

- (void)loadTableView
{
    self.contentTableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.contentTableView.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contentTableView.separatorColor = UIColorFromHex(Color_Hex_Tableview_Separator);
    self.contentTableView.rowHeight = kDefaultCellNormalHeight;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.contentView addSubview:self.contentTableView];
    
    self.contentTableView.separatorInset = UIEdgeInsetsZero;
    self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 空页面
    self.emptyView = [self listEmptyView];
    self.emptyView.hidden = YES;
    [self.contentView addSubview:self.emptyView];
    self.emptyView.centerY = self.emptyView.superview.frameHeight/2.0;
    self.emptyView.centerX = self.emptyView.superview.frameWidth/2.0;
    
}

- (void)emptyViewClicked
{
    [self triggerRefresh];
}

//-----------------------------------------------------------------------------------------------------

- (void)initalizeLoading
{
    [self showProgressView];
    self.listModel.isLoading = YES;
    __block __weak CUListViewController * blockSelf = self;
    [self.listModel gotoFirstPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        blockSelf.listModel.isLoading = NO;
        [blockSelf hideProgressView];
        if (!result.hasError)
        {
            [self.freshControl refreshLastUpdatedTime:[NSDate date]];
            [blockSelf.contentTableView reloadData];
//            // 添加空页面
//            if ([blockSelf.listModel.items count] == 0)
//            {
//                blockSelf.emptyView.hidden = NO;
//            }
//            else // 隐藏空页面
//            {
//                blockSelf.emptyView.hidden = YES;
//            }

            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {
                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                ;
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];
            
        }
        
        if ([blockSelf.listModel.items count] == 0)
        {
            blockSelf.emptyView.hidden = NO;
        }
        else // 隐藏空页面
        {
            blockSelf.emptyView.hidden = YES;
        }

    }];
    
}

- (void)triggerRefresh
{
    [self.freshControl beginRefreshing];
    [self.loadMoreControl endLoading];
    self.listModel.isLoading = YES;
    __block __weak CUListViewController * blockSelf = self;
    [self.listModel gotoFirstPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        blockSelf.listModel.isLoading = NO;
        [blockSelf.freshControl endRefreshing];
        if (!result.hasError)
        {
            // height
            [self.heightDictOfCells removeAllObjects];
            
            [self.freshControl refreshLastUpdatedTime:[NSDate date]];
            [blockSelf.contentTableView reloadData];
            
            // footer
            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {
                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
;
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];

        }
        
        // 添加空页面
        if ([blockSelf.listModel.items count] == 0)
        {
            blockSelf.emptyView.hidden = NO;
        }
        else // 隐藏空页面
        {
            blockSelf.emptyView.hidden = YES;
        }

    }];
}

- (void)triggerLoadMore
{
    [self.freshControl endRefreshing];
    self.listModel.isLoading = YES;
    [self.loadMoreControl beginLoading];
    __block __weak CUListViewController * blockSelf = self;
    [self.listModel gotoNextPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
         blockSelf.listModel.isLoading = NO;
        [blockSelf.loadMoreControl endLoading];
        if (!result.hasError)
        {
            [blockSelf.contentTableView reloadData];
            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {
                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
;
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];

        }
    }];
}

- (void)dealloc
{
    self.contentTableView.delegate = nil;
    self.contentTableView.dataSource = nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma -mark ---------------UITableViewDataSource -------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listModel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma -mark ---------------UITableViewDelegate -------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

@implementation CUListViewController (HUD)


- (void)showProgressView
{
    if (self.progressView == nil) {
        self.progressView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        self.progressView.center = CGPointMake(CGRectGetWidth(self.contentView.bounds)/2.0, CGRectGetHeight(self.contentView.bounds)/2.0);
        self.progressView.dimBackground = NO;
        [self.view addSubview:self.progressView];
        self.progressView.opacity = 0.1;

    }
    
    [self.progressView show:YES];
    self.contentView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
}

- (void)hideProgressView
{
    [self.progressView hide:NO];
    self.contentView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}


@end


@implementation CUListViewController (listEmptyView)

/**集成后由子类实现**/
- (UIView *)listEmptyView
{
    SNListEmptyView * view = [[SNListEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    view.delegate = self;
    return view;
}

@end

@implementation CUListViewController (keybord)

-(void)setViewMovedUp:(CGFloat)movedUpOffSet
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.contentView.frame;
    
    rect.origin.y -= movedUpOffSet;
    rect.size.height += movedUpOffSet;
    self.contentView.frame = rect;
    [UIView commitAnimations];
}

@end
