//
//  ViewController.m
//  RYAlertView
//
//  Created by 燕颖祥 on 15/9/21.
//  Copyright (c) 2015年 嗖嗖快跑. All rights reserved.
//

#import "ViewController.h"
#import "RYAlertView.h"

@interface ViewController ()<RYAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag)
    {
        case 1:
        {
            RYAlertView *alertView = [[RYAlertView alloc] initWithIcon:nil message:@"确定取消？" delegate:self buttonTitles:@"确定", @"取消", nil];
            [alertView show];
        }
            break;
        case 2:
        {
            RYAlertView *alertView = [[RYAlertView alloc] initWithIcon:[UIImage imageNamed:@"plaint"] message:@"确定取消？" delegate:self buttonTitles:@"确定", @"取消", nil];
            [alertView show];
        }
            break;
        case 3:
        {
            RYAlertView *alertView = [[RYAlertView alloc] initWithIcon:[UIImage imageNamed:@"plaint"] message:@"确定取消确定取消确定取消确定取消确定取消确定取消确定取消确定取消？" delegate:self buttonTitles:@"确定", @"取消", nil];
            [alertView show];
        }
            break;
        case 4:
        {
            RYAlertView *alertView = [[RYAlertView alloc] initWithIcon:nil message:@"确定取消确定取消确定取消确定取消确定取消确定取消确定取消确定取消？" delegate:self buttonTitles:@"确定", @"取消", @"不确定", nil];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(RYAlertView *)aiertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex %ld", buttonIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
