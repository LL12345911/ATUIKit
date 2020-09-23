//
//  UIImage+Joint.m
//  ATKit
//
//  Created by Mars on 2020/9/22.
//  Copyright © 2020 Mars. All rights reserved.
//

#import "UIImage+Joint.h"

@implementation UIImage (Joint)
/**
 图片拼接
 @param images 图片集合
 @param joinType 拼接方式；ATImageJointTypeVertical，垂直拼接；ATImageJointTypeHorizontal，水平拼接；ATImageJointTypeVertical ｜ATImageJointTypeCenter，垂直居中拼接；ATImageJointTypeHorizontal ｜ATImageJointTypeCenter，水平居中拼接。
 */
+ (UIImage *)jointImages:(NSArray<UIImage *> *)images joinType:(ATImageJointType)joinType{
    return [self jointImages:images joinType:joinType lineSpace:0];
}

/**
 图片拼接
 @param images 图片集合
 @param joinType 拼接方式；
 @param lineSpace 图片之间的间距
 */
+ (UIImage *)jointImages:(NSArray<UIImage *> *)images joinType:(ATImageJointType)joinType lineSpace:(CGFloat)lineSpace{
    CGFloat maxW = 0;//最大图片的宽度
    CGFloat allW = 0;//总宽度
    CGFloat maxH = 0;//最大图片的高度
    CGFloat allH = 0;//总高度
    lineSpace *= UIScreen.mainScreen.scale;
    NSMutableArray *mArr = NSMutableArray.array;
    for (UIImage *img in images) {
        if ([img isKindOfClass:UIImage.class]) {
            maxW = MAX(maxW, img.size.width);
            allW += maxW;
            //
            maxH = MAX(maxH, img.size.height);
            allH += maxH;
            [mArr addObject:img];
        }
    }
    if (mArr.count > 1) {
        allW += (mArr.count - 1) * lineSpace;
        allH += (mArr.count - 1) * lineSpace;
    }
    if (joinType & ATImageJointTypeCenter && joinType & ATImageJointTypeHorizontal) {//水平居中
        if (mArr.count > 0) {
            return [self _horizontalType:ATImageJointTypeCenter images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeCenter && joinType & ATImageJointTypeVertical){//垂直居中
        if (mArr.count > 0) {
            return [self _verticalType:ATImageJointTypeCenter images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeHorizontal && joinType & ATImageJointTypeBottom){//水平底部对齐
        if (mArr.count > 0) {
            return [self _horizontalType:ATImageJointTypeBottom images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeHorizontal && joinType & ATImageJointTypeTop){//水平顶部对齐
        if (mArr.count > 0) {
            return [self _horizontalType:ATImageJointTypeTop images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeVertical && joinType & ATImageJointTypeRight){//垂直右对齐
        if (mArr.count > 0) {
            return [self _verticalType:ATImageJointTypeRight images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeVertical && joinType & ATImageJointTypeLeft){//垂直左对齐
        if (mArr.count > 0) {
            return [self _verticalType:ATImageJointTypeLeft images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeHorizontal){//水平居中
        if (mArr.count > 0) {
            return [self _horizontalType:ATImageJointTypeCenter images:images maxHeight:maxH allWidth:allW lineSpace:lineSpace];
        }
    }else if (joinType & ATImageJointTypeVertical){//垂直居中
        if (mArr.count > 0) {
            return [self _verticalType:ATImageJointTypeCenter images:images maxWidth:maxW allHeight:allH lineSpace:lineSpace];
        }
    }else{
        
    }
    return nil;
}

+ (UIImage *)_horizontalType:(ATImageJointType)horType images:(NSArray<UIImage *> *)images maxHeight:(CGFloat)maxHeight allWidth:(CGFloat)allWidth lineSpace:(CGFloat)lineSpace{
    UIGraphicsBeginImageContext(CGSizeMake(allWidth, maxHeight));
    CGFloat pointX = 0;
    for (UIImage *img in images) {
        switch (horType) {
            case ATImageJointTypeCenter:{
                [img drawInRect:CGRectMake(pointX, (maxHeight - img.size.height)*0.5, img.size.width, img.size.height)];
            }break;
            case ATImageJointTypeBottom:{
                [img drawInRect:CGRectMake(pointX, maxHeight - img.size.height, img.size.width, img.size.height)];
            }break;
            case ATImageJointTypeTop:{
                [img drawInRect:CGRectMake(pointX, 0, img.size.width, img.size.height)];
            }break;
            default:{
                
            }break;
        }
        pointX += img.size.width + lineSpace;
    }
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg;
}
+ (UIImage *)_verticalType:(ATImageJointType)verType images:(NSArray<UIImage *> *)images maxWidth:(CGFloat)maxWidth allHeight:(CGFloat)allHeight lineSpace:(CGFloat)lineSpace{
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth, allHeight));
    CGFloat pointY = 0;
    for (UIImage *img in images) {
        switch (verType) {
            case ATImageJointTypeCenter:{
                [img drawInRect:CGRectMake((maxWidth - img.size.width)*0.5, pointY, img.size.width, img.size.height)];
            } break;
            case ATImageJointTypeRight:{
                [img drawInRect:CGRectMake(maxWidth - img.size.width, pointY, img.size.width, img.size.height)];
            } break;
            case ATImageJointTypeLeft:{
                [img drawInRect:CGRectMake(0, pointY, img.size.width, img.size.height)];
            } break;
            default:{
                [img drawInRect:CGRectMake((maxWidth - img.size.width)*0.5, pointY, img.size.width, img.size.height)];
            }break;
        }
        pointY += img.size.height + lineSpace;
    }
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg;
}

/**
 裁剪图片
 @param rect 裁剪区域
 @param orientation 图片方向
 */
- (UIImage *)cutImageRect:(CGRect)rect orientation:(UIImageOrientation)orientation{
    CGFloat scale = UIScreen.mainScreen.scale;
    rect.origin.x *= scale;
    rect.origin.y *=  scale;
    rect.size.width *=  scale;
    rect.size.height *= scale;
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:UIScreen.mainScreen.scale orientation:orientation];
    return newImage;
}

@end
