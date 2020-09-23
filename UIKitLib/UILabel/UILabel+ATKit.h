//
//  UILabel+ATAdaptContent.h
//  HighwayDoctor
//
//  Created by Mars on 2019/5/10.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* Values for NSWritingDirection */
typedef NS_ENUM(NSInteger, ATTextDirection) {
    ATTextDirectionNatural       = -1,    // Determines direction using the Unicode Bidi Algorithm rules P2 and P3
    ATTextDirectionLeft   =  0,    // Left to right writing direction
    ATTextDirectionRight   =  1     // Right to left writing direction
};

@interface UILabel (ATKit)
/**
 开发中常遇到UI要求文本均匀分布，两端对齐，开始使用在文字中手动打空格的方式，但常常会碰到相同文字有时三个字，有时四个字，五个字，这个时候用打空格的方式就会出现最后面的字或者符号无法对齐。此时，可以采用Category对UILable的文字分布方式进行处理

 使用时应注意要在给Lable的frame，text设置完之后再使用，默认使用textAlignmentLeftAndRight即可。若有其他指定宽度要设置，可使用- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;  若结尾文字以其他固定文字结尾，可替换冒号再使用

 UILabel文字均匀分布，两端对齐铺满整个控件
 */
/// 两端对齐  label
- (void)textAlignmentLeftAndRight;

/// 指定Label以最后的冒号对齐的width两端对齐
/// @param labelWidth 指定宽度
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;



///**
// *  设置字间距
// */
//- (void)setColumnSpace:(CGFloat)columnSpace;
///**
// *  设置行距
// */
//- (void)setRowSpace:(CGFloat)rowSpace;
///**
// *  设置文字对齐方向
// */
//- (void)setTextDirection:(ATTextDirection)direction;
//
//
//+ (instancetype) at_createLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;


#pragma mark - ATAutoSize
- (void)setContentHuggingWithLabelContent;
- (NSInteger)calculateLabelNumberOfRowsWithText:(NSString *)text
                                       withFont:(UIFont *)font
                                   withMaxWidth:(CGFloat)width;

//

/**
 获取文字所需行数

 @param width 宽度
 @param currentLabel 哪一个label
 @return 行数
 */
+ (NSInteger)needLinesWithWidth:(CGFloat)width currentLabel:(UILabel *)currentLabel;

/**
 * 垂直方向固定获取动态宽度的UILabel的方法
 *
 * @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)at_resizeLabelHorizontal;

/**
 *  水平方向固定获取动态宽度的UILabel的方法
 *
 *  @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)at_resizeLabelVertical;

/**
 *  垂直方向固定获取动态宽度的UILabel的方法
 *
 *  @param minimumWidth minimum width
 *
 *  @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)at_resizeLabelHorizontal:(CGFloat)minimumWidth;

/**
 *  水平方向固定获取动态宽度的UILabel的方法
 *
 *  @param minimumHeigh minimum height
 *
 *  @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)at_resizeLabelVertical:(CGFloat)minimumHeigh;



///**
// 在 UILabel 内计算内容的大小
// 
// @return CGSize
// */
//- (CGSize)contentSize;

//UILabel text两边对齐的实现代码
+(NSAttributedString *)setTextString:(NSString *)text;


/**
 配置 label 的行间距
 
 @param label 要配置的 label
 @param font 要配置的 label 的字体大小
 @param lineSpace  行间距
 @param maxWidth 要展示的最大宽度
 */
+ (void)configPropertyWithLabel:(UILabel *)label font:(CGFloat)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;

/**
 设置行间距的前提下的 label 高度
 
 @param label 要获取的 label
 @param font  字体大小
 @param lineSpace 行间距
 @param maxWidth 最大显示宽度
 @return 要展示的 label 的高度
 */
+ (CGFloat)getHeightWithLabel:(UILabel *)label font:(CGFloat)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;

/**
 获取 label 单行显示的时候需要的宽度
 
 @param label 要获取的 label
 @param font  字体大小
 @return 宽度
 */
+ (CGFloat)getWidthWithLabel:(UILabel *)label font:(CGFloat)font;

@end



NS_ASSUME_NONNULL_END
