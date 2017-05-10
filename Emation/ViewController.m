//
//  ViewController.m
//  Emation
//
//  Created by 姬巧春 on 16/4/19.
//  Copyright © 2016年 姬巧春. All rights reserved.
//

#import "ViewController.h"
#import "WBEmotionTextView.h"
#import "WBComposePhotos.h"
#import "WBComposeToolBar.h"
#import "WBEmotionKeyboard.h"
#import "UIView+JYExtension.h"
#import "commonheader.h"

@interface ViewController ()  <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) WBEmotionTextView *textView;

//配图view
@property (nonatomic, weak) WBComposePhotos *photos;

@property (nonatomic,weak) WBComposeToolBar *toolBar;

@property (nonatomic, strong) WBEmotionKeyboard *emotionKeyboard;

/**
 *  是否正在选择键盘
 */
@property (nonatomic, assign) BOOL isSwitchKeyboard;

@end

@implementation ViewController

- (WBEmotionKeyboard *)emotionKeyboard{
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[WBEmotionKeyboard alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        //_emotionKeyboard.backgroundColor = WBRandomColor;
    }
    return _emotionKeyboard;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
//    [self setupNav];
    
    // 添加textView
    WBEmotionTextView *textView = [[WBEmotionTextView alloc] init];
    textView.backgroundColor = [UIColor blueColor];
    textView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    textView.alwaysBounceVertical = YES;
    textView.placeholder = @"前进不必遗憾，若是美好，叫做精彩；若是糟糕，叫做经历！！！";
    textView.delegate = self;
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    
    self.textView = textView;
    
    // 添加toolbar
    WBComposeToolBar *toolBar = [[WBComposeToolBar alloc] init];
//    toolBar.backgroundColor = [UIColor redColor];
    toolBar.x = 0;
    toolBar.height = 44;
    toolBar.y = [UIScreen mainScreen].bounds.size.height - toolBar.height;
    toolBar.width = [UIScreen mainScreen].bounds.size.width;
    
    [toolBar setToolBarButtonClick:^(WBComposeToolBarButtonType type) {
        [self composeToolBarButtonClickWithType:type];
    }];
    [self.view addSubview:toolBar];
    
    self.toolBar = toolBar;
    
    // 添加配图View相册
    WBComposePhotos *composephotos = [[WBComposePhotos alloc] init];
    composephotos.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    composephotos.y = 100;
    self.photos = composephotos;
    [self.textView addSubview:composephotos];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:WBEmotionDidSelectedNoti object:nil];
    
    //删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteButtonClick:) name:WBEmotionDeleteBtnSelectedNoti object:nil];
}

/**
 *  删除按钮点击
 *
 *  @param noti <#noti description#>
 */
- (void)deleteButtonClick:(NSNotification *)noti{
    [self.textView deleteBackward];
}

/**
 *  表情选中  (接收通知监听文字改变)
 *
 *  @param noti <#noti description#>
 */
- (void)emotionDidSelected:(NSNotification *)noti{
    
    WBEmotion *emotion = noti.userInfo[kWBEmotion];
    [self.textView insertEmotion:emotion];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notificy{
    
    if (!self.isSwitchKeyboard) {
        
        NSValue *rectValue = notificy.userInfo[UIKeyboardFrameEndUserInfoKey];
        NSLog(@"%@",notificy);
        
        CGRect rect = [rectValue CGRectValue];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBar.y = rect.origin.y - self.toolBar.height;
        }];
    }
}

