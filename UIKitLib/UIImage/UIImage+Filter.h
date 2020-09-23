//
//  UIImage+Filter.h
//  HighwayDoctor
//
//  Created by Mars on 2019/8/6.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Filter)

#pragma mark - 特效渲染
/** 颜色加深 color 加深的颜色*/
- (UIImage *)at_drawingWithColorizeImageWithcolor:(UIColor *)color;

/** 马赛克化 */
- (UIImage *)at_drawingWithMosaic;

/** 高斯模糊 blur 模糊等级 0~1 */
- (UIImage *)at_drawingWithGaussianBlurNumber:(CGFloat)blur;

/** 边缘锐化 */
- (UIImage *)at_drawingWithEdgeDetection;

/** 浮雕 */
- (UIImage *)at_drawingWithEmboss;

/** 锐化 */
- (UIImage *)at_drawingWithSharpen;

/** 进一步锐化 */
- (UIImage *)at_drawingWithNnsharpen;

/** 获得灰度图 */
- (UIImage*)at_drawingWithGrayImage;


#pragma mark - 形态学图像渲染
/** 形态膨胀/扩张 */
- (UIImage *)at_drawingWithDilate;

/** 形态多倍膨胀/扩张 */
- (UIImage *)at_drawingWithDilateIterations:(int)iterations;

/** 侵蚀 */
- (UIImage *)at_drawingWithErode;

/** 多倍侵蚀 */
- (UIImage *)at_drawingWithErodeIterations:(int)iterations;

/** 均衡运算 */
- (UIImage *)at_drawingWithEqualization;

/** 梯度 */
- (UIImage *)at_drawingWithGradientIterations:(int)iterations;

/** 顶帽运算 */
- (UIImage *)at_drawingWithTophatIterations:(int)iterations;

/** 黑帽运算 */
- (UIImage *)at_drawingWithBlackhatIterations:(int)iterations;

@end

NS_ASSUME_NONNULL_END
