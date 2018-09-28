//
//  FQImagePreviewVc.m
//  FQPhotoPicker
//
//  Created by 龙腾飞 on 2018/3/27.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQImagePreviewVc.h"
#define BUBBLE_DIAMETER     self.view.bounds.size.width
#define BUBBLE_PADDING      10.0

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

}

//#pragma mark - 方案一: 使用pagingEnabled设置.并且让collectionView的宽度增加10.这样就能实现效果.pagingEnabled是每次滚动一个屏幕宽.而不是collection的ItemSize的宽度!
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
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER + 10, self.view.bounds.size.height) collectionViewLayout:flowLayout];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.pagingEnabled = YES;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//    }
//    return _collectionView;
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


#pragma mark - 方案三.设置collection的宽度.然后在里面在设定一个view.也能达到效果

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
//        label.frame = cell.contentView.bounds;
//        label.tag = 1000;
//        label.text = [NSString stringWithFormat:@"%zd",indexPath.row];
//        [cell.contentView addSubview:label];
//    }
//
//    cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
//    return cell;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
