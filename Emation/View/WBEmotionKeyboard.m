//
//  WBEmotionKeyboard.m
//  微博
//
//  Created by ji on 15/8/27.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionKeyboard.h"
#import "WBEmotionToolBar.h"
#import "WBEmotionListView.h"
#import "WBEmotion.h"
#import "MJExtension.h"
#import "WBEmotionTool.h"
#import "UIView+JYExtension.h"
#import "commonheader.h"


@interface WBEmotionKeyboard () <WBEmotionToolBarDelegate>

@property (nonatomic, weak) WBEmotionToolBar *toolBar;


@property (nonatomic, weak) WBEmotionListView *currentListView;

/**
 *  最近
 */
@property (nonatomic, strong) WBEmotionListView *recentListView;

/**
 *  默认
 */
@property (nonatomic, strong) WBEmotionListView *defaultListView;

/**
 *  emoji
 */
@property (nonatomic, strong) WBEmotionListView *emojiListView;

/**
 *  lxh
 */
@property (nonatomic, strong) WBEmotionListView *lxhListView;

@end

@implementation WBEmotionKeyboard

- (WBEmotionListView *)recentListView{
    if (!_recentListView) {
        _recentListView = [[WBEmotionListView alloc] init];
        
        _recentListView.emotions = [WBEmotionTool recentEmotions];
        
    }
    return _recentListView;
}


- (WBEmotionListView *)defaultListView{
    if (!_defaultListView) {
        _defaultListView = [[WBEmotionListView alloc] init];
        
        _defaultListView.emotions = [WBEmotionTool defaultEmotions];
        
    }
    return _defaultListView;
}
- (WBEmotionListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView = [[WBEmotionListView alloc] init];
        
        _emojiListView.emotions = [WBEmotionTool emojiEmotions];
        
    }
    return _emojiListView;
}

- (WBEmotionListView *)lxhListView{
    if (!_lxhListView) {
        _lxhListView = [[WBEmotionListView alloc] init];

        _lxhListView.emotions = [WBEmotionTool lxhEmotions];
        
    }
    return _lxhListView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        
        WBEmotionToolBar *toolBar = [[WBEmotionToolBar alloc] init];
        toolBar.height = 37;
        toolBar.delegate = self;
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
        //接收表情点击通知.以便更新最近表情列表
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:WBEmotionDidSelectedNoti object:nil];
        
    }
    return self;
}

- (void)emotionDidSelected:(NSNotification *)noti{
    self.recentListView.emotions = [WBEmotionTool recentEmotions];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置toolBar宽度与y
    self.toolBar.y = self.height - self.toolBar.height;
    self.toolBar.width = self.width;
    
    
    //调整当前要显示的listView的位置与大小
    self.currentListView.width = self.width;
    self.currentListView.height = self.toolBar.y;
}

- (void)emotionToolbar:(WBEmotionToolBar *)toolBar buttonClickWithType:(WBEmotionToolBarButtonType)type{
    //先移除原来显示的
    [self.currentListView removeFromSuperview];
    
    switch (type) {
        case WBEmotionToolBarButtonTypeRecent:
            self.recentListView.emotions = [WBEmotionTool recentEmotions];
            [self addSubview:self.recentListView];//最近
            break;
        case WBEmotionToolBarButtonTypeDefault://默认
            [self addSubview:self.defaultListView];
            break;
        case WBEmotionToolBarButtonTypeEmoji://emoji
            [self addSubview:self.emojiListView];
            break;
        case WBEmotionToolBarButtonTypeLxh://lxh
            [self addSubview:self.lxhListView];
            break;
    }
    //再赋值当前显示的listView
    self.currentListView = [self.subviews lastObject];
}

@end
