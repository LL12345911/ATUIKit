//
//  UIImage+Joint.h
//  ATKit
//
//  Created by Mars on 2020/9/22.
//  Copyright © 2020 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ATImageJointType){
    ATImageJointTypeVertical = 1,//垂直拼接，默认 ATImageJointTypeLeft
    ATImageJointTypeHorizontal = 1 << 1,//水平拼接 默认 ATImageJointTypeTop
    //ATImageJointTypeVertical
    ATImageJointTypeLeft = 1 << 2,//左对齐
    ATImageJointTypeRight = 1 << 3,//右对齐
    //ATImageJointTypeHorizontal
    ATImageJointTypeTop = 1 << 4,//顶部对齐
    ATImageJointTypeBottom = 1 << 5,//底部对齐
    //
    ATImageJointTypeCenter = 1 << 6,//居中
};

@interface UIImage (Joint)

/**
 图片拼接
 @param images 图片集合
 @param joinType 拼接方式；
 */
+ (UIImage *)jointImages:(NSArray<UIImage *> *)images joinType:(ATImageJointType)joinType;

/**
 图片拼接
 @param images 图片集合
 @param joinType 拼接方式；
 @param lineSpace 图片之间的间距
 */
+ (UIImage *)jointImages:(NSArray<UIImage *> *)images joinType:(ATImageJointType)joinType lineSpace:(CGFloat)lineSpace;

/**
 裁剪图片
 @param rect 裁剪区域
 @param orientation 图片方向
 */
- (UIImage *)cutImageRect:(CGRect)rect orientation:(UIImageOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
