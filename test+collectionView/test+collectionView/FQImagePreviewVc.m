//
//  FQImagePreviewVc.m
//  FQPhotoPicker
//
//  Created by 龙腾飞 on 2018/3/27.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQImagePreviewVc.h"
#import "FQ_CollectionViewCell.h"

@interface FQImagePreviewVc ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectIndex;

@end



@implementation FQImagePreviewVc



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.collectionView];
    [self addBarButtonItem];
    if (@available(iOS 11.0, *))
    {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

//#pragma mark - 方案一: 使用pagingEnabled设置.并且让collectionView的宽度增加10.这样就能实现效果.pagingEnabled是每次滚动一个屏幕宽.而不是collection的ItemSize的宽度!
//
//-(UICollectionView *)collectionView
//{
//    if (!_collectionView) {
//
//        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
//        flowLayout.minimumLineSpacing = BUBBLE_PADDING;
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER + BUBBLE_PADDING, self.view.bounds.size.height) collectionViewLayout:flowLayout];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.pagingEnabled = YES;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//    }
//    return _collectionView;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
//    if (indexPath.row % 2) {
//        cell.backgroundColor = [UIColor redColor];
//    }else{
//        cell.backgroundColor = [UIColor orangeColor];
//    }
//    return cell;
//}


//#pragma mark - 方案二:scrollViewWillEndDragging方式实现.确定停止时比较缓慢
//
//- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
//{
//    CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
//    NSInteger page = roundf(offset.x / pageSize);
//    CGFloat targetX = pageSize * page;
//    return CGPointMake(targetX, offset.y);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if (velocity.x > 0) {
//        self.selectIndex += 1;
//        if (self.selectIndex > [self.collectionView numberOfItemsInSection:0]) {
//            self.selectIndex = [self.collectionView numberOfItemsInSection:0];
//        }
//    }else if(velocity.x < 0){
//        self.selectIndex -= 1;
//        if (self.selectIndex < 0) {
//            self.selectIndex = 0;
//        }
//    }
//    CGPoint offset = *targetContentOffset;
//    CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
//    CGFloat targetX = pageSize * self.selectIndex;
//
//
//    CGPoint targetOffset = CGPointMake(targetX, offset.y);
//    targetContentOffset->x = targetOffset.x;
//    targetContentOffset->y = targetOffset.y;
//
//}
//
//-(UICollectionView *)collectionView
//{
//    if (!_collectionView) {
//
//        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
//        flowLayout.minimumLineSpacing = 10;
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//
//    }
//    return _collectionView;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    FQ_CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FQ_CollectionViewCellID" forIndexPath:indexPath];
//    if (indexPath.row % 2) {
//        cell.backgroundColor = [UIColor redColor];
//    }else{
//        cell.backgroundColor = [UIColor orangeColor];
//    }
//    return cell;
//}



//#pragma mark - -方案三:将Cell的宽度设定为屏宽+间距!随后再添加一个类似contentView.设定其宽度为屏宽.背景色设定为黑色即可!因pagingEnabled每次滚动一个屏幕宽.而不是collection的ItemSize的宽度!所以可达效果
//
//-(UICollectionView *)collectionView
//{
//    if (!_collectionView) {
//
//        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width +10, self.view.frame.size.height);
//        flowLayout.minimumLineSpacing = 0;
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width+10, self.view.frame.size.height) collectionViewLayout:flowLayout];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.pagingEnabled = YES;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//
//    }
//    return _collectionView;
//}

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
//    NSLog(@"------------------------->当前索引数:%zd",indexPath.row);
//
//    if ([cell viewWithTag:1000]) {
//        UILabel *label = [cell viewWithTag:1000];
//        label.text = [NSString stringWithFormat:@"%zd",indexPath.row];
//    }else{
//        UILabel *label = [[UILabel alloc]init];
//        label.frame = CGRectMake(10, 0, self.view.frame.size.width, self.view.frame.size.height);
//        label.tag = 1000;
//        label.text = [NSString stringWithFormat:@"%zd",indexPath.row];
//        label.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
//        [cell.contentView addSubview:label];
//    }
//
//    cell.backgroundColor = [UIColor blackColor];
//
//    return cell;
//}


#pragma mark - 方案四-终极版: 使用自定义flowLayout.重新布局每一个item.做相对偏移

-(UICollectionView *)collectionView
{
    if (!_collectionView) {

        FQ_CollectionViewFlowLayout * flowLayout = [[FQ_CollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = BUBBLE_PADDING;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER + BUBBLE_PADDING, self.view.bounds.size.height) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[FQ_CollectionViewCell class] forCellWithReuseIdentifier:@"FQ_CollectionViewCellID"];
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
    FQ_CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FQ_CollectionViewCellID" forIndexPath:indexPath];
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor redColor];
    }else{
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}


#pragma mark -公共

-(void)addBarButtonItem{
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.frame = CGRectMake(0, 0, 40, 40);
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
}

-(void)clickBackBtn:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
