//
//  LYEmotionInputView.m
//  LYLink
//
//  Created by SYLing on 2016/12/19.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYEmotionInputView.h"
#import "LYInputEmotionViewCell.h"
#import "LYEmotion.h"
#import "UIView+Frame.h"
#import "UIColor+LYColor.h"
#import "NSObject+SGExtention.h"

@interface LYEmotionInputView()<UICollectionViewDelegate, UICollectionViewDataSource,LYInputEmotionViewCellDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UIView *emotionsBar;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *emotionArray;

@end

@implementation LYEmotionInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self collecView];
        [self pageControl];
        [self emotionsBar];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emotionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYInputEmotionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InputEmotionCellId" forIndexPath:indexPath];
    
    cell.emotions = self.emotionArray[indexPath.item];
    cell.delegate = self;
    return cell;
}

// 页码设置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        [self collectionViewDidEndScroll:self.collectionView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        [self collectionViewDidEndScroll:self.collectionView];
    }

}
- (void)collectionViewDidEndScroll:(UICollectionView *)collectionView {
    self.pageControl.currentPage = (NSInteger)(collectionView.contentOffset.x / collectionView.width);
}

// 阻止事件往上传,防止点击后键盘退出
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

/** cell代理 */
- (void)inputEmotionCell:(LYInputEmotionViewCell *)inputEmotionCell didClickEmotion:(LYEmotion *)emotion
{
    if (self.didclickEmotionButton) {
        self.didclickEmotionButton(emotion);
    }
}

- (void)inputEmotionCellClickDeleteEmotion:(LYInputEmotionViewCell *)inputEmotionCell
{
    if (self.didclickDeleteEmotion) {
        self.didclickDeleteEmotion();
    }
}

#pragma mark - lazy
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) - 5 , 0, 10);
        pageControl.centerX = self.centerX;
        pageControl.numberOfPages = self.emotionArray.count;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = LYColor(153, 153, 153);
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000];
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    
    return _pageControl;
}


- (UICollectionView *)collecView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.width, self.height - 45);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 45) collectionViewLayout:flowLayout];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];//[UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerClass:[LYInputEmotionViewCell class] forCellWithReuseIdentifier:@"InputEmotionCellId"];
        _collectionView = collectionView;
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}

- (UIView *)emotionsBar
{
    if (!_emotionsBar) {
        UIView *emotionBar = [[UIView alloc] init];
        emotionBar.frame = CGRectMake(0, CGRectGetMaxY(self.pageControl.frame) + 5, self.width, 40);
        emotionBar.backgroundColor = [UIColor whiteColor];
        _emotionsBar = emotionBar;
        [self addSubview:_emotionsBar];
        
        UIButton *senderButtom = [[UIButton alloc] init];
        senderButtom.frame = CGRectMake(self.emotionsBar.width - 50, 0, 54, self.emotionsBar.height);
        [senderButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [senderButtom.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [senderButtom setTitle:@"发送" forState:UIControlStateNormal];
        [senderButtom addTarget:self action:@selector(clickSenderButtom) forControlEvents:UIControlEventTouchUpInside];
        senderButtom.backgroundColor = [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000];
        [self.emotionsBar addSubview:senderButtom];
    }
    return _emotionsBar;
}
- (NSMutableArray *)emotionArray
{
    if (!_emotionArray) {
        _emotionArray = [NSMutableArray array];
//#warning Bundle
        NSString *path = [[[NSBundle mainBundle] pathForResource:@"ClippedExpression" ofType:@"bundle"] stringByAppendingPathComponent:@"emotions.plist"];
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        
        _emotionArray = [LYEmotion sg_objectArrayFromKeyValues:[NSArray arrayWithContentsOfFile:path]].mutableCopy;
    }
    return _emotionArray;
}
- (void)clickSenderButtom
{
    if (self.didclickSenderEmotion) {
        self.didclickSenderEmotion();
    }
}

@end
