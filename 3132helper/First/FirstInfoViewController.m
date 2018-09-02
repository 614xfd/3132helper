//
//  FirstInfoViewController.m
//  3132helper
//
//  Created by mac on 2018/8/31.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "FirstInfoViewController.h"
#import "FirstObjct.h"
#import "TDCache.h"
@interface FirstInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong)UICollectionView *mainCollectionView;
@property (nonatomic, strong)FirstObjct *obj;

@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, strong)TDOperator *operator;

@property (nonatomic, strong)UIView *dustView;
@property (nonatomic, strong)UIScrollView *showPreviewScrollView;
@property (nonatomic, strong)UIImageView *showPreviewImageView;


@property (nonatomic, assign)BOOL isEdit;
@property (nonatomic, strong)NSMutableArray *editData;
@end

@implementation FirstInfoViewController
- (void)creatNavItem{
    //    self.navigationController.navigationBar
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightBtnClick:(UIButton *)rightBtn{//设置
    if (self.isEdit) {
        [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.isEdit = NO;
        for (long index = self.dataList.count - 1; index >= 0; index --) {
            if ([self.editData indexOfObject:[NSString stringWithFormat:@"%ld",index]] != NSNotFound) {
                [self.dataList removeObjectAtIndex:index];
            }
        }
    }else{
        [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.isEdit = YES;
    }
    
    [self.mainCollectionView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavItem];
    self.editData = [NSMutableArray array];
    // Do any additional setup after loading the view.
    //创建sqlite模型类
    FirstObjct *cacheModel = [[FirstObjct alloc]init];
    //通过模型生产操作者
    self.operator = [TDOperator instanceWhithModel:cacheModel];
    
    
    self.obj = [[self.operator findOneWithValue:[NSString stringWithFormat:@"%d",self.cacheID] forKey:@"ID"] firstObject];
    self.dataList = [[self stringToJSON:self.obj.dataJson] mutableCopy];
    [self creatView];
}
- (void)creatView{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0.1);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(120, 120);
    
    //2.初始化collectionView
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:self.mainCollectionView];
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    

}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    for (UIView *v in cell.subviews) {
        if (v.tag == 1000) {
            [v removeFromSuperview];
        }
    }
    
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    NSString *file = self.dataList[indexPath.row];
    UIImage *img = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile:file]];

    UIImageView *imgV = [[UIImageView alloc]initWithImage:img];
    imgV.tag  = 1000;
    imgV.frame = CGRectMake(0, 0, 100, 100);
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:imgV];
    
    
    if (self.isEdit) {
        UIImageView *checkedView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        checkedView.tag = 1000;
        if ([self.editData indexOfObject:[NSString stringWithFormat:@"%ld",indexPath.row]] != NSNotFound) {
            checkedView.image = [UIImage imageNamed:@"checked"];
        }else{
            checkedView.image = [UIImage imageNamed:@"unchecked"];
        }
        [cell addSubview:checkedView];
    }
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}



//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}





//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        if ([self.editData indexOfObject:[NSString stringWithFormat:@"%ld",indexPath.row]] != NSNotFound) {
            [self.editData removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }else{
            [self.editData addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
        [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    }else{
        NSString *file = self.dataList[indexPath.row];
        UIImage *img = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile:file]];
        [self showPreviewWithImage:img];
    }
    
}


- (void)showPreviewWithImage:(UIImage *)img{
    if (!self.dustView) {
        UIView *v = [UIApplication sharedApplication].keyWindow;
        
        self.dustView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.dustView.backgroundColor = [UIColor blackColor];
        self.dustView.alpha = 0.7;
        self.dustView.hidden = YES;
        [v addSubview:self.dustView];
        
        
        self.showPreviewScrollView = [[UIScrollView alloc]initWithFrame:self.dustView.bounds];
        self.showPreviewScrollView.minimumZoomScale = 0.5;
        self.showPreviewScrollView.maximumZoomScale = 4;
        self.showPreviewScrollView.hidden = YES;
        self.showPreviewScrollView.delegate = self;
        [v addSubview:self.showPreviewScrollView];
        
        self.showPreviewImageView = [[UIImageView alloc]initWithFrame:self.showPreviewScrollView.bounds];
        self.showPreviewImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.showPreviewScrollView addSubview:self.showPreviewImageView];
        
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPreviewImageView)];
        self.showPreviewImageView.userInteractionEnabled = YES;
        [self.showPreviewImageView addGestureRecognizer:tap];
    }
    self.dustView.hidden = NO;
    self.showPreviewScrollView.hidden = NO;
    self.showPreviewImageView.image = img;
}
- (void)hiddenPreviewImageView{
    self.dustView.hidden = YES;
    self.showPreviewScrollView.hidden = YES;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.showPreviewImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale

{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [self.showPreviewScrollView setZoomScale:scale animated:NO];
}




- (void)viewWillDisappear:(BOOL)animated{
    self.obj.dataJson = [self getJson:self.dataList];
    self.obj.number = (int)self.dataList.count;
    [self.operator deleteWithPrimary:self.obj.ID];
    [self.operator insertWithModel:self.obj];
}


@end
