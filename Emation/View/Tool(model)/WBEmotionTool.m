//
//  WBEmotionTool.m
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionTool.h"
#import "WBEmotion.h"
#import "MJExtension.h"


//最新表情的路径
#define RECENTEMOTIONS_PAHT [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentemotions.archive"]

static NSMutableArray *_recentEmotions;

@implementation WBEmotionTool

+ (void)initialize{
    if (!_recentEmotions) {
        _recentEmotions = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:RECENTEMOTIONS_PAHT]];
    }
}

+ (void)addRecentEmotion:(WBEmotion *)emotion{
    
    //2.添加进去
    //[recentArray addObject:emotion];
    // 判断是否有相等的标题 （重写isEqual）
    [_recentEmotions removeObject:emotion];
    
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //3.保存
    [NSKeyedArchiver archiveRootObject:[_recentEmotions copy] toFile:RECENTEMOTIONS_PAHT];
}


+ (NSArray *)recentEmotions{
    return _recentEmotions;
}

+ (NSArray *)defaultEmotions{
    //读取默认表情
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:@""];
    NSArray *emotions = [WBEmotion objectArrayWithFile:path];
    
    //给集合里面每一个元素都执行某个方法
    [emotions makeObjectsPerformSelector:@selector(setPath:) withObject:@"EmotionIcons/default/"];
    return emotions;
}

+ (NSArray *)emojiEmotions{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:@""];
    NSArray *emotions = [WBEmotion objectArrayWithFile:path];
    return emotions;
}

+ (NSArray *)lxhEmotions{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:@""];
    NSArray *emotions = [WBEmotion objectArrayWithFile:path];
    
    //给集合里面每一个元素都执行某个方法
    [emotions makeObjectsPerformSelector:@selector(setPath:) withObject:@"EmotionIcons/lxh/"];
    return emotions;
}


+ (WBEmotion *)emotionWithChs:(NSString *)chs{
    
    
    //先遍历默认表情
    NSArray *defaultEmotions = [self defaultEmotions];
    for (WBEmotion *emotion in defaultEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    //再遍历浪小花表情
    NSArray *lxhEmotions = [self lxhEmotions];
    for (WBEmotion *emotion in lxhEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}

@end
