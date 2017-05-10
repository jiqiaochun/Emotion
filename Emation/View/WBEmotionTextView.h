//
//  WBEmotionTextView.h
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBTextView.h"

@class WBEmotion;

//文字附件关联对象的key
#define KEY_ATTA_ASSO_EMOTION @"emotion"

@interface WBEmotionTextView : WBTextView

/**
 *  向当前textView里面添加表情
 *
 *  @param emotion <#emotion description#>
 */
- (void)insertEmotion:(WBEmotion *)emotion;


/**
 *  代表当前textView里面显示表情字符串与文字
 *
 *  @return
 */
- (NSString *)fullText;

@end
