//
//  JDLAlertView.h
//  JDLAlertView
//
//  Created by 胜炫电子 on 2018/2/9.
//  Copyright © 2018年 BlueSkyer-25. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JDLBackgroundStyle) {
    JDLBackgroundStyleNone =1,   //
    JDLBackgroundStyleBlack
//    JDLBackgroundStyle
};

//回调
typedef void(^clickBlock)(NSInteger index,NSString *title);

@interface JDLAlertView : UIView

@property (nonatomic,assign) JDLBackgroundStyle backgroundStyle;
@property (nonatomic,copy) clickBlock clickBlock;

//提示弹框
+(void)showAlertViewWithMessage:(NSString *)message
                 backgroundStyle:(JDLBackgroundStyle)style
                        duration:(NSInteger )duration;
//按钮弹框
+(void)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSArray *)btnTittles
              backgroundStyle:(JDLBackgroundStyle)style
                  backDismiss:(BOOL)dismiss
                   clickBlock:(clickBlock)clickBlock;
@end
