//
//  EqualSpaceFlowLayout.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "EqualSpaceFlowLayout.h"

@interface HFWV : UICollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame;
@end

@implementation HFWV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

@interface EqualSpaceFlowLayout()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation EqualSpaceFlowLayout
- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 5;
        self.minimumLineSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        self.sectionHeadersPinToVisibleBounds = NO;
    }
    
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    [self registerClass:[HFWV class] forDecorationViewOfKind:@"HFWV"];//注册Decoration View
    
    self.itemAttributes = [NSMutableArray new];
    
    
    CGFloat yOffset = self.sectionInset.top;
    CGFloat yOffSetDecoration = 0;
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        NSInteger itemCount = [[self collectionView] numberOfItemsInSection:section];
        NSMutableArray *itemAttributesInSection = [NSMutableArray arrayWithCapacity:itemCount];
        //        self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        
        CGFloat xOffset = self.sectionInset.left;
        CGFloat xNextOffset = self.sectionInset.left;
        CGSize headerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        UICollectionViewLayoutAttributes *layoutAttributes2 = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:itemCount inSection:section]];
        layoutAttributes2.frame = CGRectMake(0, yOffset, headerSize.width,headerSize.height);
        [itemAttributesInSection addObject:layoutAttributes2];
        
        yOffset += headerSize.height;
        yOffSetDecoration = yOffset;
        
        UICollectionViewLayoutAttributes *layoutAttributes3 = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"HFWV" withIndexPath:[NSIndexPath indexPathForItem:itemCount inSection:section]];
        layoutAttributes3.frame = CGRectMake(0, yOffSetDecoration, self.collectionView.frameWidth,0);
        layoutAttributes3.zIndex = -1;
        yOffset += self.minimumLineSpacing;
        
        for (NSInteger idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
            if (xNextOffset > [self collectionView].bounds.size.width - self.sectionInset.right) {
                xOffset = self.sectionInset.left;
                xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
                yOffset += (itemSize.height + self.minimumLineSpacing);
            }
            else
            {
                xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
            }
            
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
            [itemAttributesInSection addObject:layoutAttributes];
            
            if(idx == itemCount-1){
                yOffset += (itemSize.height + self.minimumLineSpacing);
            }
        }
        layoutAttributes3.frame = CGRectMake(0, yOffSetDecoration, self.collectionView.frameWidth,yOffset-yOffSetDecoration);
        [itemAttributesInSection addObject:layoutAttributes3];
        [self.itemAttributes addObject:itemAttributesInSection];
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.section][indexPath.row];
}
//
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
//}

//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes* att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
//    att.frame=CGRectMake(0, (125*indexPath.section)/2.0, 320, 125);
//    att.zIndex=-1;
//    return att;
//}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
//        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
//    }]];
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        NSArray *arr = self.itemAttributes[section];
        for (int row = 0; row < arr.count; row++) {
            if (CGRectIntersectsRect(rect, [arr[row] frame])) {
                [layoutAttributes addObject:arr[row]];
            }
        }
    }
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
