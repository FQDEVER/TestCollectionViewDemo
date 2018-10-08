
# TestCollectionViewDemo

#### 非常渴望系统相册滚动的效果.经过一天的研究.终于达成所愿

**效果1**:中间会有间距,并且每次滚动刚好是一个屏宽+间距宽

![WechatIMG6.jpeg](https://upload-images.jianshu.io/upload_images/2100495-f7e1395d0c72d5c1.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/200)

**效果2**:左右两张图均有少许偏移.效果极好.

![偏移效果2018-09-09 09.15.12.gif](https://upload-images.jianshu.io/upload_images/2100495-faf9106440cfc221.gif?imageMogr2/auto-orient/strip)

#### 首先:实现效果1.通过四套方案层层分析

#### 方案一:将Cell的宽度设定为屏宽+间距!随后再添加一个类似contentView.设定其宽度为屏宽.背景色设定为黑色即可!因pagingEnabled每次滚动一个屏幕宽.而不是collection的ItemSize的宽度!所以可达效果

        -(UICollectionView *)collectionView
        {
            if (!_collectionView) {

                UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
                flowLayout.itemSize = CGSizeMake(self.view.frame.size.width +10, self.view.frame.size.height);
                flowLayout.minimumLineSpacing = 0;
                flowLayout.minimumInteritemSpacing = 0;
                flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width+10, self.view.frame.size.height) collectionViewLayout:flowLayout];
                [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.pagingEnabled = YES;
                _collectionView.showsVerticalScrollIndicator = NO;
                _collectionView.showsHorizontalScrollIndicator = NO;

            }
            return _collectionView;
        }

        -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
        {
            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
            NSLog(@"------------------------->当前索引数:%zd",indexPath.row);

            if ([cell viewWithTag:1000]) {
                UILabel *label = [cell viewWithTag:1000];
                label.text = [NSString stringWithFormat:@"%zd",indexPath.row];
            }else{
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(10, 0, self.view.frame.size.width, self.view.frame.size.height);
                label.tag = 1000;
                label.text = [NSString stringWithFormat:@"%zd",indexPath.row];
                label.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
                [cell.contentView addSubview:label];
            }

            cell.backgroundColor = [UIColor blackColor];

            return cell;
        }


#### 方案二:scrollViewWillEndDragging方式实现.确定停止时的位置.每次滚动一页.也能实现.但是效果不是很理想.停止的有点缓慢


        - (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
        {
            CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
            NSInteger page = roundf(offset.x / pageSize);
            CGFloat targetX = pageSize * page;
            return CGPointMake(targetX, offset.y);
        }

        - (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
        {
            if (velocity.x > 0) {
                self.selectIndex += 1;
                if (self.selectIndex > [self.collectionView numberOfItemsInSection:0]) {
                    self.selectIndex = [self.collectionView numberOfItemsInSection:0];
                }
            }else if(velocity.x < 0){
                self.selectIndex -= 1;
                if (self.selectIndex < 0) {
                    self.selectIndex = 0;
                }
            }
            CGPoint offset = *targetContentOffset;
            CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
            CGFloat targetX = pageSize * self.selectIndex;


            CGPoint targetOffset = CGPointMake(targetX, offset.y);
            targetContentOffset->x = targetOffset.x;
            targetContentOffset->y = targetOffset.y;

        }

        -(UICollectionView *)collectionView
        {
            if (!_collectionView) {

                UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
                flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
                flowLayout.minimumLineSpacing = 10;
                flowLayout.minimumInteritemSpacing = 0;
                flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
                [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.showsVerticalScrollIndicator = NO;
                _collectionView.showsHorizontalScrollIndicator = NO;

            }
            return _collectionView;
        }

        -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
        {
            FQ_CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FQ_CollectionViewCellID" forIndexPath:indexPath];
            if (indexPath.row % 2) {
                cell.backgroundColor = [UIColor redColor];
            }else{
                cell.backgroundColor = [UIColor orangeColor];
            }
            return cell;
        }

#### 方案三.设置collection的宽度为屏宽+间距.itemSize的宽度为屏宽.设定minimumLineSpacing为间距值.也能达到效果

        -(UICollectionView *)collectionView
        {
            if (!_collectionView) {

                UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
                flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
                flowLayout.minimumLineSpacing = BUBBLE_PADDING;
                flowLayout.minimumInteritemSpacing = 0;
                flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

                _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER + BUBBLE_PADDING, self.view.bounds.size.height) collectionViewLayout:flowLayout];
                [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
                _collectionView.delegate = self;
                _collectionView.dataSource = self;
                _collectionView.pagingEnabled = YES;
                _collectionView.showsVerticalScrollIndicator = NO;
                _collectionView.showsHorizontalScrollIndicator = NO;
            }
            return _collectionView;
        }

        -(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
        {
            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
            if (indexPath.row % 2) {
                cell.backgroundColor = [UIColor redColor];
            }else{
                cell.backgroundColor = [UIColor orangeColor];
            }
            return cell;
        }

#### 方案四:最佳解决方案为自定义FQ_CollectionViewFlowLayout.继承自UICollectionViewFlowLayout.并且重写其相关代码.关键在于设置每一个UICollectionViewLayoutAttributes的frame.

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



以上均能实现产生黑色间距效果.因为方案二未设置`pagingEnabled`属性.所以滚动停止效果不太理想!方案三与四最佳!如果仅仅是实现黑色间距的效果推荐方案三.如果还有其他效果需要操作推荐方案四!

#### 随后:实现效果2.通过2套方案尝试实现:

#### 失败思路:基于方案三

要想实现系统选中cell与即将显示cell之间的效果.最开始的思路在于:**通过记录选中的cell.以及方法willDisplayCell获取即将出现的cell.即可确定左右滑动方向**

1.0如果`displayRow > self.selectIndex.`即向➡️滑动.如果`displayRow < self.selectIndex.`即向⬅️滑动

2.0如果向➡️滑动.那么`selectCell`为左.`displayCell`为右.

2.1如果向⬅️滑动.那么`displayCell`为左.`selectCell`为右.

3.0根据动画效果分析.如果`selectCell`为左侧全部显示.`displayCell`图片只显示(屏宽-间距,即向右偏移-间距值).随着拖拽.`selectCell`会逐渐向左侧滑.而`displayCell`也是向左偏移.

3.1根据动画效果分析.如果`selectCell`为右侧全部显示.`displayCell`图片只显示(屏宽-间距,即向左偏移-间距值).随着拖拽.`selectCell`会逐渐向右侧滑.而`displayCell`也是向右偏移.

通过在`scrollViewDidScroll`滚动中的偏移值去计算其对应cell的偏移值:相关代码如下.(代码中的10为内容偏移最大值)

        //整个collection的偏移offsizeX
        CGFloat offsizeX = scrollView.contentOffset.x - (self.selectIndex == 0 ? 0 : (self.selectIndex - 1) * (self.view.width + 10)) - self.view.width;
        //实际cell内部控件的偏移值为offX
        CGFloat offX = (offsizeX * 10.0 + 10) / (self.view.width + 10);
        //即将显示的cell
        FQImagePreviewCell * displayCell = (FQImagePreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.willDisplayIndex inSection:0]];
        //当前选中的cell
        FQImagePreviewCell * selectCell = (FQImagePreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];

        if (self.willDisplayIndex > self.selectIndex) {
            
            [displayCell setDirectionLeft:NO isSelect:NO contentOffSize: (10 - offX)]; //减少
            [selectCell setDirectionLeft:YES isSelect:YES contentOffSize: offX];//增加
        }else if(self.willDisplayIndex < self.selectIndex){
            [displayCell setDirectionLeft:YES isSelect:NO contentOffSize: (10 + offX)];
            [selectCell setDirectionLeft:NO isSelect:YES contentOffSize: -offX];
        }

        //随后在cell中提供相关滚动的方法即可
        -(void)setDirectionLeft:(BOOL)isleft isSelect:(BOOL)isSelectIndex contentOffSize:(CGFloat)offsize
        {
            if (isSelectIndex && isleft) {       
                //选中index.并且在左边
                self.imageView.transform = CGAffineTransformMakeTranslation(offsize, 0.0);
            }else if (isSelectIndex && !isleft){
                //选中index.并且在右边边
                self.imageView.transform = CGAffineTransformMakeTranslation(-offsize, 0.0);
            }else if (!isSelectIndex && isleft){
                //即将显示showindex.并且在左边
                self.imageView.transform = CGAffineTransformMakeTranslation(offsize, 0.0);
            }else{
                //即将显示showindex.并且在右边
                self.imageView.left = -offsize;
            }
        }

也会有点效果.但是存在bug.但是大致思路应该是对的.

#### 成功思路:基于方案四

**核心思路**

1.只有当前index以及下一个index

2.分析所得:当前index对应的偏移值为progress.下一个index偏移值为1-progress

3.随后在相关cell中重写-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes方法做效果即可

**相关代码:**

-(void)prepareLayout

        {
            
            [super prepareLayout];
            
            [_attributesArray removeAllObjects];
            
            NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
            
            CGFloat indexX = 0.0f;
            
            for (int i = 0; i < cellCount ; ++i) {
                
                FQ_CustomCollectionViewLayoutAttributes * layoutAttributes = [FQ_CustomCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                
                layoutAttributes.frame = CGRectMake(indexX, layoutAttributes.frame.origin.y, ScreenW, self.collectionView.bounds.size.height);
                
                if (i == [self getSelectCurrentIndex]) {
                    
                    layoutAttributes.progress = [self getScrollProgress];
                    
                }else if(i == ([self getSelectCurrentIndex] + 1) && [self getSelectCurrentIndex] != cellCount - 1){
                    
                    layoutAttributes.progress = -(1 - [self getScrollProgress]);
                    
                }else{
                    
                    layoutAttributes.progress = 0.5;
                    
                }
                
                [self.attributesArray addObject:layoutAttributes];
                
                indexX = indexX + (ScreenW + self.minimumLineSpacing);
                
            }
            
            [self.collectionView reloadData];
            
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

在相关cell中的处理

        -(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(FQ_CustomCollectionViewLayoutAttributes *)layoutAttributes

        {
            
            [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
            
            self.textlabel.transform = CGAffineTransformMakeTranslation(layoutAttributes.progress * BUBBLE_PADDING, 0);
            
            return layoutAttributes;
            
        }


需要注意的是.因为自定义FQ_CustomCollectionViewLayoutAttributes为UICollectionViewLayoutAttributes的子类.除了在自定义的FQ_CollectionViewFlowLayout中重写

    +(Class)layoutAttributesClass

    {
        
        return [FQ_CustomCollectionViewLayoutAttributes class];
        
    }

还需要在`FQ_CustomCollectionViewLayoutAttributes`重写

    -(id)copyWithZone:(NSZone *)zone

    {
        
        FQ_CustomCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
        
        attributes.progress = self.progress;
        
        return attributes;
        
    }


保证自定义的`FQ_CustomCollectionViewLayoutAttributes`属性能被`copy`

**最终效果:**
![ScreenRecording_09-30-2018 09-49-38.gif](https://upload-images.jianshu.io/upload_images/2100495-a48db595786f46b8.gif?imageMogr2/auto-orient/strip)

[相关demo的github链接](https://github.com/FQDEVER/TestCollectionViewDemo)

[相关使用库的github链接](https://github.com/FQDEVER/FQPhotoPicker)

