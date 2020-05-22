//
//  XLZoomHeader.m
//  XLZoomHeaderDemo
//
//  Created by MengXianLiang on 2018/8/3.
//  Copyright © 2018年 mxl. All rights reserved.
//

#import "XLZoomHeader.h"
#import <objc/runtime.h>

static NSString *XLZoomHeaderContentOffsetKey = @"contentOffset";

@interface XLZoomHeader ()

@property (nonatomic, strong) UIImageView *backGroundImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XLZoomHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initHeaderUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initHeaderUI];
    }
    return self;
}

- (void)initHeaderUI {
    self.backGroundImageView = [[UIImageView alloc] init];
    [self addSubview:self.backGroundImageView];
}

- (void)initHeaderRect {
    //设置范围
    CGFloat height = self.bounds.size.height;
    CGRect frame = self.frame;
    frame.origin.y = -height;
    self.frame = frame;
    //设置内容缩进
    self.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {return;}
    self.scrollView = (UIScrollView *)newSuperview;
    [self initHeaderRect];
    [self addObservers];
}

#pragma mark -
#pragma mark 添加观察者
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:XLZoomHeaderContentOffsetKey options:options context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:XLZoomHeaderContentOffsetKey];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:XLZoomHeaderContentOffsetKey]) {
        [self scrollViewContentOffsetDidChange:change];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
#pragma mark 放大动画
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    //顶部适应缩进
    CGFloat top = 0;
    if (@available(iOS 11.0, *)) {
        top = self.scrollView.adjustedContentInset.top;
    }
    //移动距离
    CGFloat offset = fabs(self.scrollView.contentOffset.y) - top;
    //计算高度
    CGFloat height = [self imageViewRect].size.height + offset;
    //计算宽度
    CGFloat width = height * ([self imageViewRect].size.width/[self imageViewRect].size.height);
    //x
    CGFloat x = -(width - [self imageViewRect].size.width)/2.0f + [self imageViewRect].origin.x;
    //y
    CGFloat y = -offset + [self imageViewRect].origin.y;
    //设置大小
    self.backGroundImageView.frame = CGRectMake(x, y, width, height);
    //如果向上滚动，大小不变
    if (offset <= 0) {
        self.backGroundImageView.frame = [self imageViewRect];
    }
}

- (CGRect)imageViewRect {
    CGRect rect = self.bounds;
    rect.origin.x = self.backgroundImageInsets.left;
    rect.size.width = rect.size.width - self.backgroundImageInsets.left - self.backgroundImageInsets.right;
    rect.origin.y = self.backgroundImageInsets.top;
    rect.size.height = rect.size.height - self.backgroundImageInsets.top - self.backgroundImageInsets.bottom;
    return rect;
}

#pragma mark -
#pragma mark Setter
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backGroundImageView.image = backgroundImage;
}

- (void)dealloc {
    [self removeObservers];
}

@end
 
static NSString *XLZoomHeaderKey = @"XLZoomHeaderKey";

@implementation UIScrollView (XLZoomHeader)

- (void)setXl_zoomHeader:(XLZoomHeader *)xl_zoomHeader {
    if (xl_zoomHeader != self.xl_zoomHeader) {
        [self.xl_zoomHeader removeFromSuperview];
        [self insertSubview:xl_zoomHeader atIndex:0];
        objc_setAssociatedObject(self, &XLZoomHeaderKey,
                                 xl_zoomHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (XLZoomHeader *)xl_zoomHeader {
    return objc_getAssociatedObject(self, &XLZoomHeaderKey);
}

@end
