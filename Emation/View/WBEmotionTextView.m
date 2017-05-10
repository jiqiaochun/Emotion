//
//  WBEmotionTextView.m
//  微博
//
//  Created by ji on 15/8/28.
//  Copyright (c) 2015年 ji. All rights reserved.
//

#import "WBEmotionTextView.h"
#import "WBEmotion.h"
#import "NSString+Emoji.h"
#import <objc/runtime.h>

@implementation WBEmotionTextView

- (void)insertEmotion:(WBEmotion *)emotion{
    if (emotion.isEmoji) {
        NSString *emojiStr = [emotion.code emoji];
        [self insertText:emojiStr];
    }else{
        //1.通过表情模型里面的数据初始化表情的图片
        UIImage *image = [UIImage imageNamed:emotion.fullPath];
        
        //2.NSTextAttachment-->文字附件--通过图片初始化一个文件附件出来
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        
        //当前文字附件对应的表情模型
        objc_setAssociatedObject(attachment, KEY_ATTA_ASSO_EMOTION, emotion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //        attachment.emotion = emotion;
        attachment.image = image;
        
        
        CGFloat imageWH = self.font.lineHeight;
        attachment.bounds = CGRectMake(0, -4, imageWH, imageWH);
        
        //3.把第2步的文字附件转成NSAttributedString
        NSAttributedString *emotionAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //4.把第3步取到NSAttributedString添加到现有的NSAttributedString(IWTextView)里面去
        NSMutableAttributedString *originalAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        //获取光标的位置
        NSRange selectedRange = self.selectedRange;
        
//        [originalAttr appendAttributedString:emotionAttr];
        [originalAttr replaceCharactersInRange:selectedRange withAttributedString:emotionAttr];
        
        //添加字体属性
        [originalAttr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, originalAttr.length)];
        
        self.attributedText = originalAttr;
        
        //添加完表情之后,因为重新设置了textView的attributedText,光标会跑到后面去,所以下面手动设置一下光标的位置
        self.selectedRange = NSMakeRange(selectedRange.location + 1, 0);
    }
    
    //发送文字改变通知-->如果不发送,placeholder会继续显示
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
    
    //文字改变的代理方法也得调用一下-->如果不调用 ,发微博界面右上角的"发送"按钮继续不可用
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (NSString *)fullText{
    
    NSMutableString *result = [NSMutableString string];
    //取到textView当前的内容-->textView.attributedText
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //        NSLog(@"%@===range:%@",attrs,NSStringFromRange(range));
        NSTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) {
            //    *找到attributedText里面对象的身上关联的表情模型
            WBEmotion *emotion = objc_getAssociatedObject(attachment, KEY_ATTA_ASSO_EMOTION);
            // *通过图片找到对应的表情描述字符串
            //    *拼接字符串提交到新浪微博
            [result appendString:emotion.chs];
            
        }else{
            //    *拼接字符串提交到新浪微博
            //代表是文字字符串
            [result appendString:[[self.attributedText string] substringWithRange:range]];
        }
    }];
    return [result copy];
}

@end
