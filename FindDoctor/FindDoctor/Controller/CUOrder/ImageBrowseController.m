//
//  ImageBrowseController.m
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-7.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import "ImageBrowseController.h"
#import "UIBarButtonItem+CommenButton.h"
#import "UIConstants.h"

@interface ImageBrowseController () <UIScrollViewDelegate>

@end

@implementation ImageBrowseController
{
    UILabel         *_titleLabel;
    UIScrollView    *_contentView;
    int              _currentIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationBar performSelectorOnMainThread:@selector(useTranslucentBackgroundImage) withObject:nil waitUntilDone:NO];
    
    _currentIndex = self.startIndex;
    
    [self initNavigationBar];
    [self initContentView];
    
    [self updateTitle];
    [self reloadContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self action:@selector(backAction)];
    
    UIBarButtonItem *deleteItem = [UIBarButtonItem rightItemWithTitle:@"删除" target:self action:@selector(deleteImage)];
    self.navigationItem.rightBarButtonItem = deleteItem;
}

- (void)initContentView
{
    _contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.pagingEnabled = YES;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
}

- (void)reloadContentView
{
    for (UIView *v in _contentView.subviews) {
        [v removeFromSuperview];
    }
    
    float imageWidth = CGRectGetWidth(_contentView.frame);
    float imageHeight = CGRectGetHeight(_contentView.frame);
    
    for (int i = 0; i < self.imageArray.count; i ++) {
        CGRect rect = CGRectMake(i * imageWidth, 0, imageWidth, imageHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [self.imageArray objectAtIndex:i];
        [_contentView addSubview:imageView];
    }
    
    _contentView.contentSize = CGSizeMake(imageWidth * self.imageArray.count, imageHeight);
    _contentView.contentOffset = CGPointMake(imageWidth * _currentIndex, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float viewWidth = CGRectGetWidth(scrollView.frame);
    int index = scrollView.contentOffset.x / viewWidth;
    
    if (_currentIndex != index) {
        _currentIndex = index;
        
        [self updateTitle];
    }
}

- (void)updateTitle
{
    _titleLabel.text = [NSString stringWithFormat:@"%d/%lu",_currentIndex + 1,self.imageArray.count];
}

- (void)deleteImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"要删除这张图片吗？"
                                  delegate:(id)self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles: nil];
    
    [actionSheet showFromRect:self.view.bounds inView:self.slideNavigationController.view animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [self.imageArray removeObjectAtIndex:_currentIndex];
    
    if ([self.delegate respondsToSelector:@selector(didClickToDeleteImageAtIndex:)]) {
        [self.delegate didClickToDeleteImageAtIndex:_currentIndex];
    }
    
    if (self.imageArray.count > 0) {
        if (_currentIndex > 0) {
            _currentIndex -= 1;
        }
        
        [self updateTitle];
        [self reloadContentView];
    }
    else {
        [self.slideNavigationController popViewControllerAnimated:YES];
    }
}

@end
