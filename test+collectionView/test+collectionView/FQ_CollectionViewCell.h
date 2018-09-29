//
//  FQ_CollectionViewCell.h
//  test+collectionView
//
//  Created by fanqi on 2018/9/28.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BUBBLE_DIAMETER     self.view.bounds.size.width
#define BUBBLE_PADDING      20.0
#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScreenH  [UIScreen mainScreen].bounds.size.height

@interface FQ_CollectionViewCell : UICollectionViewCell

@end

@interface FQ_CollectionViewFlowLayout : UICollectionViewFlowLayout

@end

@interface FQ_CustomCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) CGFloat progress;

@end

