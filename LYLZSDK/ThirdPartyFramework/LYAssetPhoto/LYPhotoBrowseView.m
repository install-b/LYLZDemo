//
//  CJPhotoBrowseView.m
//  weChat
//
//  Created by Lc on 16/3/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LYPhotoBrowseView.h"
#import "LYPhotoBrowseCell.h"

#import "HPWYsonry.h"

@interface LYPhotoBrowseView () <UICollectionViewDataSource, UICollectionViewDelegate, LYPhotoBrowseCellDelegate>
//@property (nonatomic, weak) UIButton *saveButton;
@property (assign, nonatomic) NSInteger lastItem;
@property (assign, nonatomic) NSInteger currentItem;
@property (assign, nonatomic) CGRect defaultRect;
@property (weak, nonatomic) UIImageView *imageView;

@property (assign, nonatomic) NSInteger burntime;
@end

static NSString *const CJPhotoBrowseViewCellId = @"CJPhotoBrowseViewCellId";

@implementation LYPhotoBrowseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
    }
   
    return self;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[LYPhotoBrowseCell class] forCellWithReuseIdentifier:CJPhotoBrowseViewCellId];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    //暂时不需要保存图片的功能
//    UIButton *sBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [sBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    sBtn.layer.cornerRadius = 5;
//    sBtn.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3];
//    [sBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    sBtn.hidden = NO;
//    self.saveButton = sBtn;
//    [self addSubview:self.saveButton];
//
//    [self.saveButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
//        make.trailing.equalTo(self).offset(-20);
//        make.bottom.equalTo(self).offset(-40);
//        make.size.equalTo(@(40));
//    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 显示当前的图片
    [collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * self.index, 0)];
    self.currentItem = self.index;
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYPhotoBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJPhotoBrowseViewCellId forIndexPath:indexPath];
    cell.defaultImageView = self.imageView;
    cell.message = self.datasource[indexPath.item];
    cell.delegate = self;
    self.lastItem = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.lastItem) return;
    self.currentItem = self.lastItem;
}

- (void)saveImage
{
    
//    LYTMessage *message = self.datasource[self.currentItem];
//    LYTImageMessageBody *body = (LYTImageMessageBody *)message.messageBody;
    
    id <LYPhotoBrowsePotoProtocol> body = self.datasource[self.currentItem];
    
    if ([body.picUrl hasPrefix:@"http:"]) {
        NSData *data; //= [NSData imageDataWithURL:body.picUrl];
        UIImage *image = [UIImage imageWithData:data];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];//[NSString imageCachesPathWithImageName:body.displayName]
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [MBProgressHUD showError:LOCALIZATION(@"保存图片失败")];
    } else {
//        [MBProgressHUD showSuccess:LOCALIZATION(@"保存图片成功")];
    }
}

- (void)photoBrowseCellEndZooming:(LYPhotoBrowseCell *)photoBrowseCell
{
    //[UIApplication sharedApplication].statusBarHidden = YES;
    [UIApplication sharedApplication].keyWindow.windowLevel = 0.0;
    [self removeFromSuperview];
}

- (void)showWithView:(UIImageView *)imageView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = 2000;
    [window addSubview:self];
    
    self.imageView = imageView;
    
    [self setupCollectionView];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}


@end

