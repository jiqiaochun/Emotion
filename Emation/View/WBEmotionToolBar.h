//
//  WBEmotionToolBar.h
//  微博
//
//  Created by ji on 15/8/27.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBEmotionToolBar;



typedef NS_ENUM(NSUInteger, WBEmotionToolBarButtonType) {
    WBEmotionToolBarButtonTypeRecent, //最近
    WBEmotionToolBarButtonTypeDefault,//默认
    WBEmotionToolBarButtonTypeEmoji,//emoji
    WBEmotionToolBarButtonTypeLxh,//浪小花
};


@protocol WBEmotionToolBarDelegate <NSObject>

- (void)emotionToolbar:(WBEmotionToolBar *)toolBar buttonClickWithType:(WBEmotionToolBarButtonType)type;

@end

@interface WBEmotionToolBar : UIView

@property (nonatomic,weak) id<WBEmotionToolBarDelegate> delegate;

- (void)childButtonClick:(UIButton *)button;

@end
