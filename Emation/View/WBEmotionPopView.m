//
//  WBEmotionPopView.m
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionPopView.h"
#import "WBEmotion.h"
#import "NSString+Emoji.h"
#import "WBEmotionButton.h"

@interface WBEmotionPopView ()

@property (weak, nonatomic) IBOutlet WBEmotionButton *emotionButton;

@end

@implementation WBEmotionPopView

+ (instancetype)emotionPopView{
    return [[[NSBundle mainBundle] loadNibNamed:@"WBEmotionPopView" owner:nil options:nil] lastObject];
}

-(void)setEmotion:(WBEmotion *)emotion{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
    
//    if (emotion.isEmoji) {
//        [self.emotionButton setTitle:[emotion.copy emoji] forState:UIControlStateNormal];
//    }else{
//        [self.emotionButton setImage:[UIImage imageNamed:emotion.fullPath] forState:UIControlStateNormal];
//    }
}


@end
