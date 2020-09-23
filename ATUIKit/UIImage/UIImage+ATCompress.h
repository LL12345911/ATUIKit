//
//  UIImage+ATCompress.h
//  HighwayDoctor
//
//  Created by Mars on 2019/5/21.
//  Copyright © 2019 Mars. All rights reserved.
//


//图片压缩
#import <UIKit/UIKit.h>


@interface UIImage (ATCompress)

#pragma mark - 压缩图片处理
/// 压缩图片精确至指定Data大小, 只需循环3次, 并且保持图片不失真
- (UIImage*)kj_compressTargetByte:(NSUInteger)maxLength;
/// 压缩图片精确至指定Data大小, 只需循环3次, 并且保持图片不失真
+ (UIImage*)kj_compressImage:(UIImage*)image TargetByte:(NSUInteger)maxLength;


@end

