//
//  ViewController.m
//  JDLAlertView
//
//  Created by 胜炫电子 on 2018/2/9.
//  Copyright © 2018年 BlueSkyer-25. All rights reserved.
//

#import "ViewController.h"
#import "JDLAlertView.h"

@interface ViewController ()
@property (nonatomic,weak) JDLAlertView *alertView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor purpleColor];
    
    UIImageView * logoImageView =[[UIImageView alloc] initWithFrame:self.view.bounds];
    logoImageView.image =[UIImage imageNamed:@"timg"];
    [self.view addSubview:logoImageView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [JDLAlertView showAlertViewWithTitle:@"提示" message:@"啦咔咔啦考虑考虑考虑考虑考虑考虑考虑考虑啦咔咔啦考虑考虑考" buttonTitles:@[@"哈哈",@"我问得",@"多大的"] backgroundStyle:JDLBackgroundStyleBlack backDismiss:YES clickBlock:^(NSInteger index, NSString *title) {
        switch (index) {
            case 0:
                NSLog(@"第一个");
                break;
            case 1:
                NSLog(@"第二个");
                break;
            case 2:
                NSLog(@"第三个");
                break;
            default:
                break;
        }
        NSLog(@"%@===%ld",title,(long)index);
    }];
    
//    [JDLAlertView showAlertViewWithMessage:@"分隔符给发个分隔符" backgroundStyle:JDLBackgroundStyleNone duration:2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
