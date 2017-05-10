//
//  WBEmotionButton.m
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionButton.h"
#import "WBEmotion.h"
#import "NSString+Emoji.h"
#import "UIButton+RemoveHighlightEffect.h"

@implementation WBEmotionButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.removeHighlightEffect = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:35];
}

- (void)setEmotion:(WBEmotion *)emotion{
    _emotion = emotion;
    
    if (emotion.isEmoji) {
        [self setTitle:[emotion.code emoji] forState:UIControlStateNormal];
    }else{
        
        [self setImage:[UIImage imageNamed:emotion.fullPath] forState:UIControlStateNormal];
    }
}

@end
