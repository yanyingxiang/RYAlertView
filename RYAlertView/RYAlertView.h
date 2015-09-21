//
//  RYAlertView.h
//  AlertView
//
//  Created by 燕颖祥 on 15/9/1.
//  Copyright (c) 2015年 嗖嗖快跑. All rights reserved.
//

//根据@fergus_ding的demo改写
//http://code.cocoachina.com/detail/303371/自定义的AlertView/

#import <UIKit/UIKit.h>

@class RYAlertView;
@protocol RYAlertViewDelegate <NSObject>
- (void)alertView:(RYAlertView *)aiertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface RYAlertView : UIView

@property (weak, nonatomic)id<RYAlertViewDelegate>delegate;

- (instancetype)initWithIcon:(UIImage *)icon message:(NSString *)message delegate:(id<RYAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ...;

- (void)show;

@end