- (void)composeToolBarButtonClickWithType:(WBComposeToolBarButtonType)type{
    NSLog(@"%zd",type);
    switch (type) {
        case WBComposeToolBarButtonTypeCamera:{
            NSLog(@"WBComposeToolBarButtonTypeCamera");
            
            BOOL result = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            
            if (result) {
                [self selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }else{
                NSLog(@"相机不可用");
            }
            
            break;
        }
        case WBComposeToolBarButtonTypePicture:
            //NSLog(@"WBComposeToolBarButtonTypePicture");
            
            [self selectImageWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            
            break;
        case WBComposeToolBarButtonTypeMention:
            NSLog(@"WBComposeToolBarButtonTypeMention");
            break;
        case WBComposeToolBarButtonTypeTrend:
            NSLog(@"WBComposeToolBarButtonTypeTrend");
            break;
        case WBComposeToolBarButtonTypeEmotion:
            NSLog(@"WBComposeToolBarButtonTypeEmotion");
            [self switchKeyboard];
            break;
            
        default:
            break;
    }
}

//- (void)setupNav{
//    // 设置tabbar左右按钮
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" target:self Action:@selector(back)];
//    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发送" target:self Action:@selector(send)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
//    
//    // 设置tabbar 的标题
//    UILabel *titleView = [[UILabel alloc] init];
//    titleView.numberOfLines = 2;
//    titleView.textAlignment = NSTextAlignmentCenter;
//    
//    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WBAccountPath];
//    NSString *name = account.name;
//    
//    if (name) {
//        NSString *title = [NSString stringWithFormat:@"发微博\n%@",name];
//        NSRange nameRange = [title rangeOfString:name];
//        
//        // 初始化一个带有属性的可变字符串
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
//        
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 3)];
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:nameRange];
//        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:nameRange];
//        
//        titleView.attributedText = attrStr;
//        
//        [titleView sizeToFit];
//        
//        self.navigationItem.titleView = titleView;
//    }else{
//        self.navigationItem.title = @"发微博";
//    }
//}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)send{
//    NSLog(@"发送");
//    
//    //判断是否有图片,如果有图片upload
//    
//    if (self.photos.images.count) {
//        [self upload];
//    }else{
//        [self update];
//    }
//    
//}

///**
// *  发送文字微博
// */
//- (void)update{
//    [WBComposeDataTool sendStatusWithText:self.textView.fullText success:^(WBStatuses *result) {
//        [MBProgressHUD showSuccess:@"发送成功"];
//    } failure:^(NSError *error) {
//        NSLog(@"请求错误:%@",error);
//        [MBProgressHUD showError:@"发送失败"];
//    }];
//}
//
///**
// *  上传图片并发布一条新微博
// */
//- (void)upload{
//    
//    NSString *urlStr = @"https://upload.api.weibo.com/2/statuses/upload.json";
//    
//    WBAccount *account = [WBAccountTool account];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = account.access_token;
//    params[@"status"] = self.textView.fullText;
//    
//    NSMutableDictionary *dataParams = [NSMutableDictionary dictionary];
//    
//    //怎么转????
//    UIImage *image = [self.photos.images firstObject];
//    
//    //把图片转成NSData
//    NSData *data = UIImageJPEGRepresentation(image, 0.6);
//    dataParams[@"pic"] = data;
//    
//    
//    [WBHttpTool postWithUrl:urlStr params:params dataParams:dataParams success:^(id responseObject) {
//        [MBProgressHUD showSuccess:@"发送成功"];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [MBProgressHUD showError:@"发送失败"];
//    }];
//    
//    
//    
//}


- (void)selectImageWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //    self.textView.backgroundColor = [UIColor colorWithPatternImage:image];
    // 在配图View相册中添加image
    [self.photos addImage:image];
    
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma -mark UITextViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    //    if (textView.text.length) {
    //        self.navigationItem.rightBarButtonItem.enabled = YES;
    //    }else{
    //        self.navigationItem.rightBarButtonItem.enabled = NO;
    //    }
    
    if (textView.contentSize.height > 100) {
        self.photos.y = textView.contentSize.height;
    }else{
        self.photos.y = 100;
    }
    
    //当"发送"按钮启用
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length;
}


/**
 *  选择键盘
 */
- (void)switchKeyboard{
    //告诉改变toolBar 的y的方法,让其不要执行
    self.isSwitchKeyboard = YES;
    
    [self.textView endEditing:YES];
    
    // 判断当前是系统键盘还是表情键盘
    if (self.textView.inputView) {
        // 表示是系统键盘
        self.textView.inputView = nil;
        self.toolBar.isSystemKeyboard = YES;
    }else{
        self.textView.inputView = self.emotionKeyboard;
        self.toolBar.isSystemKeyboard = NO;
    }
    
    //告诉改变toolBar 的y的方法,让其可以执行
    self.isSwitchKeyboard = NO;
    [self.textView becomeFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBEmotionDidSelectedNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBEmotionDeleteBtnSelectedNoti object:nil];
}
@end
