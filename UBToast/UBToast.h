#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UBToastShowMode) {
    UBToastShowMode_V011, // 默认模式
    UBToastShowMode_V012,
};

@interface UBToast : NSObject

/// 更新展示模式-全局的
/// @param mode 模式
+ (void)updateShowMode:(UBToastShowMode)mode;


/// 展示一段信息
/// @param message 要展示的信息
+ (void)showMessage:(NSString *)message;


/// 展示一段信息
/// @param message 要展示的信息
/// @param duration 展示时长
+ (void)showMessage:(NSString *)message duration:(CGFloat)duration;


/// 展示一段信息
/// @param message 要展示的信息
/// @param topOffset  信息提示框相对顶部的偏移（屏幕顶部）
+ (void)showMessage:(NSString *)message topOffset:(CGFloat)topOffset;


/// 展示一段信息
/// @param message 要展示的信息
/// @param topOffset  信息提示框相对顶部的偏移（屏幕顶部）
/// @param duration 展示时长
+ (void)showMessage:(NSString *)message topOffset:(CGFloat)topOffset duration:(CGFloat)duration;


/// 展示一段信息
/// @param message 要展示的信息
/// @param bottomOffset 信息提示框相对低部的偏移（屏幕低部）
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)bottomOffset;


/// 展示一段信息
/// @param message 要展示的信息
/// @param bottomOffset 信息提示框相对低部的偏移（屏幕低部）
/// @param duration 展示时长
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat) bottomOffset duration:(CGFloat) duration;


/// 展示一段信息
/// @param message 要展示的信息
/// @param center 中心点
+ (void)showMessage:(NSString *)message center:(CGPoint)center;

@end
