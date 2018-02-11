//
//  JDLAlertView.m
//  JDLAlertView
//
//  Created by 胜炫电子 on 2018/2/9.
//  Copyright © 2018年 BlueSkyer-25. All rights reserved.
//

#import "JDLAlertView.h"

#define KSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KRGB(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(1.0)]

#define KAlertWidth  KSCREEN_WIDTH -100
const CGFloat KAlertGap   = 10.0;
const CGFloat KBtnHeight  = 44.0;
const CGFloat titleFont   = 18.0;
const CGFloat messageFont   = 16.0;
const CGFloat btnTitleFont   = 16.0;

@interface JDLAlertView ()
/** 标题 **/
@property(nonatomic, copy )NSString * title;
/** 内容 **/
@property(nonatomic, copy )NSString * message;
/** 按钮数据 **/
@property(nonatomic,strong)NSArray  * btnArr;
/** 点击背景是否dismiss **/
@property(nonatomic,assign)BOOL backDismiss;

@property(nonatomic,strong)UIView   * backgroundView;
@property(nonatomic,strong)UIView   * contentView;

/** 定制 可能弹框上面需要添加APP logo **/
@property(nonatomic,strong)UIImageView   * logoImageView;

@end

@implementation JDLAlertView

//提示弹框
+(void)showAlertViewWithMessage:(NSString *)message
                backgroundStyle:(JDLBackgroundStyle)style
                        duration:(NSInteger )duration{

    JDLAlertView *alertView =[[JDLAlertView alloc] initAlertViewWithTitle:nil message:message buttonTitles:nil backgroundStyle:style backDismiss:nil clickBlock:nil];
    [alertView showAlert];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissAlert];
    });
}

//按钮弹框
+(void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                   buttonTitles:(NSArray *)btnTittles
                backgroundStyle:(JDLBackgroundStyle)style
                    backDismiss:(BOOL)dismiss
                  clickBlock:(clickBlock)clickBlock{
    
    JDLAlertView *alertView =[[JDLAlertView alloc] initAlertViewWithTitle:title message:message buttonTitles:btnTittles backgroundStyle:style backDismiss:dismiss clickBlock:clickBlock];
    [alertView showAlert];
}

#pragma mark ------ 初始化
-(instancetype)initAlertViewWithTitle:(NSString*)title
                              message:(NSString*)message
                         buttonTitles:(NSArray*)btnArray
                      backgroundStyle:(JDLBackgroundStyle)style
                          backDismiss:(BOOL)dismiss
                           clickBlock:(clickBlock)clickBlock{
    if([super initWithFrame:[UIScreen mainScreen].bounds]){

        _title = [title copy];
        _message = [message copy];
        _btnArr = btnArray;
        _backgroundStyle =style;
        _backDismiss =dismiss;
        _clickBlock = clickBlock;
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
//        [self addSubview:self.logoImageView];
    }
    return self;
}

#pragma mark ------ 事件处理
-(void)btnPressed:(UIButton *)sender{
    
    if (self.clickBlock) {
        self.clickBlock(sender.tag, [sender currentTitle]);
    }
    [self dismissAlert];
}

-(void)tapAction{
    [self dismissAlert];
}

-(void)showAlert
{
    CGFloat backViewAlpha;
    switch (_backgroundStyle) {
        case JDLBackgroundStyleNone:
            backViewAlpha =0.0f;
            break;
        case JDLBackgroundStyleBlack:
            backViewAlpha =0.2f;
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = backViewAlpha;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.25f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[_contentView layer] addAnimation:popAnimation forKey:nil];
}

-(void)dismissAlert
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.center =CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) +KAlertGap);
        self.backgroundView.alpha =0.0;
        self.contentView.alpha =0.0;
        
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
}

#pragma mark ------ 懒加载
-(UIView *)backgroundView{

    if (!_backgroundView) {
        _backgroundView =[[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor =[UIColor blackColor];
        _backgroundView.alpha =0.0f;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_backgroundView addGestureRecognizer:tap];
        tap.enabled = _backDismiss ==YES ?YES :NO;
    }
    return _backgroundView;
}

-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView                     = [[UIView alloc]init];
        _contentView.layer.cornerRadius  = 5;
        _contentView.layer.masksToBounds = YES;
        UIColor *backgroundColor =self.btnArr.count? [UIColor whiteColor]:[UIColor colorWithWhite:0.0 alpha:0.4];
        _contentView.backgroundColor =backgroundColor;

        CGFloat titleHeight   = [self createTitle];
        CGFloat messageHeight = [self createMessageWithTitleHeight:titleHeight];
        CGFloat btnHeight     = [self createBtnWithMessageHeight:messageHeight];
        
        _contentView.bounds =CGRectMake(0, 0, KAlertWidth, btnHeight);
        _contentView.center =self.center;
    }
    return _contentView;
}

//-(UIImageView *)logoImageView{
//    if (!_logoImageView) {
//        _logoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(200, CGRectGetMinY(self.contentView.frame) -40, 50, 50)];
//        _logoImageView.backgroundColor =[UIColor orangeColor];
//    }
//    return _logoImageView;
//}

-(CGFloat )createTitle{
    if (!self.title.length) return KAlertGap;
    CGFloat height = [self heightWithString:self.title fontSize:titleFont width:KAlertWidth -2 *KAlertGap];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,KAlertWidth,height +2*KAlertGap)];
    titleLabel.text = self.title;
    titleLabel.textColor =KRGB(28, 28, 28);
    titleLabel.numberOfLines =0;
    titleLabel.font = [UIFont systemFontOfSize:titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    
    return CGRectGetMaxY(titleLabel.frame);
}

-(CGFloat)createMessageWithTitleHeight:(CGFloat)titleHeight
{
    if (!self.message.length) return titleHeight;
    
    CGFloat height = [self heightWithString:self.message fontSize:messageFont width:KAlertWidth -2 *KAlertGap];
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(KAlertGap, titleHeight, KAlertWidth -2 *KAlertGap, height +KAlertGap)];
    messageLabel.numberOfLines = 0;
    messageLabel.text = self.message;
    
    UIColor *textColor =self.btnArr.count? KRGB(28, 28, 28):[UIColor whiteColor];
    messageLabel.textColor = textColor;
    messageLabel.font = [UIFont systemFontOfSize:messageFont];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:messageLabel];
    
    return CGRectGetMaxY(messageLabel.frame);
}

-(CGFloat)createBtnWithMessageHeight:(CGFloat)messageHeight
{
    if (!self.btnArr.count) return messageHeight +KAlertGap;
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, messageHeight +KAlertGap *0.5, KAlertWidth, KBtnHeight)];
    [self.contentView addSubview:btnView];

    CGFloat btnWidth =CGRectGetWidth(btnView.frame)/self.btnArr.count;

    [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton*btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(btnWidth *idx,0,btnWidth, KBtnHeight);
        btn.tag = idx;
        btn.titleLabel.font = [UIFont systemFontOfSize:btnTitleFont];
        btn.layer.borderColor =[UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.4f;

        [btn setTitle :(NSString*)obj forState:UIControlStateNormal];
        [btn setTitleColor:KRGB(28, 28, 28) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];

        [btnView addSubview:btn];
        
        if(idx ==1) btn.backgroundColor =[UIColor orangeColor];
    }];
    
    return CGRectGetMaxY(btnView.frame);
}

/** 计算文本高度 **/
-(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

@end
