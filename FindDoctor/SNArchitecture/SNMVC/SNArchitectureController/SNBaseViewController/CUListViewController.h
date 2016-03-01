//
//  CUListViewController.h
//  CollegeUnion
//
//  Created by li na on 15/3/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "SNBaseListModel.h"
#import "SNRefreshControl.h"
#import "SNLoadMoreControl.h"

@interface CUListViewController : SNViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView * content;
@property (nonatomic,strong) UIView * emptyView;

- (instancetype)initWithPageName:(NSString *)pageName listModel:(SNBaseListModel *)listModel;

- (void)triggerRefresh;
- (void)triggerLoadMore;

/**第一次进入页面loading**/
- (void)initalizeLoading;

@property (nonatomic,strong) SNBaseListModel * listModel;
@property (nonatomic,strong) UITableView * contentTableView;

@property (nonatomic,strong,readonly) UIView * contentView;
@property (nonatomic,assign,readwrite)BOOL hasTab;
@property (nonatomic,assign,readwrite)BOOL hasFreshControl;
@property (nonatomic,assign,readwrite)BOOL hasLoadMoreControl;
@property (nonatomic,assign,readwrite)BOOL shouldFreshWhenComing;
@property (nonatomic,strong)MBProgressHUD   * progressView;

@property (nonatomic,strong) SNRefreshControl * freshControl;
@property (nonatomic,strong) SNLoadMoreControl * loadMoreControl;

//@property (nonatomic,strong) NSMutableArray * heightOfCells;
@property (nonatomic,strong) NSMutableDictionary * heightDictOfCells;

- (void)setShouldHaveTab;
- (void)loadNavigationBar;
- (void)loadContentView;
- (void)removeContentView;

- (void)setShouldFreshControl;
- (void)setShouldLoadMoreControl;
- (void)setShouldFreshWhenComing;


@end

@interface CUListViewController (HUD)

- (void)showProgressView;
- (void)hideProgressView;

@end

@interface CUListViewController (listEmptyView)

/**集成后由子类实现**/
- (UIView *)listEmptyView;

@end

@interface CUListViewController (keybord)

-(void)setViewMovedUp:(CGFloat)movedUpOffSet;

@end