//
//  UITextField+ATKit.h
//  HighwayDoctor
//
//  Created by Mars on 2019/5/7.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSRange textInputTrimByLength(UIView<UITextInput> *input, NSInteger maxLength);

typedef NS_ENUM(NSInteger, ATShakedDirection) {
    ATShakedDirectionHorizontal,
    ATShakedDirectionVertical
};



@interface UITextField (ATKit)



@property (assign, nonatomic)  NSInteger at_maxLength;//if <=0, no limit
/**
 用户输入时回调block
 
 @param block 返回允许最大Text长度, 负数表示不限制
 */
- (void)notifyChange:(NSInteger(^)(UITextField *textField, NSString *text))block;

#pragma mark - leftView(UIImageView)
/**
 提添加 UITextField 左边视图
 
 @param imageName 图片名称
 @param margin 到左边和右边的间距（上下默认间距为5）
 */
- (void)at_leftView:(NSString *)imageName leftAndRightMargin:(CGFloat)margin;

/**
 添加 UITextField 左边视图
 
 @param imageName 图片名称
 @param margin 到左边和右边的间距】
 @param bottom 到上边和下边的间距
 */
- (void)at_leftView:(NSString *)imageName leftAndRightMargin:(CGFloat)margin topAndBottom:(CGFloat)bottom;

/**
 移除 UITextField 左边视图
 */
- (void)removeLeftImageView;


#pragma mark - Shake
/** Shake the UITextField
 *
 * Shake the text field with default values
 */
- (void)at_shake;

/** Shake the UITextField
 *
 * Shake the text field a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 */
- (void)at_shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UITextField
 *
 * Shake the text field a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)at_shake:(int)times withDelta:(CGFloat)delta completion:(void((^)(void)))handler;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)(void)))handler;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shakeDirection of the shake
 */
- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ATShakedDirection)shakeDirection;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shakeDirection of the shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)at_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ATShakedDirection)shakeDirection completion:(void((^)(void)))handler;


#pragma mark - Block

@property (copy, nonatomic) BOOL (^at_shouldBegindEditingBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^at_shouldEndEditingBlock)(UITextField *textField);
@property (copy, nonatomic) void (^at_didBeginEditingBlock)(UITextField *textField);
@property (copy, nonatomic) void (^at_didEndEditingBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^at_shouldChangeCharactersInRangeBlock)(UITextField *textField, NSRange range, NSString *replacementString);
@property (copy, nonatomic) BOOL (^at_shouldReturnBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^at_shouldClearBlock)(UITextField *textField);

- (void)setAt_shouldBegindEditingBlock:(BOOL (^)(UITextField *textField))shouldBegindEditingBlock;
- (void)setAt_shouldEndEditingBlock:(BOOL (^)(UITextField *textField))shouldEndEditingBlock;
- (void)setAt_didBeginEditingBlock:(void (^)(UITextField *textField))didBeginEditingBlock;
- (void)setAt_didEndEditingBlock:(void (^)(UITextField *textField))didEndEditingBlock;
- (void)setAt_shouldChangeCharactersInRangeBlock:(BOOL (^)(UITextField *textField, NSRange range, NSString *string))shouldChangeCharactersInRangeBlock;
- (void)setAt_shouldClearBlock:(BOOL (^)(UITextField *textField))shouldClearBlock;
- (void)setAt_shouldReturnBlock:(BOOL (^)(UITextField *textField))shouldReturnBlock;


@end












@interface UITextView (ATKit2)

- (void)notifyChange:(NSInteger(^)(UITextView *textField, NSString *text))block;

@end




