//
//  UIView+ATAnyCorners.h
//  HighwayDoctor
//
//  Created by Mars on 2019/5/23.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ATUIRectCornerAllCorners            = 0,        //  所有角
    ATUIRectCornerTopLeft               = 1 << 0,   //  所有左上角
    ATUIRectCornerTopRight              = 1 << 1,   //  所有右上角
    ATUIRectCornerBottomLeft            = 1 << 2,   //  所有左下角
    ATUIRectCornerBottomRight           = 1 << 3,   //  所有右下角
    
    ATUIRectCornerTopLeftRight          = 1 << 4,   //  所有左上角右上角
    ATUIRectCornerTopLeftBottomLeft     = 1 << 5,   //  所有左边两个角
    ATUIRectCornerBottomLeftRight       = 1 << 6,   //  所有下边两个角
    ATUIRectCornerTopRightBottomRight   = 1 << 7,   //  所有右边两个角
    
} ATUIRectCornerType;


NS_ASSUME_NONNULL_BEGIN

@interface UIView (ATAnyCorners)


/**
 设置圆角

 @param cornerRadius 圆角半径
 @param borderWidth 圆角宽度
 @param borderColor 圆角颜色
 @param cornerType 圆角类型
 */
- (void)at_BorderCornerRadius:(CGFloat)cornerRadius
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor
                         type:(ATUIRectCornerType)cornerType;



/**
 设置圆角

 @param cornerRadius 圆角半径
 @param borderWidth 圆角宽度
 @param cornerType 圆角类型
 */
- (void)at_BorderCornerRadius:(CGFloat)cornerRadius
                  borderWidth:(CGFloat)borderWidth
                         type:(ATUIRectCornerType)cornerType;


/**
 设置圆角

 @param cornerRadius 圆角半径
 @param cornerType 圆角类型
 */
- (void)at_BorderCornerRadius:(CGFloat)cornerRadius
                         type:(ATUIRectCornerType)cornerType;
@end

NS_ASSUME_NONNULL_END
