//
//  WBEmotionPopView.h
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBEmotion;

@interface WBEmotionPopView : UIView

+ (instancetype)emotionPopView;

@property (nonatomic,strong) WBEmotion *emotion;

@end
