//
//  WBTextView.m
//  微博
//
//  Created by ji on 15/8/25.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBTextView.h"
#import "UIView+JYExtension.h"
#import "commonheader.h"

@interface WBTextView ()

@property (nonatomic,strong) UILabel *placeholderLabel;

@end

@implementation WBTextView

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = [UIColor grayColor];
        placeholderLabel.font = self.font;
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    // 设置占位文字的文字
    self.placeholderLabel.x = 8;
    self.placeholderLabel.y = 8;
    
    // 设置大小
//    self.placeholderLabel.size = [placeholder sizeWithFont:self.placeholderLabel.font maxW:([UIScreen mainScreen].bounds.size.width-16)];
    self.placeholderLabel.size = [placeholder sizeWithFont:self.placeholderLabel.font forWidth:([UIScreen mainScreen].bounds.size.width-16) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.placeholderLabel.numberOfLines = 0;
    [self.placeholderLabel sizeToFit];
}

- (void)textDidChange{
    self.placeholderLabel.hidden = self.text.length;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    // 调整placeholder文字的大小
    self.placeholderLabel.font = font;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
