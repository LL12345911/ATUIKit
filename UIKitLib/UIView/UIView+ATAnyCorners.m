    //
    //  UIView+ATAnyCorners.m
    //  HighwayDoctor
    //
    //  Created by Mars on 2019/5/23.
    //  Copyright © 2019 Mars. All rights reserved.
    //

#import "UIView+ATAnyCorners.h"

@implementation UIView (ATAnyCorners)

- (void)at_BorderCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(ATUIRectCornerType)cornerType {
    //获取圆角类型
    UIRectCorner type = [self getCornerRadiusType:cornerType];
    
    [self addLayerView:cornerRadius borderWidth:borderWidth borderColor:borderColor type:type];
    [self clipLayerView:cornerRadius borderWidth:borderWidth borderColor:borderColor type:type];
}

/**
 设置圆角
 
 @param cornerRadius 圆角半径
 @param borderWidth 圆角宽度
 @param cornerType 圆角类型
 */
- (void)at_BorderCornerRadius:(CGFloat)cornerRadius
                  borderWidth:(CGFloat)borderWidth
                         type:(ATUIRectCornerType)cornerType{
        //获取圆角类型
    UIRectCorner type = [self getCornerRadiusType:cornerType];
    [self addLayerView:cornerRadius borderWidth:borderWidth borderColor:nil type:type];
    [self clipLayerView:cornerRadius borderWidth:borderWidth borderColor:nil type:type];

}


/**
 设置圆角
 
 @param cornerRadius 圆角半径
 @param cornerType 圆角类型
 */
- (void)at_BorderCornerRadius:(CGFloat)cornerRadius
                         type:(ATUIRectCornerType)cornerType{
    //获取圆角类型
    UIRectCorner type = [self getCornerRadiusType:cornerType];
    [self addLayerView:cornerRadius borderWidth:0 borderColor:nil type:type];
    [self clipLayerView:cornerRadius borderWidth:0 borderColor:nil type:type];

    
}


- (void)clipLayerView:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor type:(UIRectCorner)cornerType{
        //2. 加一个layer 按形状 把外面的减去
    CGRect clipRect = CGRectMake(0, 0,CGRectGetWidth(self.frame)-1, CGRectGetHeight(self.frame)-1);
    CGSize clipRadii = CGSizeMake(cornerRadius, borderWidth);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:cornerType cornerRadii:clipRadii];
    
    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    if (borderColor) {
        clipLayer.strokeColor = borderColor.CGColor;
    }else{
        clipLayer.strokeColor = [UIColor clearColor].CGColor;
    }
        //    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    clipLayer.lineWidth = 1;
    clipLayer.lineJoin = kCALineJoinRound;
    clipLayer.lineCap = kCALineCapRound;
    clipLayer.path = clipPath.CGPath;
    self.layer.mask = clipLayer;
}

- (void)addLayerView:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor type:(UIRectCorner)cornerType{
    //1. 加一个layer 显示形状
    CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0,CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame)-borderWidth);
    CGSize radii = CGSizeMake(cornerRadius, borderWidth);
   //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornerType cornerRadii:radii];
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    if (borderColor) {
        shapeLayer.strokeColor = borderColor.CGColor;
    }else{
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    }
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}

/**
 获取圆角类型

 @param cornerType 圆角类型
 @return 圆角类型
 */
- (UIRectCorner)getCornerRadiusType:(ATUIRectCornerType)cornerType{
    UIRectCorner type = UIRectCornerAllCorners;
    switch (cornerType) {
        case ATUIRectCornerAllCorners:
            type = UIRectCornerAllCorners;
            break;
        case ATUIRectCornerTopLeft:
            type = UIRectCornerTopLeft;
            break;
        case ATUIRectCornerTopRight:
            type = UIRectCornerTopRight;
            break;
        case ATUIRectCornerBottomLeft:
            type = UIRectCornerBottomLeft;
            break;
        case ATUIRectCornerBottomRight:
            type = UIRectCornerBottomLeft;
            break;
        case ATUIRectCornerTopLeftRight:
            type = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case ATUIRectCornerTopLeftBottomLeft:
            type = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            break;
        case ATUIRectCornerBottomLeftRight:
            type = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case ATUIRectCornerTopRightBottomRight:
            type = UIRectCornerTopRight | UIRectCornerBottomRight;
            break;
        default:
            break;
    }
    return type;
}

@end
