//
//  ViewController.m
//  PhotoZoom
//
//  Created by md on 16/8/11.
//  Copyright © 2016年 HKQ. All rights reserved.
//

#import "ViewController.h"
#import "ImageEnlargeCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *colView;
    NSMutableArray *mImages;//车型图片
    NSInteger selectIndex;//选中的图片
    UIWindow *mWindow;
}
// 显示图片的视图
@property (nonatomic,strong) UIImageView *imageView ;

// 显示缩放视图
@property (nonatomic,strong) UICollectionView *collectionView ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mImages = [NSMutableArray arrayWithCapacity:10];
    //图片组
    for (int i = 118; i < 127; i++) {
        [mImages addObject:[NSString stringWithFormat:@"http://192.168.5.63/BusinessImage.ashx?id=%d&type=BusinessImage",i]];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-45-64) collectionViewLayout:layout];
    [colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    colView.backgroundColor = [UIColor clearColor];
    colView.delegate = self;
    colView.dataSource = self;
    [self.view addSubview:colView];

}
/***
 ***
 UICollectionView  delegate
 ***
 ***
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return self.imageUrlArrays.count;
    }
    return mImages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        static NSString *cellID = @"cellID" ;
        ImageEnlargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath] ;
        // 传数据
        cell.imageUrlString = self.imageUrlArrays[indexPath.row] ;
        // 刷新视图
        [cell setNeedsLayout] ;
        return cell ;
    }
    static NSString *cellID = @"myCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (mImages.count > 0) {
        UIImageView *mImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        mImageView.backgroundColor = [UIColor clearColor];
        mImageView.contentMode = UIViewContentModeScaleAspectFit;
        [mImageView sd_setImageWithURL:[NSURL URLWithString:mImages[indexPath.row]]];
        [cell.contentView addSubview:mImageView];
    }
    
    
    return cell;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
//配置每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        return CGSizeMake(kScreenWidth, kScreenHeight);
    }
    return CGSizeMake((kScreenWidth-40)/3, (kScreenWidth-40)/5);
}

//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    [self createWindowForBigPicture];
}
#pragma mark - UICollectionView 继承父类的方法------------------------------------
// 减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    NSLog(@"停止减速，滑动视图停止了");
    
    // 视图停止滑动的时候执行一些操作
    int pageIndex = (int)self.collectionView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width) ;
    self.label.text = [NSString stringWithFormat:@"%d/%lu",pageIndex+1,(unsigned long)self.imageUrlArrays.count] ;
    NSLog(@"====%f====%f====%d",self.collectionView.contentOffset.x,[UIScreen mainScreen].bounds.size.width ,pageIndex);
    
}
#pragma mark - Show Big Picture
- (void)createWindowForBigPicture
{
    self.imageUrlArrays = mImages;
    mWindow = [UIApplication sharedApplication].keyWindow;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init] ;
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) ;
    flowLayout.minimumInteritemSpacing = 0 ;
    flowLayout.minimumLineSpacing = 0;
    
    // 设置方法
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout] ;
    self.collectionView.backgroundColor = [UIColor blackColor] ;
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    self.collectionView.pagingEnabled = YES ;
    self.collectionView.contentOffset = CGPointMake(([UIScreen mainScreen].bounds.size.width)*selectIndex, [UIScreen mainScreen].bounds.size.height);
    self.collectionView.showsHorizontalScrollIndicator = NO ;
    [self.collectionView registerClass:[ImageEnlargeCell class] forCellWithReuseIdentifier:@"cellID"] ;
    [mWindow addSubview:self.collectionView] ;
    
    
    // 创建下面页数显示的文本
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width-200, 20)] ;
    self.label.textAlignment = NSTextAlignmentCenter ;
    self.label.textColor = [UIColor whiteColor] ;
    self.label.text = [NSString stringWithFormat:@"%d/%lu",selectIndex+1,(unsigned long)self.imageUrlArrays.count] ;
    [mWindow addSubview:self.label] ;
    
    

    // 自定义返回按键button
    UIImage *image = [UIImage imageNamed:@"sitting_04@2x.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.frame = CGRectMake(10, 20, 30, 30) ;
    [button setImage:image forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(returnButtonAction:) forControlEvents:UIControlEventTouchUpInside] ;
    [mWindow addSubview:button] ;
    
}
#pragma mark button等视图的点击事件-------------------------------------
- (void)returnButtonAction:(UIButton *)sender
{
    [self.collectionView removeFromSuperview];
    [self.label removeFromSuperview];
    [sender removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
