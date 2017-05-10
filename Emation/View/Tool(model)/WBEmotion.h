//
//  WBEmotion.h
//  微博
//
//  Created by ji on 15/8/27.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBEmotion : NSObject <NSCoding>

/**
 *  表情对应的中文描述
 */
@property (nonatomic, copy) NSString *chs;

/**
 *  表情对应的繁体中文描述
 */
@property (nonatomic, copy) NSString *cht;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString *png;

/**
 *  emoji表情的code
 */
@property (nonatomic, copy) NSString *code;

/**
 *  如果type等于0.代表是图片表情,否则为emoji表情
 */
@property (nonatomic, copy) NSString *type;

/**
 *  表情对应的路径
 */
@property (nonatomic, copy) NSString *path;


@property (nonatomic, copy) NSString *fullPath;

/**
 *  是否是emoji表情
 */
@property (nonatomic, assign) BOOL isEmoji;


@end
