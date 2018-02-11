//
//  JDLAlertView.h
//  JDLAlertView
//
//  Created by 胜炫电子 on 2018/2/9.
//  Copyright © 2018年 BlueSkyer-25. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JDLBackgroundStyle) {
    JDLBackgroundStyleNone =1,   
    JDLBackgroundStyleBlack
};

//回调
typedef void(^clickBlock)(NSInteger index,NSString *title);

@interface JDLAlertView : UIView

@property (nonatomic,assign) JDLBackgroundStyle backgroundStyle;
@property (nonatomic,copy) clickBlock clickBlock;

/**
 提示弹框

 @param message 提示内容
 @param style 背景样式
 @param duration 间隔多久后消失
 */
+(void)showAlertViewWithMessage:(NSString *)message
                 backgroundStyle:(JDLBackgroundStyle)style
                        duration:(NSInteger )duration;
/**
 按钮弹框 (没有标题&内容 可传nil，会自动不创建)

 @param title 标题
 @param message 内容
 @param btnTittles 按钮数组
 @param style 背景样式
 @param dismiss 点击背景是否dismiss
 @param clickBlock 按钮点击事件回掉传值
 */
+(void)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)btnTittles
              backgroundStyle:(JDLBackgroundStyle)style
                  backDismiss:(BOOL)dismiss
                   clickBlock:(clickBlock)clickBlock;
@end
