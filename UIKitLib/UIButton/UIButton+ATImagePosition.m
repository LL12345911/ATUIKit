//
//  UIButton+JKImagePosition.m
//  HighwayDoctor
//
//  Created by Mars on 2019/5/17.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "UIButton+ATImagePosition.h"

@implementation UIButton (ATImagePosition)
/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)at_setImagePosition:(ATImagePosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWidth = self.currentImage.size.width;
    CGFloat imageHeight = self.currentImage.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // Single line, no wrapping. Truncation based on the NSLineBreakMode.
    CGSize size = [self.currentTitle sizeWithFont:self.titleLabel.font];
    CGFloat labelWidth = size.width;
    CGFloat labelHeight = size.height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsZero;
    
    switch (postion) {
        case ATImagePositionLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case ATImagePositionRight:
            if (labelWidth+imageWidth+spacing >= self.frame.size.width) {
                CGFloat left = self.frame.size.width - spacing - imageWidth;
                imageEdgeInsets = UIEdgeInsetsMake(0, left + spacing/2, 0, -spacing/2);
                titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);

            }else{
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
                titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            }
            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);

//            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
//            titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
//            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            
            break;
            
        case ATImagePositionTop:
            imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case ATImagePositionBottom:
            imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        default:
            break;
    }
  
    self.imageEdgeInsets = imageEdgeInsets;
    self.titleEdgeInsets = titleEdgeInsets;
    self.contentEdgeInsets = contentEdgeInsets;
    
//    CGFloat imageWith = self.imageView.image.size.width;
//    CGFloat imageHeight = self.imageView.image.size.height;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
//    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
//#pragma clang diagnostic pop
//
//    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
//    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
//    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
//    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
//
//    switch (postion) {
//        case ATImagePositionLeft:{
//            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
//            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
//
//        }
//            break;
//
//        case ATImagePositionRight:{
//            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
//            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
//        }
//            break;
//
//        case ATImagePositionTop:{
//
//            CGSize imageSize = self.imageView.frame.size;
//            CGSize titleSize = self.titleLabel.frame.size;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//            CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
//#pragma clang diagnostic pop
//            CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
//            if (titleSize.width + 0.5 < frameSize.width) {
//                titleSize.width = frameSize.width;
//            }
//
//            CGFloat totalHeight = imageSize.height + titleSize.height;
//            self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height + spacing), 0.0, 0.0, - titleSize.width);
//            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height + spacing), 0);
////
////            CGFloat labelHeight = [self getStringHeightWithText:self.titleLabel.text font:self.titleLabel.font viewWidth:self.frame.size.width];
////            CGRect imageFrame = [self imageView].frame;
////
////            CGFloat topheight = (self.frame.size.height - labelHeight - imageFrame.size.height- spacing)/ 2.0;
////
////            self.imageView.center = CGPointMake(self.frame.size.width/2, topheight +self.imageView.frame.size.height/2);
////
////            self.titleLabel.frame = CGRectMake(0, imageFrame.size.height + spacing + topheight, self.frame.size.width, labelHeight);
////            self.titleLabel.textAlignment = NSTextAlignmentCenter;
////
////            //self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
////            //self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
//
//        }
//            break;
//
//        case ATImagePositionBottom:{
//            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
//            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
//        }
//            break;
//
//        default:
//            break;
//    }
    
}


@end
