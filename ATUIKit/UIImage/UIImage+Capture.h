//
//  UIImage+SubImage.h
//  EngineeringCool
//
//  Created by Mars on 2019/8/21.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Capture)

/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

/** 将两个图片生成一张图片 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;


/// 当前视图截图
+ (UIImage*)captureScreen:(UIView*)view;
/// 指定位置屏幕截图
+ (UIImage*)captureScreen:(UIView*)view Rect:(CGRect)rect;
/// 截取当前屏幕（窗口截图）
+ (UIImage*)captureScreenWindow;
/// 截取当前屏幕 （根据手机方向旋转）
+ (UIImage*)captureScreenWindowForInterfaceOrientation;

#pragma mark - 裁剪处理
/// 不规则图形切图
+ (UIImage*)anomalyCaptureImageWithView:(UIView*)view BezierPath:(UIBezierPath*)path;
/// 多边形切图
+ (UIImage*)polygonCaptureImageWithImageView:(UIImageView*)imageView PointArray:(NSArray*)points;
/// 指定区域裁剪
+ (UIImage*)cutImageWithImage:(UIImage*)image Frame:(CGRect)frame;
/// 图片路径裁剪，裁剪路径 "以外" 部分
+ (UIImage*)captureOuterImage:(UIImage*)image BezierPath:(UIBezierPath*)path Rect:(CGRect)rect;
/// 图片路径裁剪，裁剪路径 "以内" 部分
+ (UIImage*)captureInnerImage:(UIImage*)image BezierPath:(UIBezierPath*)path Rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
