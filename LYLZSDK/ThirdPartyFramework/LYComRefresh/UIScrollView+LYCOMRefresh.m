#import "UIScrollView+LYCOMRefresh.h"
#import "LYCOMRefreshHeader.h"
#import "LYCOMRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (LYCOMRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (MJRefresh)

#pragma mark - header
static const char LYCOMRefreshHeaderKey = '\0';
- (void)setHeader:(LYCOMRefreshHeader *)header
{
    if (header != self.header) {
        // 删除旧的，添加新的
        [self.header removeFromSuperview];
        [self addSubview:header];
        
        // 存储新的
        [self willChangeValueForKey:@"header"]; // KVO
        objc_setAssociatedObject(self, &LYCOMRefreshHeaderKey,
                                 header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"]; // KVO
    }
}

- (LYCOMRefreshHeader *)header
{
    return objc_getAssociatedObject(self, &LYCOMRefreshHeaderKey);
}

#pragma mark - footer
static const char LYCOMRefreshFooterKey = '\0';
- (void)setFooter:(LYCOMRefreshFooter *)footer
{
    if (footer != self.footer) {
        // 删除旧的，添加新的
        [self.footer removeFromSuperview];
        [self addSubview:footer];
        
        // 存储新的
        [self willChangeValueForKey:@"footer"]; // KVO
        objc_setAssociatedObject(self, &LYCOMRefreshFooterKey,
                                 footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"]; // KVO
    }
}

- (LYCOMRefreshFooter *)footer
{
    return objc_getAssociatedObject(self, &LYCOMRefreshFooterKey);
}

#pragma mark - other
- (NSInteger)totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char LYCOMRefreshReloadDataBlockKey = '\0';
- (void)setReloadDataBlock:(void (^)(NSInteger))reloadDataBlock
{
    [self willChangeValueForKey:@"reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &LYCOMRefreshReloadDataBlockKey, reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))reloadDataBlock
{
    return objc_getAssociatedObject(self, &LYCOMRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.reloadDataBlock ? : self.reloadDataBlock(self.totalDataCount);
}
@end

@implementation UITableView (LYCOMRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(lycom_reloadData)];
}

- (void)lycom_reloadData
{
    [self lycom_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (LYCOMRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(lycom_reloadData)];
}

- (void)lycom_reloadData
{
    [self lycom_reloadData];
    
    [self executeReloadDataBlock];
}
@end
