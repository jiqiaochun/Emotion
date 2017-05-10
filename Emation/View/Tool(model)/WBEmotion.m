//
//  WBEmotion.m
//  微博
//
//  Created by ji on 15/8/27.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotion.h"
#import "MJExtension.h"

@implementation WBEmotion

MJCodingImplementation

- (void)setPath:(NSString *)path{
    _path = path;
    self.fullPath = [NSString stringWithFormat:@"%@%@",self.path,self.png];
}

- (void)setType:(NSString *)type{
    _type = type;
    
    if ([self.type isEqualToString:@"1"]) {
        self.isEmoji = YES;
    }
}

- (BOOL)isEqual:(WBEmotion *)object{
    if ([self.chs isEqualToString:object.chs] || [self.code isEqualToString:object.code]) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
