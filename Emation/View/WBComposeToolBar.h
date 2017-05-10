//
//  WBComposeToolBar.h
//  微博
//
//  Created by ji on 15/8/25.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBComposeToolBarButtonType){
    WBComposeToolBarButtonTypeCamera,
    WBComposeToolBarButtonTypePicture,
    WBComposeToolBarButtonTypeMention,
    WBComposeToolBarButtonTypeTrend,
    WBComposeToolBarButtonTypeEmotion,
};

@interface WBComposeToolBar : UIView

@property (nonatomic,copy) void(^toolBarButtonClick)(WBComposeToolBarButtonType type);

@property (nonatomic, assign) BOOL isSystemKeyboard;

@end
