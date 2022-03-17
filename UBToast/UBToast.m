#import "UBToast.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const DEFAULT_DISPLAY_DURATION = 2.0;

@interface UBToast ()

@property (nonatomic, strong) UILabel *titleLabel; // <#Description#>
@property (nonatomic, strong) UIButton *titleBGView; // <#Description#>
@property (nonatomic, assign) NSTimeInterval duration; // <#Description#>

@end


@implementation UBToast

#pragma mark - life cycle
- (instancetype)initWithMessage:(NSString *)message {
    if (self = [super init]) {
        CGSize textSize = [message boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        
        self.titleLabel.text = message;
        self.titleLabel.frame = CGRectMake(0, 0, textSize.width + 12, textSize.height + 12);

        self.titleBGView.frame = CGRectMake(0, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        [self.titleBGView addSubview:self.titleLabel];

        self.duration = DEFAULT_DISPLAY_DURATION;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:)  name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:[UIDevice currentDevice]];
}


#pragma mark - public methods
/// 展示一段信息
/// @param message 要展示的信息
+ (void)showMessage:(NSString *)message {
    [UBToast showMessage:message duration:DEFAULT_DISPLAY_DURATION];
}

/// 展示一段信息
/// @param message 要展示的信息
/// @param duration 展示时长
+ (void)showMessage:(NSString *)message duration:(CGFloat)duration {
    if (message && message.length) {
        UBToast *toast = [[UBToast alloc] initWithMessage:message];
        [toast setDuration:duration];
        [toast show];
    }
}

/// 展示一段信息
/// @param message 要展示的信息
/// @param topOffset  信息提示框相对顶部的偏移（屏幕顶部）
+ (void)showMessage:(NSString *)message topOffset:(CGFloat)topOffset {
    [UBToast showMessage:message  topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

/// 展示一段信息
/// @param message 要展示的信息
/// @param topOffset  信息提示框相对顶部的偏移（屏幕顶部）
/// @param duration 展示时长
+ (void)showMessage:(NSString *)message topOffset:(CGFloat)topOffset duration:(CGFloat)duration {
    UBToast *toast = [[UBToast alloc] initWithMessage:message];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}

/// 展示一段信息
/// @param message 要展示的信息
/// @param bottomOffset 信息提示框相对低部的偏移（屏幕低部）
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset {
    if (message.length > 0) {
        [UBToast showMessage:message  bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
    }
}

/// 展示一段信息
/// @param message 要展示的信息
/// @param bottomOffset 信息提示框相对低部的偏移（屏幕低部）
/// @param duration 展示时长
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    UBToast *toast = [[UBToast alloc] initWithMessage:message];
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

/// 展示一段信息
/// @param message 要展示的信息
/// @param center 中心点
+ (void)showMessage:(NSString *)message center:(CGPoint)center
{
    UBToast *toast = [[UBToast alloc] initWithMessage:message];
    [toast setDuration:DEFAULT_DISPLAY_DURATION];
    [toast showWithCenter:center];
}


#pragma mark - event response
- (void)toastTaped:(UIButton *)sender {
    [self hideAnimation];
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
    [self hideAnimation];
}


#pragma mark - animations
- (void)showAnimation {

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.titleBGView.alpha = 1.0f;
    } completion:^(BOOL finished) { }];
//    [UIView beginAnimations:@"show" context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.3];
//    self.titleBGView.alpha = 1.0f;
//    [UIView commitAnimations];
}

- (void)hideAnimation {
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.titleBGView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self dismissToast];
    }];

//    [UIView beginAnimations:@"hide" context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
//    [UIView setAnimationDuration:0.3];
//    self.titleBGView.alpha = 0.0f;
//    [UIView commitAnimations];
}


#pragma mark - private methods
- (void)dismissToast {
    [self.titleBGView removeFromSuperview];
}

- (void)show {
    
    self.titleBGView.center = CGPointMake(keyWindow().center.x, keyWindow().center.y + 30);
    [keyWindow()  addSubview:self.titleBGView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showWithCenter:(CGPoint)center
{
    self.titleBGView.center = center;
    [keyWindow()  addSubview:self.titleBGView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showFromTopOffset:(CGFloat)top_ {
    self.titleBGView.center = CGPointMake(keyWindow().center.x, top_ + self.titleBGView.frame.size.height/2);
    [keyWindow() addSubview:self.titleBGView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}

- (void)showFromBottomOffset:(CGFloat)bottom_ {
    self.titleBGView.center = CGPointMake(keyWindow().center.x, keyWindow().frame.size.height-(bottom_ + self.titleBGView.frame.size.height/2));
    [keyWindow() addSubview:self.titleBGView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}


#pragma mark - getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        _titleLabel = textLabel;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:14];;
    }
    return _titleLabel;
}

- (UIButton *)titleBGView {
    if (!_titleBGView) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBGView = btn;
        btn.layer.cornerRadius = 5.0f;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [btn addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        btn.alpha = 0.0f;
    }
    return _titleBGView;;
}



static inline UIWindow *keyWindow() {
    
    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)]) {
        if ([[[UIApplication sharedApplication] delegate] window]) {
            return [[[UIApplication sharedApplication] delegate] window];
        }
    }
    
    if (@available(iOS 13.0,*)) {
        UIWindow *foundWindow = nil;
        NSArray  *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow  *window in windows) {
            if (window.isKeyWindow) {
                foundWindow = window;
                break;
            }
        }
        return foundWindow;
    } else {
        return  [UIApplication sharedApplication].keyWindow;
    }

}
@end
