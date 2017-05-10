//
//  WBEmotionPageView.m
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionPageView.h"
#import "WBEmotion.h"
#import "NSString+Emoji.h"
#import "WBEmotionPopView.h"
#import "WBEmotionButton.h"
#import "WBEmotionTool.h"
#import "UIView+JYExtension.h"
#import "commonheader.h"

#define MARGIN 10

@interface WBEmotionPageView ()

@property (nonatomic, weak) UIButton *deleteButton;

/**
 *  表情按钮对应的集合,记录表情按钮,以便在调整位置的时候用到
 */
@property (nonatomic, strong) NSMutableArray *emotionButtons;

@property (nonatomic, strong) WBEmotionPopView *popView;

@end

@implementation WBEmotionPageView

- (WBEmotionPopView *)popView{
    if (!_popView) {
        _popView = [WBEmotionPopView emotionPopView];
    }
    return _popView;
}

- (NSMutableArray *)emotionButtons{
    if (!_emotionButtons) {
        _emotionButtons = [NSMutableArray array];
    }
    return _emotionButtons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteButton = [[UIButton alloc] init];
        //设置不同状态的图片
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        
        //添加删除按钮点击事件
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        //1.长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        //设置长按手势响应时间
//        longPress.minimumPressDuration = 2;
        [self addGestureRecognizer:longPress];
        
    }
    return self;
}

- (void)deleteButtonClick:(UIButton *)button{
    
    //发送一个删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:WBEmotionDeleteBtnSelectedNoti object:nil];
    
}

- (void)longPress:(UIGestureRecognizer *)ges{
    NSLog(@"%s",__func__);
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled) {
        [self.popView removeFromSuperview];
        return;
    }
    
    //2.取到按的位置
    CGPoint point = [ges locationInView:self];
    
    WBEmotionButton *tempButton = nil;
    //3.查看按的位置是在哪一个表情按钮之上
    for (WBEmotionButton *button in self.emotionButtons) {
        if (CGRectContainsPoint(button.frame, point)) {
            tempButton = button;
            break;
        }
    }
    
    if (tempButton) {
        //4.在对应按钮上显示popView
        //遇到问题?在这儿拿到当前button上面显示的表情对应的表情模型
        
        self.popView.emotion = tempButton.emotion;
        
        //取到屏幕上最后一个Window,因为我们添加的子控件要添加到最上面
        UIWindow *keyWindow = [[UIApplication sharedApplication].windows lastObject];
        
        //坐标转换
        CGRect rect = [tempButton convertRect:tempButton.bounds toView:keyWindow];
        //添加到window上
        [keyWindow addSubview:self.popView];
        
        //计算x,x应该与button的x相等
        self.popView.centerX = CGRectGetMidX(rect);
        self.popView.y = CGRectGetMidY(rect) - self.popView.height;
    }
    
    
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    //添加表情按钮
    NSInteger count = emotions.count;
    
    for (int i=0; i<count; i++) {
        
        //取出对应的表情模型
        WBEmotion *emotion = emotions[i];
        
        //NSLog(@"%@",emotion.png);
        
        WBEmotionButton *button = [[WBEmotionButton alloc] init];
    
        button.emotion = emotion;
        //button.backgroundColor = WBRandomColor;
        
        //按钮点击监听
        [button addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self.emotionButtons addObject:button];
    }
}

- (void)emotionButtonClick:(WBEmotionButton *)button{
    NSLog(@"%s",__func__);
    
    //保存到最近表情列表
    [WBEmotionTool addRecentEmotion:button.emotion];
    
    WBEmotionPopView *popView = [WBEmotionPopView emotionPopView];
    
    popView.emotion = button.emotion;
    
    //[self addSubview:popView];
    
    //取到屏幕上最后一个Window,因为我们添加的子控件要添加到最上面
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows lastObject];
    
    //坐标转换
    CGRect rect = [button convertRect:button.bounds toView:keyWindow];
    //添加到window上
    [keyWindow addSubview:popView];
    
    
    //计算x,x应该与button的x相等
    popView.centerX = CGRectGetMidX(rect);
    popView.y = CGRectGetMidY(rect) - popView.height;
    
    
    //0.25秒之后消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView removeFromSuperview];
    });
    
    //发出表情点击了的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:WBEmotionDidSelectedNoti object:nil userInfo:[NSDictionary dictionaryWithObject:button.emotion forKey:kWBEmotion]];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //取出子控件的个数
    NSInteger count = self.emotionButtons.count;
    
    CGFloat childW = (self.width - MARGIN * 2) / PAGE_MAX_COL;
    CGFloat childH = (self.height - MARGIN) / PAGE_MAX_ROW;
    
    
    for (int i=0; i<count; i++) {
        UIView *view = self.emotionButtons[i];
        
        view.size = CGSizeMake(childW, childH);
        
        //求出当前在第几列第几行
        NSInteger col = i % PAGE_MAX_COL;
        NSInteger row = i / PAGE_MAX_COL;
        
        //设置位置
        view.x = col * childW + MARGIN;
        view.y = row * childH + MARGIN;
    }
    
    self.deleteButton.size = CGSizeMake(childW, childH);
    
    self.deleteButton.x = self.width - childW - MARGIN;
    self.deleteButton.y = self.height - childH;
}

@end
