//
//  WBEmotionListView.m
//  微博
//
//  Created by ji on 15/8/27.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionListView.h"
#import "WBEmotionToolBar.h"
#import "WBEmotionPageView.h"
#import "UIView+JYExtension.h"


@interface WBEmotionListView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pagecontrol;

@property (nonatomic, weak) UIScrollView *scrollView;

/**
 *  记录scrollView的用户自己添加的子控件,因为直接调用 scrollView.subViews会出现问题(因为滚动条也算scrollView的子控件)
 */
@property (nonatomic, strong) NSMutableArray *scrollsubViews;

@property (nonatomic,assign) NSInteger page;

@end

@implementation WBEmotionListView

- (NSMutableArray *)scrollsubViews{
    if (!_scrollsubViews) {
        _scrollsubViews = [NSMutableArray array];
    }
    return _scrollsubViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加uipageControl
        UIPageControl *pagecontrol = [[UIPageControl alloc] init];
//        pagecontrol.backgroundColor = WBRandomColor;
        
//        pagecontrol.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
//        pagecontrol.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
        
        //使用kvc直接赋值当前选中的图标
        [pagecontrol setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [pagecontrol setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        
        [self addSubview:pagecontrol];
        self.pagecontrol = pagecontrol;
        
        
        //添加scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
//        scrollView.backgroundColor = WBRandomColor;
        //隐藏水平方法的滚动条
        scrollView.showsHorizontalScrollIndicator = false;
        //开启分页
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        [self addSubview:scrollView];
        
        self.scrollView = scrollView;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置pageControl
    self.pagecontrol.width = self.width;
    self.pagecontrol.height = 30;
    
    self.pagecontrol.y = self.height - self.pagecontrol.height;
    
    
    //设置scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pagecontrol.y;
    
    //设置scrollView里面子控件的大小
    
    for (int i=0; i<self.scrollsubViews.count; i++) {
        UIView *view = self.scrollsubViews[i];
        
        view.size = self.scrollView.size;
        view.x = i * self.scrollView.width;
    }
    
    //根据添加的子控件的个数计算内容大小
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.scrollsubViews.count, self.scrollView.height);

}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    //在第二次执行这个方法的时候,就需要把之前已经添加的pageView给移除
    [self.scrollsubViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollsubViews removeAllObjects];
    
    NSInteger page = (emotions.count + PAGE_MAX_EMOTION_COUNT - 1 )/ PAGE_MAX_EMOTION_COUNT ;
    
    
    //设置页数
    self.pagecontrol.numberOfPages = page;
    self.page = page;
    
    for (int i=0; i<page; i++) {
        WBEmotionPageView *view = [[WBEmotionPageView alloc] init];
//        view.backgroundColor = WBRandomColor;
        
        //切割每一页的表情集合
        NSRange range;
        
        range.location = i * PAGE_MAX_EMOTION_COUNT;
        range.length = PAGE_MAX_EMOTION_COUNT;
        
        //如果表情只有99个,那么最后一页就不满20个,所以需要加一个判断
        NSInteger lastPageCount = emotions.count - range.location;
        if (lastPageCount < PAGE_MAX_EMOTION_COUNT) {
            range.length = lastPageCount;
        }
        
        
        //截取出来是每一页对应的表情
        NSArray *childEmotions = [emotions subarrayWithRange:range];
        //设置每一页的表情集合
        view.emotions = childEmotions;
        
        [self.scrollView addSubview:view];
        [self.scrollsubViews addObject:view];
    }
    
    //告诉当前控件,去重新布局一下
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算页数-->小数-->四舍五入
    CGFloat page = scrollView.contentOffset.x / scrollView.width;
    self.pagecontrol.currentPage = (int)(page + 0.5);
    
//    WBEmotionToolBar *toolbar = [[WBEmotionToolBar alloc] init];
//    for (int i = 0; i < toolbar.subviews.count; i++) {
//        UIButton *button = toolbar.subviews[i];
//        if ([button.titleLabel.text isEqualToString:@"Emoji"] && self.page) {
//            
//            [toolbar childButtonClick:button];
//        }
//    }
}

@end
