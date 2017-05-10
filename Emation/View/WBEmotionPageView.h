//
//  WBEmotionPageView.h
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <UIKit/UIKit.h>

//一页最大列数
#define PAGE_MAX_COL 7
//最大行数
#define PAGE_MAX_ROW 3

//一页显示多少个
#define PAGE_MAX_EMOTION_COUNT (PAGE_MAX_COL * PAGE_MAX_ROW - 1)

@interface WBEmotionPageView : UIView

/**
 *  当前一页对应的表情集合
 */
@property (nonatomic, strong) NSArray *emotions;

@end
