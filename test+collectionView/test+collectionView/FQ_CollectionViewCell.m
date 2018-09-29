//
//  FQ_CollectionViewCell.m
//  test+collectionView
//
//  Created by fanqi on 2018/9/28.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQ_CollectionViewCell.h"

@implementation FQ_CustomCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone
{
    FQ_CustomCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.progress = self.progress;
    return attributes;
}

@end


@interface FQ_CollectionViewFlowLayout()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation FQ_CollectionViewFlowLayout

+(Class)layoutAttributesClass
{
    return [FQ_CustomCollectionViewLayoutAttributes class];
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    [_attributesArray removeAllObjects];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    //横向间距
    //self.minimumLineSpacing
    CGFloat indexX = 0.0f;
    
    for (int i = 0; i < cellCount ; ++i) {
        FQ_CustomCollectionViewLayoutAttributes * layoutAttributes = [FQ_CustomCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        layoutAttributes.frame = CGRectMake(indexX, layoutAttributes.frame.origin.y, ScreenW, self.collectionView.bounds.size.height);
        
        //明天调整这块.....
        if (i == [self getSelectCurrentIndex]) {
            layoutAttributes.progress = [self getScrollProgress];
        }else if(i == ([self getSelectCurrentIndex] + 1) && [self getSelectCurrentIndex] != cellCount - 1){
            layoutAttributes.progress = -(1 - [self getScrollProgress]);
        }else{
            layoutAttributes.progress = 0.0;
        }
        
        [self.attributesArray addObject:layoutAttributes];
        
        indexX = indexX + (ScreenW + self.minimumLineSpacing);
    }
    
    //这次根据情况添加
    [self.collectionView reloadData];
}

//2.提供布局属性对象
-(NSArray<FQ_CustomCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray.copy;
}


//1.提供滚动范围
-(CGSize)collectionViewContentSize
{
    return CGSizeMake((ScreenW + self.minimumLineSpacing) * self.attributesArray.count - self.minimumLineSpacing, self.collectionView.bounds.size.height);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(int)getSelectCurrentIndex
{
    int selectIndex = self.collectionView.contentOffset.x / (ScreenW + self.minimumLineSpacing);
    return selectIndex;
}

-(CGFloat)getScrollProgress{
    CGFloat progress = self.collectionView.contentOffset.x / (ScreenW + self.minimumLineSpacing) - [self getSelectCurrentIndex];
    return MAX(MIN(progress, 1), 0) ;
}

-(NSMutableArray *)attributesArray
{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end


@interface FQ_CollectionViewCell()
@property (nonatomic, strong) UILabel *textlabel;
@end

@implementation FQ_CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textlabel];
        self.textlabel.frame = self.contentView.bounds;
    }
    return self;
}


-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(FQ_CustomCollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    self.textlabel.transform = CGAffineTransformMakeTranslation(layoutAttributes.progress * BUBBLE_PADDING, 0);
    return layoutAttributes;
}


-(UILabel *)textlabel
{
    if (!_textlabel) {
        _textlabel = [[UILabel alloc]init];
        _textlabel.numberOfLines = 0;
        _textlabel.text = @"适用场景：方法 2 和 方法 3 的原理近似，效果也相近，适用场景也基本相同，但方法 3 的体验会好很多，snap 到整数页的过程很自然，或者说用户完全感知不到 snap 过程的存在。这两种方法的减速过程流畅，适用于一屏有多页，但需要按整数页滑动的场景；也适用于如图表中自动 snap 到整数天的场景；还适用于每页大小不同的情况下 snap 到整数页的场景（不做举例，自行发挥，其实只需要修改计算目标 offset 的方法）。适用场景：方法 2 和 方法 3 的原理近似，效果也相近，适用场景也基本相同，但方法 3 的体验会好很多，snap 到整数页的过程很自然，或者说用户完全感知不到 snap 过程的存在。这两种方法的减速过程流畅，适用于一屏有多页，但需要按整数页滑动的场景；也适用于如图表中自动 snap 到整数天的场景；还适用于每页大小不同的情况下 snap 到整数页的场景（不做举例，自行发挥，其实只需要修改计算目标 offset 的方法）。";
    }
    return _textlabel;
}

@end
