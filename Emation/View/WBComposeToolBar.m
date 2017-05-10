//
//  WBComposeToolBar.m
//  微博
//
//  Created by ji on 15/8/25.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBComposeToolBar.h"
#import "UIView+JYExtension.h"

@implementation WBComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        [self addChildBtnWithImageName:@"compose_camerabutton_background" type:WBComposeToolBarButtonTypeCamera];
        [self addChildBtnWithImageName:@"compose_toolbar_picture" type:WBComposeToolBarButtonTypePicture];
        [self addChildBtnWithImageName:@"compose_mentionbutton_background" type:WBComposeToolBarButtonTypeMention];
        [self addChildBtnWithImageName:@"compose_trendbutton_background" type:WBComposeToolBarButtonTypeTrend];
        [self addChildBtnWithImageName:@"compose_emoticonbutton_background" type:WBComposeToolBarButtonTypeEmotion];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat childW = self.width / self.subviews.count;
    
    NSInteger count = self.subviews.count;
    
    
    for (int i=0; i<count; i++) {
        UIButton *button = self.subviews[i];
        
        //设置按钮位置
        button.x = i * childW;
        button.width = childW;
        button.height = self.height;
    }

}

- (void)addChildBtnWithImageName:(NSString *)imageName type:(WBComposeToolBarButtonType)type{
    UIButton *button = [[UIButton alloc] init];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    
    button.tag = type;
    
    [button addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)childButtonClick:(UIButton *)button{
    if (self.toolBarButtonClick) {
        self.toolBarButtonClick(button.tag);
    }
}

- (void)setIsSystemKeyboard:(BOOL)isSystemKeyboard{
        
    UIButton *button = (UIButton *)[self viewWithTag:WBComposeToolBarButtonTypeEmotion];
    
    if (isSystemKeyboard) {
        NSLog(@"系统键盘");
        //是系统键盘,显示表情的图标
        [button setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }else{
        NSLog(@"表情键盘");
        //显示键盘的图标
        [button setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
        
    }
    
}

@end
