//
//  WBEmotionToolBar.m
//  微博
//
//  Created by ji on 15/8/27.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionToolBar.h"
#import "UIView+JYExtension.h"
#import "UIButton+RemoveHighlightEffect.h"

@interface WBEmotionToolBar ()

/**
 *  当前选中的button
 */
@property (nonatomic, weak) UIButton *currentSelectedBtn;


@end

@implementation WBEmotionToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加4个按钮
        
        [self addChildBtnWithTitle:@"最近" bgImageName:@"left" type:WBEmotionToolBarButtonTypeRecent];
        [self addChildBtnWithTitle:@"默认" bgImageName:@"mid" type:WBEmotionToolBarButtonTypeDefault];
        [self addChildBtnWithTitle:@"Emoji" bgImageName:@"mid" type:WBEmotionToolBarButtonTypeEmoji];
        [self addChildBtnWithTitle:@"浪小花" bgImageName:@"right" type:WBEmotionToolBarButtonTypeLxh];
        
        //
        //        [self childButtonClick:defaultBtn];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //计算出每一个按钮的宽度
    CGFloat childW = self.width / 4;
    
    NSInteger count = self.subviews.count;
    
    for (int i=0; i<count; i++) {
        UIView *childView = self.subviews[i];
        
        //设置宽高大小位置
        childView.x = i * childW;
        childView.width = childW;
        childView.height = self.height;
    }
}

//compose_emotion_table_mid_selected
- (UIButton *)addChildBtnWithTitle:(NSString *)title bgImageName:(NSString *)bgImageName type:(WBEmotionToolBarButtonType)type{
    
    UIButton *button = [[UIButton alloc] init];
    //去掉button的按下高亮效果
    button.removeHighlightEffect = YES;
    //设置标题
    [button setTitle:title forState:UIControlStateNormal];
    
    button.tag = type;
    
    //设置不同状态下的背景图片
    //UIControlStateNormal  拉伸
    UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"compose_emotion_table_%@_normal",bgImageName]];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
   
    //UIControlStateSelected  拉伸
    UIImage *buttonImageselected = [UIImage imageNamed:[NSString stringWithFormat:@"compose_emotion_table_%@_selected",bgImageName]];
    buttonImageselected = [buttonImageselected stretchableImageWithLeftCapWidth:floorf(buttonImageselected.size.width/2) topCapHeight:floorf(buttonImageselected.size.height/2)];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [button setBackgroundImage:buttonImageselected forState:UIControlStateSelected];
    
    //设置选中状态字体颜色
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    //监听点击事件
    [button addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:button];
    
    return button;
}
- (void)setDelegate:(id<WBEmotionToolBarDelegate>)delegate{
    _delegate = delegate;
    [self childButtonClick:(UIButton *)[self viewWithTag:WBEmotionToolBarButtonTypeDefault]];
}


- (void)childButtonClick:(UIButton *)button{
    
    //先移除之前选中的button
    self.currentSelectedBtn.enabled = YES;
    //选中当前
    button.enabled = NO;
    //记录当前选中的按钮
    self.currentSelectedBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:buttonClickWithType:)]) {
        [self.delegate emotionToolbar:self buttonClickWithType:button.tag];
    }
}

@end
