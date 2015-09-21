//
//  RYAlertView.m
//  AlertView
//
//  Created by 燕颖祥 on 15/9/1.
//  Copyright (c) 2015年 嗖嗖快跑. All rights reserved.
//

#import "RYAlertView.h"

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define MessageFont 16

@interface RYAlertView()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIImageView *iconImageView;

@property (assign, nonatomic) NSString *message;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end

CGFloat mainViewWidth;
CGFloat mainViewHeight;

@implementation RYAlertView

- (instancetype)initWithIcon:(UIImage *)icon message:(NSString *)message delegate:(id<RYAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ...
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        
        _icon               = icon;
        _message            = message;
        _delegate           = delegate;
        _buttonArray        = [NSMutableArray array];
        _buttonTitleArray   = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        [self initMainView];
        [self startAnimation];
    }
    
    return self;
}

- (void)initMainView
{
    mainViewWidth = [UIScreen mainScreen].bounds.size.width - 50;
    mainViewHeight = 0;
    
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = 10;
    _mainView.layer.masksToBounds = YES;
    
    [self initIcon];
    [self initMessage];
    [self initAllButtons];
    
    _mainView.frame = CGRectMake(0, 0, mainViewWidth, mainViewHeight);
    _mainView.center = self.center;
    [self addSubview:_mainView];
}

- (void)initIcon
{
    if (_icon != nil)
    {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor whiteColor];
        _iconImageView.image = _icon;
        _iconImageView.frame = CGRectMake(mainViewWidth/2-25, 15, 50, 50);
        [_mainView addSubview:_iconImageView];
        mainViewHeight += _iconImageView.frame.size.height + 15;
    }
}

- (void)initMessage
{
    if (_message != nil)
    {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.text = _message;
        _messageLabel.textColor = RGBA(50, 50, 50, 1.0);
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:MessageFont];
        _messageLabel.text = _message;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize messageSize = [self getMessageSize];
        
        if (_icon != nil)
        {
            _messageLabel.frame = CGRectMake(30, 80, mainViewWidth - 60, messageSize.height);

        }else
        {
            _messageLabel.frame = CGRectMake(30, 15, mainViewWidth - 60, messageSize.height);
        }
        [_mainView addSubview:_messageLabel];
        mainViewHeight += _messageLabel.frame.size.height + 15;
    }
}

- (void)initAllButtons
{
    if (_buttonTitleArray.count > 0)
    {
        mainViewHeight += 15 + 45;
        UIView *horizonSperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageLabel.frame) + 15, mainViewWidth, 0.5)];
        horizonSperatorView.backgroundColor = RGBA(175, 175, 188, 1.0);
        [_mainView addSubview:horizonSperatorView];
        
        CGFloat buttonWidth = mainViewWidth / _buttonTitleArray.count;
        for (NSString *buttonTitle in _buttonTitleArray)
        {
            NSInteger index = [_buttonTitleArray indexOfObject:buttonTitle];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index * buttonWidth, CGRectGetMaxY(horizonSperatorView.frame), buttonWidth, 44)];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            if (_buttonTitleArray.count != 1)
            {
                if (index == 0)
                {
                    [button setTitleColor:RGBA(150, 150, 150, 1.0) forState:UIControlStateNormal];
                }else
                {
                    [button setTitleColor:RGBA(255, 109, 30, 1.0) forState:UIControlStateNormal];
                }
            }else
            {
                [button setTitleColor:RGBA(255, 109, 30, 1.0) forState:UIControlStateNormal];
            }

            [button addTarget:self action:@selector(buttonWithPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_mainView addSubview:button];
            
            if (index < _buttonTitleArray.count - 1)
            {
                UIView *verticalSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y, 0.5, button.frame.size.height)];
                verticalSeperatorView.backgroundColor = RGBA(175, 175, 188, 1.0);
                [_mainView addSubview:verticalSeperatorView];
            }
        }
    }
}

- (CGSize)getMessageSize
{
    UIFont *font = [UIFont systemFontOfSize:MessageFont];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [_message boundingRectWithSize:CGSizeMake(mainViewWidth - (30 + 30), 2000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (void)startAnimation
{
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.removedOnCompletion = YES;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.duration = 0.20;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    scaleAnim.values = values;
    [_mainView.layer addAnimation:scaleAnim forKey:nil];
}

- (void)buttonWithPressed:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        NSInteger index = [_buttonTitleArray indexOfObject:button.titleLabel.text];
        [_delegate alertView:self clickedButtonAtIndex:index];
    }
    [self disimss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].windows[[UIApplication sharedApplication].windows.count - 1];
    [window.rootViewController.view addSubview:self];
}

- (void)disimss
{
    [self removeFromSuperview];
}

@end
