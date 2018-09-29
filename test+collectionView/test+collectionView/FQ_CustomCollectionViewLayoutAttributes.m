//
//  FQ_CustomCollectionViewLayoutAttributes.m
//  test+collectionView
//
//  Created by fanqi on 2018/9/29.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQ_CustomCollectionViewLayoutAttributes.h"

@implementation FQ_CustomCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone
{
    FQ_CustomCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.progress = self.progress;
    return attributes;
}

@end
