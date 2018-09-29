//
//  FQ_CollectionViewCell.m
//  test+collectionView
//
//  Created by fanqi on 2018/9/28.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQ_CollectionViewCell.h"
#import "FQ_CustomCollectionViewLayoutAttributes.h"


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
