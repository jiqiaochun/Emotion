//
//  WBEmotionTool.h
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBEmotion;

@interface WBEmotionTool : NSObject

/**
 *  通过表情的描述字符串找到对应表情模型
 *
 *  @param chs <#chs description#>
 *
 *  @return <#return value description#>
 */
+ (WBEmotion *)emotionWithChs:(NSString *)chs;

/**
 *  添加最近表情到最近表情列表(集合)
 *
 *  @param emotion <#emotion description#>
 */
+ (void)addRecentEmotion:(WBEmotion *)emotion;


/**
 *  获取最近表情列表
 *
 *  @return
 */
+ (NSArray *)recentEmotions;

+ (NSArray *)defaultEmotions;
+ (NSArray *)emojiEmotions;
+ (NSArray *)lxhEmotions;

@end
